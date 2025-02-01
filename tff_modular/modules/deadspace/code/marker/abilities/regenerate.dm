/datum/action/cooldown/necro/psy/regeneration
	name = "Regenerate"
	desc = "Paralyzes a necromorph for a limited amount of time, regenerating limbs and healing them in the process. Can only be used on corruption."
	button_icon_state = "default" //TODO : get a regeneration sprite
	cost = 200
	var/duration = 7 SECONDS
	cooldown_time = 180 SECONDS
	marker_flags = SIGNAL_ABILITY_POST_ACTIVATION
	/// How many limbs can be regenerated per use
	var/max_limbs = 2
	/// How much health is restored
	var/heal_amount = 40
	/// How much lasting damage is healed
	var/lasting_damage_heal = 40
	/// When a limb is replaced, the mob suffers lasting damage equal to the limb's health * this value
	var/limb_lasting_damage = 0
	/// When lasting_damage is healed, the marker transfers biomass to the mob, equal to the damage healed * this value
	var/biomass_lasting_damage_cost = 0.7
	/// When healing burn damage, each point of heal_amount can heal this many points of actual burn damage
	var/burn_heal_mult = 0.5
	/// Interval between shaking necromorph
	var/shake_interval = 0.4 SECONDS

/datum/action/cooldown/necro/psy/regeneration/PreActivate(mob/living/target)
	if(!isnecromorph(target))
		to_chat(owner, span_notice("You cannot regenerate non-necromorphs!"))
		return FALSE
	for(var/turf/nearby as anything in RANGE_TURFS(1, target))
		if(nearby.necro_corrupted)
			break
		else
			to_chat(owner, span_notice("No nearby corruption!"))
			return FALSE
	return ..()

/datum/action/cooldown/necro/psy/regeneration/Activate(mob/living/target)
	..()
	target.AddComponent(/datum/component/regenerate, duration, max_limbs, heal_amount, lasting_damage_heal, limb_lasting_damage, biomass_lasting_damage_cost, burn_heal_mult, shake_interval)
