

/datum/uplink_item/ammo/pistolaps_traitor
	name = "9mm Stechkin APS Magazine"
	desc = "An additional 15-round 9mm magazine, compatible with the Stechkin APS machine pistol."
	item = /obj/item/ammo_box/magazine/m9mm_aps
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS
	cost = 2

/datum/uplink_item/ammo/smg_traitor
	name = ".45 SMG Magazine"
	desc = "An additional 24-round .45 magazine suitable for use with the C-20r submachine gun."
	item = /obj/item/ammo_box/magazine/smgm45
	cost = 2

/datum/uplink_item/ammo/smgap_traitor
	name = ".45 Armor Piercing SMG Magazine"
	desc = "An additional 24-round .45 magazine suitable for use with the C-20r submachine gun.\
			These rounds are less effective at injuring the target but penetrate protective gear."
	item = /obj/item/ammo_box/magazine/smgm45/ap
	cost = 3

/datum/uplink_item/ammo/smgfire_traitor
	name = ".45 Incendiary SMG Magazine"
	desc = "An additional 24-round .45 magazine suitable for use with the C-20r submachine gun.\
			Loaded with incendiary rounds which inflict little damage, but ignite the target."
	item = /obj/item/ammo_box/magazine/smgm45/incen
	cost = 3

/datum/uplink_item/ammo/smgempty_traitor
	name = "Empty .45 SMG Magazine"
	desc = "An additional, empty 24-round .45 magazine suitable for use with the C-20r submachine gun.\
			Ammunition not included."
	item = /obj/item/ammo_box/magazine/smgm45/empty
	cost = 1

/datum/uplink_item/ammo/shotgun/buck_traitor
	name = "12g Buckshot Drum"
	desc = "An additional 8-round buckshot magazine for use with the Bulldog shotgun. Front towards enemy."
	item = /obj/item/ammo_box/magazine/m12g
	cost = 1

/datum/uplink_item/ammo/shotgun/dragon_traitor
	name = "12g Dragon's Breath Drum"
	desc = "An alternative 8-round dragon's breath magazine for use in the Bulldog shotgun. \
			'I'm a fire starter, twisted fire starter!'"
	item = /obj/item/ammo_box/magazine/m12g/dragon
	cost = 3


/datum/uplink_item/ammo/shotgun/meteor_traitor
	name = "12g Meteorslug Shells"
	desc = "An alternative 8-round meteorslug magazine for use in the Bulldog shotgun. \
		Great for blasting airlocks off their frames and knocking down enemies."
	limited_stock = 1
	cost = 4
	item = /obj/item/ammo_box/magazine/m12g/meteor


/datum/uplink_item/ammo/shotgun/slug_traitor
	name = "12g Slug Drum"
	desc = "An additional 8-round slug magazine for use with the Bulldog shotgun. \
			Now 8 times less likely to shoot your pals."
	cost = 3
	item = /obj/item/ammo_box/magazine/m12g/slug


/datum/uplink_item/ammo/shotgun/empty_traitor
	name = "Empty 12g Drum"
	desc = "An empty 8-round magazine for use in the Bulldog shotgun. \
			Ammunition not included."
	cost = 1
	item = /obj/item/ammo_box/magazine/m12g/empty


/datum/uplink_item/ammo/pistolap
	name = "9mm Armour Piercing Magazine"
	desc = "An additional 8-round 9mm magazine, compatible with the Makarov pistol. \
			These rounds are less effective at injuring the target but penetrate protective gear."
	item = /obj/item/ammo_box/magazine/m9mm/ap
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS
	cost = 2

/datum/uplink_item/ammo/pistolhp
	name = "9mm Hollow Point Magazine"
	desc = "An additional 8-round 9mm magazine, compatible with the Makarov pistol. \
			These rounds are more damaging but ineffective against armour."
	item = /obj/item/ammo_box/magazine/m9mm/hp
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS
	cost = 2

/datum/uplink_item/ammo/pistolfire
	name = "9mm Incendiary Magazine"
	desc = "An additional 8-round 9mm magazine, compatible with the Makarov pistol. \
			Loaded with incendiary rounds which inflict little damage, but ignite the target."
	item = /obj/item/ammo_box/magazine/m9mm/fire
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS
	cost = 2

/datum/uplink_item/ammo/revolver
	name = ".357 Speed Loader"
	desc = "A speed loader that contains seven additional .357 Magnum rounds; usable with the Syndicate revolver. \
			For when you really need a lot of things dead."
	item = /obj/item/ammo_box/a357
	purchasable_from = ~(UPLINK_ALL_SYNDIE_OPS | UPLINK_SPY) //nukies get their own version
	uplink_item_flags = SYNDIE_TRIPS_CONTRABAND
	cost = 2
