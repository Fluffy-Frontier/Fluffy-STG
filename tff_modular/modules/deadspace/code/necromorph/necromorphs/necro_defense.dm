//The primary attack, which goes directly into attack_necromorph
/mob/living/carbon/human/necromorph/UnarmedAttack(atom/A, proximity_flag, list/modifiers)
	A.attack_necromorph(src, modifiers)
	changeNext_move(CLICK_CD_MELEE)
	return

//The proc and backup rolled up in one.
/atom/proc/attack_necromorph(mob/living/carbon/human/necromorph/user, list/modifiers, dealt_damage)
	if(!uses_integrity || (!user.melee_damage_upper && !dealt_damage)) //No damage
		return FALSE
	dealt_damage = dealt_damage || rand(user.melee_damage_lower, user.melee_damage_upper)
	user.do_attack_animation(src, user.attack_effect)
	user.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 1, 3)
	attack_generic(user, dealt_damage, BRUTE, MELEE, TRUE, user.armour_penetration)

/mob/living/attack_necromorph(mob/living/carbon/human/necromorph/user, list/modifiers, dealt_damage)
	dealt_damage = dealt_damage || rand(user.melee_damage_lower, user.melee_damage_upper)
	user.do_attack_animation(src, user.attack_effect)
	playsound(loc, 'sound/items/weapons/slash.ogg', 50, TRUE, -1)
	user.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 1, 3)
	var/zone_attacked = ran_zone(user.zone_selected)
	var/armor_block = run_armor_check(zone_attacked, MELEE)
	visible_message(span_danger("[user.name] attacked [src]!"), \
	span_userdanger("[user.name] attacked you!"), span_hear("You hear a attacked of the flesh!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You attacked [src]!"))
	apply_damage(dealt_damage, BRUTE, zone_attacked, armor_block)
	log_combat(user, src, "attacked")

/mob/living/carbon/human/attack_necromorph(mob/living/carbon/human/necromorph/user, list/modifiers, dealt_damage)
	if(check_block(user, 0, "the [user.name]"))
		visible_message(span_danger("[user] tries to hit [src]!"), \
						span_danger("[user] tries to hit you!"), span_hear("You hear a swoosh!"), null, user)
		user.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 1, 3)
		user.do_attack_animation(src, user.attack_effect)
		playsound(loc, 'sound/items/weapons/slashmiss.ogg', 50, TRUE, -1)
		return FALSE

	user.do_attack_animation(src, user.attack_effect)
	if (w_uniform)
		w_uniform.add_fingerprint(user)
	dealt_damage = prob(90) ? (dealt_damage || rand(user.melee_damage_lower, user.melee_damage_upper)) : 0
	if(!dealt_damage)
		playsound(loc, 'sound/items/weapons/slashmiss.ogg', 50, TRUE, -1)
		user.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 1, 3)
		visible_message(span_danger("[user] lunges at [src]!"), \
		span_userdanger("[user] lunges at you!"), span_hear("You hear a swoosh!"), null, user)
		to_chat(user, span_danger("You lunge at [src]!"))
		return FALSE
	var/obj/item/bodypart/affecting = get_bodypart(ran_zone(user.zone_selected))
	if(!affecting)
		affecting = get_bodypart(BODY_ZONE_CHEST)
	var/armor_block = run_armor_check(affecting, MELEE)
	playsound(loc, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
	visible_message(span_danger("[user.name] attacked [src]!"), \
	span_userdanger("[user.name] attacked you!"), span_hear("You hear a attacked of the flesh!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You attacked [src]!"))
	log_combat(user, src, "attacked")
	if(!dismembering_strike(user, user.zone_selected)) //Dismemberment successful
		return TRUE
	apply_damage(dealt_damage, BRUTE, affecting, armor_block)

/mob/living/carbon/human/necromorph/get_eye_protection()
	return ..() + 2

/mob/living/carbon/human/necromorph/get_ear_protection()
	return INFINITY

/mob/living/carbon/human/necromorph/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	skipcatch = TRUE
	.=..()

/mob/living/carbon/human/necromorph/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE, required_biotype = ALL)
	return FALSE

/mob/living/carbon/human/necromorph/setStaminaLoss(amount, updating_stamina = TRUE, forced = FALSE, required_biotype = ALL)
	return FALSE

/mob/living/carbon/human/necromorph/soundbang_act(intensity = 1, stun_pwr = 20, damage_pwr = 5, deafen_pwr = 15)
	return 0
