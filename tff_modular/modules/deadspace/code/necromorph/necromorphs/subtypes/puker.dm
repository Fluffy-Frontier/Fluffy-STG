/mob/living/carbon/human/necromorph/puker
	health = 125
	maxHealth = 125
	class = /datum/necro_class/puker
	necro_species = /datum/species/necromorph/puker
	armor_type = /datum/armor/dsnecro_puker

/mob/living/carbon/human/necromorph/puker/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_puker)
	death_sound = pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_death_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_death_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_death_3.ogg',
	)

/mob/living/carbon/human/necromorph/puker/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.puker_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/puker
	display_name = "Puker"
	desc = "A flexible ranged necromorph who fights by dousing enemies in acid, and is effective at long ranges. Good for crowd control and direct firefights, but suffers greatly in melee combat."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/puker/puker.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/puker
	nest_allowed = TRUE
	tier = 2
	biomass_cost = 125
	biomass_spent_required = 680
	melee_damage_lower = 7
	melee_damage_upper = 10
	armor_type = /datum/armor/dsnecro_puker
	actions = list(
		/datum/action/cooldown/necro/shoot/puker_snapshot,
		/datum/action/cooldown/necro/shoot/puker_longshot,
		/datum/action/cooldown/necro/shout,
		/datum/action/cooldown/necro/scream,
		// /datum/action/cooldown/necro/spray,
	)
	minimap_icon = "puker"
	implemented = TRUE

/datum/armor/dsnecro_puker
	melee = 50
	bullet = 50
	laser = 0
	energy = 0
	bomb = 5
	bio = 75
	fire = 10
	acid = 100

/datum/species/necromorph/puker
	name = "Puker"
	id = SPECIES_NECROMORPH_PUKER
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/puker,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/puker,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/puker,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/puker,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/puker,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/puker,
	)

/datum/species/necromorph/puker/get_scream_sound(mob/living/carbon/human/necromorph/puker)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_pain_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_shout_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_shout_4.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/puker/puker_shout_long_4.ogg',
	)

/datum/action/cooldown/necro/shoot/puker_longshot
	name = "Long shot"
	desc = "A powerful projectile for longrange shooting."
	cooldown_time = 3.5 SECONDS
	windup_time = 0.5 SECONDS
	projectiletype = /obj/projectile/bullet/biobomb/puker_longshot
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_LONGSHOT_DOWN

/datum/action/cooldown/necro/shoot/puker_longshot/pre_fire(atom/target)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, src)

/datum/action/cooldown/necro/shoot/puker_longshot/post_fire()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, src)

/obj/projectile/bullet/biobomb/puker_longshot
	name = "acid blast"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "acid_large"

	damage = 10
	speed = 0.8

/obj/projectile/bullet/biobomb/puker_longshot/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(. == BULLET_ACT_HIT)
		if(isliving(target))
			var/mob/living/M = target
			M.adjust_timed_status_effect(18 SECONDS, /datum/status_effect/bioacid, 180 SECONDS)

#define PUKER_SNAPSHOT_AUTOTARGET_RANGE 3

/datum/action/cooldown/necro/shoot/puker_snapshot
	name = "Snapshot"
	desc = "A moderate-strength projectile that auto-aims at targets within X range."
	cooldown_time = 2.5 SECONDS
	windup_time = 0 SECONDS
	projectiletype = /obj/projectile/bullet/biobomb/puker_snapshot
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_SNAPSHOT_DOWN

/datum/action/cooldown/necro/shoot/puker_snapshot/New(Target, original, cooldown)
	desc = "A moderate-strength projectile that auto-aims at targets within [PUKER_SNAPSHOT_AUTOTARGET_RANGE] range."
	..()

/datum/action/cooldown/necro/shoot/puker_snapshot/PreActivate(atom/target)
	if(!isliving(target))
		for(var/mob/potential_target in view(PUKER_SNAPSHOT_AUTOTARGET_RANGE, get_turf(target)))
			if(!faction_check(potential_target.faction, owner.faction))
				target = potential_target
				break
		if(!isliving(target))
			to_chat(owner, span_warning("No valid targets found within [PUKER_SNAPSHOT_AUTOTARGET_RANGE] tiles range."))
			return TRUE
	return ..()

#undef PUKER_SNAPSHOT_AUTOTARGET_RANGE

/obj/projectile/bullet/biobomb/puker_snapshot
	name = "acid bolt"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "acid_large"

	damage = 6
	speed = 0.8

/obj/projectile/bullet/biobomb/puker_snapshot/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(. == BULLET_ACT_HIT)
		if(isliving(target))
			var/mob/living/M = target
			M.adjust_timed_status_effect(10 SECONDS, /datum/status_effect/bioacid, 180 SECONDS)
