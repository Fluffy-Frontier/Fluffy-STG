//FF addition to code\modules\uplink\uplink_items\dangerous.dm
/datum/uplink_item/dangerous/pistol
	name = "Makarov Pistol Case"
	desc = "A weapon case containing an unknown variant of the Makarov pistol, along with two spare magazines and a box of loose 9mm ammunition. \
		Chambered in 9mm. Perfect for frequent skirmishes with security, as well as ensuring you have enough firepower to outlast the competition. \
		While not included in the kit, the pistol is compatible with suppressors, which can be purchased seperately."
	item = /obj/item/storage/toolbox/guncase/traitor
	cost = 5
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/dangerous/aps_traitor
	name = "Stechkin APS Machine Pistol"
	desc = "An ancient Soviet machine pistol, refurbished for the modern age. Uses 9mm auto rounds in 15-round magazines and is compatible \
			with suppressors. The gun fires in three round bursts."
	item = /obj/item/gun/ballistic/automatic/pistol/aps
	cost = 7
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/dangerous/revolver
	name = "Syndicate Revolver"
	desc = "A brutally simple Syndicate revolver that fires .357 Magnum rounds and has 7 chambers."
	item = /obj/item/gun/ballistic/revolver
	cost = 10
	surplus = 50
	purchasable_from = ~UPLINK_ALL_SYNDIE_OPS //only traitors get the original revolver


/datum/uplink_item/dangerous/smgc20r_traitor
	name = "C-20r Submachine Gun"
	desc = "A fully-loaded Scarborough Arms bullpup submachine gun. The C-20r fires .45 rounds with a \
			24-round magazine and is compatible with suppressors."
	item = /obj/item/gun/ballistic/automatic/c20r/unrestricted
	cost = 12
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)

/datum/uplink_item/dangerous/shotgun_traitor
	name = "Bulldog Shotgun"
	desc = "A fully-loaded semi-automatic drum-fed shotgun. Compatible with all 12g rounds. Designed for close \
			quarter anti-personnel engagements."
	item = /obj/item/gun/ballistic/shotgun/bulldog/unrestricted
	cost = 12
	purchasable_from = ~(UPLINK_NUKE_OPS | UPLINK_CLOWN_OPS)
