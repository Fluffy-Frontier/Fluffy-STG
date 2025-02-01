/obj/item/bodypart/chest/necromorph/puker
	name = BODY_ZONE_CHEST
	limb_id = SPECIES_NECROMORPH_PUKER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	icon_state = "chest"
	max_damage = 200
	px_x = 0
	px_y = 0
	wound_resistance = 5
	n_biomass = 17.5

/obj/item/bodypart/head/necromorph/puker
	name = BODY_ZONE_HEAD
	limb_id = SPECIES_NECROMORPH_PUKER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	icon_state = "head"
	max_damage = 30
	px_x = 0
	px_y = -8
	wound_resistance = 0
	n_biomass = 15

/obj/item/bodypart/arm/left/necromorph/puker
	name = "left blade"
	limb_id = SPECIES_NECROMORPH_PUKER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 20
	px_x = -6
	px_y = 0
	wound_resistance = -3
	n_biomass = 7.5

/obj/item/bodypart/arm/right/necromorph/puker
	name = "right blade"
	limb_id = SPECIES_NECROMORPH_PUKER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	icon_state = "r_arm"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 20
	px_x = 6
	px_y = 0
	wound_resistance = -3
	n_biomass = 7.5

/obj/item/bodypart/leg/left/necromorph/puker
	name = "left leg"
	limb_id = SPECIES_NECROMORPH_PUKER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	icon_state = "l_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 35
	px_x = -2
	px_y = 12
	wound_resistance = -3
	n_biomass = 7.5
	special_footstep_sounds = list(list(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_5.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_6.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_7.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_8.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_9.ogg'
	), VOLUME_MID, 0)

/obj/item/bodypart/leg/right/necromorph/puker
	name = "right leg"
	limb_id = SPECIES_NECROMORPH_PUKER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	icon_state = "r_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 35
	px_x = 2
	px_y = 12
	wound_resistance = -3
	n_biomass = 7.5
	special_footstep_sounds = list(list(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_5.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_6.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_7.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_8.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_footstep_9.ogg'
	), VOLUME_MID, 0)
