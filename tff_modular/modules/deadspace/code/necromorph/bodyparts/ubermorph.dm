/obj/item/bodypart/chest/necromorph/ubermorph
	name = BODY_ZONE_CHEST
	limb_id = SPECIES_NECROMORPH_UBERMORPH
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/ubermorph.dmi'
	icon_state = "chest"
	max_damage = 800
	px_x = 0
	px_y = 0
	wound_resistance = 20

/obj/item/bodypart/head/necromorph/ubermorph
	name = BODY_ZONE_HEAD
	limb_id = SPECIES_NECROMORPH_UBERMORPH
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/ubermorph.dmi'
	icon_state = "head"
	max_damage = 60
	px_x = 0
	px_y = -8
	wound_resistance = 0
	base_pixel_x = -5
	base_pixel_y = -45

/obj/item/bodypart/arm/left/necromorph/ubermorph
	name = "left blade"
	limb_id = SPECIES_NECROMORPH_UBERMORPH
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/ubermorph.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 90
	px_x = -6
	px_y = 0
	wound_resistance = -5
	base_pixel_x = -15
	base_pixel_y = -20

/obj/item/bodypart/arm/right/necromorph/ubermorph
	name = "right blade"
	limb_id = SPECIES_NECROMORPH_UBERMORPH
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/ubermorph.dmi'
	icon_state = "r_arm"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 90
	px_x = 6
	px_y = 0
	wound_resistance = -5
	base_pixel_y = -20

/obj/item/bodypart/leg/left/necromorph/ubermorph
	name = "left leg"
	limb_id = SPECIES_NECROMORPH_UBERMORPH
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/ubermorph.dmi'
	icon_state = "l_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 90
	px_x = -2
	px_y = 12
	wound_resistance = -5
	base_pixel_x = -13
	special_footstep_sounds = list(list(
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_4.ogg'
	), VOLUME_MID, 0)

/obj/item/bodypart/leg/right/necromorph/ubermorph
	name = "right leg"
	limb_id = SPECIES_NECROMORPH_UBERMORPH
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/ubermorph.dmi'
	icon_state = "r_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 90
	px_x = 2
	px_y = 12
	wound_resistance = -5
	special_footstep_sounds = list(list(
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/footstep/ubermorph_footstep_4.ogg'
	), VOLUME_MID, 0)
