#define MOUNT_ANIMATION_TIME 0.15 SECONDS
#define PIXEL_X_OFFSET 1
#define PIXEL_Y_OFFSET 2

GLOBAL_LIST_INIT(wallrun_types_typecache, typecacheof(list(
		/turf/closed/wall,
		/obj/structure/grille,
		/obj/structure/window,
		/obj/machinery/door,
)))

/// Allows a living mob to climb on a wall and walk ignoring tables and gravity
/datum/component/wallrun
	var/atom/mount_point
	/// Cached values
	var/matrix/cached_matrix
	var/cached_alpha
	var/cached_passflags
	var/cached_density
	var/offset_x
	var/offset_y

/datum/component/wallrun/Initialize(list/circuit_component_types)
	var/mob/living/owner = parent
	if (!isliving(owner))
		return COMPONENT_INCOMPATIBLE
	if(istype(owner, /mob/living/carbon/human/necromorph/leaper))
		RegisterSignal(owner, COMSIG_STARTED_CHARGE, PROC_REF(on_charge_started))
	RegisterSignal(owner, list(COMSIG_MOVABLE_BUMP, COMSIG_LEAPER_MOUNT), PROC_REF(on_bump))

/datum/component/wallrun/proc/on_charge_started(mob/living/source)
	if(mount_point)
		unmount()
	UnregisterSignal(parent, list(COMSIG_STARTED_CHARGE, COMSIG_MOVABLE_BUMP))
	RegisterSignal(parent, COMSIG_FINISHED_CHARGE, PROC_REF(on_charge_finished))

/datum/component/wallrun/proc/mount_after_leap(mob/living/source, atom/bumped)
	mount_to(bumped)

/datum/component/wallrun/proc/on_charge_finished(mob/living/source)
	UnregisterSignal(parent, COMSIG_FINISHED_CHARGE)
	RegisterSignal(parent, COMSIG_STARTED_CHARGE, PROC_REF(on_charge_started))
	RegisterSignal(parent, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump))

/datum/component/wallrun/proc/on_bump(mob/living/source, atom/bumped)
	SIGNAL_HANDLER
	if(GLOB.wallrun_types_typecache[bumped.type])
		if(!mount_point && source.body_position == STANDING_UP)
			mount_to(bumped)
		else if(bumped != mount_point)
			transit_to(bumped)

/datum/component/wallrun/proc/mount_to(atom/bumped)
	cache_data(parent)
	var/mob/living/source = parent
	source.pass_flags |= PASSTABLE
	source.density = FALSE
	var/new_alpha = cached_alpha
	if(source.alpha > 100)
		new_alpha = max(cached_alpha * 0.5, 100)
	var/dir_to_source = get_dir(bumped, source)
	var/list/offset = get_pixel_offset(dir_to_source)
	animate(source, time = MOUNT_ANIMATION_TIME, pixel_x = offset[PIXEL_X_OFFSET], pixel_y = offset[PIXEL_Y_OFFSET], transform = matrix(cached_matrix, dir2angle(dir_to_source), MATRIX_ROTATE), alpha = new_alpha, easing = BACK_EASING)
	RegisterSignal(source, COMSIG_LIVING_UPDATED_RESTING, PROC_REF(update_resting))
	RegisterSignal(source, COMSIG_MOB_STATCHANGE, PROC_REF(on_parent_stat_change))
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))
	if(ismovable(bumped))
		RegisterSignal(bumped, COMSIG_MOVABLE_MOVED, PROC_REF(on_mount_point_moved))
	RegisterSignal(bumped, COMSIG_QDELETING, PROC_REF(unmount))
	RegisterSignal(bumped, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mount_point_dir_change))
	mount_point = bumped

/datum/component/wallrun/proc/get_pixel_offset(dir_to_source)
	var/mob/living/source = parent
	var/base_pixel_x = source.base_pixel_x
	var/base_pixel_y = source.base_pixel_y
	var/matrix/rotation =  matrix(cached_matrix, dir2angle(dir_to_source), MATRIX_ROTATE)
	var/list/offset[2]
	offset[PIXEL_X_OFFSET] = (base_pixel_x * rotation.a) + (base_pixel_y * rotation.b)
	offset[PIXEL_Y_OFFSET] = (base_pixel_x * rotation.d) + (base_pixel_y * rotation.e)
	return offset

/datum/component/wallrun/proc/transit_to(atom/bumped)
	var/mob/living/source = parent
	var/dir_to_source = get_dir(bumped, source)
	var/list/offset = get_pixel_offset(dir_to_source)
	animate(source, time = MOUNT_ANIMATION_TIME, pixel_x = offset[PIXEL_X_OFFSET], pixel_y = offset[PIXEL_Y_OFFSET], transform = matrix(cached_matrix, dir2angle(dir_to_source), MATRIX_ROTATE), easing = BACK_EASING)
	UnregisterSignal(mount_point, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING, COMSIG_ATOM_DIR_CHANGE))
	if(ismovable(bumped))
		RegisterSignal(bumped, COMSIG_MOVABLE_MOVED, PROC_REF(on_mount_point_moved))
	RegisterSignal(bumped, COMSIG_QDELETING, PROC_REF(unmount))
	RegisterSignal(bumped, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mount_point_dir_change))
	mount_point = bumped

/datum/component/wallrun/proc/unmount()
	SIGNAL_HANDLER
	UnregisterSignal(parent, list(COMSIG_MOB_STATCHANGE, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_UPDATED_RESTING))
	UnregisterSignal(mount_point, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING, COMSIG_ATOM_DIR_CHANGE))
	mount_point = null
	load_cached_data(parent)

/datum/component/wallrun/proc/cache_data(mob/living/source)
	cached_matrix = matrix(source.transform)
	cached_alpha = source.alpha
	cached_passflags = source.pass_flags
	cached_density = source.density

/datum/component/wallrun/proc/load_cached_data(mob/living/source)
	animate(source, time = MOUNT_ANIMATION_TIME, pixel_x = source.base_pixel_x, pixel_y = source.base_pixel_y, alpha = cached_alpha, transform = matrix(cached_matrix), easing = BACK_EASING)
	source.pass_flags = cached_passflags
	source.density = cached_density
	cached_matrix = null
	cached_alpha = null
	cached_passflags = null
	cached_density = null

/datum/component/wallrun/proc/on_parent_stat_change(mob/living/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(new_stat > CONSCIOUS)
		unmount()

/datum/component/wallrun/proc/change_mount_point(atom/new_point)
	var/mob/living/source = parent
	var/dir_to_source = get_dir(new_point, source)
	var/list/offset = get_pixel_offset(dir_to_source)
	animate(source, time = MOUNT_ANIMATION_TIME, pixel_x = offset[PIXEL_X_OFFSET], pixel_y = offset[PIXEL_Y_OFFSET], transform = matrix(cached_matrix, dir2angle(dir_to_source), MATRIX_ROTATE), easing = BACK_EASING)
	UnregisterSignal(mount_point, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING, COMSIG_ATOM_DIR_CHANGE))
	if(ismovable(new_point))
		RegisterSignal(new_point, COMSIG_MOVABLE_MOVED, PROC_REF(on_mount_point_moved))
	RegisterSignal(new_point, COMSIG_QDELETING, PROC_REF(unmount))
	RegisterSignal(new_point, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mount_point_dir_change))
	mount_point = new_point

/datum/component/wallrun/proc/find_mount_point(turf/location)
	if(location.density && GLOB.wallrun_types_typecache[location.type])
		return location
	for(var/atom/movable/mov as anything in location)
		if(mov.density && GLOB.wallrun_types_typecache[mov.type])
			return mov

/datum/component/wallrun/proc/on_parent_moved(mob/living/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	if(get_dir(old_loc, mount_point) == turn(dir, 180))
		var/atom/next_mount_point = find_mount_point(get_step(old_loc, turn(dir, 90)))
		if(next_mount_point)
			var/atom/possible_mount_point = find_mount_point(get_step(source, turn(dir, 90)))
			if(possible_mount_point)
				change_mount_point(possible_mount_point)
				return
			change_mount_point(next_mount_point)
			return
		next_mount_point = find_mount_point(get_step(old_loc, turn(dir, -90)))
		if(next_mount_point)
			var/atom/possible_mount_point = find_mount_point(get_step(source, turn(dir, -90)))
			if(possible_mount_point)
				change_mount_point(possible_mount_point)
				return
			change_mount_point(next_mount_point)
			return
	else
		var/direction = get_dir(old_loc, mount_point)
		// Check if mount point was diagonal to us
		if(direction & (direction - 1))
			// Check if didn't move away from mount point
			if(direction & dir)
				var/dir_to_source = get_dir(mount_point, source)
				var/list/offset = get_pixel_offset(dir_to_source)
				animate(source, time = MOUNT_ANIMATION_TIME, pixel_x = offset[PIXEL_X_OFFSET], pixel_y = offset[PIXEL_Y_OFFSET], transform = matrix(cached_matrix, dir2angle(dir_to_source), MATRIX_ROTATE), easing = BACK_EASING)
				return
		else
			var/atom/next_mount_point = find_mount_point(get_step(source, get_dir(old_loc, mount_point)))
			if(next_mount_point)
				change_mount_point(next_mount_point)
				return
			else
				var/dir_to_source = get_dir(mount_point, source)
				var/list/offset = get_pixel_offset(dir_to_source)
				animate(source, time = MOUNT_ANIMATION_TIME, pixel_x = offset[PIXEL_X_OFFSET], pixel_y = offset[PIXEL_Y_OFFSET], transform = matrix(cached_matrix, dir2angle(dir_to_source), MATRIX_ROTATE), easing = BACK_EASING)
				return
	unmount()

/datum/component/wallrun/proc/on_mount_point_moved(atom/movable/source, atom/old_loc, dir, forced, list/old_locs)
	SIGNAL_HANDLER
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	step_to(parent, old_loc)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_parent_moved))

/datum/component/wallrun/proc/on_mount_point_dir_change(atom/source, old_dir, new_dir)
	SIGNAL_HANDLER
	var/angle = (dir2angle(new_dir) - dir2angle(old_dir))
	var/turf/new_loc = get_step(source, turn(get_dir(source, parent), angle))
	var/mob/living/owner = parent
	if(new_loc.CanPass(owner, get_dir(source, new_loc)))
		owner.forceMove(new_loc)
		owner.setDir(turn(owner.dir, angle))
	else
		unmount()

/datum/component/wallrun/proc/update_resting(atom/movable/source, resting)
	SIGNAL_HANDLER
	if(resting)
		unmount()

#undef MOUNT_ANIMATION_TIME
#undef PIXEL_X_OFFSET
#undef PIXEL_Y_OFFSET
