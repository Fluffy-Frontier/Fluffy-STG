#define CHARGE_SPEED min((tiles_moved - tiles_before_charge) * speed_per_tile, maximum_speed)
#define CHARGE_STOP -1
#define LIVING_CRUSH_DAMAGE 20

/datum/action/cooldown/necro/long_charge
	name = "Toggle Charging"
	cooldown_time = 0
	/// Wether the user is currently charging or not
	var/active = FALSE
	/// The number of tiles the user has moved since the charge started
	var/tiles_moved = 0
	/// The number of tiles the user must move before the charge starts.
	/// Creates negative speed modifier to make users toggle charging when needed
	var/tiles_before_charge = 3
	/// The speed modifier per tile moved
	var/speed_per_tile = 0.15
	/// The maximum speed modifier
	var/maximum_speed = 2.1
	/// Time before which we should make a move to continue charge
	var/next_move_limit = 0
	/// Direction we are charging at
	var/charge_dir = NONE
	/// If this charge should keep momentum on dir change and if it can charge diagonally
	var/agile_charge = FALSE

/datum/action/cooldown/necro/long_charge/New(Target, original, cooldown)
	desc = "Toggle charging to move faster and cause damage on crush. You will be slower before you move [tiles_before_charge] tiles."
	..()

/datum/action/cooldown/necro/long_charge/Activate(atom/target)
	if(active)
		stop_charge()
		to_chat(owner, span_notice("You stop charging when moving."))
		return TRUE
	start_charge()
	to_chat(owner, span_notice("You start charging when moving."))
	return TRUE

/datum/action/cooldown/necro/long_charge/proc/start_charge()
	active = TRUE
	tiles_moved = 0
	RegisterSignal(owner, COMSIG_MOB_CLIENT_PRE_MOVE, PROC_REF(on_client_premove))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(owner, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_dir_change))
	RegisterSignal(owner, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump))
	relalculate_speed()

/datum/action/cooldown/necro/long_charge/proc/stop_charge()
	active = FALSE
	tiles_moved = 0
	UnregisterSignal(owner, list(COMSIG_MOB_CLIENT_PRE_MOVE, COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE, COMSIG_MOVABLE_BUMP))
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/necro_charge)

/datum/action/cooldown/necro/long_charge/proc/on_client_premove(datum/source, list/move_args)
	SIGNAL_HANDLER
	if(next_move_limit < world.time || (!agile_charge && move_args[2] != charge_dir))
		tiles_moved = 0
		relalculate_speed()

/datum/action/cooldown/necro/long_charge/proc/on_moved(datum/source, atom/oldloc, direction, Forced, old_locs)
	SIGNAL_HANDLER
	if(Forced || owner.throwing)
		return
	if(!agile_charge)
		charge_dir = direction
	++tiles_moved
	relalculate_speed()
	on_moved_action()

/datum/action/cooldown/necro/long_charge/proc/on_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER
	tiles_moved = 0
	relalculate_speed()

/datum/action/cooldown/necro/long_charge/proc/on_bump(datum/source, atom/bumped)
	SIGNAL_HANDLER
	if(tiles_moved <= tiles_before_charge)
		return
	bumped.crush_act(owner, src, CHARGE_SPEED)

/datum/action/cooldown/necro/long_charge/proc/slowdown_charge(tiles)
	//Might need to add some to_chat/visible_message calls below
	var/previous = tiles_moved
	if(tiles == CHARGE_STOP)
		tiles_moved = 0
	else
		tiles_moved = max(tiles - tiles_moved, 0)

	if(previous != tiles_moved)
		relalculate_speed()

/datum/action/cooldown/necro/long_charge/proc/relalculate_speed()
	if(active)
		owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/necro_charge, TRUE, CHARGE_SPEED)

//To be overridden by child types
/datum/action/cooldown/necro/long_charge/proc/on_moved_action()
	return

//To be overridden by child types
/datum/action/cooldown/necro/long_charge/proc/special_crush_living(mob/living/crushed)
	return FALSE

/atom/proc/crush_act(mob/living/crushing, datum/action/cooldown/necro/long_charge/action, speed)
	action.slowdown_charge(CHARGE_STOP)

/mob/living/crush_act(mob/living/crushing, datum/action/cooldown/necro/long_charge/action, speed)
	apply_damage(speed * 20, BRUTE, BODY_ZONE_CHEST)
	if(QDELING(src))
		return

	if(density && ((mob_size == crushing.mob_size && speed <= action.maximum_speed) || mob_size > crushing.mob_size))
		action.slowdown_charge(CHARGE_STOP)
		step(src, action.charge_dir)
		return

	if(!action.special_crush_living(src))
		action.slowdown_charge(CHARGE_STOP)

/turf/crush_act(mob/living/crushing, datum/action/cooldown/necro/long_charge/action, speed)
	if(speed >= action.maximum_speed)
		EX_ACT(src, EXPLODE_HEAVY)
	else
		EX_ACT(src, EXPLODE_LIGHT)

	if(QDELING(src))
		return

	action.slowdown_charge(CHARGE_STOP)

/obj/proc/speed_to_crush_damage(datum/action/cooldown/necro/long_charge/action, speed)
	if(!anchored)
		unbuckle_all_mobs()
		return speed * 20

	if(flags_1 & ON_BORDER_1)
		if(dir == REVERSE_DIR(action.charge_dir))
			action.slowdown_charge(3)
			return speed * 80
		action.slowdown_charge(1)
		return speed * 160

	action.slowdown_charge(2)
	return speed * 240

/obj/vehicle/speed_to_crush_damage(datum/action/cooldown/necro/long_charge/action, speed)
	return speed * 16

/obj/vehicle/unmanned/speed_to_crush_damage(datum/action/cooldown/necro/long_charge/action, speed)
	return speed * 10

/obj/vehicle/sealed/mecha/speed_to_crush_damage(datum/action/cooldown/necro/long_charge/action, speed)
	return speed * 240

/obj/structure/razorwire/speed_to_crush_damage(datum/action/cooldown/necro/long_charge/action, speed)
	if(!anchored)
		return speed * 20
	action.slowdown_charge(3)
	return speed * 45

/obj/crush_act(mob/living/crushing, datum/action/cooldown/necro/long_charge/action, speed)
	if(resistance_flags & INDESTRUCTIBLE)
		action.slowdown_charge(CHARGE_STOP)
		return

	playsound(loc, "punch", 25, 1)
	take_damage(speed_to_crush_damage(action, speed), BRUTE, MELEE)
	if(QDELING(src))
		return

	if(anchored)
		action.slowdown_charge(CHARGE_STOP)
		return

	var/throw_dir = pick(
		turn(action.charge_dir, 45),
		turn(action.charge_dir, -45),
		turn(action.charge_dir, 90),
		turn(action.charge_dir, -90),
		) //Throwing them somewhere not behind nor ahead of the charger.
	var/throw_dist = min(round(speed) + 1, 3)

	var/throw_x = src.x
	if(throw_dir & WEST)
		throw_x += throw_dist
	else if(throw_dir & EAST)
		throw_x -= throw_dist

	var/throw_y = src.y
	if(throw_dir & NORTH)
		throw_y += throw_dist
	else if(throw_dir & SOUTH)
		throw_y -= throw_dist

	throw_x = clamp(throw_x, 1, world.maxx)
	throw_y = clamp(throw_y, 1, world.maxy)

	if(!safe_throw_at(locate(throw_x, throw_y, z), throw_dist, 1, crushing, TRUE) && density)
		action.slowdown_charge(CHARGE_STOP)
		return

	action.slowdown_charge(2)
	return

/obj/machinery/vending/crush_act(mob/living/crushing, datum/action/cooldown/necro/long_charge/action, speed)
	if(!anchored)
		return ..()
	if(density)
		action.slowdown_charge(CHARGE_STOP)
		return

/obj/vehicle/crush_act(mob/living/crushing, datum/action/cooldown/necro/long_charge/action, speed)
	take_damage(speed_to_crush_damage(action, speed), BRUTE, MELEE)
	if(density && crushing.move_force <= move_resist)
		action.slowdown_charge(CHARGE_STOP)
		return
	action.slowdown_charge(2)

/*
	Long charge subtypes below
*/

/datum/action/cooldown/necro/long_charge/brute
	agile_charge = FALSE

/datum/action/cooldown/necro/long_charge/brute/on_moved_action()
	var/shake_dist = min(round(CHARGE_SPEED * 5), 7)
	if(shake_dist <= 0)
		return

	for(var/mob/living/carbon/victim in range(shake_dist, owner))
		if(victim.stat == DEAD)
			continue
		if(victim.client)
			shake_camera(victim, 1, 1)

/datum/action/cooldown/necro/long_charge/brute/special_crush_living(mob/living/crushed)
	crushed.Paralyze(CHARGE_SPEED * 20)

	if(crushed.anchored)
		return

	var/throw_dir = pick(
		turn(charge_dir, 45),
		turn(charge_dir, -45),
		turn(charge_dir, 90),
		turn(charge_dir, -90),
		) //Throwing them somewhere not behind nor ahead of the charger.
	var/throw_dist = min(round(CHARGE_SPEED) + 1, 3)

	var/throw_x = crushed.x
	if(throw_dir & WEST)
		throw_x += throw_dist
	else if(throw_dir & EAST)
		throw_x -= throw_dist

	var/throw_y = crushed.y
	if(throw_dir & NORTH)
		throw_y += throw_dist
	else if(throw_dir & SOUTH)
		throw_y -= throw_dist

	throw_x = clamp(throw_x, 1, world.maxx)
	throw_y = clamp(throw_y, 1, world.maxy)

	if(!crushed.safe_throw_at(locate(throw_x, throw_y, crushed.z), throw_dist, 1, owner, TRUE) && crushed.density)
		return

	slowdown_charge(1)
	return TRUE

#undef CHARGE_STOP
#undef CHARGE_SPEED
#undef LIVING_CRUSH_DAMAGE
