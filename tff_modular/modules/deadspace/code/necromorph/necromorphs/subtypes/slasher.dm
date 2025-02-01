/mob/living/carbon/human/necromorph/slasher
	health = 180
	maxHealth = 100
	class = /datum/necro_class/slasher
	necro_species = /datum/species/necromorph/slasher
	armor_type = /datum/armor/dsnecro_slasher
	pixel_x = -8
	base_pixel_x = -8

/mob/living/carbon/human/necromorph/slasher/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_slasher)

/mob/living/carbon/human/necromorph/slasher/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.slasher_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/slasher
	display_name = "Slasher"
	desc = "The frontline soldier of the necromorph horde. While slow, the slasher's charge and dodge help it close the distance."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/slasher
	nest_allowed = TRUE
	tier = 1
	biomass_cost = 50
	biomass_spent_required = 0
	melee_damage_lower = 10
	melee_damage_upper = 16
	armor_type = /datum/armor/dsnecro_slasher
	actions = list(
		/datum/action/cooldown/necro/charge/slasher,
		/datum/action/cooldown/necro/dodge,
		/datum/action/cooldown/necro/shout,
	)
	minimap_icon = "slasher"
	implemented = TRUE

/datum/armor/dsnecro_slasher
	melee = 40
	bullet = 45
	laser = 0
	energy = 0
	bomb = 0
	bio = 50
	fire = 0
	acid = 80

/datum/species/necromorph/slasher
	name = "Slasher"
	id = SPECIES_NECROMORPH_SLASHER
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/slasher,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/slasher,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/slasher,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/slasher,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/slasher,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/slasher,
	)

/datum/species/necromorph/slasher/get_scream_sound(mob/living/carbon/human/necromorph/slasher)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher/slasher_shout_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher/slasher_shout_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher/slasher_shout_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/slasher/slasher_shout_4.ogg',
	)

/datum/action/cooldown/necro/charge/slasher
	cooldown_time = 12 SECONDS
	charge_delay = 1 SECONDS
	charge_time = 4 SECONDS

/datum/action/cooldown/necro/charge/slasher/do_charge_indicator(atom/charge_target)
	var/mob/living/carbon/human/necromorph/source = owner
	var/matrix/new_matrix = matrix(source.transform)
	var/shake_dir = pick(-1, 1)
	new_matrix.Turn(16*shake_dir)
	animate(source, transform = new_matrix, pixel_x = source.pixel_x + 5*shake_dir, time = 1)
	animate(transform = matrix(), pixel_x = source.pixel_x-5*shake_dir, time = 9, easing = ELASTIC_EASING)
	source.play_necro_sound(SOUND_SHOUT_LONG, VOLUME_MID, TRUE, 3)
