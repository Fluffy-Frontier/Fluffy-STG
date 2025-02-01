/mob/living/carbon/human/necromorph/slasher/enhanced
	health = 215
	maxHealth = 215
	class = /datum/necro_class/slasher/enhanced
	necro_species = /datum/species/necromorph/slasher/enhanced
	armor_type = /datum/armor/dsnecro_e_slasher
	pixel_x = -8
	base_pixel_x = -8
	mob_size = MOB_SIZE_LARGE

/mob/living/carbon/human/necromorph/slasher/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	death_sound = pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher_enhanced/eslasher_death_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher_enhanced/eslasher_death_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher_enhanced/eslasher_death_3.ogg',
	)

/mob/living/carbon/human/necromorph/slasher/enhanced/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.enhanced_slasher_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/slasher/enhanced
	display_name = "Enhanced Slasher"
	desc = "The frontline soldier of the necromorph horde. Slow when not charging, but its blade arms make for powerful melee attacks"
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/slasher_enhanced.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/slasher/enhanced
	nest_allowed = FALSE
	tier = 2
	biomass_cost = 125
	biomass_spent_required = 680
	melee_damage_lower = 18
	melee_damage_upper = 22
	armor_type = /datum/armor/dsnecro_e_slasher
	actions = list(
		/datum/action/cooldown/necro/charge/slasher/enhanced,
		/datum/action/cooldown/necro/dodge/enhanced,
		/datum/action/cooldown/necro/shout,
		/datum/action/cooldown/necro/scream,
	)
	minimap_icon = "e_slasher"
	implemented = TRUE

/datum/species/necromorph/slasher/enhanced
	name = "Enhanced Slasher"
	id = SPECIES_NECROMORPH_SLASHER_ENHANCED
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/slasher/enhanced,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/slasher/enhanced,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/slasher/enhanced,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/slasher/enhanced,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/slasher/enhanced,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/slasher/enhanced,
	)

/datum/armor/dsnecro_e_slasher
	melee = 40
	bullet = 60
	laser = 0
	energy = 0
	bomb = 15
	bio = 75
	fire = 15
	acid = 95

/datum/species/necromorph/slasher/enhanced/get_scream_sound(mob/living/carbon/human/necromorph/slasher/enhanced)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher_enhanced/eslasher_pain_extreme.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher_enhanced/eslasher_shout_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher_enhanced/eslasher_shout_long_5.ogg',
	)

/datum/action/cooldown/necro/charge/slasher/enhanced
	cooldown_time = 20 SECONDS
	charge_delay = 0.75 SECONDS
	charge_time = 4 SECONDS

/datum/action/cooldown/necro/dodge/enhanced
	cooldown_time = 6 SECONDS
