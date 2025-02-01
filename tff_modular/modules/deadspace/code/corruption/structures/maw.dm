#define MAW_DAMAGE_PER_SECOND 1.5

// Human biomass = their limbs
/obj/structure/necromorph/maw
	name = "maw"
	desc = "A disgusting mass of throbbing flesh and gnashing teeth, it looks like something out of a nightmare."
	desc_controls = "Drag a body onto the maw to begin biomass consumption. Will grab the living if they step on it."
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption.dmi'
	icon_state = "maw"
	density = FALSE
	max_integrity = 30
	can_buckle = TRUE
	max_buckled_mobs = INFINITY
	buckle_lying = 270
	// Biomass that will be slowly given to the marker
	var/processing_biomass = 0

/obj/structure/necromorph/maw/Initialize(mapload, obj/structure/marker/marker)
	.=..()
	if(!marker)
		return INITIALIZE_HINT_QDEL
	marker.add_biomass_source(/datum/biomass_source/maw, src)
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(maw_grabbing),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/necromorph/maw/update_icon_state()
	..()
	icon_state = length(buckled_mobs) ? "maw_active" : "maw"

///The signal handler that starts the process of grabbing
/obj/structure/necromorph/maw/proc/maw_grabbing(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(AM == src)
		return
	if(!maw_can_grab(AM))
		return //Don't try to grab

	AM.visible_message(span_danger("\The [src] stretches out to grab [AM]!"), \
	span_userdanger("\The [src] stretches out to grab you!"))

	//Give the target time to run, then drag their ass to the shadowrealm if they are still there
	addtimer(CALLBACK(src, PROC_REF(maw_grab), AM), 3 SECONDS)

///General checker before maw grabs, buckling will do a second check if this goes through
/obj/structure/necromorph/maw/proc/maw_can_grab(atom/movable/AM)
	if(!isliving(AM))
		return FALSE //So we don't accidentally grab things like structures and objects
	if(issilicon(AM))
		return FALSE //This is checked in buckling, but for our sanity we'll check it here first
	var/mob/living/L = AM
	if(isnecromorph(AM) && !(L.stat == DEAD))
		return FALSE //We don't want living necros to be grabbed
	if(L.movement_type & (FLYING|FLOATING))
		return FALSE
	if(L.buckled)
		return FALSE //For sanity's sake it won't mess with stuff already buckled

	return TRUE

///The part where the maw grabs you, assuming all checks have passed
/obj/structure/necromorph/maw/proc/maw_grab(atom/movable/AM)
	var/mob/living/L = AM
	src.buckle_mob(L, FALSE, TRUE) //This comes wrapped with a standard buckle check
	if(L.buckled) //We don't want it to throw this message if the buckle check didn't go through
		L.visible_message(span_danger("\The [src] drags [L] into itself!"), \
		span_userdanger("\The [src] drags you into itself!"))

/obj/structure/necromorph/maw/proc/maw_push()
	var/turf/T = get_turf(src)
	var/dirs = GLOB.alldirs.Copy()
	var/valid_dir
	while(!valid_dir && length(dirs))
		var/direction = pick_n_take(dirs)
		var/turf/dest = get_step(src, direction)
		if(isnull(dest))
			continue
		if(!T.density && T.Adjacent(dest)) //This checks for border stuff
			valid_dir = direction
			break

	if(valid_dir)
		for(var/obj/item/I in T) //Grabs any items on it's turf, and pushes it off of the maw
			step(I, valid_dir, 0.2)

/// Doesn't do any ANY safety checks. Use with caution
//TODO : rewrite bite_human to respect stumps
/obj/structure/necromorph/maw/proc/bite_human(mob/living/carbon/human/target, delta_time)
	if(length(target.bodyparts) <= 1) //Won't let you continue unless target has only a torso. Problematic due to stumps counting as body parts
		var/obj/item/bodypart/part = target.bodyparts[1]
		processing_biomass += part.n_biomass * 1.1
		target.gib(TRUE, TRUE, TRUE, TRUE)
		maw_push() //This pushes items away from the maw after it is done
		return

	var/obj/item/bodypart/part = pick(target.bodyparts)
	var/iteration = 0
	while(istype(part, /obj/item/bodypart/chest) && iteration++ < 5)
		part = pick(target.bodyparts - part)

	if(iteration >= 5)
		stack_trace("Maw tried to bite a human but couldn't find a non-chest bodypart")
		return

	// If damage is above 80%
	if(part.get_damage() >= (part.max_damage * LIMB_DISMEMBERMENT_PERCENT) - 1)
		processing_biomass += part.n_biomass * 1.1
		part.dismember(wounding_type = WOUND_BLUNT, silent = TRUE)
	else
		processing_biomass += 0.02
		// Damage shouldn't be above or equal to 80%
		part.receive_damage(
			min(
				MAW_DAMAGE_PER_SECOND * delta_time,
				(part.max_damage * LIMB_DISMEMBERMENT_PERCENT) - part.get_damage() - 1
			), 0, sharpness = SHARP_EDGED|SHARP_POINTY
		)

/// Doesn't do any ANY safety checks. Use with caution
/obj/structure/necromorph/maw/proc/bite_living(mob/living/target, delta_time)
	if(target.stat != DEAD || target.health > target.maxHealth * 0.1)
		target.adjustBruteLoss(MAW_DAMAGE_PER_SECOND * delta_time, TRUE)
		processing_biomass += target.mob_size * 0.5
		return
	//Might need some balance
	processing_biomass += target.mob_size * 5
	qdel(target)

///Necros don't need anything too fancy, just qdeling is good enough
/obj/structure/necromorph/maw/proc/bite_necro(mob/living/carbon/human/necromorph/target, delta_time) //Basically copied bite_human with less efficiency
	if(length(target.bodyparts) <= 1)
		var/obj/item/bodypart/part = target.bodyparts[1]
		processing_biomass += part.n_biomass
		qdel(target)
		return

	var/obj/item/bodypart/part = pick(target.bodyparts)
	var/iteration = 0
	while(istype(part, /obj/item/bodypart/chest) && iteration++ < 5)
		part = pick(target.bodyparts - part)

	if(iteration >= 5)
		stack_trace("Maw tried to bite a necro but couldn't find a non-chest bodypart")
		return

	// If damage is above 80%
	if(part.get_damage() >= (part.max_damage * LIMB_DISMEMBERMENT_PERCENT) - 1)
		processing_biomass += part.n_biomass
		part.drop_limb(FALSE, TRUE)
		qdel(part)
	else
		// Damage shouldn't be above or equal to 80%
		part.receive_damage(
			min(
				MAW_DAMAGE_PER_SECOND * delta_time,
				(part.max_damage * LIMB_DISMEMBERMENT_PERCENT) - part.get_damage() - 1
			), 0, sharpness = SHARP_EDGED|SHARP_POINTY
		)
/obj/structure/necromorph/maw/is_buckle_possible(mob/living/target, force, check_loc)
	if(!..())
		return FALSE
	if(issilicon(target))
		return FALSE
	return TRUE

/obj/structure/necromorph/maw/user_buckle_mob(mob/living/M, mob/user, check_loc)
	if(issilicon(M))
		to_chat(user, span_warning("[src] refuses to consume [M]!"))
		return FALSE
	if(!do_after(user, M, 5 SECONDS, IGNORE_HELD_ITEM|DO_PUBLIC, TRUE, CALLBACK(src, PROC_REF(buckle_mob_check), M)))
		return
	return ..()

/obj/structure/necromorph/maw/proc/buckle_mob_check(mob/living/buckling)
	if(QDELING(src))
		return
	if(buckling.buckled)
		return
	return TRUE

/obj/structure/necromorph/maw/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(buckled_mob.buckled != src || !user.CanReach(buckled_mob))
		return
	var/time_to_unbuckle = (buckled_mob == user) ? 8 SECONDS : 6 SECONDS
	if(!do_after(user, buckled_mob, time_to_unbuckle, IGNORE_HELD_ITEM|DO_PUBLIC, TRUE, CALLBACK(src, PROC_REF(still_buckled), buckled_mob)))
		return
	return ..()

/obj/structure/necromorph/maw/proc/still_buckled(mob/living/buckled_mob)
	return buckled_mob.buckled == src

/obj/structure/necromorph/maw/relaymove(mob/living/user, direction)
	if(SEND_SIGNAL(src, COMSIG_ATOM_RELAYMOVE, user, direction) & COMSIG_BLOCK_RELAYMOVE)
		return
	if(!do_after(user, src, 2 SECONDS, IGNORE_HELD_ITEM|DO_PUBLIC) || (user.buckled != src))
		return
	unbuckle_mob(user, TRUE)

/obj/structure/necromorph/maw/post_buckle_mob(mob/living/M)
	if(length(buckled_mobs) >= 1)
		update_icon(UPDATE_ICON_STATE)

/obj/structure/necromorph/maw/post_unbuckle_mob(mob/living/M)
	if(!length(buckled_mobs))
		update_icon(UPDATE_ICON_STATE)

/datum/action/cooldown/necro/corruption/maw
	name = "maw"
	desc = "It acts as a corpose disposal, slowly devouring any corpses put inside. Gives 20% extra biomass for humans, can devour normal mobs, and can recycle necromorphs."
	button_icon_state = "maw"
	place_structure = /obj/structure/necromorph/maw
	cost = 40
	marker_only = TRUE

#undef MAW_DAMAGE_PER_SECOND
