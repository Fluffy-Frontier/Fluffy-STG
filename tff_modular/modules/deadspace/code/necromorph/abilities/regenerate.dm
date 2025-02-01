/datum/action/cooldown/necro/regenerate
	name = "Regenerate"
	desc = "Regrows a missing limb and restores some of your health."
	cooldown_time = 10 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_REGENERATE_DOWN
	var/duration = 5 SECONDS

	/// How many limbs can be regenerated per use
	var/max_limbs = 1
	/// How much health is restored
	var/heal_amount = 40
	/// How much lasting damage is healed
	var/lasting_damage_heal = 20
	/// When a limb is replaced, the mob suffers lasting damage equal to the limb's health * this value
	var/limb_lasting_damage = 0
	/// When lasting_damage is healed, the marker transfers biomass to the mob, equal to the damage healed * this value
	var/biomass_lasting_damage_cost = 0
	/// When healing burn damage, each point of heal_amount can heal this many points of actual burn damage
	var/burn_heal_mult = 0.5
	/// Interval between shaking necromorph
	var/shake_interval = 0.5 SECONDS

/datum/action/cooldown/necro/regenerate/Activate(atom/target)
	owner.AddComponent(/datum/component/regenerate, duration, max_limbs, heal_amount, lasting_damage_heal, limb_lasting_damage, biomass_lasting_damage_cost, burn_heal_mult, shake_interval)
	StartCooldown(cooldown_time + duration)
