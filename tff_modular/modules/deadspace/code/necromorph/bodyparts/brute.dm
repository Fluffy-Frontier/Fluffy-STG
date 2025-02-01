/obj/item/bodypart/chest/necromorph/brute
	name = BODY_ZONE_CHEST
	limb_id = SPECIES_NECROMORPH_BRUTE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/brute.dmi'
	icon_state = "chest-d"
	max_damage = 400
	px_x = 0
	px_y = 0
	wound_resistance = 30
	n_biomass = 81
	burn_modifier = 0.75

/obj/item/bodypart/head/necromorph/brute
	name = BODY_ZONE_HEAD
	limb_id = SPECIES_NECROMORPH_BRUTE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/brute.dmi'
	icon_state = "head-d"
	max_damage = 100
	px_x = 0
	px_y = -8
	wound_resistance = 10
	n_biomass = 15 //pea brain, not much n_biomass
	burn_modifier = 0.75

/obj/item/bodypart/arm/left/necromorph/brute
	name = "left arm"
	limb_id = SPECIES_NECROMORPH_BRUTE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/brute.dmi'
	icon_state = "l_arm-d"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 150
	px_x = -6
	px_y = 0
	wound_resistance = 5
	n_biomass = 21
	burn_modifier = 0.75

/obj/item/bodypart/arm/right/necromorph/brute
	name = "right arm"
	limb_id = SPECIES_NECROMORPH_BRUTE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/brute.dmi'
	icon_state = "r_arm-d"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 150
	px_x = 6
	px_y = 0
	wound_resistance = 5
	n_biomass = 21
	burn_modifier = 0.75

/obj/item/bodypart/leg/left/necromorph/brute
	name = "left leg"
	limb_id = SPECIES_NECROMORPH_BRUTE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/brute.dmi'
	icon_state = "l_leg-d"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 150
	px_x = -2
	px_y = 12
	wound_resistance = 5
	n_biomass = 21
	burn_modifier = 0.75
	special_footstep_sounds = list(list(
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_5.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_6.ogg'
	), VOLUME_MID, 0)

/obj/item/bodypart/leg/right/necromorph/brute
	name = "right leg"
	limb_id = SPECIES_NECROMORPH_BRUTE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/brute.dmi'
	icon_state = "r_leg-d"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 150
	px_x = 2
	px_y = 12
	wound_resistance = 5
	n_biomass = 21
	burn_modifier = 0.75
	special_footstep_sounds = list(list(
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_5.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/brute_step_6.ogg'
	), VOLUME_MID, 0)
