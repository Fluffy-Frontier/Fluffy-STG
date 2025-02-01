/datum/corruption_node
	/// Amount of corruption we can keep
	var/remaining_weed_amount = 25
	/// How far can we spread corruption
	var/control_range = 5
	/// Atom we are bound to in real world
	var/atom/parent
	/// The Marker we are part of. Mainly used by corruption to get marker net
	var/obj/structure/marker/marker
	/// A list of corruption that have us as a master
	var/list/corruption

/datum/corruption_node/New(atom/new_parent, obj/structure/marker/marker)
	if(!new_parent)
		qdel(src)

		CRASH("Tried to spawn a corruption node without parent in real world.")

	if(!marker)
		if(length(GLOB.necromorph_markers))
			marker = pick(GLOB.necromorph_markers)
		else
			qdel(src)
			CRASH("Tried to spawn a corruption node without marker.")
	corruption = list()
	parent = new_parent
	src.marker = marker
	marker.nodes += src
	RegisterSignal(new_parent, COMSIG_QDELETING, PROC_REF(on_parent_delete))
	RegisterSignal(new_parent, COMSIG_ATOM_BREAK, PROC_REF(on_parent_break))

	var/turf/parent_turf = get_turf(new_parent)
	var/obj/structure/corruption/corrupt = locate(/obj/structure/corruption) in parent_turf
	if(!corrupt)
		new /obj/structure/corruption(parent_turf, src)
	else
		corrupt.set_master(src)

/datum/corruption_node/Destroy()
	STOP_PROCESSING(SSnecrocorruption, src)
	marker?.nodes -= src
	for(var/obj/structure/corruption/corrupt as anything in corruption)
		corrupt.on_master_delete()
	corruption = null
	marker = null
	parent = null
	return ..()

/datum/corruption_node/proc/on_parent_delete(atom/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/corruption_node/proc/on_parent_break(atom/source)
	SIGNAL_HANDLER
	qdel(src)


/* SUBTYPES */
/datum/corruption_node/atom
	remaining_weed_amount = 49
	control_range = 7

/datum/corruption_node/atom/New(atom/new_parent, obj/structure/marker/marker)
	. = ..()
	var/obj/structure/corruption/corrupt = locate(/obj/structure/corruption) in get_turf(new_parent)
	RegisterSignal(corrupt, COMSIG_ATOM_BREAK, PROC_REF(on_corruption_break))

/datum/corruption_node/atom/proc/on_corruption_break(turf/source)
	addtimer(CALLBACK(src, PROC_REF(spawn_new_corruption)), 5 MINUTES, TIMER_OVERRIDE)

/datum/corruption_node/atom/proc/spawn_new_corruption()
	var/obj/structure/corruption/corrupt = locate(/obj/structure/corruption) in get_turf(parent)
	if(corrupt)
		corrupt.set_master(src)
	else
		new /obj/structure/corruption(get_turf(parent), src)

/datum/corruption_node/atom/marker
	remaining_weed_amount = 49
	control_range = 7
