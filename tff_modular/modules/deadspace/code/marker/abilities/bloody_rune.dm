/datum/action/cooldown/necro/psy/rune
	name = "Bloody Rune"
	desc = "Creates a spooky rune. Has no functional effects, just for decoration. Should be at least 3 tiles away from another bloody rune!"
	button_icon_state = "rune"
	cost = 16

/datum/action/cooldown/necro/psy/rune/Activate(atom/target)
	var/turf/target_turf = get_turf(target)
	if(isgroundlessturf(target_turf) || target_turf.density)
		to_chat(owner, span_warning("There is no space to place a rune!"))
		return
	//Using for loop because of compiler optiization
	for(var/obj/effect/decal/cleanable/necro_rune/rune in range(3, target_turf))
		to_chat(owner, span_warning("Another bloody rune is too close!"))
		return
	..()
	new /obj/effect/decal/cleanable/necro_rune(target_turf, null, RUNE_COLOR_MEDIUMRED, TRUE)
	return TRUE

//Initialized in make_datum_references_lists
GLOBAL_LIST_EMPTY(necro_runes)

/obj/effect/decal/cleanable/necro_rune
	name = "rune"
	desc = "Graffiti. Damn kids."
	icon = 'tff_modular/modules/deadspace/icons/effects/runes.dmi'
	icon_state = "rune-1"
	gender = NEUTER
	mergeable_decal = FALSE
	var/used_overlays = ""

/obj/effect/decal/cleanable/necro_rune/Initialize(mapload, colour, fade_in)
	. = ..()
	icon_state = "rune-[rand(1, 5)]"
	if(colour)
		color = colour
	for(var/i = 1 to 2)
		used_overlays += "[rand(1, 10)]"
		add_overlay(GLOB.necro_runes[i])
	if(fade_in)
		alpha = 0
		animate(src, alpha = 255, time = 1 SECONDS, flags = ANIMATION_PARALLEL)

/obj/effect/decal/cleanable/necro_rune/NeverShouldHaveComeHere(turf/T)
	return T.density || isgroundlessturf(T)

/obj/effect/decal/cleanable/necro_rune/update_overlays()
	. = ..()
	. += GLOB.necro_runes[used_overlays[1]]
	. += GLOB.necro_runes[used_overlays[2]]
