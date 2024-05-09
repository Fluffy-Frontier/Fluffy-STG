#define DIG_UNDEFINED 	1
#define DIG_DELETE 		2
#define DIG_ROCK		3

#define BRUSH_DELETE	1
#define BRUSH_UNCOVER	2
#define BRUSH_NONE		3
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Large finds - (Potentially) active alien machinery from the dawn of time
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TO DO LIST:
// * Consider about adding constructshell back
// * Do something about hoverpod, its quite useless now. Maybe get a chance to find a space pod
// * Consider adding more big artifacts
// * Add more effects from /vg/
//


/datum/artifact_find
	var/artifact_id
	var/artifact_find_type

/datum/artifact_find/New()
	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha","fluffy","zeta")]-[rand(0,9999)]"

	artifact_find_type = pick(\
	5;/obj/machinery/power/supermatter_crystal/shard,\
	1000;/obj/machinery/artifact)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Boulders - sometimes turn up after excavating turf - excavate further to try and find large xenoarch finds

/obj/structure/boulder
	name = "rocky debris"
	desc = "Leftover rock from an excavation, it's been partially dug out already but there's still a lot to go."
	icon = 'tff_modular/modules/xenoarcheology/icons/mining.dmi'
	icon_state = "boulder1"
	density = TRUE
	opacity = 1
	anchored = TRUE
	var/measured = FALSE
	var/holomark = FALSE
	var/holomark_adv = FALSE
	var/stabilised = FALSE
	var/excavation_level = 0
	var/target_excavation_level = 0
	var/approximate_excavation_level = 0
	var/datum/artifact_find/artifact_find = new /datum/artifact_find

/obj/structure/boulder/examine(mob/user)
	. = ..()
	. += span_notice("[holomark ? "This boulder has been scanned. Target Depth: [approximate_excavation_level] +- 15 cm." : "This boulder has not been scanned."]")
	if(holomark_adv)
		. += span_notice("The item depth is [target_excavation_level] cm.")
	. += span_notice("[measured ? "This boulder has been measured. Dug Depth: [excavation_level]." : "This boulder has not been measured."]")
	. += span_notice("[stabilised ? "This boulder has been stabilised." : "This boulder has not been stabilised."]")

/obj/structure/boulder/Initialize(mapload)
	. = ..()
	icon_state = "boulder[rand(1, 4)]"
	target_excavation_level = rand(25, 100)
	approximate_excavation_level = target_excavation_level - (rand(-15,15))

/obj/structure/boulder/proc/spawn_artifact()
	var/obj/machinery/artifact/new_artifact = new artifact_find.artifact_find_type(get_turf(src))
	if (!stabilised)
		if (prob(50))
			new_artifact.update_integrity(10) // It is on the edge of destruction
		else
			new_artifact.Destroy()

/obj/structure/boulder/Destroy() // spawns and destroys artifact immideately
	. = ..()
	if (!stabilised)
		var/obj/machinery/artifact/new_artifact = new artifact_find.artifact_find_type(get_turf(src))
		new_artifact.Destroy()

/obj/structure/boulder/Bumped(AM)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		var/obj/item/offered_item = H.get_active_held_item()
		if(istype(offered_item, /obj/item/xenoarch/hammer))
			attackby(offered_item, H)

	else if(iscyborg(AM))
		var/mob/living/silicon/robot/R = AM
		if(istype(R.module_active, /obj/item/xenoarch/hammer))
			attackby(R.module_active, R)

/obj/structure/boulder/proc/get_scanned(advanced)
	if (advanced)
		holomark_adv = TRUE
	holomark = TRUE
	return TRUE

/obj/structure/boulder/proc/get_stabilised()
	if (stabilised)
		return FALSE
	else
		stabilised = TRUE
		return TRUE

/obj/structure/boulder/proc/get_measured()
	if (measured)
		return FALSE
	else
		measured = TRUE
		return TRUE

/obj/structure/boulder/proc/try_dig(dig_amount)
	if(!dig_amount)
		return DIG_UNDEFINED
	excavation_level += dig_amount
	if(excavation_level > target_excavation_level)
		qdel(src)
		return DIG_DELETE
	return DIG_ROCK

/obj/structure/boulder/proc/try_uncover()
	if(excavation_level > target_excavation_level)
		qdel(src)
		return BRUSH_DELETE
	if(excavation_level == target_excavation_level)
		spawn_artifact()
		qdel(src)
		return BRUSH_UNCOVER
	try_dig(1)
	return BRUSH_NONE

/obj/structure/boulder/attackby(obj/item/W, mob/user)
	. = ..()
	if(istype(W, /obj/item/pickaxe))
		to_chat(user, span_notice("You begin smashing the boulder."))
		if(!do_after(user, 2.5 SECONDS, target = src))
			to_chat(user, span_warning("You slip and smash the boulder with extra force!"))
			excavation_level += rand(10,50)
			return
		switch(try_dig(25))
			if(DIG_UNDEFINED)
				message_admins("Tell coders something broke with xenoarch hammers and dig amount.")
				return
			if(DIG_DELETE)
				to_chat(user, span_warning("The boulder crumbles, leaving nothing behind."))
				return
			if(DIG_ROCK)
				to_chat(user, span_notice("You successfully dig the boulder. The item inside seems to be still intact."))

	if(istype(W, /obj/item/xenoarch/hammer))
		var/obj/item/xenoarch/hammer/hammer = W
		to_chat(user, span_notice("You begin carefully using your hammer."))
		if(!do_after(user, hammer.dig_speed, target = src))
			to_chat(user, span_warning("You interrupt your careful planning, damaging the boulder in the process!"))
			excavation_level += rand(1,5)
			return
		switch(try_dig(hammer.dig_amount))
			if(DIG_UNDEFINED)
				message_admins("Tell coders something broke with xenoarch hammers and dig amount.")
				return
			if(DIG_DELETE)
				to_chat(user, span_warning("The boulder crumbles, leaving nothing behind."))
				return
			if(DIG_ROCK)
				to_chat(user, span_notice("You successfully dig around the item."))

	if (istype(W, /obj/item/xenoarch/handheld_scanner))
		var/obj/item/xenoarch/handheld_scanner/scanner = W
		if (holomark_adv || (holomark && !istype(scanner, /obj/item/xenoarch/handheld_scanner/advanced)))
			to_chat(user, span_notice("The boulder was already scanned. You can even see the holomark attached to it."))
			return
		to_chat(user, span_notice("You begin to scan [src] using [scanner]."))
		if(!do_after(user, scanner.scanning_speed, target = src))
			to_chat(user, span_warning("You interrupt your scanning, damaging the boulder in the process!"))
			excavation_level += rand(1,5)
			return
		if(get_scanned(scanner.scan_advanced))
			to_chat(user, (span_notice("You successfully scanned the boulder, attaching the holomark to it with some info!")))
			if(scanner.scan_advanced)
				to_chat(user, span_notice("Thanks to the advanced scanner the holomark now also displays the exact depth needed!"))
			return

	if(istype(W, /obj/item/xenoarch/tape_measure))
		if (measured)
			to_chat(user, span_notice("The boulder was already measured."))
			return
		to_chat(user, span_notice("You begin carefully using your measuring tape."))
		if(!do_after(user, 4 SECONDS, target = src))
			to_chat(user, span_warning("You interrupt your careful planning, damaging the boulder in the process!"))
			excavation_level += rand(1,5)
			return
		if(get_measured())
			to_chat(user, span_notice("You successfully attach a holo measuring tape to the boulder; the boulder will now report its dug depth always!"))
			return

	if(istype(W, /obj/item/xenoarch/brush))
		var/obj/item/xenoarch/brush/brush = W
		to_chat(user, span_notice("You begin carefully using your brush."))
		if(!do_after(user, brush.dig_speed, target = src))
			to_chat(user, span_warning("You interrupt your careful planning, damaging the boulder in the process!"))
			excavation_level += rand(1,5)
			return
		switch(try_uncover())
			if(BRUSH_DELETE)
				to_chat(user, span_warning("The boulder crumbles, leaving nothing behind."))
				return
			if(BRUSH_UNCOVER)
				to_chat(user, span_notice("You successfully brush around the item, fully revealing the item!"))
				return
			if(BRUSH_NONE)
				to_chat(user, span_notice("You brush around the item, but it wasn't revealed... hammer some more."))

	if(istype(W, /obj/item/xenoarch/handheld_recoverer))
		if (stabilised)
			to_chat(user, span_notice("The boulder was already stabilised."))
			return
		to_chat(user, span_notice("You begin slowly stabilising the boulder with your [W]. You better not move during this delicate process."))
		if(!do_after(user, 15 SECONDS, target = src))
			to_chat(user, span_warning("Your hands slip and the [W] deals some serious damage to the boulder!"))
			excavation_level += rand(5,25) // whoops, 2 bad
			return
		if(get_stabilised())
			to_chat(user, span_notice("You successfully stabilise the object inside the boulder!"))
			return
		to_chat(user, span_warning("The boulder was already stabilised."))

#undef BRUSH_DELETE
#undef BRUSH_UNCOVER
#undef BRUSH_NONE

#undef DIG_UNDEFINED
#undef DIG_DELETE
#undef DIG_ROCK
