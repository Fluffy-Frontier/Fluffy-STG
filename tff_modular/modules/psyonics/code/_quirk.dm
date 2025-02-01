#define TRAIT_PSYONIC_USER "psyonicuser"
#define TRAIT_NO_PSYONICS "no_psyonics"
#define TRAIT_PRO_PSYONICS "pro_psyonics"

#define LATENT_PSYONIC 0
#define OPERANT_PSYONIC 1
#define MASTER_PSYONIC 2
#define GRANDMASTER_PSYONIC 3
#define PARAMOUNT_PSYONIC 4
#define GREATEST_PSYONIC 5

GLOBAL_LIST_INIT(psyonic_schools, list(
	"Redaction",
	"Coercion",
	"Psychokinesis",
	"Energistics",
))

/datum/quirk/psyonic
	name = "Psyonic Abilities"
	desc = "Either you were born like this or gained powers from implants/training or other events - you are a psyonic. \
			Your mind can access the world that lies beyond our mortal plane. One day voices from within had pierced your skull \
			like a tide wave turns a sailboat over in open sea, but you withstanded it and received abilities your father haven't \
			even dreamed of. From now on a special type of energy is stored in your mind, body and soul and you have control over it. \
			Every psyonic is a follower of a certain school: \
			Redaction - school of mending and curing bodies and souls; \
			Coercion - school of trickery and controlling others; \
			Psychokinesis - school of object manipulation; \
			Energistics - school of elecricity, fire and light; \
			You can select the school, but it's power will be randomised every round."
	value = 12 // Отдадите за псионику жопу, чтобы потом вам Рэнди Рандом всегда слал наименьший уровень силы
	medical_record_text = "Patient possesses connection to an another plain of reality."
	quirk_flags = QUIRK_HIDE_FROM_SCAN|QUIRK_HUMAN_ONLY|QUIRK_PROCESSES // Сканеры не видят псиоников. Только псионик школы принуждения может точно определить, является ли живое существо псиоником
	gain_text = span_cyan("You mind feels uneasy, but... so powerful.")
	lose_text = span_warning("You lost something, that kept your connection with other realms.")
	icon = "fa-star"
	mob_trait = TRAIT_PSYONIC_USER
	veteran_only = TRUE
	allow_for_donator = TRUE
	// Текущий уровень маны
	var/mana_level = 0
	// Максимально возможный уровень маны
	var/max_mana = 10
	// Уровень псионических способностей
	var/psyonic_level = 0
	// Строка для описания уровня
	var/psyonic_level_string = "Latent"
	// Первичная школа псионики
	var/school
	// Вторичная школа псионики
	var/secondary_school
	/// Два вара скопированные из item_quirk для правильной выдачи лицензии
	var/list/where_items_spawned
	var/open_backpack = FALSE

/datum/quirk/psyonic/add(client/client_source)
	school = client_source?.prefs?.read_preference(/datum/preference/choiced/psyonic_school)
	if(!school)
		school = pick(GLOB.psyonic_schools)
	secondary_school = client_source?.prefs?.read_preference(/datum/preference/choiced/psyonic_school_secondary)
	if(!secondary_school)
		secondary_school = pick(GLOB.psyonic_schools)
	var/mob/living/carbon/human/whom_to_give = quirk_holder
	var/fluff_1 = rand(0,1)
	var/fluff_2 = rand(0,1)
	var/fluff_3 = rand(0,1)
	var/fluff_4 = rand(0,1)
	psyonic_level = fluff_1 + fluff_2 + fluff_3 + fluff_4
	if(HAS_MIND_TRAIT(whom_to_give, TRAIT_MADNESS_IMMUNE)) // A.K.A. Психолог
		psyonic_level += rand(0,1) // _возможное_ доп очко
	switch(psyonic_level)
		if(LATENT_PSYONIC)
			psyonic_level_string = "Pi"
		if(OPERANT_PSYONIC)
			psyonic_level_string = "Omicron"
		if(MASTER_PSYONIC)
			psyonic_level_string = "Kappa"
		if(GRANDMASTER_PSYONIC)
			psyonic_level_string = "Lambda"
		if(PARAMOUNT_PSYONIC)
			psyonic_level_string = "Theta"
		if(GREATEST_PSYONIC) // Дозволен только особо везучим психологам, у которых все предыдущие пять рандомов вышли на 1
			psyonic_level_string = "Epsilon"
	max_mana = (psyonic_level + 1) * 20 // Минимальный - 20, максимальный - 100
	RegisterSignal(quirk_holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS, PROC_REF(get_status_tab_item))
	if(school == secondary_school)
		psyonic_level += 1 // Если вторичка совпадает с первой - добавляем один уровень, но не меняем описание
	switch(school)
		if("Redaction")
			whom_to_give.try_add_redaction_school(psyonic_level, secondary_school)
		if("Coercion")
			whom_to_give.try_add_coercion_school(psyonic_level, secondary_school)
		if("Psychokinesis")
			whom_to_give.try_add_psychokinesis_school(psyonic_level, secondary_school)
		if("Energistics")
			whom_to_give.try_add_energistics_school(psyonic_level, secondary_school)

	if(secondary_school != school) // Если школы разные, добавить способность нулевого уровня вторичной школы
		switch(secondary_school)
			if("Redaction")
				whom_to_give.try_add_redaction_school(0, 0)
			if("Coercion")
				whom_to_give.try_add_coercion_school(0, 0)
			if("Psychokinesis")
				whom_to_give.try_add_psychokinesis_school(0, 0)
			if("Energistics")
				whom_to_give.try_add_energistics_school(0, 0)

	var/fluff_text = span_cyan("Current psionic factors:") + "<br>" + \
					 "[fluff_1 ? "Current star position is aligned to your soul." : "The stars do not precede luck to you."]" + "<br>" + \
					 "[fluff_2 ? "Other realms are unusually active this shift." : "Other realms are quiet today."]" + "<br>" + \
					 "[fluff_3 ? "Time-bluespace continuum seems to be stable today." : "Time-bluespace continuum is not giving you energy today."]" + "<br>" + \
					 "[fluff_4 ? "Your mind is clearly open to otherwordly energy." : "Something clouds your connection to otherworld energy."]"
	to_chat(quirk_holder, boxed_message(span_infoplain(jointext(fluff_text, "\n&bull; "))))
	psyonic_level -= 1 // Обязаловка, иначе выдаст спеллы которые нельзя кастануть

	var/obj/item/card/psyonic_license/new_license = new(whom_to_give)

	give_item_to_holder(new_license, list(LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS), flavour_text = "Make sure not to lose it. You can not remake this on the station.")

/datum/quirk/psyonic/proc/give_item_to_holder(obj/item/quirk_item, list/valid_slots, flavour_text = null, default_location = "at your feet", notify_player = TRUE)
	if(ispath(quirk_item))
		quirk_item = new quirk_item(get_turf(quirk_holder))

	var/mob/living/carbon/human/human_holder = quirk_holder

	var/where = human_holder.equip_in_one_of_slots(quirk_item, valid_slots, qdel_on_fail = FALSE, indirect_action = TRUE) || default_location

	if(where == LOCATION_BACKPACK)
		open_backpack = TRUE

	if(notify_player)
		LAZYADD(where_items_spawned, span_boldnotice("You have \a [quirk_item] [where]. [flavour_text]"))

/datum/quirk/psyonic/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_GET_STATUS_TAB_ITEMS)

// Показывает текущее кол-во псионической энергии
/datum/quirk/psyonic/proc/get_status_tab_item(mob/living/source, list/items)
	SIGNAL_HANDLER

	items += "Psyonic School: [school]"
	items += "Secondary School: [secondary_school]"
	items += "Psyonic Tier: [psyonic_level_string]"
	items += "Current psyonic energy: [mana_level]/[max_mana]"

/datum/quirk/psyonic/process(seconds_per_tick)
	if(HAS_TRAIT(quirk_holder, TRAIT_NO_PSYONICS)) // Имплант подавления регена
		return

	if(HAS_TRAIT(quirk_holder, TRAIT_MINDSHIELD)) // Womp womp
		return

	var/additional_mana = 1
	if(quirk_holder.has_status_effect(/datum/status_effect/drugginess)) // Наркота даёт бафф к генерации маны
		additional_mana *= 1.5

	if(HAS_TRAIT(quirk_holder, TRAIT_PRO_PSYONICS)) // Если есть имплант для увеличения регена маны
		additional_mana *= 2

	if(mana_level <= max_mana)
		mana_level += seconds_per_tick * 0.5 * additional_mana
	mana_level = clamp(mana_level, 0, max_mana)

/datum/quirk_constant_data/psyonic_school
	associated_typepath = /datum/quirk/psyonic
	customization_options = list(/datum/preference/choiced/psyonic_school, /datum/preference/choiced/psyonic_school_secondary)

/datum/preference/choiced/psyonic_school
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "psyonic_school"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/psyonic_school/create_default_value()
	return "Redaction"

/datum/preference/choiced/psyonic_school/init_possible_values()
	return GLOB.psyonic_schools

/datum/preference/choiced/psyonic_school/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Psyonic Abilities" in preferences.all_quirks

/datum/preference/choiced/psyonic_school/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/psyonic_school_secondary
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "psyonic_school_secondary"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/psyonic_school_secondary/create_default_value()
	return "Redaction"

/datum/preference/choiced/psyonic_school_secondary/init_possible_values()
	return GLOB.psyonic_schools

/datum/preference/choiced/psyonic_school_secondary/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return "Psyonic Abilities" in preferences.all_quirks

/datum/preference/choiced/psyonic_school_secondary/apply_to_human(mob/living/carbon/human/target, value)
	return

#undef LATENT_PSYONIC
#undef OPERANT_PSYONIC
#undef MASTER_PSYONIC
#undef GRANDMASTER_PSYONIC
#undef PARAMOUNT_PSYONIC
