/obj/item/bodypart/chest/necromorph/leaper/enhanced
	name = BODY_ZONE_CHEST
	limb_id = SPECIES_NECROMORPH_LEAPER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/leaper_enhanced.dmi'
	icon_state = "chest"
	max_damage = 200
	n_biomass = 20
	wound_resistance = 10

/obj/item/bodypart/head/necromorph/leaper/enhanced
	name = BODY_ZONE_HEAD
	limb_id = SPECIES_NECROMORPH_LEAPER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/leaper_enhanced.dmi'
	icon_state = "head"
	max_damage = 45
	n_biomass = 10
	wound_resistance = 2

//Leapers use arms to walk
/obj/item/bodypart/arm/left/necromorph/leaper/enhanced
	limb_id = SPECIES_NECROMORPH_LEAPER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/leaper_enhanced.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 55
	n_biomass = 15
	wound_resistance = -1

/obj/item/bodypart/arm/right/necromorph/leaper/enhanced
	limb_id = SPECIES_NECROMORPH_LEAPER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/leaper_enhanced.dmi'
	icon_state = "r_arm"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 55
	n_biomass = 15
	wound_resistance = -1

/obj/item/bodypart/leg/right/necromorph/leaper/enhanced
	desc = "A long calloused string of flesh held securely together with tendons and exposed bone, it looks very sharp at the tip."
	limb_id = SPECIES_NECROMORPH_LEAPER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/leaper_enhanced.dmi'
	icon_state = "r_leg"
	max_damage = 40
	force = 20 //A surprisingly effective weapon if used in a emergency
	throwforce = 30 //You could really hurt someone with this
	n_biomass = 5
	wound_resistance = -5

/obj/item/bodypart/leg/left/necromorph/leaper/enhanced
	desc = "A long calloused string of flesh held securely together with tendons and exposed bone, it looks very sharp at the tip."
	limb_id = SPECIES_NECROMORPH_LEAPER_ENHANCED
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/leaper_enhanced.dmi'
	icon_state = "l_leg"
	max_damage = 40
	force = 20 //A surprisingly effective weapon if used in a emergency
	throwforce = 30 //You could really hurt someone with this
	n_biomass = 5
	wound_resistance = -5

