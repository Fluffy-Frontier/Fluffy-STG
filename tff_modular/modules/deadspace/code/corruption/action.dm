/datum/action/cooldown/necro/corruption
	name = "Generic corruption placement ability"
	button_icon = 'tff_modular/modules/deadspace/icons/hud/action_corruption.dmi'
	cooldown_time = 0.1 SECONDS
	click_to_activate = TRUE
	var/cost = 0
	var/image/template
	var/obj/structure/necromorph/place_structure = /obj/structure/necromorph
	var/can_place_in_sight = FALSE
	var/marker_only = FALSE

/datum/action/cooldown/necro/corruption/New(Target, original, cooldown)
	..()
	name += " | Cost: [cost] bio"
	template = new /image/necromorph_subtype(initial(place_structure.icon), null, initial(place_structure.icon_state))
	template.pixel_x = initial(place_structure.base_pixel_x)
	template.pixel_y = initial(place_structure.base_pixel_y)

/datum/action/cooldown/necro/corruption/set_click_ability(mob/on_who)
	.=..()
	owner.mouse_move_intercept = src
	owner.client.images += template

/datum/action/cooldown/necro/corruption/unset_click_ability(mob/on_who, refund_cooldown)
	.=..()
	owner.mouse_move_intercept = null
	//Gotta check if client is still there because unset is also called in Logout()
	owner.client?.images -= template
	template.loc = null

/datum/action/cooldown/necro/corruption/InterceptClickOn(mob/living/clicker, params, atom/target)
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(unset_after_click)
			unset_click_ability(clicker, refund_cooldown = TRUE)
		clicker.next_click = world.time + click_cd_override
		return FALSE

	if(!IsAvailable(feedback = TRUE))
		return FALSE
	if(!target)
		return FALSE
	// The actual action begins here
	if(!PreActivate(target))
		return FALSE

	// And if we reach here, the action was complete successfully
	if(!LAZYACCESS(modifiers, SHIFT_CLICK) && unset_after_click)
		unset_click_ability(clicker, refund_cooldown = FALSE)
	clicker.next_click = world.time + click_cd_override

	return TRUE

/datum/action/cooldown/necro/corruption/Activate(atom/target)
	var/mob/camera/marker_signal/signal = owner
	var/current_biomass = istype(signal, /mob/camera/marker_signal/marker) ? signal.marker.marker_biomass : signal.marker.signal_biomass
	if(current_biomass < cost)
		to_chat(signal, span_warning("Not enough biomass!"))
		return TRUE
	var/turf/target_turf = get_turf(target)
	var/result_message = can_place(target_turf)
	if(result_message)
		to_chat(signal, span_warning(result_message))
		return TRUE
	if(istype(signal, /mob/camera/marker_signal/marker))
		signal.marker.change_marker_biomass(-cost)
	else
		signal.marker.change_signal_biomass(-cost)
	var/obj/structure/necromorph/structure = new place_structure(target_turf, signal.marker)
	structure.dir = template.dir
	..()
	return TRUE

/datum/action/cooldown/necro/corruption/proc/mouse_movement_intercepted(atom/intercepted)
	var/turf/turf_loc = get_turf(intercepted)
	template.loc = turf_loc
	template.color = can_place(turf_loc) ? COLOR_RED : COLOR_GREEN

//Returns a string on fail. Otherwise - null
/datum/action/cooldown/necro/corruption/proc/can_place(turf/turf_loc)
	if(!turf_loc)
		return "No turf selected!"
	if(turf_loc.density)
		return "Turf is obstructed!"
	if(!turf_loc.necro_corrupted)
		return "Turf isn't corrupted!"
	if(locate(/obj/structure/necromorph) in turf_loc)
		return "There is another necromorph structure on this turf!"
	if(locate(/obj/structure/necromorph) in range(1, turf_loc))
		return "Too close to another necromorph structure!"
	//Remove this loop if it causes too much lag when hovering over a pile of items
	for(var/atom/movable/movable as anything in turf_loc)
		if(movable.density)
			return "Turf is obstructed!"
	if(!can_place_in_sight)
		for(var/mob/living/living in viewers(world.view, turf_loc))
			if((!isnecromorph(living) && living.ckey) && (living.stat < UNCONSCIOUS) && !living.is_blind())
				return "Turf is in sight of a sentient creature!"
	return
