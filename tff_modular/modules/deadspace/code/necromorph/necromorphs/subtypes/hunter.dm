
#define CUMULATIVE_BURN_DAMAGE	0.5
#define FAKEDEATH_HEAL_TIME	4 SECONDS
#define ARM_SWING_RANGE_HUNTER	3

/mob/living/carbon/human/necromorph/hunter
	health = 275
	maxHealth = 275
	class = /datum/necro_class/hunter
	necro_species = /datum/species/necromorph/hunter
	armor_type = /datum/armor/dsnecro_hunter

/mob/living/carbon/human/necromorph/hunter/Initialize(mapload, obj/structure/marker/marker_master)
	. = ..()
	add_movespeed_modifier(/datum/movespeed_modifier/dsnecro_hunter)

/mob/living/carbon/human/necromorph/hunter/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.hunter_sounds[audio_type]), volume, vary, extra_range)

/mob/living/carbon/human/necromorph/hunter/handle_death_check()
	var/total_burn = getFireLoss()
	var/total_brute = getBruteLoss()

	var/damage = total_burn + total_brute
	if(damage >= maxHealth)
		if(total_burn >= (initial(maxHealth)))
			return TRUE

		if(getLastingDamage() >= initial(maxHealth))
			return TRUE

		if(!IsParalyzed())
			apply_status_effect(/datum/status_effect/incapacitating/paralyzed, 8.6 SECONDS)
			AddComponent(/datum/component/regenerate, duration_time = 8.6 SECONDS, max_limbs = 5, heal_amount = 100, lasting_damage_heal = 35, burn_heal_mult = 0.1)
		return FALSE
	return FALSE

/mob/living/carbon/human/necromorph/hunter/apply_damage(damage, damagetype, def_zone, blocked, wound_bonus, bare_wound_bonus, forced, spread_damage, sharpness, attack_direction, attacking_item, wound_clothing)
	if(health - damage <= 0)
		handle_death_check()
	. = ..()

/datum/necro_class/hunter
	display_name = "Hunter"
	desc = "A rapidly regenerating vanguard, designed to lead the charge, suffer a glorious death, then get back up and do it again. \
	Avoid fire though."
	ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/hunter.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/hunter
	nest_allowed = FALSE
	tier = 3
	biomass_cost = 400
	biomass_spent_required = 1200
	melee_damage_lower = 18
	melee_damage_upper = 22
	armor_type = /datum/armor/dsnecro_hunter
	actions = list(
		/datum/action/cooldown/necro/swing/hunter,
		// /datum/action/cooldown/necro/taunt/hunter,
		/datum/action/cooldown/necro/regenerate/hunter,
		/datum/action/cooldown/necro/shout,
	)
	minimap_icon = "hunter"
	implemented = TRUE

/datum/armor/dsnecro_hunter
	melee = 80
	bullet = 60
	laser = 0
	energy = 0
	bomb = 15
	bio = 75
	fire = 0
	acid = 95

/datum/species/necromorph/hunter
	name = "Hunter"
	id = SPECIES_NECROMORPH_HUNTER
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/hunter,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/hunter,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/hunter,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/hunter,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/hunter,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/hunter,
	)

/datum/species/necromorph/hunter/get_scream_sound(mob/living/carbon/human/necromorph/hunter)
	return pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_5.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_6.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_long_3.ogg',
	)

/datum/action/cooldown/necro/regenerate/hunter
	cooldown_time = 30 SECONDS
	duration = 8.6 SECONDS
	lasting_damage_heal = 20
	heal_amount = 30
	burn_heal_mult = 0.33

/datum/action/cooldown/necro/regenerate/hunter/PreActivate(atom/target)
	var/mob/living/carbon/human/necromorph/necromorph = owner
	necromorph.play_necro_sound(SOUND_PAIN, VOLUME_MID, 1, 3)
	return ..()

/datum/action/cooldown/necro/swing/hunter
	name = "Hookblade"
	desc = "A shortrange charge with a swing at the end, pulling in all enemies it hits."
	visual_type = /obj/effect/temp_visual/swing/hunter

/datum/action/cooldown/necro/swing/hunter/windup()
	var/mob/living/carbon/human/necromorph/necromorph = owner
	necromorph.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 1, 2)
	return ..()

/datum/action/cooldown/necro/swing/hunter/hit_mob(mob/living/L)
	if(..())
		var/throw_dir = pick(
			turn(owner.dir, 90),
			turn(owner.dir, -90),
			)
		var/throw_dist = 2

		var/throw_x = L.x
		if(throw_dir & WEST)
			throw_x += throw_dist
		else if(throw_dir & EAST)
			throw_x -= throw_dist

		var/throw_y = L.y
		if(throw_dir & NORTH)
			throw_y += throw_dist
		else if(throw_dir & SOUTH)
			throw_y -= throw_dist

		throw_x = clamp(throw_x, 1, world.maxx)
		throw_y = clamp(throw_y, 1, world.maxy)

		L.safe_throw_at(locate(throw_x, throw_y, L.z), throw_dist, 1, owner, TRUE)

/obj/effect/temp_visual/swing/hunter
	base_icon_state = "hunter"
	icon_state = "hunter_left"
	variable_icon = TRUE

/datum/action/cooldown/necro/taunt/hunter
	desc = "Provides a defensive buff to the hunter, and a larger one to his allies."
	type_buff = /datum/component/statmod/taunt_buff
	var/obj/effect/temp_visual/expanding_circle/EC

/datum/action/cooldown/necro/taunt/hunter/Activate()
	owner:play_necro_sound(SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
	. = ..()
	EC = new /obj/effect/temp_visual/expanding_circle(owner.loc, 1.5 SECONDS, 1.5,"#ff0000")
	EC.pixel_y += 40	//Offset it so it appears to be at our mob's head
	addtimer(CALLBACK(src, PROC_REF(effects)), 4)
	addtimer(CALLBACK(src, PROC_REF(effects)), 8)

/datum/action/cooldown/necro/taunt/hunter/proc/effects()
	EC = new /obj/effect/temp_visual/expanding_circle(owner.loc, 1.5 SECONDS, 1.5,"#ff0000")
	EC.pixel_y += 40	//Offset it so it appears to be at our mob's head

/datum/component/statmod/taunt_buff
	//These stats apply to self
	//statmods = list(STATMOD_MOVESPEED_ADDITIVE = 0.15,
	//				STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = 0.85
	//)
