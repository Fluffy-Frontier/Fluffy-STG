/datum/component/statmod/frenzy_buff
	//statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 1,
	//				STATMOD_ATTACK_SPEED = 1)
	var/duration
	var/lifetimer

/datum/component/statmod/frenzy_buff/Initialize(duration)
	. = ..()
	set_timer(duration)
	to_chat(parent, span_notice("You feel your muscles twitch with renewed energy!"))

/datum/component/statmod/frenzy_buff/proc/set_timer(newduration)
	if (newduration)
		duration = newduration
	deltimer(lifetimer)
	lifetimer = addtimer(CALLBACK(src, PROC_REF(finish)), duration, TIMER_STOPPABLE)

/datum/component/statmod/frenzy_buff/proc/finish()
	to_chat(parent, span_notice("You feel your body slowing down as your muscles relax"))

	qdel(src)
