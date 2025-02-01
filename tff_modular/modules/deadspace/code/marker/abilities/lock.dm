/datum/action/cooldown/necro/psy/lock
	name = "Lock"
	desc = "Forcibly closes and bolts a powered airlock, crushing creatures inside the airlock. Will automatically unbolt after some time."
	button_icon_state = "default" //TODO : get a lock sprite
	cost = 100
	var/duration = 30 SECONDS
	cooldown_time = 3 MINUTES //We don't want this being abused, so long cooldown

/datum/action/cooldown/necro/psy/lock/PreActivate(obj/machinery/door/airlock/target)
	if(!target.hasPower()) //Gameplay-wise you can't unbolt a unpowered door, so we will follow that same rule for balance reasons.
		to_chat(owner, span_notice("You cannot lock a unpowered airlock!"))
		return FALSE //Don't bolt door, because crew cannot unbolt a unpowered door.
	if(!isobj(target))
		return TRUE
	return ..()

/datum/action/cooldown/necro/psy/lock/Activate(obj/machinery/door/airlock/target)
	..()
	if(!target.density) //Check if the door is opened before bolting it
		target.close(TRUE, TRUE) //Force it closed regardless of what is inside of it, this will crush mobs too.
	target.bolt()
	addtimer(CALLBACK(target, TYPE_PROC_REF(/obj/machinery/door/airlock, unbolt)), duration) //This is what unbolts the door after the duration

