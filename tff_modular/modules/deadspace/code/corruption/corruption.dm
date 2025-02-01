#define GROW 1
#define SPREAD 2
#define DECAY 3
#define IDLE 4

// Amount of integrity lost and gained per second
#define INTEGRITY_PER_SECOND 3

/obj/structure/corruption
	name = ""
	desc = "There is something scary in it."
	icon = 'tff_modular/modules/deadspace/icons/effects/new_corruption.dmi'
	icon_state = "corruption-1"
	base_icon_state = "corruption"
	layer = NECROMORPH_CORRUPTION_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT //Corruption can be clicked through
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_NECROMORPHS
	canSmoothWith = SMOOTH_GROUP_NECROMORPHS + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS
	anchored = TRUE
	max_integrity = 20
	integrity_failure = 0.5
	//Smallest alpha we can get in on_integrity_change()
	alpha = 20
	resistance_flags = UNACIDABLE
	pass_flags = PASSTABLE | PASSGRILLE
	interaction_flags_atom = NONE
	/// Node that keeps us alive
	var/datum/corruption_node/master
	/// If we are growing or decaying
	var/state = null
	/// Bitmask of directions we can potentially spread to (those directions have open turfs)
	var/dirs_to_spread = 0
	/// If our loc has stairs. Used to for optimization
	var/has_stairs = FALSE
	/// The list of turfs that the corruption will not be able to grow over
	var/static/list/blacklisted_turfs = list(
		/turf/open/space,
		/turf/open/chasm,
		/turf/open/lava,
		/turf/open/openspace,
	)

/obj/structure/corruption/Initialize(mapload, datum/corruption_node/new_master)
	.=..()
	if(!new_master)
		return INITIALIZE_HINT_QDEL

	for(var/obj/structure/corruption/corruption in loc)
		if(corruption != src)
			return INITIALIZE_HINT_QDEL

	if(isturf(loc))
		var/turf/our_loc = loc
		our_loc.necro_corrupted = TRUE

	set_master(new_master)

	state = GROW

	atom_integrity = 3
	//I hate that you can't just override update_integrity()
	RegisterSignal(src, COMSIG_ATOM_INTEGRITY_CHANGED, PROC_REF(on_integrity_change))

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_location_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_location_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	if(locate(/obj/structure/stairs) in loc)
		has_stairs = TRUE

	update_dirs_to_spread()

	START_PROCESSING(SSnecrocorruption, src)

	SEND_SIGNAL(loc, COMSIG_TURF_NECRO_CORRUPTED, src)

/obj/structure/corruption/Destroy()
	if(master)
		master.remaining_weed_amount++
		master.corruption -= src
	master = null

	STOP_PROCESSING(SSnecrocorruption, src)
	var/turf/previous_loc = loc
	.=..()

	if(isturf(previous_loc) && !(locate(/obj/structure/corruption) in previous_loc))
		previous_loc.necro_corrupted = FALSE
		SEND_SIGNAL(previous_loc, COMSIG_TURF_NECRO_UNCORRUPTED, src)

/obj/structure/corruption/proc/get_integrity_lost() //atom_defence.dm
	return max_integrity - get_integrity()

/obj/structure/corruption/Moved(turf/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(QDELING(src))
		return
	if(istype(old_loc))
		old_loc.necro_corrupted = FALSE
	if(!isturf(loc))
		qdel(src)
		return
	var/turf/our_loc = loc
	our_loc.necro_corrupted = TRUE
	update_dirs_to_spread(old_loc)

/obj/structure/corruption/process(delta_time)
	switch(state)
		if(GROW)
			repair_damage(INTEGRITY_PER_SECOND*delta_time)
		if(SPREAD)
			/*
				We use get_dist instead of IN_GIVEN_RANGE because we want to spread to turfs that are on different Z levels
			*/
			var/list/dirs_to_process = GLOB.cardinals.Copy()
			if(has_stairs)
				var/obj/structure/stairs/stairs = locate(/obj/structure/stairs) in loc
				if(stairs.isTerminator())
					dirs_to_process -= stairs.dir
					var/turf/check_turf = get_step_multiz(loc, (stairs.dir|UP))
					var/turf/above_turf = GET_TURF_ABOVE(check_turf)
					if(above_turf?.zPassOut(UP))
						if(check_turf?.Enter(src, TRUE) && !check_turf.necro_corrupted)
							if(master.remaining_weed_amount > 0 && get_dist(check_turf, master.parent) <= master.control_range)
								new /obj/structure/corruption(check_turf, master)

			if(!dirs_to_spread)
				return

			for(var/direction in dirs_to_process)
				if(!(dirs_to_spread & direction))
					continue
				var/turf/check_turf = get_step(src, direction)
				if(check_turf.Enter(src, TRUE))
					if(isopenspaceturf(check_turf))
						var/turf/below = GET_TURF_BELOW(check_turf)
						if(check_turf.zPassOut(DOWN) && below?.zPassOut(DOWN) && !below.necro_corrupted)
							if(master.remaining_weed_amount > 0 && get_dist(below, master.parent) <= master.control_range)
								new /obj/structure/corruption(below, master)
						return
					//Check if our node can be used
					if(master.remaining_weed_amount > 0 && get_dist(check_turf, master.parent) <= master.control_range)
						new /obj/structure/corruption(check_turf, master)
						continue
					//Otherwise search for a a nearby node
					for(var/datum/corruption_node/node as anything in master.marker.nodes-master)
						if(node.remaining_weed_amount > 0 && IN_GIVEN_RANGE(check_turf, node.parent, node.control_range))
							new /obj/structure/corruption(check_turf, node)
		if(DECAY)
			take_damage(INTEGRITY_PER_SECOND*delta_time)
		if(IDLE)
			. = PROCESS_KILL
			CRASH("Corruption was processing in IDLE state")
		else
			. = PROCESS_KILL
			CRASH("Corruption was processing with state: [isnull(state) ? "NULL" : state]")

/obj/structure/corruption/proc/on_location_entered(atom/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(istype(arrived, /obj/structure/stairs))
		has_stairs = TRUE
		update_spread_state()

/obj/structure/corruption/proc/on_location_exited(atom/source, atom/movable/gone, direction)
	if(istype(gone, /obj/structure/stairs) && !(locate(/obj/structure/stairs) in loc))
		has_stairs = FALSE
		update_spread_state()

/obj/structure/corruption/proc/update_dirs_to_spread(turf/old_loc)
	dirs_to_spread = 0

	if(old_loc)
		for(var/potential_dir in GLOB.cardinals)
			var/turf/turf = get_step(old_loc, potential_dir)
			if(isopenspaceturf(turf))
				UnregisterSignal(GET_TURF_BELOW(turf), list(COMSIG_TURF_CHANGE, COMSIG_TURF_NECRO_CORRUPTED, COMSIG_TURF_NECRO_UNCORRUPTED))
			UnregisterSignal(turf, list(COMSIG_TURF_CHANGE, COMSIG_TURF_NECRO_CORRUPTED, COMSIG_TURF_NECRO_UNCORRUPTED))

	for(var/potential_dir in GLOB.cardinals)
		var/turf/turf = get_step(loc, potential_dir)
		register_turf(turf, potential_dir)
		if(isopenspaceturf(turf))
			register_turf(GET_TURF_BELOW(turf), potential_dir)

	update_spread_state()

/obj/structure/corruption/proc/register_turf(turf/target, potential_dir)
	RegisterSignal(target, COMSIG_TURF_CHANGE, PROC_REF(on_nearby_turf_change))

	if(!isopenturf(target) || is_type_in_list(target, blacklisted_turfs))
		return

	if(!target.necro_corrupted)
		RegisterSignal(target, COMSIG_TURF_NECRO_CORRUPTED, PROC_REF(on_nearby_turf_corrupted))
		dirs_to_spread |= potential_dir
	else
		RegisterSignal(target, COMSIG_TURF_NECRO_UNCORRUPTED, PROC_REF(on_nearby_turf_uncorrupted))

/obj/structure/corruption/proc/update_spread_state()
	if(!master || get_integrity_lost())
		return
	if(dirs_to_spread || has_stairs)
		state = SPREAD
		START_PROCESSING(SSnecrocorruption, src)
	else
		state = IDLE
		STOP_PROCESSING(SSnecrocorruption, src)

/obj/structure/corruption/proc/on_nearby_turf_change(turf/source, path, list/new_baseturfs, flags, list/post_change_callbacks)
	if(isopenspaceturf(source))
		if(ispath(/turf/open/openspace))
			return
		UnregisterSignal(GET_TURF_BELOW(source), list(COMSIG_TURF_CHANGE, COMSIG_TURF_NECRO_CORRUPTED, COMSIG_TURF_NECRO_UNCORRUPTED))

	if(ispath(path, /turf/open) && !is_path_in_list(path, blacklisted_turfs))
		if(isopenturf(source) && !is_type_in_list(source, blacklisted_turfs))
			return
		//Assume turf is not corrupted yet since it couldn't be corrupted before
		RegisterSignal(source, COMSIG_TURF_NECRO_CORRUPTED, PROC_REF(on_nearby_turf_corrupted))
		dirs_to_spread |= get_dir(loc, source)
	else
		dirs_to_spread &= ~get_dir(loc, source)
		UnregisterSignal(source, list(COMSIG_TURF_NECRO_CORRUPTED, COMSIG_TURF_NECRO_UNCORRUPTED))
		if(ispath(/turf/open/openspace))
			register_turf(GET_TURF_BELOW(source), get_dir(loc, source))

	update_spread_state()

/obj/structure/corruption/proc/on_nearby_turf_corrupted(turf/source)
	dirs_to_spread &= ~get_dir(loc, source)
	update_spread_state()

/obj/structure/corruption/proc/on_nearby_turf_uncorrupted(turf/source)
	dirs_to_spread |= get_dir(loc, source)
	update_spread_state()

/obj/structure/corruption/proc/on_master_delete()
	master.corruption -= src
	var/datum/corruption_node/old_master = master
	for(var/datum/corruption_node/node as anything in old_master.marker.nodes)
		if(node.remaining_weed_amount > 0 && IN_GIVEN_RANGE(src, node.parent, node.control_range))
			set_master(node)
			return
	master = null
	state = DECAY
	START_PROCESSING(SSnecrocorruption, src)

/obj/structure/corruption/proc/on_integrity_change(atom/source, old_integrity, new_integrity)
	SIGNAL_HANDLER
	if(master)
		if(old_integrity >= max_integrity)
			state = GROW
			START_PROCESSING(SSnecrocorruption, src)
		else if(new_integrity >= max_integrity)
			update_spread_state()
	alpha = clamp(255*new_integrity/max_integrity, 20, 185)

// Doesn't do any safety checks, make sure to do them first
/obj/structure/corruption/proc/set_master(datum/corruption_node/new_master)
	if(!new_master)
		return
	if(master)
		master.remaining_weed_amount++
		master.corruption -= src
	master = new_master
	new_master.remaining_weed_amount--
	new_master.corruption += src
	if(state == DECAY)
		if(get_integrity_lost())
			state = GROW
			START_PROCESSING(SSnecrocorruption, src)
		else
			update_spread_state()

/obj/structure/corruption/play_attack_sound(damage_amount, damage_type, damage_flag)
	return

/obj/structure/corruption/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	switch(damage_type)
		if(BRUTE)
			damage_amount *= 0.25
		if(BURN)
			damage_amount *= 2
	. = ..()

/obj/structure/corruption/can_see_marker()
	return RANGE_TURFS(1, src)

#undef INTEGRITY_PER_SECOND

#undef GROW
#undef SPREAD
#undef DECAY
#undef IDLE
