/mob/living/carbon/human/necromorph/exploder/enhanced
	health = 200
	maxHealth = 200
	class = /datum/necro_class/exploder/enhanced
	necro_species = /datum/species/necromorph/exploder/enhanced
	armor_type = /datum/armor/dsnecro_e_exploder
	bodyparts = list(
		/obj/item/bodypart/chest/necromorph/exploder/enhanced,
		/obj/item/bodypart/head/necromorph/exploder/enhanced,
		/obj/item/bodypart/arm/left/necromorph/exploder/enhanced,
		/obj/item/bodypart/arm/right/necromorph/exploder/enhanced,
		/obj/item/bodypart/leg/left/necromorph/exploder/enhanced,
		/obj/item/bodypart/leg/right/necromorph/exploder/enhanced,)
	pixel_x = -8
	base_pixel_x = -8

/mob/living/carbon/human/necromorph/exploder/enhanced/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_e_exploder) //Ever so slightly faster then his normal cousin

/mob/living/carbon/human/necromorph/exploder/enhanced/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.exploder_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/exploder/enhanced
	display_name = "Enhanced Exploder"
	desc = "An expendable suicide bomber, the exploder's sole purpose is to go out in a blaze of glory, and hopefully take a few people with it."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/exploder/exploder_enhanced.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/exploder/enhanced
	tier = 2
	melee_damage_lower = 10
	melee_damage_upper = 16
	biomass_cost = 165
	biomass_spent_required = 850
	armor_type = /datum/armor/dsnecro_e_exploder
	actions = list(
		/datum/action/cooldown/necro/shout,
		/datum/action/cooldown/necro/explode,
		/datum/action/cooldown/necro/charge/exploder,
	)
	minimap_icon = "e_exploder"
	implemented = TRUE
	nest_allowed = FALSE

/datum/species/necromorph/exploder/enhanced
	name = "Enhanced Exploder"
	id = SPECIES_NECROMORPH_EXPLODER_ENHANCED
	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/exploder/enhanced,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/exploder/enhanced,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/exploder/enhanced,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/exploder/enhanced,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/exploder/enhanced,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/exploder/enhanced,
	)


/datum/armor/dsnecro_e_exploder
	melee = 40
	bullet = 40
	laser = 0
	energy = 0
	bomb = 10
	bio = 70
	fire = 25
	acid = 100
