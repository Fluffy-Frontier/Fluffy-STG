/obj/machinery/vending/wardrobe/sec_wardrobe
	desc = "An Armadyne peacekeeper equipment vendor."
	name = "\improper MultiSec Peacekeeper Outfitting Station"
	icon = 'tff_modular/modules/redsec/icons/vending.dmi'
	icon_state = "secdrobe"
	product_ads = "Beat perps in style!;It's red so you can't see the blood!;You have the right to be fashionable!;Now you can be the fashion police you always wanted to be!"
	product_categories = list(
		list(
			"name" = "RedSec",
			"icon" = "hat-cowboy",
			"products" = list(
				/obj/item/clothing/suit/hooded/wintercoat/security/redsec = 5,
				/obj/item/storage/belt/security/redsec = 5,
				/obj/item/storage/backpack/security/redsec = 5,
				/obj/item/storage/backpack/satchel/sec/redsec = 5,
				/obj/item/storage/backpack/duffelbag/sec/redsec = 5,
				/obj/item/clothing/under/rank/security/officer/redsec = 5,
				/obj/item/clothing/shoes/jackboots/sec/redsec = 5,
				/obj/item/clothing/head/beret/sec = 5,
				/obj/item/clothing/head/soft/sec = 5,
				/obj/item/clothing/mask/bandana/red = 5,
				/obj/item/clothing/glasses/hud/security/redsec = 5,
				/obj/item/clothing/gloves/color/black = 5,
				/obj/item/clothing/under/rank/security/officer/skirt/redsec = 5,
				/obj/item/clothing/under/rank/security/nova/utility/redsec = 5,
				/obj/item/clothing/suit/toggle/jacket/sec/old = 5,
				/obj/item/clothing/suit/armor/vest/alt/sec/redsec = 2,
				/obj/item/storage/backpack/waistbag/redsec = 3,
				/obj/item/clothing/suit/armor/vest/alt/caftan = 3,
				/obj/item/clothing/head/berendeyka = 3,
			),
		),
		list(
			"name" = "BlueSec",
			"icon" = "user-tie",
			"products" = list(
				/obj/item/clothing/suit/hooded/wintercoat/security = 5,
				/obj/item/clothing/suit/toggle/jacket/sec/blue = 5,
				/obj/item/clothing/suit/toggle/jacket/sec/bluewinter = 5,
				/obj/item/clothing/suit/toggle/jacket/sec = 5,
				/obj/item/clothing/suit/armor/vest/peacekeeper/brit = 5,
				/obj/item/clothing/neck/security_cape = 5,
				/obj/item/clothing/neck/security_cape/armplate = 5,
				/obj/item/storage/backpack/security = 5,
				/obj/item/storage/backpack/satchel/sec = 5,
				/obj/item/storage/backpack/messenger/sec = 5,
				/obj/item/storage/backpack/duffelbag/sec = 5,
				/obj/item/clothing/under/rank/security/officer = 10,
				/obj/item/clothing/under/rank/security/officer/skirt = 10,
				/obj/item/clothing/under/rank/security/peacekeeper/plain_skirt = 10,
				/obj/item/clothing/under/rank/security/peacekeeper = 10,
				/obj/item/clothing/under/rank/security/nova/utility = 3,
				/obj/item/clothing/shoes/jackboots/sec = 10,
				/obj/item/clothing/head/security_garrison = 10,
				/obj/item/clothing/head/security_cap = 10,
				/obj/item/clothing/head/beret/sec/peacekeeper = 5,
				/obj/item/clothing/head/helmet/sec/sol = 5,
				/obj/item/clothing/head/hats/warden/police/patrol = 5,
				/obj/item/clothing/head/costume/ushanka/sec = 10,
				/obj/item/clothing/gloves/color/black/security = 10,
				/obj/item/storage/backpack/waistbag/bluesec = 3,
			),
		),
	)
	premium = list( /obj/item/clothing/accessory/cqd_holster = 5,
					/obj/item/clothing/under/rank/security/officer/formal = 5,
					/obj/item/clothing/suit/jacket/officer/tan = 5,
					/obj/item/clothing/suit/jacket/officer/blue = 3,
					/obj/item/clothing/head/beret/sec/navyofficer = 5,
					/obj/item/clothing/glasses/hud/security/sunglasses = 3,
					/obj/item/clothing/glasses/hud/security/sunglasses/redsec = 3,
					/obj/item/clothing/glasses/hud/security/sunglasses/peacekeeper = 3,
					/obj/item/clothing/glasses/hud/security/sunglasses/peacekeeper/armadyne = 3,
					/obj/item/storage/box/holobadge = 1,
					/obj/item/berdish_kit = 3,
	)
	light_color = "#abadcc"
	vend_reply = "Beat these scumbags!"
	default_price = PAYCHECK_CREW
	extra_price = PAYCHECK_COMMAND * 1.5
	payment_department = ACCOUNT_SEC

/obj/item/clothing/under/rank/security/officer/skirt/redsec // крысы переобозначением целиком убили редсек юбочку. Возвращаем.
	name = "security skirt"
	desc = "A \"tactical\" security uniform with the legs replaced by a skirt."
	icon_state = "secskirt"
	inhand_icon_state = "r_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	uses_advanced_reskins = FALSE
