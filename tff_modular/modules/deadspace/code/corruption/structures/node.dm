#define GROWING 1
#define DECAYING 2

/obj/structure/necromorph/node
	name = "growth"
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption.dmi'
	icon_state = "minigrowth"
	var/corruption_node_type = /datum/corruption_node

/obj/structure/necromorph/node/Initialize(mapload, obj/structure/marker/new_master)

	if(!new_master)
		return INITIALIZE_HINT_QDEL
	var/datum/corruption_node/node = new corruption_node_type(src, new_master)
	var/obj/structure/corruption/corrupt = locate(/obj/structure/corruption) in loc
	if(!corrupt)
		new /obj/structure/corruption(loc, node)
	else
		corrupt.set_master(node)
	return ..()

/obj/structure/necromorph/node/update_signals(atom/old_loc, turf/new_loc)
	if(old_loc)
		UnregisterSignal(old_loc, list(COMSIG_TURF_NECRO_UNCORRUPTED))
	if(new_loc)
		if(istype(new_loc) && new_loc.necro_corrupted)
			RegisterSignal(new_loc, COMSIG_TURF_NECRO_UNCORRUPTED, PROC_REF(on_turf_uncorrupted))
			state = GROWING
			START_PROCESSING(SSnecrocorruption, src)
		else
			qdel(src)

/obj/structure/necromorph/node/on_turf_uncorrupted(turf/source)
	qdel(src)

#undef GROWING
#undef DECAYING
