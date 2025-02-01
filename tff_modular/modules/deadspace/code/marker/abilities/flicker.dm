/datum/action/cooldown/necro/psy/flicker
	name = "Flicker"
	desc = "Causes a targeted light to flicker."
	button_icon_state = "flicker"
	cost = 10
	cooldown_time = 10 SECONDS

/datum/action/cooldown/necro/psy/flicker/PreActivate(obj/machinery/light/target)
	if(!istype(target, /obj/machinery/light))
		return FALSE
	return ..()

/datum/action/cooldown/necro/psy/flicker/Activate(obj/machinery/light/target)
	..()
	target.flicker()
	return TRUE
