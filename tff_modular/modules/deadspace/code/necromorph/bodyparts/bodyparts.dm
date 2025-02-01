#define DROPLIMB_THRESHOLD_EDGE 0.2
#define DROPLIMB_THRESHOLD_TEAROFF 0.5
#define DROPLIMB_THRESHOLD_DESTROY 1

/obj/item/bodypart/chest/necromorph
	name = BODY_ZONE_CHEST
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	//bodypart_flags = ()
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'
	icon_state = "chest"
	interaction_flags_item = NONE //So you don't pick it up
	w_class = WEIGHT_CLASS_GIGANTIC //So you can't put them in bags
	dmg_overlay_type = null
	max_damage = 200
	is_dimorphic = FALSE
	px_x = 0
	px_y = 0
	grind_results = null
	wound_resistance = 10
	acceptable_bodytype = BODYTYPE_NECROMORPH
	can_be_disabled = FALSE

/obj/item/bodypart/head/necromorph
	name = BODY_ZONE_HEAD
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'
	icon_state = "head"
	interaction_flags_item = NONE
	w_class = WEIGHT_CLASS_GIGANTIC
	head_flags = null
	dmg_overlay_type = null
	max_damage = 200
	px_x = 0
	px_y = -8
	wound_resistance = 5
	is_dimorphic = FALSE
	can_be_disabled = FALSE
	show_organs_on_examine = TRUE

/obj/item/bodypart/head/necromorph/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	if((wounding_type & WOUND_SLASH) && brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_EDGE)
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(burn_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BURN, wounding_type = wounding_type)

	else if((wounding_type * WOUND_PIERCE) && (brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_TEAROFF))
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BRUTE, wounding_type = wounding_type)

/obj/item/bodypart/arm/left/necromorph
	name = "left arm"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'
	icon_state = "l_arm"
	interaction_flags_item = NONE
	w_class = WEIGHT_CLASS_GIGANTIC
	dmg_overlay_type = null
	attack_verb_continuous = list("slaps", "punches")
	attack_verb_simple = list("slap", "punch")
	max_damage = 50
	px_x = -6
	px_y = 0
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/arm/left/necromorph/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	if((wounding_type & WOUND_SLASH) && brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_EDGE)
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(burn_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BURN, wounding_type = wounding_type)

	else if((wounding_type * WOUND_PIERCE) && (brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_TEAROFF))
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BRUTE, wounding_type = wounding_type)

/obj/item/bodypart/arm/right/necromorph
	name = "right arm"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'
	icon_state = "r_arm"
	interaction_flags_item = NONE
	w_class = WEIGHT_CLASS_GIGANTIC
	dmg_overlay_type = null
	attack_verb_continuous = list("slaps", "punches")
	attack_verb_simple = list("slap", "punch")
	max_damage = 50
	px_x = 6
	px_y = 0
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/arm/right/necromorph/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	if((wounding_type & WOUND_SLASH) && brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_EDGE)
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(burn_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BURN, wounding_type = wounding_type)

	else if((wounding_type * WOUND_PIERCE) && (brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_TEAROFF))
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BRUTE, wounding_type = wounding_type)

/obj/item/bodypart/leg/left/necromorph
	name = "left leg"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'
	icon_state = "l_leg"
	interaction_flags_item = NONE
	w_class = WEIGHT_CLASS_GIGANTIC
	dmg_overlay_type = null
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 50
	px_x = -2
	px_y = 12
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/leg/left/necromorph/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	if((wounding_type & WOUND_SLASH) && brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_EDGE)
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(burn_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BURN, wounding_type = wounding_type)

	else if((wounding_type * WOUND_PIERCE) && (brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_TEAROFF))
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BRUTE, wounding_type = wounding_type)

/obj/item/bodypart/leg/right/necromorph
	name = "right leg"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	bodyshape = parent_type::bodyshape | BODYSHAPE_CUSTOM
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'
	icon_state = "r_leg"
	interaction_flags_item = NONE
	w_class = WEIGHT_CLASS_GIGANTIC
	dmg_overlay_type = null
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 50
	px_x = 2
	px_y = 12
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/leg/right/necromorph/try_dismember(wounding_type, wounding_dmg, wound_bonus, bare_wound_bonus)
	if((wounding_type & WOUND_SLASH) && brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_EDGE)
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(burn_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BURN, wounding_type = wounding_type)

	else if((wounding_type * WOUND_PIERCE) && (brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_TEAROFF))
		return dismember(BRUTE, wounding_type = wounding_type)

	else if(brute_dam + wounding_dmg >= max_damage * DROPLIMB_THRESHOLD_DESTROY)
		return dismember(BRUTE, wounding_type = wounding_type)

#undef DROPLIMB_THRESHOLD_EDGE
#undef DROPLIMB_THRESHOLD_TEAROFF
#undef DROPLIMB_THRESHOLD_DESTROY


//BODYPART_UNREMOVABLE
