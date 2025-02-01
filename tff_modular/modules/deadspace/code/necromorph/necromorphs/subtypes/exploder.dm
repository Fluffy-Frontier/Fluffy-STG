/mob/living/carbon/human/necromorph/exploder
	health = 100
	maxHealth = 100
	class = /datum/necro_class/exploder
	necro_species = /datum/species/necromorph/exploder
	armor_type = /datum/armor/dsnecro_exploder
	bodyparts = list(
		/obj/item/bodypart/chest/necromorph/exploder,
		/obj/item/bodypart/head/necromorph/exploder,
		/obj/item/bodypart/arm/left/necromorph/exploder,
		/obj/item/bodypart/arm/right/necromorph/exploder,
		/obj/item/bodypart/leg/left/necromorph/exploder,
		/obj/item/bodypart/leg/right/necromorph/exploder,
	)

/mob/living/carbon/human/necromorph/exploder/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_exploder)
	death_sound = pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_death_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_death_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_death_3.ogg',
	)

/mob/living/carbon/human/necromorph/exploder/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.exploder_sounds[audio_type]), volume, vary, extra_range)

/mob/living/carbon/human/necromorph/exploder/has_hand_for_held_index(i)
	return TRUE //Exploders don't have real arms, so we need to do some weird stuff to prevent runtimes

/datum/necro_class/exploder
	display_name = "Exploder"
	desc = "An expendable suicide bomber, the exploder's sole purpose is to go out in a blaze of glory, and hopefully take a few people with it."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/exploder/exploder.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/exploder
	tier = 1
	biomass_cost = 75
	biomass_spent_required = 0
	melee_damage_lower = 4
	melee_damage_upper = 8
	armor_type = /datum/armor/dsnecro_exploder
	actions = list(
		/datum/action/cooldown/necro/shout,
		/datum/action/cooldown/necro/explode,
		/datum/action/cooldown/necro/charge/exploder,
	)
	minimap_icon = "exploder"
	implemented = TRUE
	nest_allowed = TRUE

/datum/armor/dsnecro_exploder
	melee = 25
	bullet = 30
	laser = 0
	energy = 0
	bomb = 15
	bio = 65
	fire = 0
	acid = 100

/datum/species/necromorph/exploder
	name = "Exploder"
	id = SPECIES_NECROMORPH_EXPLODER
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/exploder,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/exploder,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/exploder,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/exploder,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/exploder,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/exploder,
	)

/datum/species/necromorph/exploder/get_scream_sound(mob/living/carbon/human/necromorph/exploder)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_pain_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_pain_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_pain_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_pain_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/exploder/exploder_pain_5.ogg',
	)
