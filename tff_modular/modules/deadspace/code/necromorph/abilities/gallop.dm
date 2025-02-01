#define GALLOP_CRASH_LIMIT 2

/datum/action/cooldown/necro/active/gallop
	name = "Gallop"
	desc = "Gives a huge burst of speed, while making you vulnerable to crashing into objects."
	cooldown_time = 12 SECONDS
	duration_time = 7 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_GALLOP_DOWN
	var/crash_count = 0

//Worse version of leaper gallop, since hoppers practically move at the speed of sound when galloping
/datum/action/cooldown/necro/active/gallop/hopper
	cooldown_time = 15 SECONDS
	duration_time = 2.5 SECONDS

/datum/action/cooldown/necro/active/gallop/Activate(atom/target)
	var/mob/living/carbon/human/necromorph/holder = owner
	if(holder.stat > CONSCIOUS || holder.body_position != STANDING_UP || holder.charging)
		return
	..()
	crash_count = 0
	holder.play_necro_sound(SOUND_SHOUT, VOLUME_MID, TRUE, 3)
	RegisterSignal(holder, COMSIG_STARTED_CHARGE, TYPE_PROC_REF(/datum/action/cooldown/necro/active, CooldownEnd))
	RegisterSignal(holder, COMSIG_MOB_STATCHANGE, PROC_REF(OnStatChange))
	RegisterSignal(holder, COMSIG_LIVING_UPDATED_RESTING, PROC_REF(OnUpdateResting))
	RegisterSignal(holder, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(OnHit))
	RegisterSignal(holder, COMSIG_MOVABLE_BUMP, PROC_REF(OnBump))
	RegisterSignal(holder, COMSIG_MOVABLE_MOVED, PROC_REF(OnMoved))
	holder.add_movespeed_modifier(/datum/movespeed_modifier/gallop)

/datum/action/cooldown/necro/active/gallop/proc/OnStatChange(mob/living/carbon/human/necromorph/leaper/source, new_stat, old_stat)
	SIGNAL_HANDLER
	if(new_stat > old_stat)
		CooldownEnd()

/datum/action/cooldown/necro/active/gallop/proc/OnUpdateResting(mob/living/carbon/human/necromorph/leaper/source, resting)
	SIGNAL_HANDLER
	if(resting)
		CooldownEnd()

/datum/action/cooldown/necro/active/gallop/proc/OnHit(mob/living/carbon/human/necromorph/leaper/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if (crash_count < GALLOP_CRASH_LIMIT)
		crash_count++
		return
	source.visible_message(span_danger("[source] crumples on impact!"), span_danger("You crumple on impact"))
	shake_camera(source, 20, 1)
	StopCrash()

/datum/action/cooldown/necro/active/gallop/proc/OnBump(mob/living/carbon/human/necromorph/leaper/source, atom/bumped)
	SIGNAL_HANDLER
	source.visible_message(span_danger("[source] slams into [bumped]!"), span_danger("You slam into [bumped]!"))
	if(iscarbon(bumped)) //You can slam into necros and humans while galloping
		var/mob/living/carbon/victim = bumped
		if(is_enhanced(source)) //You really don't want to be bodied by the enhanced leaper
			victim.Knockdown(25)
			victim.take_overall_damage(15)
			victim.drop_all_held_items()
		else
			victim.Knockdown(20)
			victim.take_overall_damage(5)
		shake_camera(victim, 20, 1)
	StopCrash()

/datum/action/cooldown/necro/active/gallop/proc/OnMoved(mob/living/carbon/human/necromorph/leaper/source)
	SIGNAL_HANDLER
	shake_camera(source, 3, 0.5)

/datum/action/cooldown/necro/active/gallop/proc/StopCrash()
	var/mob/living/carbon/human/necromorph/holder = owner
	shake_camera(holder, 20, 1)
	holder.Knockdown(10)
	holder.take_overall_damage(5)
	//Stops the gallop
	CooldownEnd()

/datum/action/cooldown/necro/active/gallop/CooldownEnd()
	. = ..()
	if(.)
		UnregisterSignal(owner, list(
			COMSIG_STARTED_CHARGE,
			COMSIG_MOB_STATCHANGE,
			COMSIG_LIVING_UPDATED_RESTING,
			COMSIG_MOB_APPLY_DAMAGE,
			COMSIG_MOVABLE_BUMP,
			COMSIG_MOVABLE_MOVED,
		))
		owner.remove_movespeed_modifier(/datum/movespeed_modifier/gallop)

/datum/movespeed_modifier/gallop
	multiplicative_slowdown = -2.5

#undef GALLOP_CRASH_LIMIT
