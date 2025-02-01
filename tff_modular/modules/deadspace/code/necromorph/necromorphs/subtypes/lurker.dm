/mob/living/carbon/human/necromorph/lurker
	health = 65
	maxHealth = 65
	class = /datum/necro_class/lurker
	necro_species = /datum/species/necromorph/lurker
	pixel_x = -16
	base_pixel_x = -16

/mob/living/carbon/human/necromorph/lurker/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_lurker)

/mob/living/carbon/human/necromorph/lurker/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.lurker_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/lurker
	display_name = "Lurker"
	desc = "Long range fire-support. The lurker is tough and hard to hit as long as its retractible armor is closed. When open it is slow and vulnerable, but fires sharp spines in waves of three."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/lurker/lurker.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/lurker
	melee_damage_lower = 10
	melee_damage_upper = 16
	actions = list(
	)
	minimap_icon = "lurker"

/datum/species/necromorph/lurker
	name = "Lurker"
	id = SPECIES_NECROMORPH_LURKER
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/lurker,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/lurker,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/lurker,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/lurker,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/lurker,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/lurker,
	)

/datum/species/necromorph/lurker/get_scream_sound(mob/living/carbon/human/necromorph/lurker)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/lurker/lurker_shout_long_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/lurker/lurker_shout_long_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/lurker/lurker_shout_4.ogg',
	)
