#define LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE 128
#define MARKER_SIGNAL_PLANE 250

GLOBAL_LIST_EMPTY(markers_signals)
/mob/camera/marker_signal
	name = "Signal"
	icon_state = "markersignal-"
	icon = 'tff_modular/modules/deadspace/icons/signals/eye.dmi'
	plane = MARKER_SIGNAL_PLANE
	alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
	invisibility = INVISIBILITY_MARKER_SIGNAL
	see_invisible = SEE_INVISIBLE_MARKER_SIGNAL
	sight = SEE_MOBS|SEE_OBJS|SEE_TURFS
	mouse_opacity = MOUSE_OPACITY_ICON
	movement_type = PHASING|FLYING
	hud_type = /datum/hud/marker_signal
	interaction_range = null
	var/psy_energy = 0
	var/psy_energy_maximum = 900
	var/psy_energy_generation = 1.5
	var/updatedir = null
	var/list/abilities
	var/list/visibleChunks
	var/obj/structure/marker/marker
	var/static_visibility_range = 16
	//CSS class used by this signal in the chat
	var/necrochat_class = "necrosignal"

/mob/camera/marker_signal/Initialize(mapload, obj/structure/marker/master)
	visibleChunks = list()
	abilities = list()
	.=..()
	if(!master)
		return INITIALIZE_HINT_QDEL
	marker = master
	GLOB.markers_signals += src
	AddElement(/datum/element/movetype_handler)
	icon_state += "[rand(1, 25)]"
	master.marker_signals += src
	if(!loc)
		forceMove(get_turf(marker))

	update_marker_detect_hud()
	setLoc(loc, TRUE)

//	var/datum/action/prey_sightings/action = new(src)
	//action.Grant(src)

	for(var/datum/action/cooldown/necro/psy/ability as anything in subtypesof(/datum/action/cooldown/necro/psy))
		if((initial(ability.marker_flags) & SIGNAL_ABILITY_MARKER_ONLY) && !istype(src, /mob/camera/marker_signal/marker))
			continue
		ability = new ability(src)
		abilities += ability
		if(!marker.active)
			if(initial(ability.marker_flags) & SIGNAL_ABILITY_PRE_ACTIVATION)
				ability.Grant(src)
		else
			if(initial(ability.marker_flags) & SIGNAL_ABILITY_POST_ACTIVATION)
				ability.Grant(src)

	if(marker.active)
		for(var/datum/action/cooldown/necro/corruption/ability as anything in subtypesof(/datum/action/cooldown/necro/corruption))
			if(initial(ability.marker_only) && !istype(src, /mob/camera/marker_signal/marker))
				continue
			ability = new ability(src)
			ability.Grant(src)

	START_PROCESSING(SSobj, src)

/mob/camera/marker_signal/Destroy()
	STOP_PROCESSING(SSobj, src)
	GLOB.markers_signals -= src
	if(marker)
		marker.marker_signals -= src
		marker.necroqueue -= src
		marker = null
	return ..()

/mob/camera/marker_signal/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	name = "[pick(GLOB.ing_verbs)] [initial(name)]"

/mob/camera/marker_signal/process(delta_time)
	change_psy_energy(psy_energy_generation*delta_time)

/mob/camera/marker_signal/Move(NewLoc, direct, glide_size_override = 32)
	if(updatedir)
		setDir(direct)//only update dir if we actually need it, so overlays won't spin on base sprites that don't have directions of their own

	if(glide_size_override && glide_size != glide_size_override)
		set_glide_size(glide_size_override)
	if(NewLoc)
		abstract_move(NewLoc)
		update_parallax_contents()
	else
		var/turf/destination = get_turf(src)

		if((direct & NORTH) && y < world.maxy)
			destination = get_step(destination, NORTH)

		else if((direct & SOUTH) && y > 1)
			destination = get_step(destination, SOUTH)

		if((direct & EAST) && x < world.maxx)
			destination = get_step(destination, EAST)

		else if((direct & WEST) && x > 1)
			destination = get_step(destination, WEST)

		abstract_move(destination)

/mob/camera/marker_signal/forceMove(atom/destination)
	abstract_move(destination) // move like the wind
	return TRUE

/mob/camera/marker_signal/zMove(dir, turf/target, z_move_flags = NONE, recursions_left = 1, list/falling_movs)
	. = ..()
	if(.)
		setLoc(loc, force_update = TRUE)

/mob/camera/marker_signal/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	..()
	if(client)
		//marker.markernet.visibility(src)
		update_marker_detect_hud()
		//update_static(old_loc)
	return TRUE

/mob/camera/marker_signal/proc/setLoc(destination, force_update = FALSE)
	if(!marker)
		return
	if(!isturf(marker.loc))
		return
	destination = get_turf(destination)
	if(!force_update && (destination == get_turf(src)))
		return //we are already here!
	if (destination)
		abstract_move(destination)
	else
		moveToNullspace()
	update_marker_detect_hud()
	update_parallax_contents()


/mob/camera/marker_signal/DblClickOn(atom/A, params)
	if(check_click_intercept(params, A))
		return

	if(istype(A, /mob/living/carbon/human/necromorph))
		possess_necromorph(A)

	// Otherwise just jump to the turf
	if(A.loc)
		abstract_move(get_turf(A))

/mob/camera/marker_signal/proc/update_marker_detect_hud()
	var/datum/atom_hud/marker_detector/hud = GLOB.huds[DATA_HUD_MARKER]
	var/list/old_images = hud_list[MARKER_DETECT_HUD]
	//DELETION?


	if(!length(hud.hud_users_all_z_levels))
		return

	hud.remove_atom_from_hud(src)

	var/static/list/vis_contents_opaque = list()
	var/turf/our_turf = get_turf(src)
	var/our_z_offset = GET_TURF_PLANE_OFFSET(our_turf)
	var/key = "[COLOR_RED]"

	var/obj/effect/overlay/marker_detect_hud/hud_obj = vis_contents_opaque[key]
	if(!hud_obj)
		hud_obj = new /obj/effect/overlay/marker_detect_hud()
		SET_PLANE_W_SCALAR(hud_obj, PLANE_TO_TRUE(hud_obj.plane), our_z_offset)
		hud_obj.color = COLOR_RED
		vis_contents_opaque[key] = hud_obj




	var/list/new_images = list()
	var/list/turfs = get_visible_turfs()
	for(var/turf/seen_turf as anything in turfs)
		var/image/img = (old_images.len > new_images.len) ? old_images[new_images.len + 1] : image(loc = seen_turf, layer = ABOVE_ALL_MOB_LAYER)
		img.vis_contents += hud_obj
		SET_PLANE(img, GAME_PLANE, seen_turf)
		new_images += img
	for(var/i in (new_images.len + 1) to old_images.len)
		qdel(old_images[i])

	active_hud_list[MARKER_DETECT_HUD] = new_images
	hud.add_atom_to_hud(src)



/mob/camera/marker_signal/proc/get_visible_turfs()
	if(!isturf(loc))
		return list()
	var/client/C = client
	var/view = C ? getviewsize(C.view) : getviewsize(world.view)
	var/turf/lowerleft = locate(max(1, x - (view[1] - 1)/2), max(1, y - (view[2] - 1)/2), z)
	var/turf/upperright = locate(min(world.maxx, lowerleft.x + (view[1] - 1)), min(world.maxy, lowerleft.y + (view[2] - 1)), lowerleft.z)
	return block(lowerleft, upperright)

/mob/camera/marker_signal/ClickOn(atom/A, params)
	if(check_click_intercept(params,A))
		return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlMiddleClickOn(A)
		else
			MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK))
		base_click_alt(src, A)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A)
		return

	if(world.time <= next_move)
		return
	A.attack_marker_signal(src)

/atom/proc/attack_marker_signal(mob/camera/marker_signal/user)
	return FALSE

/mob/camera/marker_signal/verb/leave_horde()
	set name = "Leave the Horde"
	set category = "Necromorph"

	qdel(src)

/mob/camera/marker_signal/verb/switch_necroqueue()
	set name = "Join/Leave Necroqueue"
	set category = "Necromorph"

	if(!marker.active)
		to_chat(src, span_notice("Marker is not active yet!"))
		return
	if(src in marker.necroqueue)
		to_chat(src, span_notice("You have left the necroqueue."))
		marker.necroqueue -= src
	else
		to_chat(src, span_notice("You are now in the necroqueue. When a necromorph vessel is available, you will be automatically placed in control of it. You can still manually posess necromorphs."))
		marker.necroqueue += src

/mob/camera/marker_signal/verb/jump_to_maker()
	set name = "Jump to Marker"
	set category = "Necromorph"

	forceMove(get_turf(marker))

/mob/camera/marker_signal/verb/jump_to_necro()
	set name = "Jump to Necromorph"
	set category = "Necromorph"

	if(!length(marker.necromorphs))
		to_chat(src, span_notice("There are no necromorphs to jump to!"))
		return

	var/mob/living/carbon/human/necromorph/necro = tgui_input_list(src, "Select necromorph to jump to", "Jump To Necromorph", marker.necromorphs)
	if(necro)
		forceMove(get_turf(necro))

/mob/camera/marker_signal/verb/jump_to_span_locs()
	set name = "Jump to Necromorph Spawn Locs"
	set category = "Necromorph"

	var/atom/location = tgui_input_list(src, "Select object to jump to", "Jump To Spawn Loc", marker.necro_spawn_atoms)
	if(location)
		forceMove(get_turf(location))

/mob/camera/marker_signal/verb/possess_necromorph(mob/living/carbon/human/necromorph/necro in world)
	set name = "Possess Necromorph"
	set category = "Object"
	if(necro.stat == DEAD)
		to_chat(src, span_notice("This vessel was damaged beyond use!"))
		return
	if(necro.controlling)
		to_chat(src, span_notice("This vessel is already possessed!"))
		return
	necro.controlling = src
	//To prevent self attack when possesing through a double click
	client.click_intercept_time = world.time + 1
	mind.transfer_to(necro, TRUE)
	abstract_move(null)

/mob/camera/marker_signal/proc/change_psy_energy(amount)
	psy_energy = clamp(psy_energy+amount, 0, psy_energy_maximum)
	if(hud_used)
		var/datum/hud/marker_signal/our_hud = hud_used
		var/filter = our_hud.psy_energy.get_filter("alpha_filter")
		animate(filter, x = clamp(HUD_METER_PIXEL_WIDTH*(psy_energy/psy_energy_maximum), 0, HUD_METER_PIXEL_WIDTH), time = 0.5 SECONDS)
		our_hud.foreground_psy.maptext = MAPTEXT("[round(psy_energy, 1)]/[psy_energy_maximum] | +[psy_energy_generation] psy/sec")

/mob/camera/marker_signal/proc/update_biomass_hud(hud_override)
	var/datum/hud/marker_signal/our_hud = hud_override || hud_used
	our_hud?.foreground_bio.maptext = MAPTEXT("[round(marker.signal_biomass, 1)] | +[marker.last_biomass_income*marker.signal_biomass_percent] bio/sec")

/mob/camera/marker_signal/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, message_range, datum/saymode/saymode, list/message_mods = list())
	if(!message || stat)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_boldwarning("You cannot send IC messages (muted)."))
			return
		if (!(ignore_spam || forced) && src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if(!marker)
		to_chat(src, span_warning("There is no connection between you and the Marker!"))
		return

	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	message = "<span class='[src.necrochat_class]'>[name]: [message]</span>"

	marker.hive_mind_message(src, message)

	return TRUE

/mob/camera/marker_signal/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), message_range)
	. = ..()
	// Create map text prior to modifying message for goonchat
	if (client?.prefs.read_preference(/datum/preference/toggle/enable_runechat) && (client.prefs.read_preference(/datum/preference/toggle/enable_runechat_non_mobs) || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans)
	// Recompose the message, because it's scrambled by default
	message = compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods)
	to_chat(src,
		html = message,
		avoid_highlighting = speaker == src)

/mob/camera/marker_signal/verb/become_master()
	set name = "Become master signal"
	set category = "Necromorph"

	if(!marker.active)
		to_chat(src, span_notice("Marker is not active yet!"))
		return
	if(marker.camera_mob)
		to_chat(src, span_notice("There is a player controlling the marker already!"))
		return
	var/mob/camera/marker_signal/marker/camera = new /mob/camera/marker_signal/marker(get_turf(src), marker)
	marker.camera_mob = camera
	camera.fully_replace_character_name(camera.name)
	camera.ckey = src.ckey
	camera.change_psy_energy(psy_energy)
	qdel(src)

/mob/camera/marker_signal/marker
	name = "Marker"
	icon_state = "mastersignal"
	icon = 'tff_modular/modules/deadspace/icons/signals/mastersignal.dmi'
	hud_type = /datum/hud/marker_signal/marker
	interaction_range = null
	pixel_x = -7
	pixel_y = -7
	psy_energy_maximum = 4500
	psy_energy_generation = 3
	necrochat_class = "necromarker"
	///Used when spawning necromorphs
	var/image/necro_preview
	///Necro class of a necromorph we are going to spawn
	var/spawning_necromorph

/mob/camera/marker_signal/marker/Initialize(mapload, obj/structure/marker/master)
	. = ..()
	icon_state = "mastersignal"
	remove_verb(src, list(
		/mob/camera/marker_signal/verb/become_master,
		/mob/camera/marker_signal/verb/switch_necroqueue,
	))

/mob/camera/marker_signal/marker/Destroy()
	marker?.camera_mob = null
	return ..()

/mob/camera/marker_signal/marker/update_biomass_hud(hud_override)
	var/datum/hud/marker_signal/our_hud = hud_override || hud_used
	our_hud?.foreground_bio.maptext = MAPTEXT("[round(marker.marker_biomass, 1)] | +[marker.last_biomass_income*(1-marker.signal_biomass_percent)] bio/sec")

/mob/camera/marker_signal/marker/verb/downgrade()
	set name = "Downgrade to normal signal"
	set category = "Necromorph"

	var/mob/camera/marker_signal/signal = new /mob/camera/marker_signal(get_turf(src), marker)
	signal.fully_replace_character_name(signal.name)
	signal.ckey = src.ckey
	signal.change_psy_energy(psy_energy)
	qdel(src)

/mob/camera/marker_signal/marker/verb/open_marker_ui()
	set name = "Open Marker UI"
	set category = "Necromorph"

	marker.ui_interact(src)

/mob/camera/marker_signal/marker/ClickOn(atom/A, params)
	if(check_click_intercept(params,A))
		return

	var/list/modifiers = params2list(params)
	if(spawning_necromorph)
		if(LAZYACCESS(modifiers, LEFT_CLICK))
			if(!LAZYACCESS(modifiers, SHIFT_CLICK))
				spawn_necromorph(A)
				detach_necro_preview()
			else
				spawn_necromorph(A)
			return
		else if(LAZYACCESS(modifiers, RIGHT_CLICK))
			detach_necro_preview()
			return
	if(LAZYACCESS(modifiers, SHIFT_CLICK))
		if(LAZYACCESS(modifiers, MIDDLE_CLICK))
			ShiftMiddleClickOn(A)
			return
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlShiftClickOn(A)
			return
		ShiftClickOn(A)
		return
	if(LAZYACCESS(modifiers, MIDDLE_CLICK))
		if(LAZYACCESS(modifiers, CTRL_CLICK))
			CtrlMiddleClickOn(A)
		else
			MiddleClickOn(A, params)
		return
	if(LAZYACCESS(modifiers, ALT_CLICK))
		base_click_alt(src, A)
		return
	if(LAZYACCESS(modifiers, CTRL_CLICK))
		CtrlClickOn(A)
		return

	if(world.time <= next_move)
		return
	A.attack_marker_signal(src)

/mob/camera/marker_signal/marker/proc/spawn_necromorph(turf/A)
	if(marker.biomass_invested < marker.necro_classes[spawning_necromorph].biomass_spent_required)
		to_chat(src, span_warning("Not enough biomass spent!"))
		return
	if(marker.marker_biomass < marker.necro_classes[spawning_necromorph].biomass_cost)
		to_chat(src, span_warning("Not enough biomass!"))
		return
	var/datum/necro_class/class = marker.necro_classes[spawning_necromorph]
	if(class.spawn_limit >= 0 && class.spawned_number >= class.spawn_limit)
		to_chat(src, span_warning("You cannot spawn more necromorphs of this type!"))
		return
	A = get_turf(A)
	if(!A)
		return
	if(A.density)
		to_chat(src, span_warning("Location is dense!"))
		return
	for(var/atom/movable/movable as anything in A)
		if(movable.density)
			to_chat(src, span_warning("Location has dense objects on it!"))
			return
	//In case there was a nearby spawnloc but nest was behind a wall
	var/spawnloc_cantsee
	for(var/atom/spawnloc as anything in marker.necro_spawn_atoms)
		if(!IN_GIVEN_RANGE(spawnloc, A, 4))
			continue
		var/turf/turf_loc = get_turf(spawnloc)
		if(!can_see(turf_loc, A, 4))
			spawnloc_cantsee = TRUE
			continue
		marker.change_marker_biomass(-marker.necro_classes[spawning_necromorph].biomass_cost)
		marker.biomass_invested += marker.necro_classes[spawning_necromorph].biomass_cost
		var/path = marker.necro_classes[spawning_necromorph].necromorph_type_path
		++class.spawned_number
		var/mob/living/carbon/human/necromorph/mob = new path(A, marker)
		if(marker.use_necroqueue && length(marker.necroqueue))
			var/list/necroqueue_copy = marker.necroqueue.Copy()
			//If current signal has no key and there are other signals in the queue, pick another one
			while(length(necroqueue_copy))
				var/mob/camera/marker_signal/signal = pick_n_take(necroqueue_copy)
				signal = pick_n_take(necroqueue_copy)
				if(signal.key)
					signal.possess_necromorph(mob)
					return
		return
	if(!spawnloc_cantsee)
		to_chat(src, span_warning("There are no possible spawn locations nearby!"))
	else
		to_chat(src, span_warning("Nearby spawn location cant see this turf!"))

/mob/camera/marker_signal/marker/proc/attach_necro_preview(datum/necro_class/class)
	necro_preview = new /image/necromorph_subtype(class.ui_icon, null, "preview")
	var/mob/living/carbon/human/necromorph/necro = class.necromorph_type_path
	necro_preview.pixel_x = initial(necro.base_pixel_x)
	necro_preview.pixel_y = initial(necro.base_pixel_y)
	client.images += necro_preview
	mouse_move_intercept = src
	spawning_necromorph = class.type

/mob/camera/marker_signal/marker/proc/detach_necro_preview()
	if(mouse_move_intercept == src)
		mouse_move_intercept = null
	spawning_necromorph = null
	client.images -= necro_preview
	necro_preview = null

/mob/camera/marker_signal/marker/proc/mouse_movement_intercepted(atom/intercepted)
	necro_preview.loc = get_turf(intercepted)

/obj/effect/overlay/marker_detect_hud
	name = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	icon = 'tff_modular/modules/deadspace/icons/hud/alpha_mask.dmi'
	icon_state = ""
	alpha = 100
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/effect/overlay/marker_detect_hud/camera_unseen
	icon = 'tff_modular/modules/deadspace/icons/hud/cameranet_static.dmi'

#undef MARKER_SIGNAL_PLANE
#undef LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
