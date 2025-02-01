#define CHARGE_SPEED(charger) (min(charger.valid_steps_taken, charger.max_steps_buildup) * charger.speed_per_step)

/datum/action/cooldown/necro/charge
	name = "Charge"
	desc = "Allows you to charge at a chosen position."
	cooldown_time = 10 SECONDS
	click_to_activate = TRUE
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_CHARGE_DOWN
	/// Delay before the charge actually occurs
	var/charge_delay = 10 SECONDS
	/// The maximum amount of time we can charge
	var/charge_time = 10 SECONDS
	/// The sleep time before moving in deciseconds while charging
	var/charge_speed = 4
	/// If the current move is being triggered by us or not
	var/actively_moving = FALSE
	var/valid_steps_taken = 0
	var/speed_per_step = 0.15
	var/max_steps_buildup = 14

	var/atom/target_atom

/datum/action/cooldown/necro/charge/PreActivate(atom/target)
	var/mob/living/carbon/human/necromorph/charger = owner
	var/turf/T = get_turf(target)
	if(!T)
		return FALSE
	if(charger.resting)
		to_chat(charger, span_notice("You cannot charge while on the floor!"))
		return FALSE
	if(!ishuman(target))
		for(var/mob/living/carbon/human/hummie in view(1, T))
			if(!isnecromorph(hummie))
				target = hummie
				break
	if(target == owner || isnecromorph(target))
		return FALSE

	target_atom = target

	if(isturf(target))
		RegisterSignal(target, COMSIG_ATOM_ENTERED, PROC_REF(on_target_loc_entered))
	else
		var/static/list/loc_connections = list(
			COMSIG_ATOM_ENTERED = PROC_REF(on_target_loc_entered),
		)
		AddComponent(/datum/component/connect_loc_behalf, target, loc_connections)

	return ..()

/datum/action/cooldown/necro/charge/Activate(atom/target)
	var/mob/living/carbon/human/necromorph/exploder/user = owner
	var/initial_transform = matrix(user.transform)
	var/initial_x = user.pixel_x
	var/initial_y = user.pixel_y
	var/shake_dir
	shake_dir = pick(-1, 1)
	user.play_necro_sound(SOUND_SHOUT, VOLUME_MID, TRUE, 3)
	animate(
		user,
		pixel_x = (3 * shake_dir),
		pixel_y = (2 * shake_dir),
		time = 1
	)
	animate(
		pixel_x = initial_x,
		pixel_y = initial_y,
		time = 2,
		easing = ELASTIC_EASING
	)
	PLAY_SHAKING_ANIMATION(user, 7, 5, shake_dir, initial_x, initial_y, initial_transform)
	PLAY_SHAKING_ANIMATION(user, 10, 6, shake_dir, initial_x, initial_y, initial_transform)
	// Start pre-cooldown so that the ability can't come up while the charge is happening
	StartCooldown(charge_time+charge_delay+1)
	addtimer(CALLBACK(src, PROC_REF(do_charge)), charge_delay)
	return TRUE

/datum/action/cooldown/necro/charge/proc/do_charge()
	var/mob/living/carbon/human/necromorph/charger = owner

	actively_moving = FALSE
	charger.charging = TRUE
	RegisterSignal(charger, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump))
	RegisterSignal(charger, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_move))
	RegisterSignal(charger, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	charger.setDir(get_dir(charger, target_atom))
	do_charge_indicator(target_atom)

	var/datum/move_loop/new_loop = GLOB.move_manager.move_towards(charger, target_atom, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
	if(!new_loop)
		UnregisterSignal(charger, list(COMSIG_MOVABLE_BUMP, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED))
		return
	RegisterSignal(new_loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(new_loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(new_loop, COMSIG_MOVELOOP_STOP, PROC_REF(charge_end))
	RegisterSignal(charger, COMSIG_MOB_STATCHANGE, PROC_REF(stat_changed))
	RegisterSignal(charger, COMSIG_LIVING_UPDATED_RESTING, PROC_REF(update_resting))

	SEND_SIGNAL(charger, COMSIG_STARTED_CHARGE)

/datum/action/cooldown/necro/charge/proc/on_target_loc_entered(atom/loc, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER
	if(arrived != owner)
		return
	on_bump(owner, target_atom)

/datum/action/cooldown/necro/charge/proc/pre_move(datum)
	SIGNAL_HANDLER
	actively_moving = TRUE

/datum/action/cooldown/necro/charge/proc/post_move(datum)
	SIGNAL_HANDLER
	actively_moving = FALSE

/datum/action/cooldown/necro/charge/proc/charge_end(datum/move_loop/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/necromorph/charger = source.moving
	UnregisterSignal(charger, list(COMSIG_MOVABLE_BUMP, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_MOB_STATCHANGE, COMSIG_LIVING_UPDATED_RESTING))
	charger.charging = FALSE
	charger.remove_movespeed_modifier(/datum/movespeed_modifier/necro_charge)
	StartCooldown()
	SEND_SIGNAL(owner, COMSIG_FINISHED_CHARGE)

	qdel(GetComponent(/datum/component/connect_loc_behalf))
	target_atom = null
	charger.pixel_x = 0
	charger.pixel_y = 0

/datum/action/cooldown/necro/charge/proc/stat_changed(mob/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(new_stat > CONSCIOUS)
		GLOB.move_manager.stop_looping(owner)

/datum/action/cooldown/necro/charge/proc/do_charge_indicator(atom/charge_target)
	return

/datum/action/cooldown/necro/charge/proc/on_move(atom/source, atom/new_loc)
	SIGNAL_HANDLER
	if(!actively_moving)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/datum/action/cooldown/necro/charge/proc/on_moved(atom/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/necromorph/charger = source
	if(++valid_steps_taken <= max_steps_buildup)
		charger.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/necro_charge, TRUE, -CHARGE_SPEED(src))

	if(valid_steps_taken >= 15) //Sanity check so necros don't charge until they hit something if they miss a target
		GLOB.move_manager.stop_looping(owner)

	//Light shake with each step
	shake_camera(source, 1.5, 0.5)

	return

/datum/action/cooldown/necro/charge/proc/on_bump(atom/movable/source, atom/target)
	SIGNAL_HANDLER
	if(ismob(target) || target.uses_integrity)
		hit_target(source, target)
	GLOB.move_manager.stop_looping(owner)

/datum/action/cooldown/necro/charge/proc/hit_target(mob/living/carbon/human/necromorph/source, mob/living/target)
	target.attack_necromorph(source)
	if(isliving(target))
		if(ishuman(target))
			var/mob/living/carbon/human/human_target = target
			if(human_target.check_block(source, 0, "the [source.name]", attack_type = LEAP_ATTACK))
				source.Stun(6)
				shake_camera(source, 4, 3)
				shake_camera(target, 2, 1)
				return
		shake_camera(target, 4, 3)
		shake_camera(source, 2, 3)
		target.visible_message(
			span_danger("[source] slams into [target]!"),
			span_userdanger("[source] tramples you onto the ground!")
			)
		target.Knockdown(6)
		target.drop_all_held_items()
	else
		source.visible_message(span_danger("[source] smashes into [target]!"))
		shake_camera(source, 4, 3)
		source.Stun(6)

/datum/action/cooldown/necro/charge/proc/update_resting(atom/movable/source, resting)
	SIGNAL_HANDLER
	if(resting)
		GLOB.move_manager.stop_looping(source)

#undef CHARGE_SPEED
