/mob/living/carbon/human/necromorph/twitcher
	health = 175
	maxHealth = 175
	class = /datum/necro_class/twitcher
	necro_species = /datum/species/necromorph/twitcher
	armor_type = /datum/armor/dsnecro_twitcher
	pixel_x = -8
	base_pixel_x = -8
	///Pool for passive dodging of projectiles, gained passively over time and lost by dodging
	var/dodge_pool = 100
	//The absolute max the dodge_pool can have
	var/max_pool = 100
	///Chance of dodge_pool decreasing from bullet dodge
	var/dodge_pool_chance = 55
	///Amount dodge_pool decreases
	var/dodge_pool_usage = 12

/mob/living/carbon/human/necromorph/twitcher/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_twitcher)

/mob/living/carbon/human/necromorph/twitcher/bullet_act(obj/projectile/bullet, def_zone, piercing_hit = FALSE)
	if(stat == DEAD)
		return ..() //We don't want the twitcher to dodge if he is dead

	if(prob(dodge_pool))
		visible_message(span_danger("[src] twitches out of the way of [bullet]!"))
		Shake(pick(15,-15),pick(15, -15), 1 SECONDS)
		playsound(src, SFX_BULLET_MISS, 75, TRUE)
		if(prob(dodge_pool_chance)) //Lowers dodge pool, moves twitcher out of the way if pool lowers
			dodge_pool -= dodge_pool_usage
			var/move_dir = pick(GLOB.alldirs)
			Move(get_step(src, move_dir), move_dir)
		return BULLET_ACT_FORCE_PIERCE
	return ..()

/mob/living/carbon/human/necromorph/twitcher/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.twitcher_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/twitcher
	display_name = "Twitcher"
	desc = "An elite soldier displaced in time, blinks around randomly and is difficult to hit. Charges extremely quickly"
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/twitcher.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/twitcher
	tier = 1 //For the sake of sanity checks the normal twitcher is technically a T1
	biomass_cost = 150
	biomass_spent_required = 850
	melee_damage_lower = 10
	melee_damage_upper = 16
	armor_type = /datum/armor/dsnecro_twitcher
	actions = list(
		/datum/action/cooldown/necro/shout,
		/datum/action/cooldown/necro/charge,
		/datum/action/cooldown/necro/charge/twitcher,
	)
	minimap_icon = "twitcher"
	implemented = TRUE
	nest_allowed = FALSE

/datum/armor/dsnecro_twitcher
	melee = 45
	bullet = 55
	laser = 0
	energy = 0
	bomb = 0
	bio = 50
	fire = 0
	acid = 80

/datum/species/necromorph/twitcher
	name = "Twitcher"
	id = SPECIES_NECROMORPH_TWITCHER
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/twitcher,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/twitcher,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/twitcher,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/twitcher,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/twitcher,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/twitcher,
	)

/datum/species/necromorph/twitcher/get_scream_sound(mob/living/carbon/human/necromorph/twitcher)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_5.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/twitcher/twitcher_shout_1.ogg',
	)

//Twitcher passively generates it's dodge back at a flat rate
/datum/species/necromorph/twitcher/spec_life(mob/living/carbon/human/necromorph/twitcher/necro, delta_time, times_fired)
	if(necro.stat == DEAD)
		return //Don't want it generating dodge while dead
	necro.dodge_pool = min(necro.dodge_pool + (0.6 * delta_time), necro.max_pool)
	return ..()


