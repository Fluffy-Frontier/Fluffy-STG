#define DEFAULT_SPAWN_COOLDOWN 5 MINUTES

/obj/structure/necromorph/nest
	name = "nest"
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption64.dmi'
	icon_state = "nest"
	density = TRUE
	pixel_x = -16
	base_pixel_x = -16
	pixel_y = -16
	base_pixel_y = -16
	///Type, not a reference
	var/datum/necro_class/spawning_necromorph
	var/biomass_spent = 0
	///Amount of necromorphs players can possess atm
	var/available_necromorphs = 0
	///Not really safe, lets hope nothing breaks
	var/currently_active_necromorphs = 0
	///Amount of necromorphs we can have
	var/max_spawns = 2
	var/obj/structure/marker/marker
	var/timer_id

/obj/structure/necromorph/nest/Initialize(mapload, obj/structure/marker/new_master)
	.=..()
	if(!new_master)
		return INITIALIZE_HINT_QDEL
	marker = new_master
	new_master.necro_spawn_atoms += src

/obj/structure/necromorph/nest/Destroy()
	marker?.necro_spawn_atoms -= src
	marker = null
	return ..()

/obj/structure/necromorph/nest/examine(mob/user)
	.=..()
	if(istype(user, /mob/camera/marker_signal))
		var/string
		if(spawning_necromorph)
			string = "Nest produces [initial(spawning_necromorph.display_name)].\n\
				It has [available_necromorphs] necromorphs left inside.\n"
			if(timer_id)
				string += "Another necromorph will be ready in [timeleft(timer_id)/(1 SECONDS)] seconds."
			else
				string += "The nest is full."
		else
			string = "Nest isn't configured to produce necromorphs."
		. += span_notice(string)

/obj/structure/necromorph/nest/attack_marker_signal(mob/camera/marker_signal/user)
	if(istype(user, /mob/camera/marker_signal/marker))
		var/response = tgui_alert(user, "Do you want to upgrade \the [src] or possess a necromorph?", "Nest", list("Upgrade", "Possess"))
		if(!response || QDELING(src))
			return
		if(response == "Possess")
			goto main
		if(!spawning_necromorph)
			pick_type2spawn(user)
		return
	main:
		if(!spawning_necromorph)
			to_chat(user, span_notice("This nest isn't configured to spawn any necromorph."))
			return
		if(currently_active_necromorphs >= max_spawns)
			to_chat(user, span_notice("All necromorphs are already possessed!"))
			return
		if(available_necromorphs <= 0)
			to_chat(user, span_notice("Wait [timeleft(timer_id)/(1 SECONDS)] seconds before the nest produces [initial(spawning_necromorph.display_name)]"))
			return
		if(tgui_alert(user, "Are you sure you want to possess [initial(spawning_necromorph.display_name)]", "Nest", list("Yes", "No")) == "Yes")
			if(QDELING(src) || available_necromorphs == 0)
				return
			var/type_to_spawn = initial(spawning_necromorph.necromorph_type_path)
			available_necromorphs--
			currently_active_necromorphs++
			var/mob/living/carbon/human/necromorph/necromorph = new type_to_spawn(get_turf(src), marker)
			user.possess_necromorph(necromorph)
			RegisterSignal(necromorph, COMSIG_LIVING_DEATH, PROC_REF(on_necromorph_death))
			RegisterSignal(necromorph, COMSIG_QDELETING, PROC_REF(on_necromorph_death))
			if((available_necromorphs+currently_active_necromorphs) < max_spawns)
				timer_id = addtimer(CALLBACK(src, PROC_REF(add_necromorph_to_spawn)), DEFAULT_SPAWN_COOLDOWN, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_NO_HASH_WAIT)

/obj/structure/necromorph/nest/proc/on_necromorph_death(mob/living/carbon/human/necromorph/necromorph)
	UnregisterSignal(necromorph, list(COMSIG_QDELETING, COMSIG_LIVING_DEATH))
	currently_active_necromorphs--
	if((available_necromorphs+currently_active_necromorphs) < max_spawns)
		timer_id = addtimer(CALLBACK(src, PROC_REF(add_necromorph_to_spawn)), DEFAULT_SPAWN_COOLDOWN, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_NO_HASH_WAIT)

/obj/structure/necromorph/nest/proc/pick_type2spawn(mob/camera/marker_signal/user)
	if(spawning_necromorph)
		return
	var/list/classes = list()
	for(var/datum/necro_class/class as anything in marker.necro_classes)
		class = marker.necro_classes[class]
		if(class.nest_allowed)
			classes["[class.display_name], Biomass: [class.biomass_cost]"] = class
	var/datum/necro_class/class = classes[tgui_input_list(user, "Pick a necromorph nest will spawn", "Nest", classes)]
	if(QDELING(src))
		return
	if(class.biomass_cost > marker.marker_biomass)
		to_chat(user, span_warning("You don't have enough biomass!"))
		return
	biomass_spent = class.biomass_cost
	spawning_necromorph = class.type
	timer_id = addtimer(CALLBACK(src, PROC_REF(add_necromorph_to_spawn)), DEFAULT_SPAWN_COOLDOWN, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_NO_HASH_WAIT)

/obj/structure/necromorph/nest/proc/add_necromorph_to_spawn()
	if((available_necromorphs+currently_active_necromorphs) >= max_spawns)
		return
	available_necromorphs++
	if((available_necromorphs+currently_active_necromorphs) < max_spawns)
		timer_id = addtimer(CALLBACK(src, PROC_REF(add_necromorph_to_spawn)), DEFAULT_SPAWN_COOLDOWN, TIMER_UNIQUE|TIMER_STOPPABLE|TIMER_NO_HASH_WAIT)

/datum/action/cooldown/necro/corruption/nest
	name = "Nest"
	button_icon_state = "nest"
	place_structure = /obj/structure/necromorph/nest
	cost = 110
	marker_only = TRUE

#undef DEFAULT_SPAWN_COOLDOWN
