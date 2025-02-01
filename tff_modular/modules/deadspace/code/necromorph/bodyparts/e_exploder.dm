/obj/item/bodypart/chest/necromorph/exploder/enhanced
	name = BODY_ZONE_CHEST
	limb_id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/exploder/exploder_enhanced.dmi'
	icon_state = "chest"
	max_damage = 200
	px_x = 0
	px_y = 0
	wound_resistance = 20
	n_biomass = 10

/obj/item/bodypart/head/necromorph/exploder/enhanced
	name = BODY_ZONE_HEAD
	limb_id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/exploder/exploder_enhanced.dmi'
	icon_state = "head"
	max_damage = 35
	px_x = 0
	px_y = -8
	wound_resistance = 3
	n_biomass = 9

/obj/item/bodypart/arm/left/necromorph/exploder/enhanced
	name = "red pustule"
	limb_id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/exploder/exploder_enhanced.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 60
	px_x = -2
	px_y = 12
	wound_resistance = 1
	n_biomass = 16 //The majority of n_biomass is in the arm, due to the much bigger explosion

/obj/item/bodypart/arm/right/necromorph/exploder/enhanced
	name = "right arm"
	limb_id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/exploder/exploder_enhanced.dmi'
	icon_state = "r_arm"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 55
	px_x = 2
	px_y = 12
	wound_resistance = -6
	n_biomass = 7

/obj/item/bodypart/leg/right/necromorph/exploder/enhanced
	name = "fused legs"
	desc = "Two legs fused together to form a thick, meaty stalk."
	plaintext_zone = "fused legs"
	limb_id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	can_be_disabled = TRUE
	disabling_threshold_percentage = 2 // ORIGINAL 1
	max_damage = 70
	n_biomass = 0 //Handled in chest due to sprite funnies
	wound_resistance = -3

/obj/item/bodypart/leg/right/necromorph/exploder/enhanced/dismemberable_by_wound()
	return FALSE

/obj/item/bodypart/leg/right/necromorph/exploder/enhanced/dismemberable_by_total_damage()
	return FALSE

/obj/item/bodypart/leg/left/necromorph/exploder/enhanced
	name = "nub"
	desc = "The fleshy remains of a leg that was fused together. This is useless."
	plaintext_zone = "leg nub"
	limb_id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	can_be_disabled = FALSE
	bodypart_flags = BODYPART_PSEUDOPART
	max_damage = 20
	n_biomass = 0

/obj/item/bodypart/leg/left/necromorph/exploder/enhanced/dismemberable_by_wound()
	return FALSE

/obj/item/bodypart/leg/left/necromorph/exploder/enhanced/dismemberable_by_total_damage()
	return FALSE

