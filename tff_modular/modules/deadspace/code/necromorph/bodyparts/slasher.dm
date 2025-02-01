/obj/item/bodypart/chest/necromorph/slasher
	name = BODY_ZONE_CHEST
	limb_id = SPECIES_NECROMORPH_SLASHER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	icon_state = "chest"
	max_damage = 200
	px_x = 0
	px_y = 0
	wound_resistance = 5
	n_biomass = 10

/obj/item/bodypart/head/necromorph/slasher
	name = BODY_ZONE_HEAD
	limb_id = SPECIES_NECROMORPH_SLASHER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	icon_state = "head"
	max_damage = 30
	px_x = 0
	px_y = -8
	wound_resistance = 0
	n_biomass = 7
	base_pixel_x = -5
	base_pixel_y = -20

/obj/item/bodypart/arm/left/necromorph/slasher
	name = "left blade"
	limb_id = SPECIES_NECROMORPH_SLASHER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 25
	px_x = -6
	px_y = 0
	wound_resistance = -3
	n_biomass = 2
	base_pixel_x = -15
	base_pixel_y = -15

/obj/item/bodypart/arm/right/necromorph/slasher
	name = "right blade"
	limb_id = SPECIES_NECROMORPH_SLASHER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("slashes", "stabs")
	attack_verb_simple = list("slash", "stab")
	max_damage = 25
	px_x = 6
	px_y = 0
	wound_resistance = -3
	n_biomass = 2
	base_pixel_y = -15

/obj/item/bodypart/leg/left/necromorph/slasher
	name = "left leg"
	limb_id = SPECIES_NECROMORPH_SLASHER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	icon_state = "l_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 30
	px_x = -2
	px_y = 12
	wound_resistance = -3
	n_biomass = 2

/obj/item/bodypart/leg/right/necromorph/slasher
	name = "right leg"
	limb_id = SPECIES_NECROMORPH_SLASHER
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	icon_state = "r_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 30
	px_x = 2
	px_y = 12
	wound_resistance = -3
	n_biomass = 2
