/mob/living/carbon/human/necromorph/infector/enhanced
	health = 185
	maxHealth = 185
	class = /datum/necro_class/infector/enhanced
	necro_species = /datum/species/necromorph/infector/enhanced

/mob/living/carbon/human/necromorph/infector/enhanced/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_e_infector)

/mob/living/carbon/human/necromorph/infector/enhanced/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.infector_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/infector/enhanced
	display_name = "Enhanced Infector"
	desc = "Unlike the more fragile counterpart, this infector is a capable fighter. However, nothing compares to its supportive capabilities."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/infector.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/infector/enhanced
	melee_damage_lower = 10
	melee_damage_upper = 16
	actions = list(
	)
	minimap_icon = "e_infector"

/datum/species/necromorph/infector/enhanced
	name = "Enhanced Infector"
	id = SPECIES_NECROMORPH_INFECTOR_ENHANCED
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/infector/enhanced,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/infector/enhanced,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/infector/enhanced,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/infector/enhanced,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/infector/enhanced,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/infector/enhanced,
	)
