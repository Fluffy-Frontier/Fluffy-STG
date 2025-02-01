/obj/item/melee/baton/security/berdish
	name = "gendarme baton"
	desc = "A long axe for beating criminal scum."
	desc_controls = "Left click to stun, right click to harm. It seems to bring huge snakes."
	icon = 'tff_modular/modules/security-rearm/icons/obj/berdish.dmi'
	worn_icon = 'tff_modular/modules/security-rearm/icons/mob/berdish_back.dmi'
	icon_state = "berdish"
	base_icon_state = "berdish"
	inhand_icon_state = "berdish"
	worn_icon_state = "berdish"
	icon_angle = -90
	lefthand_file = 'tff_modular/modules/security-rearm/icons/mob/berdish_lefthand.dmi'
	righthand_file = 'tff_modular/modules/security-rearm/icons/mob/berdish_righthand.dmi'
	SET_BASE_PIXEL(-8, 0)

/obj/item/melee/baton/security/berdish/loaded //this one starts with a cell pre-installed.
	preload_cell_type = /obj/item/stock_parts/power_store/cell/high

/obj/item/berdish_kit
	name = "chudo-yudo kit"
	desc = "A strange box containing wood working tools and an instruction paper to turn stun batons into something else."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "alienbox"
	custom_price = PAYCHECK_COMMAND * 4.5

/datum/crafting_recipe/berdish
	name = "Berdish"
	result = /obj/item/melee/baton/security/berdish
	reqs = list(
		/obj/item/melee/baton/security = 1,
		/obj/item/berdish_kit = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	time = 5 SECONDS
	category = CAT_WEAPON_MELEE
