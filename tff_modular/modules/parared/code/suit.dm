/obj/item/clothing/suit/toggle/labcoat/para_red
	icon = 'tff_modular/modules/parared/suit.dmi'
	worn_icon = 'tff_modular/modules/parared/suit.dmi'
	name = "red paramedic labcoat"
	desc = "A red vest with reflective strips for First Responsers."
	icon_state = "labcoat_pmedred"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/para_red/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/storage/medkit,
	)

/datum/loadout_item/suit/labcoat_parared
	name = "Red Paramedic Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/para_red
	restricted_roles = list(JOB_CHIEF_MEDICAL_OFFICER, JOB_PARAMEDIC, JOB_SECURITY_MEDIC)
