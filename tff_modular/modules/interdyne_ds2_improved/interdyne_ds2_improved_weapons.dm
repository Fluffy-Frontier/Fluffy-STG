/obj/item/gun/ballistic/automatic/wt550/evil
	name = "\improper C-20A carabine"
	desc = "A lightweight, fully automatic variant of C-20r SMG designed for planetary combat. Uses 4.6x30mm rounds."
	pin = /obj/item/firing_pin/implant/pindicate
	fire_sound = 'modular_nova/modules/modular_weapons/sounds/rifle_heavy.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/wt550m9/evil
	fire_sound_volume = 70
	icon_state = "c20r"
	inhand_icon_state = "c20r"
	recoil = 0.2

//Рескин магазина от WT, чтобы КРАСИВО
/obj/item/ammo_box/magazine/wt550m9/evil
	name = "\improper C-20A magazine (4.6x30mm)"
	desc = "A standard-issue C-20r magazine casing, redesigned for smaller 4.6x30mm bullets. Can be used with the C-20A carabine."
	icon_state = "c20r45"
	base_icon_state = "c20r45"
	ammo_band_icon = "+c20rab"
	ammo_band_color = null

/obj/item/ammo_box/magazine/wt550m9/evil/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[round(ammo_count(), 2)]"

//На Дюне и ДС-2 такие магазины найти невозможно, добавляем на случай щитспавна от педалей
/obj/item/ammo_box/magazine/wt550m9/evil/wtap
	name = "\improper C-20A magazine (4.6x30mm AP)"
	MAGAZINE_TYPE_ARMORPIERCE
	ammo_type = /obj/item/ammo_casing/c46x30mm/ap

/obj/item/ammo_box/magazine/wt550m9/evil/wtic
	name = "\improper C-20A magazine (4.6x30mm incendiary)"
	MAGAZINE_TYPE_INCENDIARY
	ammo_type = /obj/item/ammo_casing/c46x30mm/inc

/obj/item/gun/ballistic/shotgun/riot/sol/evil/special
	name = "\improper Krait Shotgun"
	desc = "A simplified variant of the SolFed Renoster Shotgun designed by Gorlex Marauders. While cheaper in production, it does come with worse ergonimics and greater recoil."
	recoil = 1
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/riot/evil_special

/obj/item/ammo_box/magazine/internal/shot/riot/evil_special
	ammo_type = /obj/item/ammo_casing/shotgun/hunter

/obj/item/gun/ballistic/shotgun/riot/sol/evil/special/give_manufacturer_examine()
	AddElement(/datum/element/manufacturer_examine, COMPANY_REMOVED)

// делаем ящик
/obj/item/storage/toolbox/guncase/interdyne
	name = "Special gun case"
	desc = "A weapon's case. Has a blood-red 'S' stamped on the cover."

/obj/item/storage/toolbox/guncase/interdyne/wt550/PopulateContents()
	new /obj/item/gun/ballistic/automatic/wt550/evil(src)
	new /obj/item/ammo_box/magazine/wt550m9/evil(src)
	new /obj/item/ammo_box/magazine/wt550m9/evil(src)

// Делаем есворд для офицера
/obj/item/melee/energy/sword/saber/green/dyne
	name = "Officer energy sword"
	desc = "“When death comes for me, I will look it right in the eye” - reads the inscription on the hilt."
