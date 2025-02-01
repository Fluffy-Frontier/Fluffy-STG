/datum/action/cooldown/necro/psy/blowout
	name = "Blowout"
	desc = "Destroys a target wall light, with an explosion of sparks."
	button_icon_state = "blowout"
	cost = 40

/datum/action/cooldown/necro/psy/blowout/PreActivate(obj/machinery/light/target)
	if(!istype(target, /obj/machinery/light))
		return
	return ..()

/datum/action/cooldown/necro/psy/blowout/Activate(obj/machinery/light/target)
	..()
	target.break_light_tube()
	return TRUE
