/mob/living/carbon/human/necromorph/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()

	//AddComponent(/datum/component/seethrough_mob) //commented out until we can get this working on humans
	var/mob/living/carbon/human/necromorph/necro_owner = src
	necro_owner.physiology.armor = necro_owner.physiology.armor.add_other_armor(armor_type)

	if(!marker_master)
		return INITIALIZE_HINT_QDEL

	//fully_replace_character_name(real_name, "[name] [rand(1, 999)]") // DO I NEED THIS?

	marker = marker_master
	marker_master.add_necro(src)
	var/datum/necro_class/temp = marker_master.necro_classes[class]
	temp.load_data(src)

/mob/living/carbon/human/necromorph/Destroy()
	evacuate()
	marker?.remove_necro(src)
	return ..()

/mob/living/carbon/human/necromorph/update_damage_overlays()
	return

/mob/living/carbon/human/necromorph/update_wound_overlays()
	return

//We should be always able to attack our opponents
/mob/living/carbon/human/necromorph/has_active_hand()
	return TRUE

//This messes with bloody hands, we don't want those on necros yet due to having no custom sprites for it
/mob/living/carbon/human/necromorph/update_worn_gloves(update_obscured)
	return

//This had to be moved from species due to code improvements
/mob/living/carbon/human/necromorph/apply_damage(damage, damagetype = BRUTE, def_zone = null, blocked, wound_bonus, bare_wound_bonus, forced = FALSE, spread_damage = FALSE, wound_bonus = 0, bare_wound_bonus = 0, sharpness = NONE, attack_direction = null, attacking_item, wound_clothing)
	if(dodge_shield > 0)
		// Calculate amount of the damage that was blocked by the shield
		var/dodged_damage = min(dodge_shield, damage, damage * (100 - blocked) / 100)
		reduce_shield(dodged_damage)
		blocked += (dodged_damage / damage) * 100
	return ..()

/mob/living/carbon/human/necromorph/updatehealth()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return

	set_health(maxHealth - getFireLoss() - getBruteLoss() - getToxLoss())
	update_stat()
	SEND_SIGNAL(src, COMSIG_CARBON_UPDATING_HEALTH_HUD)
	if(hud_used)
		var/datum/hud/necromorph/hud = hud_used
		hud.update_healthbar(src)

/mob/living/carbon/human/necromorph/revive(full_heal_flags = NONE, excess_healing = 0, force_grab_ghost = FALSE)
	.=..()
	marker?.add_necro(src)

/mob/living/carbon/human/necromorph/set_stat(new_stat)
	.=..()
	update_sight()

/mob/living/carbon/human/necromorph/update_sight()
	. = ..()
	switch(stat)
		if(CONSCIOUS)
			see_in_dark = conscious_see_in_dark
		if(UNCONSCIOUS)
			see_in_dark = unconscious_see_in_dark
	//Otherwise we are dead and see_in_dark was handled in parent call

/mob/living/carbon/human/necromorph/death(gibbed)
	. = ..()
	marker?.remove_necro(src)

/mob/living/carbon/human/necromorph/create_dna()
	dna = new /datum/dna(src)
	dna.species = new necro_species

/mob/living/carbon/human/necromorph/update_stat()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	if(stat != DEAD)
		if(handle_death_check())
			death()
			return
		else
			set_stat(CONSCIOUS)
	update_damage_hud()
	update_health_hud()
	update_stamina_hud()

/// Check if the necromorph should die
/mob/living/carbon/human/necromorph/proc/handle_death_check()
	return (health <= 0 && !HAS_TRAIT(src, TRAIT_NODEATH))
