/datum/action/cooldown/necro/sense
	name = "Sense"
	desc = "Reveals nearby living creatures around you to yourself."
	cooldown_time = 7 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_SENSE_DOWN
	var/duration = 5 SECONDS
	var/list/image/trackers = null

/datum/action/cooldown/necro/sense/Destroy()
	if(trackers)
		remove_trackers()
	return ..()

/datum/action/cooldown/necro/sense/Activate(atom/target)
	if(trackers)
		remove_trackers()

	var/closest_human = 0
	var/list/can_see = list()
	for(var/mob/living/found as anything in GLOB.mob_living_list)
		if(found.stat == DEAD)
			continue
		if(found.z != owner.z)
			continue
		if(ishuman(found))
			closest_human = min(closest_human, GET_TRUE_DIST(found, owner))
		if(!IN_GIVEN_RANGE(found, owner, 5))
			continue
		//We don't need necromorphs in here
		if(faction_check(owner.faction, found.faction))
			continue
		can_see += found

	trackers = list()
	for(var/mob/living/found as anything in can_see)
		var/image/added = image('icons/effects/effects.dmi', get_turf(found), "impact_laser")
		added.alpha = 128
		trackers += added
		owner.client?.images += added

	addtimer(CALLBACK(src, PROC_REF(remove_trackers)), duration, TIMER_OVERRIDE|TIMER_UNIQUE)

	if(closest_human > 0)
		to_chat(owner, span_notice("There is a living human [closest_human]m away!"))
	else
		to_chat(owner, span_notice("There are no living prey on this floor"))

	var/mob/living/carbon/human/necromorph/necro = owner
	necro.play_necro_sound(SOUND_SPEECH, VOLUME_MID, TRUE, 3)
	play_effects()

/datum/action/cooldown/necro/sense/proc/play_effects()
	set waitfor = FALSE

	var/obj/effect/temp_visual/circle = new /obj/effect/temp_visual/expanding_circle(owner.loc, 2 SECONDS, 2)
	circle.pixel_y += 40 //Offset it so it appears to be at our mob's head
	sleep(4)
	circle = new /obj/effect/temp_visual/expanding_circle(owner.loc, 2 SECONDS, 2)
	circle.pixel_y += 40
	sleep(4)
	circle = new /obj/effect/temp_visual/expanding_circle(owner.loc, 2 SECONDS, 2)
	circle.pixel_y += 40

/datum/action/cooldown/necro/sense/proc/remove_trackers()
	for(var/image/tracker as anything in trackers)
		owner.client?.images -= tracker
	trackers = null
