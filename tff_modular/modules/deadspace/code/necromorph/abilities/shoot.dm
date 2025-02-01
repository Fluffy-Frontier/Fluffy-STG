/datum/action/cooldown/necro/shoot
	name = "Shoot"
	desc = "Shoot projectiles at your enemies."
	cooldown_time = 1.5 SECONDS
	click_to_activate = TRUE
	var/windup_time = 0
	var/projectiletype = /obj/projectile/bullet/biobomb

/datum/action/cooldown/necro/shoot/Activate(atom/target)
	. = TRUE
	owner.face_atom(target)
	pre_fire(target)
	var/mob/living/carbon/human/necromorph/necro = owner
	necro.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 3)
	INVOKE_ASYNC(src, PROC_REF(shoot), target)

/datum/action/cooldown/necro/shoot/proc/pre_fire()
	return

/datum/action/cooldown/necro/shoot/proc/shoot(atom/target)
	if(windup_time > 0)
		StartCooldown(windup_time)
		sleep(windup_time)
	var/turf/startloc = get_turf(owner)
	var/obj/projectile/P = new projectiletype(startloc)
	P.def_zone = owner.zone_selected
	P.starting = startloc
	P.firer = owner
	//We don't want to hit other necromorphs
	P.ignored_factions = owner.faction
	P.fired_from = owner
	P.yo = target.y - startloc.y
	P.xo = target.x - startloc.x
	P.original = target
	P.fire()
	StartCooldown()
	INVOKE_ASYNC(src, PROC_REF(post_fire))

/datum/action/cooldown/necro/shoot/proc/post_fire()
	return

/obj/projectile/bullet/biobomb
	name = "acid bolt"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "acid_large"
	speed = 1
	impact_effect_type = /obj/effect/temp_visual/biombomb_impact
	//The immediate damage from a direct hit, bioacid gives more damage over time.
	damage = 10 // ORIGINAL 5
	damage_type = BURN

	armor_flag = ACID
	armour_penetration = 0
	eyeblur = 5

//burns a living target over the course of it's duration
/datum/status_effect/bioacid
	id = "bioacid"
	status_type = STATUS_EFFECT_UNIQUE //Won't give us a new effect until this one wears off
	duration = 4 SECONDS //The different necro acid projectiles increase this duration
	tick_interval = 2 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/bioacid

/datum/status_effect/bioacid/on_creation(mob/living/new_owner)
	RegisterSignal(new_owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))
	. = ..()

/datum/status_effect/bioacid/on_remove()
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))
	. = ..()

//If the poor sod gets some water they can wash the acid off
/datum/status_effect/bioacid/proc/on_clean(atom/source, clean_types)
	SIGNAL_HANDLER
	if(!(clean_types & CLEAN_TYPE_ACID))
		return NONE
	owner.remove_status_effect(/datum/status_effect/bioacid)
	return COMPONENT_CLEANED

/datum/status_effect/bioacid/tick()
	linked_alert.icon_state = "bioacid"
	var/armor = owner.run_armor_check(attack_flag = ACID, silent = TRUE)
	owner.apply_damage(4, BURN, blocked = armor, spread_damage = TRUE) //ORIGINAL DAMAGE: 2 MORE?

/datum/status_effect/bioacid/get_examine_text()
	return span_warning("[owner.p_they(TRUE)] [owner.p_are()] covered in sizzling acid!")

/atom/movable/screen/alert/status_effect/bioacid
	name = "Covered in acid"
	desc = "You are covered in sizzling acid! <i>Splash yourself with some water, or find a shower!</i>"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "impact_acid_4"

/obj/projectile/bullet/biobomb/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(. == BULLET_ACT_HIT)
		if(isliving(target))
			var/mob/living/M = target
			M.apply_status_effect(/datum/status_effect/bioacid)

/obj/effect/temp_visual/biombomb_impact
	name = "\improper acid bolt impact"
	icon = 'tff_modular/modules/deadspace/icons/obj/projectiles.dmi'
	icon_state = "impact_acid_1"
	color = COLOR_MUZZLE_ACID

/obj/effect/temp_visual/biombomb_impact/Initialize(mapload)
	icon_state = "impact_acid_[rand(1, 4)]"
	return ..()
