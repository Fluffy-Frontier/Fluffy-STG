/datum/action/cooldown/spell/conjure_item/psyonic
	delete_old = FALSE
	delete_on_failure = TRUE
	requires_hands = TRUE
	// Сколько маны стоит кастануть спелл
	var/mana_cost = 10
	// Некоторые спеллы могут отнимать стамину
	var/stamina_cost = 0
	// Что написать жертве
	var/target_msg
	// Сила способности
	var/cast_power = 0
	// Вторичная школа. Может дать особые эффекты при комбинациях
	var/secondary_school = 0
	// Псионические способности (в основном) не блокируются, но выводят особенные сообщения тем, кто это может
	antimagic_flags = MAGIC_RESISTANCE_MIND
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS

/datum/action/cooldown/spell/conjure_item/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

// Проверяем достаточно ли маны
/datum/action/cooldown/spell/conjure_item/psyonic/proc/check_for_mana()
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		return TRUE
	else
		return FALSE

// Сосём ману у псионика
/datum/action/cooldown/spell/conjure_item/psyonic/proc/drain_mana(forced = FALSE)
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	caster.adjustStaminaLoss(stamina_cost, forced = TRUE)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		quirk_holder.mana_level -= mana_cost
		return TRUE
	else if (forced)
		quirk_holder.mana_level = 0
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/conjure_item/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

/datum/action/cooldown/spell/conjure_item/psyonic/cast(atom/cast_on)
	drain_mana()
	return ..()

// Для спеллов типа self
/datum/action/cooldown/spell/psyonic
	// Сколько маны стоит кастануть спелл
	var/mana_cost = 10
	// Некоторые спеллы могут отнимать стамину
	var/stamina_cost = 0
	// Сила способности
	var/cast_power = 0
	// Вторичная школа. Может дать особые эффекты при комбинациях
	var/secondary_school = 0
	// Псионические способности (в основном) не блокируются, но выводят особенные сообщения тем, кто это может
	antimagic_flags = MAGIC_RESISTANCE_MIND

	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS

/datum/action/cooldown/spell/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

// Проверяем достаточно ли маны
/datum/action/cooldown/spell/psyonic/proc/check_for_mana()
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		return TRUE
	else
		return FALSE

// Сосём ману у псионика
/datum/action/cooldown/spell/psyonic/proc/drain_mana(forced = FALSE)
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	caster.adjustStaminaLoss(stamina_cost, forced = TRUE)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		quirk_holder.mana_level -= mana_cost
		return TRUE
	else if (forced)
		quirk_holder.mana_level = 0
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

/datum/action/cooldown/spell/pointed/psyonic
	// Сколько маны стоит кастануть спелл
	var/mana_cost = 10
	// Некоторые спеллы могут отнимать стамину
	var/stamina_cost = 0
	// Что написать жертве
	var/target_msg
	// Сила способности
	var/cast_power = 0
	// Вторичная школа. Может дать особые эффекты при комбинациях
	var/secondary_school = 0
	// Псионические способности (в основном) не блокируются, но выводят особенные сообщения тем, кто это может
	antimagic_flags = MAGIC_RESISTANCE_MIND

	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE
	cooldown_reduction_per_rank = 0 SECONDS


/datum/action/cooldown/spell/pointed/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

// Проверяем достаточно ли маны
/datum/action/cooldown/spell/pointed/psyonic/proc/check_for_mana()
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		return TRUE
	else
		return FALSE

// Сосём ману у псионика
/datum/action/cooldown/spell/pointed/psyonic/proc/drain_mana(forced = FALSE)
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	caster.adjustStaminaLoss(stamina_cost, forced = TRUE)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		quirk_holder.mana_level -= mana_cost
		return TRUE
	else if (forced)
		quirk_holder.mana_level = 0
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/pointed/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

/datum/action/cooldown/spell/touch/psyonic
	// Сколько маны стоит кастануть спелл
	var/mana_cost = 10
	// Некоторые спеллы могут отнимать стамину
	var/stamina_cost = 0
	// Что написать жертве
	var/target_msg
	// Сила способности
	var/cast_power = 0
	// Вторичная школа. Может дать особые эффекты при комбинациях
	var/secondary_school = 0
	// Псионические способности (в основном) не блокируются, но выводят особенные сообщения тем, кто это может
	antimagic_flags = MAGIC_RESISTANCE_MIND

	school = SCHOOL_UNSET
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE


/datum/action/cooldown/spell/touch/psyonic/New(Target, power, additional_school)
	. = ..()
	cast_power = power
	secondary_school = additional_school

// Проверяем достаточно ли маны
/datum/action/cooldown/spell/touch/psyonic/proc/check_for_mana()
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		return TRUE
	else
		return FALSE

// Сосём ману у псионика
/datum/action/cooldown/spell/touch/psyonic/proc/drain_mana(forced = FALSE)
	var/mob/living/carbon/human/caster = owner
	var/datum/quirk/psyonic/quirk_holder = caster.get_quirk(/datum/quirk/psyonic)
	caster.adjustStaminaLoss(stamina_cost, forced = TRUE)
	if(quirk_holder && (quirk_holder.mana_level - mana_cost) >= 0)
		quirk_holder.mana_level -= mana_cost
		return TRUE
	else if (forced)
		quirk_holder.mana_level = 0
		return TRUE
	else
		return FALSE

/datum/action/cooldown/spell/touch/psyonic/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE

	if(!check_for_mana())
		return FALSE
	else
		return TRUE

/datum/action/cooldown/spell/touch/psyonic/create_hand(mob/living/carbon/cast_on)
	. = ..()
	if(!.)
		return .
	var/obj/item/bodypart/transfer_limb = cast_on.get_active_hand()
	if(IS_ROBOTIC_LIMB(transfer_limb))
		to_chat(cast_on, span_notice("You fail to channel your psyonic powers through your inorganic hand."))
		return FALSE

	return TRUE

/particles/droplets/psyonic
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = list("dot"=2,"drop"=1)
	width = 32
	height = 36
	count = 20
	spawning = 0.2
	lifespan = 1.5 SECONDS
	fade = 0.5 SECONDS
	color = "#00a2ff"
	position = generator(GEN_BOX, list(-9,-9,0), list(9,18,0), NORMAL_RAND)
	scale = generator(GEN_VECTOR, list(0.9,0.9), list(1.1,1.1), NORMAL_RAND)
	gravity = list(0, 0.95)

// Проверка на то, есть ли квирк псионики у хумана
/mob/living/carbon/human/proc/ispsyonic()
	if(has_quirk(/datum/quirk/psyonic))
		return TRUE
	return FALSE
