/// If you have ideas how to implement without constantly creating/deleting component while still being able to change
/// parameters and allow necromorphs and signals to regenerate necromorphs wihout duplicating code. Please implement it that way.
/datum/component/regenerate
	dupe_mode = COMPONENT_DUPE_ALLOWED
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
	var/burn_heal_mult = 1
	/// Interval between shaking necromorph
	var/shake_interval = 0.5 SECONDS

	/// Amount of heal per second
	var/heal_per_second = 0
	/// Time since last shake
	var/last_shake = 0
	/// List of limbs to regenerate
	var/list/regenerating_limbs

/datum/component/regenerate/Initialize(duration_time = 5 SECONDS, max_limbs, heal_amount, lasting_damage_heal, limb_lasting_damage, biomass_lasting_damage_cost, burn_heal_mult, shake_interval)
	if(!isnecromorph(parent))
		return COMPONENT_INCOMPATIBLE
	if(max_limbs)
		src.max_limbs = max_limbs
	if(heal_amount)
		src.heal_amount = heal_amount
	if(lasting_damage_heal)
		src.lasting_damage_heal = lasting_damage_heal
	if(limb_lasting_damage)
		src.limb_lasting_damage = limb_lasting_damage
	if(biomass_lasting_damage_cost)
		src.biomass_lasting_damage_cost = biomass_lasting_damage_cost
	if(burn_heal_mult)
		src.burn_heal_mult = burn_heal_mult
	if(shake_interval)
		src.shake_interval = shake_interval

	var/mob/living/carbon/human/necromorph/owner = parent

	regenerating_limbs = owner.get_missing_limbs()
	regenerating_limbs.len = max_limbs //Reduces the list size to however many limbs the var is set to

	//Special effect:
	//If the user is missing two or more limbs, play a special sound
	if(length(regenerating_limbs) >= 2)
		owner.play_necro_sound(SOUND_REGEN, VOLUME_MID, 1)

	//Lets play the animations
	var/datum/species/necromorph/species = owner.dna.species
	for(var/limb_type in regenerating_limbs)
		species.regenerate_limb(owner, limb_type, duration_time)

	owner.shake_animation(30)

	ADD_TRAIT(owner, TRAIT_INCAPACITATED, src)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, src)
	ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, src)

	heal_per_second = (heal_amount / duration_time) SECONDS

	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/component/regenerate, finish_regenerating)), duration_time)
	START_PROCESSING(SSfastprocess, src)

/datum/component/regenerate/process(delta_time)
	var/mob/living/carbon/human/necromorph/owner = parent
	last_shake += delta_time
	if(last_shake >= shake_interval)
		last_shake = 0
		owner.shake_animation(30)

	var/remaining_heal = owner.heal_bodypart_damage(brute = heal_per_second * delta_time)
	if(remaining_heal)
		owner.heal_bodypart_damage(burn = heal_per_second * delta_time * burn_heal_mult)

/datum/component/regenerate/proc/finish_regenerating()
	var/mob/living/carbon/human/necromorph/owner = parent

	for(var/limb_type in regenerating_limbs)
		owner.regenerate_limb(limb_type)

		if(limb_lasting_damage)
			owner.adjustLastingDamage(owner.get_bodypart(limb_type).max_damage * limb_lasting_damage)

	if(lasting_damage_heal)
		var/lasting_heal = min(lasting_damage_heal, owner.getLastingDamage())
		owner.adjustLastingDamage(lasting_heal*-1)

	owner.regenerate_organs()
	owner.remove_all_embedded_objects()
	for(var/datum/wound/iter_wound as anything in owner.all_wounds)
		iter_wound.remove_wound()

	REMOVE_TRAIT(owner, TRAIT_INCAPACITATED, src)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, src)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, src)

	qdel(src)
