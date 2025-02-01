/mob/living/carbon/human/necromorph/spitter
	health = 90
	maxHealth = 90
	class = /datum/necro_class/spitter
	necro_species = /datum/species/necromorph/spitter
	armor_type = /datum/armor/dsnecro_spitter

/mob/living/carbon/human/necromorph/spitter/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	death_sound = pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/spitter/spitter_death_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/spitter/spitter_death_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/spitter/spitter_death_3.ogg',
	)

/mob/living/carbon/human/necromorph/spitter/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.spitter_sounds[audio_type]), volume, vary, extra_range)

/datum/necro_class/spitter
	display_name = "Spitter"
	desc = "A midline skirmisher with the ability to spit acid at medium range. Works best when accompanied by slashers to protect it from attacks. Weak and fragile in direct combat."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/spitter.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/spitter
	nest_allowed = TRUE
	tier = 1
	biomass_cost = 45
	biomass_spent_required = 0
	melee_damage_lower = 10
	melee_damage_upper = 13
	armor_type = /datum/armor/dsnecro_spitter
	actions = list(
		/datum/action/cooldown/necro/shoot/spitter_snapshot,
		/datum/action/cooldown/necro/shoot/spitter_longshot,
		/datum/action/cooldown/necro/shout,
		/datum/action/cooldown/necro/scream,
	)
	minimap_icon = "spitter"
	implemented = TRUE

/datum/armor/dsnecro_spitter
	melee = 40
	bullet = 45
	laser = 0
	energy = 0
	bomb = 0
	bio = 65
	fire = 0
	acid = 90

/datum/species/necromorph/spitter
	name = "Spitter"
	id = SPECIES_NECROMORPH_SPITTER
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/spitter,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/spitter,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/spitter,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/spitter,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/spitter,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/spitter,
	)

/datum/species/necromorph/spitter/get_scream_sound(mob/living/carbon/human/necromorph/spitter)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/spitter/spitter_pain_extreme.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/spitter/spitter_pain_extreme_2.ogg',
	)

/datum/action/cooldown/necro/shoot/spitter_longshot
	name = "Long shot"
	desc = "A powerful projectile for longrange shooting."
	cooldown_time = 3.5 SECONDS
	windup_time = 0.5 SECONDS
	projectiletype = /obj/projectile/bullet/biobomb/spitter_longshot
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_LONGSHOT_DOWN

/datum/action/cooldown/necro/shoot/spitter_longshot/pre_fire(atom/target)
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, src)

/datum/action/cooldown/necro/shoot/spitter_longshot/post_fire()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, src)

/obj/projectile/bullet/biobomb/spitter_longshot
	name = "acid blast"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "acid_large"

	damage = 7
	speed = 0.8

/obj/projectile/bullet/biobomb/spitter_longshot/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(. == BULLET_ACT_HIT)
		if(isliving(target))
			var/mob/living/M = target
			M.adjust_timed_status_effect(9 SECONDS, /datum/status_effect/bioacid, 180 SECONDS)

#define SPITTER_SNAPSHOT_AUTOTARGET_RANGE 3

/datum/action/cooldown/necro/shoot/spitter_snapshot
	name = "Snapshot"
	desc = "A moderate-strength projectile that auto-aims at targets within X range."
	cooldown_time = 3 SECONDS
	windup_time = 0 SECONDS
	projectiletype = /obj/projectile/bullet/biobomb/spitter_snapshot
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_SNAPSHOT_DOWN

/datum/action/cooldown/necro/shoot/spitter_snapshot/New(Target, original, cooldown)
	desc = "A moderate-strength projectile. Auto-aims at targets within [SPITTER_SNAPSHOT_AUTOTARGET_RANGE] range."
	..()

/datum/action/cooldown/necro/shoot/spitter_snapshot/PreActivate(atom/target)
	if(!isliving(target))
		for(var/mob/potential_target in view(SPITTER_SNAPSHOT_AUTOTARGET_RANGE, get_turf(target)))
			if(!faction_check(potential_target.faction, owner.faction))
				target = potential_target
				break
		if(!isliving(target))
			to_chat(owner, span_warning("No valid targets found within [SPITTER_SNAPSHOT_AUTOTARGET_RANGE] tiles range."))
			return TRUE
	return ..()

#undef SPITTER_SNAPSHOT_AUTOTARGET_RANGE

/obj/projectile/bullet/biobomb/spitter_snapshot
	name = "acid bolt"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "acid_large"

	damage = 4
	speed = 0.8

/obj/projectile/bullet/biobomb/spitter_snapshot/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(. == BULLET_ACT_HIT)
		if(isliving(target))
			var/mob/living/M = target
			M.adjust_timed_status_effect(6 SECONDS, /datum/status_effect/bioacid, 180 SECONDS)

