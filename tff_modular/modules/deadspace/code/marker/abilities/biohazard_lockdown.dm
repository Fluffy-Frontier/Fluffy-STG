/datum/action/cooldown/necro/psy/biohazard_lockdown
	name = "Biohazard Lockdown"
	desc = "Trips the biohazard sensors, causing all doors to bolt and the fire alarm to engage."
	button_icon_state = "default" //TODO : add a biohazard lockdown sprite
	cost = 800
	var/duration = 2 MINUTES
	cooldown_time = 15 MINUTES
	marker_flags = SIGNAL_ABILITY_POST_ACTIVATION|SIGNAL_ABILITY_MARKER_ONLY

/datum/action/cooldown/necro/psy/biohazard_lockdown/PreActivate(atom/target)
	var/area/bh = get_area(target)
	/*
	if(bh.area_flags & NO_ALERTS) //If there are no sensors then we can't trip them
		return FALSE
	*/
	for(var/mob/living/L in bh)
		if(isnecromorph(L) && L.stat != DEAD)
			duration = 4 MINUTES //We increase the duration if there are necros.
	return ..()

/datum/action/cooldown/necro/psy/biohazard_lockdown/Activate(atom/target)
	..()
	var/area/alarmed = get_area(target)
	alarmed.biohazardlockdown(target)

	playsound(target, 'tff_modular/modules/deadspace/sound/effects/biohazard_alarm.ogg', 50, TRUE, 5)
	for(var/obj/machinery/door/airlock/door in alarmed)
		addtimer(CALLBACK(door, TYPE_PROC_REF(/obj/machinery/door/airlock, unbolt)), duration)
	addtimer(CALLBACK(alarmed, TYPE_PROC_REF(/area, set_fire_effect), FALSE), duration)

/area/proc/biohazardlockdown(area/trigger)
	//Trigger alarm effect
	set_fire_effect(TRUE)
	//Lockdown airlocks
	for(var/obj/machinery/door/airlock/door in src)
		close_and_lock_door(door)
