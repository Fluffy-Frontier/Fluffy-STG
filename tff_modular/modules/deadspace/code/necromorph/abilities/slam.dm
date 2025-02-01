/*
	Slam is an AOE melee attack, primarily used by the necromorph brute.
	Slam strikes a three-tile arc either side of an epicentre.
	Any standing mobs in the affected area which are smaller than the attacker, will be knocked down for a time
*/

#define WINDUP_TIME 2 SECONDS

/datum/action/cooldown/necro/slam
	name = "Slam"
	desc = "The brute's signature move."
	click_to_activate = TRUE
	cooldown_time = 8 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_SLAM_DOWN

/datum/action/cooldown/necro/slam/PreActivate(atom/target)
	target = get_step(owner, get_dir(owner, target))

	if(!target)
		to_chat(owner, "You can't slam in that direction!")
		return FALSE
	if (target == get_turf(owner))
		to_chat(owner, "You can't slam yourself!")
		return FALSE

	return ..()

/datum/action/cooldown/necro/slam/Activate(turf/target)
	StartCooldown()
	SlamTarget(target)
	return TRUE

/datum/action/cooldown/necro/slam/proc/SlamTarget(turf/target)
	set waitfor = FALSE

	var/mob/living/carbon/human/necromorph/necro = owner
	necro.play_necro_sound(SOUND_SHOUT, VOLUME_MID, 1, 3)

	necro.face_atom(target)

	ADD_TRAIT(necro, TRAIT_INCAPACITATED, src)
	ADD_TRAIT(necro, TRAIT_IMMOBILIZED, src)
	ADD_TRAIT(necro, TRAIT_HANDS_BLOCKED, src)

	//Here we start the windup.
	var/cached_pixels_x = necro.pixel_x
	var/cached_pixels_y = necro.pixel_y

	//We do the windup animation. This involves the user slowly rising into the air, and tilting back if striking horizontally
	animate(
		necro,
		transform = turn(matrix(), 25*SIGN(necro.x - target.x)),
		pixel_y = cached_pixels_y + 16,
		time = WINDUP_TIME
	)

	sleep(WINDUP_TIME)

	//Lets finish the slamming animation. We drop sharply back to the floor
	//And, if we had an x offset, we'll also strike there
	animate(
		necro,
		transform = null,
		pixel_y = cached_pixels_y,
		pixel_x = cached_pixels_x,
		time = 0.5 SECONDS,
		easing = BACK_EASING
	)

	sleep(2)
	//Wait a little, then we strike

	playsound(target, 'tff_modular/modules/deadspace/sound/weapons/heavysmash.ogg', 100, 1, 20,20)

	var/dir_to_target = get_dir(owner, target)
	var/list/affected_turfs = list(target)

	affected_turfs += get_step(owner, turn(dir_to_target, 45))
	affected_turfs += get_step(owner, turn(dir_to_target, -45))

	for(var/turf/T in affected_turfs)
		if(isnull(T))
			continue
		for(var/mob/living/living in T)
			living.Knockdown(3 SECONDS)
			living.drop_all_held_items()
		if(isclosedturf(T))
			EX_ACT(T, EXPLODE_HEAVY)
		else
			EX_ACT(T, EXPLODE_LIGHT)
			for(var/atom/A in T)
				//We dont want brute to destroy this stuff
				if(!istype(A, /obj/machinery/atmospherics/pipe) && !istype(A, /obj/structure/cable) && !istype(A, /obj/structure/disposalpipe))
					EX_ACT(A, EXPLODE_HEAVY)

	sleep(1)
	playsound(target, 'tff_modular/modules/deadspace/sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	sleep(1)
	playsound(target, 'tff_modular/modules/deadspace/sound/weapons/heavysmash.ogg', 100, 1, 20,20)
	sleep(1)
	animate(necro, transform=matrix(), pixel_x = cached_pixels_x, pixel_y = cached_pixels_y, time = 7)
	sleep(7)

	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, src)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, src)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, src)

#undef WINDUP_TIME
