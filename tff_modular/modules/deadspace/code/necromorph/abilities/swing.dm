/datum/action/cooldown/necro/swing
	name = "Swing"
	desc = "An arm swing pulling in all enemies it hits"
	click_to_activate = TRUE
	cooldown_time = 8 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_HUNTERSWING_DOWN
	var/swing_time = 1 SECONDS //ORIGINAL 1.5
	var/move_time = 2 SECONDS
	var/angle = 150
	var/range = 3
	var/visual_type = /obj/effect/temp_visual/swing
	var/hitsound = 'sound/items/weapons/slice.ogg'
	var/damage = 10
	var/knockdown_time = 2 SECONDS
	var/actively_moving = FALSE
	var/turf/swing_target

/datum/action/cooldown/necro/swing/PreActivate(atom/target)
	if(owner.incapacitated)
		return FALSE
	if(!get_turf(target))
		return FALSE

	return ..()

/datum/action/cooldown/necro/swing/Activate(atom/target)
	StartCooldown()
	target = get_turf(target)
	owner.face_atom(target)

	var/datum/move_loop/new_loop = GLOB.move_manager.move_towards(owner, target, 1.6, FALSE, 0.25 SECONDS)
	if(!new_loop)
		return TRUE

	actively_moving = FALSE
	swing_target = target
	windup()
	RegisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_move))
	RegisterSignal(new_loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(new_loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(new_loop, COMSIG_MOVELOOP_STOP, PROC_REF(loop_end))
	return TRUE

/datum/action/cooldown/necro/swing/proc/windup()
	var/cached_pixel_x = owner.pixel_x
	var/cached_pixel_y = owner.pixel_y

	animate(
		owner,
		pixel_x = owner.pixel_x + (SIGN(swing_target.x - owner.x) * -24),
		pixel_y = owner.pixel_y + (SIGN(swing_target.y - owner.y) * -24),
		time = 0.25 SECONDS,
		easing = BACK_EASING
	)
	animate(pixel_x = cached_pixel_x, pixel_y = cached_pixel_y, time = 0.5 SECONDS, easing = BACK_EASING)

/datum/action/cooldown/necro/swing/proc/pre_move()
	SIGNAL_HANDLER
	actively_moving = TRUE

/datum/action/cooldown/necro/swing/proc/post_move()
	SIGNAL_HANDLER
	actively_moving = FALSE

/datum/action/cooldown/necro/swing/proc/on_move()
	SIGNAL_HANDLER
	if(!actively_moving)
		return COMSIG_KB_MOB_BLOCKMOVEMENT_DOWN // ELSE client/user user.movement_locked = TRUE BUG?

/datum/action/cooldown/necro/swing/proc/loop_end()
	SIGNAL_HANDLER
	UnregisterSignal(owner, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_move))
	INVOKE_ASYNC(src, PROC_REF(swing))

/datum/action/cooldown/necro/swing/proc/swing()
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, src)

	//Calculate cone that we will hit
	var/turf/our_loc = get_turf(owner)

	var/angle_to_target = ATAN2(swing_target.x - our_loc.x, swing_target.y - our_loc.y)
	var/smallest_angle = SIMPLIFY_DEGREES(angle_to_target - (angle / 2))
	var/biggest_angle = SIMPLIFY_DEGREES(angle_to_target + (angle / 2))

	var/list/list/stages[ROUND_UP(angle/30)]

	for(var/i=1 to length(stages))
		stages[i] = list()

	for(var/turf/T as anything in RANGE_TURFS(range, our_loc)-our_loc)
		if(get_dist_euclidean(our_loc, T) > range)
			continue
		var/angle_to_turf = SIMPLIFY_DEGREES(ATAN2(T.x - our_loc.x, T.y - our_loc.y))
		if(smallest_angle > biggest_angle)
			if(angle_to_turf < smallest_angle && angle_to_turf > biggest_angle)
				continue
		else if (angle_to_turf < smallest_angle || angle_to_turf > biggest_angle)
			continue
		stages[ROUND_UP(SIMPLIFY_DEGREES(angle_to_turf - smallest_angle)/30)] += T

	// 1 is right, -1 is left
	var/hand_modifier = (owner.active_hand_index % 2) ? - 1 : 1

	execute_swing(stages, hand_modifier, ((hand_modifier > -1) ? biggest_angle : smallest_angle) * -1)

	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, src)

/datum/action/cooldown/necro/swing/proc/execute_swing(list/list/stages, hand_modifier, starting_degree)
	var/sleep_time = swing_time/length(stages)
	var/turf/our_loc = get_turf(owner)

	var/obj/effect/visual_effect = new visual_type(our_loc, swing_time, angle, hand_modifier, starting_degree)

	for(var/list/stage as anything in stages)
		var/list/to_check = stage.Copy()
		while(length(to_check))
			var/turf/turf_to_check = to_check[1]
			var/list/line = get_line(our_loc, turf_to_check)
			to_check -= line
			var/turf/previous_turf = our_loc
			for(var/turf/T as anything in line)
				if(!T.CanPass(visual_effect, get_dir(previous_turf, T)))
					break
				line -= T
				previous_turf = T

			stage -= line

		for(var/turf/T as anything in stage)
			hit_turf(T)

		sleep(sleep_time)

/datum/action/cooldown/necro/swing/proc/hit_turf(turf/T)
	for(var/mob/living/L in T)
		hit_mob(L)

/datum/action/cooldown/necro/swing/proc/hit_mob(mob/living/L)
	//Shouldn't happen, but I'd rather be safe than sorry
	if(L == owner)
		return

	L.Knockdown(knockdown_time)
	L.apply_damage(damage, BRUTE, owner.zone_selected)
	playsound(L, hitsound, VOLUME_MID, TRUE)
	return TRUE

/obj/effect/temp_visual/swing
	name = "tentacle"
	icon = 'tff_modular/modules/deadspace/icons/necromorphs/swinging_limbs.dmi'
	base_icon_state = "harvester_tentacle"
	icon_state = "harvester_tentacle"
	randomdir = FALSE
	//Centered for hunter
	pixel_x = -40
	pixel_y = -32
	var/variable_icon = FALSE
	//This lets us have different swing sounds for different swing visuals
	var/swing_sound = list(
		'tff_modular/modules/deadspace/sound/effects/attacks/big_swoosh_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/attacks/big_swoosh_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/attacks/big_swoosh_3.ogg',
		)

/obj/effect/temp_visual/swing/Initialize(mapload, duration, angle, swing_direction, starting_degree)
	src.duration = duration
	if(variable_icon)
		icon_state = base_icon_state + ((swing_direction > -1) ? "_left" : "_right")
	// Icons are actually at -90 degrees
	transform = transform.Turn(starting_degree + 90)
	. = ..()
	var/turn_angle = angle * swing_direction * 1.1
	var/swing_sounds = src.swing_sound
	animate(src, duration, transform = transform.Turn(turn_angle), easing = CIRCULAR_EASING)
	playsound(src, pick(swing_sounds), VOLUME_MID, 1)
