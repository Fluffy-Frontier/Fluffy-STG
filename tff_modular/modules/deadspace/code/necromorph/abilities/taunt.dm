
/*
	Taunt is an ability used by the hunter

	It has two parts:
		1. This extension, applied to the user. Buffs the user's movespeed and damage resist. Gives the user a red outline to mark them
			Applies the companion extension to everyone on the user's team who can see them, each tick

		2. The companion, applied to people who see the user. Buffs the subject's damage resist and evasion]

	Taunt lasts a long time potentially. But it ends early under two conditions:
		1. The user is knocked down

		2. Six seconds pass without seeing a valid enemy
*/

/datum/action/cooldown/necro/taunt
	name = "Taunt"
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_TAUNT_DOWN
	var/status
	cooldown_time = 20 SECONDS
	var/duration = 5 MINUTES
	var/tick_interval = 1 SECONDS

	var/started_at
	var/stopped_at

	var/ongoing_timer
	var/tick_timer

	var/time_without_enemy = 0
	var/max_time_without_enemy = 6 SECONDS

	var/list/comps_observations = list()
	var/type_buff = null
	var/datum/component/statmod/buff

/datum/action/cooldown/necro/taunt/PreActivate(atom/target)
	if (owner.incapacitated)
		return FALSE

	if (owner:body_position == LYING_DOWN)
		to_chat(owner, span_danger("You must be standing to use taunt!"))
		return FALSE

	//Taunt requires a visible enemy
	if (!owner.enemy_in_view(require_standing = TRUE))
		to_chat(owner, span_danger("You need a standing enemy in view to use taunt!"))
		return FALSE

	. = ..()

/datum/action/cooldown/necro/taunt/Activate()
	StartCooldown()
	if (type_buff && !buff)
		buff = owner.AddComponent(type_buff)
	if (!owner.get_filter("taunt"))
		var/newfilter = filter(type="outline", size = 1, color = rgb(255,0,0,128))
		owner.add_filter("taunt", 1, newfilter)
	ongoing_timer = addtimer(CALLBACK(src, PROC_REF(stop)), duration, TIMER_STOPPABLE)
	if (tick_interval)
		tick_timer = addtimer(CALLBACK(src, PROC_REF(tick)), tick_interval, TIMER_STOPPABLE)

/datum/action/cooldown/necro/taunt/proc/stop()
	deltimer(ongoing_timer)
	deltimer(tick_timer)
	time_without_enemy = 0
	if (buff)
		qdel(buff)
		buff = null
	if (owner.get_filter("taunt"))
		owner.remove_filter("taunt")
	if (comps_observations != list())
		for(var/datum/component/statmod/taunt_companion/comp as anything in comps_observations)
			comp.end()
	comps_observations = list()


/datum/action/cooldown/necro/taunt/proc/tick()

	tick_timer = addtimer(CALLBACK(src, PROC_REF(tick)), tick_interval, TIMER_STOPPABLE)

	if (!owner.enemy_in_view(require_standing = TRUE))

		time_without_enemy += tick_interval
		if (time_without_enemy >= max_time_without_enemy)
			to_chat(owner, span_danger("There are no more enemies in sight, taunt is ended"))
			stop()

	else
		time_without_enemy = 0
		//Lets apply the effect to other necros
		for (var/mob/living/carbon/human/H in view(owner, 10))
			if (!isnecromorph(H))
				continue

			//They already have it?
			if (H.GetComponent(/datum/component/statmod/taunt_companion))
				continue

			//Go!
			comps_observations.Add(H.AddComponent(/datum/component/statmod/taunt_companion, owner))

/*
	Companion effect
	Applied to others who see the taunt user (referrred to as shield)
	Ticks regularly and removes itself if the shield is no longer in view
*/
/datum/component/statmod/taunt_companion
	var/tick_timer
	var/mob/shield

	var/tick_interval = 1 SECONDS

/datum/component/statmod/taunt_companion/Initialize(mob/shield)
	.=..()
	src.shield = shield
	tick_timer = addtimer(CALLBACK(src, PROC_REF(tick)), tick_interval, TIMER_STOPPABLE)

/datum/component/statmod/taunt_companion/proc/tick()
	if(QDELETED(src))
		return

	//Check we can still see the shield
	if (QDELETED(shield) || !(shield in (view(7, parent))))
		end()
		return

	tick_timer = addtimer(CALLBACK(src, PROC_REF(tick)), tick_interval, TIMER_STOPPABLE)

/datum/component/statmod/taunt_companion/proc/end()
	deltimer(tick_timer)
	qdel(src)
