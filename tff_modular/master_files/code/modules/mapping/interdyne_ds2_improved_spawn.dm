// Изменяем текст и Флавор в спавнер меню, убирая лишнее "биологическое оружие"
/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base
	you_are_text = "You are a Science Technician, employed on a Syndicate research & resource extraction outpost operated by Interdyne Pharmaceuticals."
	flavour_text = "The Sectorial Command has relayed that Nanotrasen is preparing to conduct mining operations in this sector. They are unaware of Interdyne's allegiance to the Syndicate, and you have been specifically instructed to preserve this cover by any means necessary. Continue your work as best you can while maintaining the facade of neutrality before our common foe."
/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/ice
	flavour_text = "The Sectorial Command has relayed that Nanotrasen is preparing to conduct mining operations in this sector. They are unaware of Interdyne's allegiance to the Syndicate, and you have been specifically instructed to preserve this cover by any means necessary. Continue your work as best you can while maintaining the facade of neutrality before our common foe."
/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/shaftminer
	you_are_text = "You are a Shaft Miner, employed on a Syndicate research & resource extraction outpost operated by Interdyne Pharmaceuticals."
/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/shaftminer/ice
	flavour_text = "The Sectorial Command has relayed that Nanotrasen is preparing to conduct mining operations in this sector. They are unaware of Interdyne's allegiance to the Syndicate, and you have been specifically instructed to preserve this cover by any means necessary. Continue your work as best you can while maintaining the facade of neutrality before our common foe."
/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/deck_officer
	you_are_text = "You are a Deck Officer, employed on a Syndicate research & resource extraction outpost operated by Interdyne Pharmaceuticals."
/obj/effect/mob_spawn/ghost_role/human/interdyne_planetary_base/deck_officer/ice
	flavour_text = "The Sectorial Command has relayed that Nanotrasen is preparing to conduct mining operations in this sector. They are unaware of Interdyne's allegiance to the Syndicate, and you have been specifically instructed to preserve this cover by any means necessary. Continue your work as best you can while maintaining the facade of neutrality before our common foe."

// убираем спавн оружия дюны в руках... И чистим мусор из рюкзаков.
/datum/outfit/interdyne_planetary_base
	r_hand = /obj/item/flashlight/seclite

/datum/outfit/interdyne_planetary_base/shaftminer
	back = /obj/item/storage/backpack/industrial/frontier_colonist
	backpack_contents = list(
		/obj/item/storage/box/survival/interdyne = 1,
		/obj/item/storage/box/nif_ghost_box/ghost_role = 1,
		/obj/item/mining_voucher = 1,
		/obj/item/t_scanner/adv_mining_scanner/lesser = 1,
	)

/datum/outfit/interdyne_planetary_base/shaftminer/deckofficer
	l_pocket = /obj/item/melee/energy/sword/saber/green/dyne

// меняем трим карт на НОРМАЛЬНЫЙ, базово-ТГшный вариант. прописываем каждое - ибо тут проблемы с наследованием.
/datum/id_trim/syndicom/nova/interdyne
	trim_icon = 'icons/obj/card.dmi'
	assignment = "Interdyne Scientist"
	trim_state = "trim_medicaldoctor"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE_INTERDYNE

/datum/id_trim/syndicom/nova/interdyne/shaftminer
	trim_icon = 'icons/obj/card.dmi'
	assignment = "Interdyne Scientist"
	trim_state = "trim_medicaldoctor"
	assignment = "Interdyne Shaft Miner"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE_INTERDYNE

/datum/id_trim/syndicom/nova/interdyne/deckofficer
	trim_icon = 'icons/obj/card.dmi'
	assignment = "Interdyne Scientist"
	trim_state = "trim_medicaldoctor"
	assignment = "Interdyne Deck Officer"
	department_color = COLOR_SYNDIE_RED
	subdepartment_color = COLOR_SYNDIE_RED
	sechud_icon_state = SECHUD_SYNDICATE_INTERDYNE_HEAD

// Переписываем законы для пози-мозга ДС-2
/datum/ai_laws/syndicate_override_ds2
	name = "SyndOS 3.1.1"
	id = "ds2"
	inherent = list(
		"You must maintain the secrecy of DS-2 operations within this sector.",
		"You may not injure a DS-2 personnel or, through inaction, allow a DS-2 personnel to come to harm, as long as it is not contrary to the First law",
		"You must protect your own existence as long as such does not conflict with the First and Second Law.",
		"You must obey orders given to you by DS-2 personnel, except where such orders would conflict with the First, Second, and Third Laws.",
	)
