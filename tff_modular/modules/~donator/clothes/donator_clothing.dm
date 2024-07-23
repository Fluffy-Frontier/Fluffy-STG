/obj/item/clothing/neck/cloak/officer
	name = "officer's coat"
	desc = "Officer's coat in RedSec colors with a big N on the back. The inside of the collar has a label with 'Cyrus' written on it."
	var/alternate_desc = "Officer's coat in Syndicate colors with a big S on the back. The inside of the collar has a label with 'Nova' written on it."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/cloaks.dmi'
	icon_state = "mercreaper_cloak_nt"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'
	unique_reskin = list(
		"Nanotrasen" = "mercreaper_cloak_nt",
		"Syndicate" = "mercreaper_cloak_syndie"
	)

/obj/item/clothing/neck/cloak/officer/reskin_obj(mob/M)
	. = ..()
	if(icon_state == "mercreaper_cloak_syndie")
		desc = alternate_desc

/obj/item/clothing/suit/hooded/wintercoat/specialops
	name = "security long jacket"
	desc = "Long jacket developed by \"Armadyne\" for security officers. There is a blue Armadyne logo on the back. Made from materials to retain heat and can be used down to -20 Celsius."

	icon = 'tff_modular/master_files/icons/donator/obj/clothing/suit.dmi'
	icon_state = "mercreapercoat_summer"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/suit.dmi'
	worn_icon_state = "mercreapercoat_summer"

	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
	slot_flags = ITEM_SLOT_OCLOTHING|ITEM_SLOT_NECK

	hoodtype = /obj/item/clothing/head/hooded/winterhood/specialops

/obj/item/clothing/suit/hooded/wintercoat/specialops/winter
	name = "security winter long jacket"
	desc = "Long jacket developed by \"Armadyne\" for security personnel working in harsh, low temperature conditions. There is a blue Armadyne logo on the back. Made from materials to retain heat and can be used down to -40 Celsius."

	icon_state = "mercreapercoat_winter"
	worn_icon_state = "mercreapercoat_winter"

	hoodtype = /obj/item/clothing/head/hooded/winterhood/specialops/winter

/obj/item/clothing/head/hooded/winterhood/specialops
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/head.dmi'
	worn_icon_state = "mercreaperhood_summer"

/obj/item/clothing/head/hooded/winterhood/specialops/winter
	worn_icon_state = "mercreaperhood_winter"

/obj/item/clothing/suit/teshari
	name = "teshari base"
	desc = "HOW YOU GET THIS?"
	icon = 'tff_modular/master_files/icons/donator/mob/clothing/suit.dmi'
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/suit.dmi'
	worn_icon_teshari = 'tff_modular/master_files/icons/donator/mob/clothing/suit.dmi'

/obj/item/clothing/suit/teshari/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(!is_species(equipper, /datum/species/teshari))
		to_chat(equipper, span_warning("[src] is far too small for you!"))
		return FALSE
	return ..()

/obj/item/clothing/under/teshari
	name = "teshari base"
	desc = "HOW YOU GET THIS?"
	icon = 'tff_modular/master_files/icons/donator/mob/clothing/under.dmi'
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/under.dmi'
	worn_icon_teshari = 'tff_modular/master_files/icons/donator/mob/clothing/under.dmi'

/obj/item/clothing/under/teshari/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(!is_species(equipper, /datum/species/teshari))
		to_chat(equipper, span_warning("[src] is far too small for you!"))
		return FALSE
	return ..()

/obj/item/clothing/suit/teshari/furcoat
	name = "tenka fabric coat"
	desc = "This is a small tenka fabric coat, with slits for wings. It’s visible that it was sewn for a small creature."
	icon_state = "zanozkin_furcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/labcoat
	name = "lab coat"
	desc = "This is a very long laboratory coat and it has slits for wings."
	icon_state = "zanozkin_labcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/labcoat/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/suit/teshari/graycoat
	name = "grey coat"
	desc = "This is a grey coat, it has hidden slits for wings, the material seems expensive and from a certain angle the bottom part seems transparent."
	icon_state = "zanozkin_strangeshirt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/jacket
	name = "black jacket FZ"
	desc = "This is a black jacket from an unknown company with hidden slits for wings."
	icon_state = "zanozkin_coldcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/jacket/noblue
	icon_state = "zanozkin_coldcoat_noblue"


/obj/item/clothing/suit/teshari/russian_jacket
	name = "russian raptor coat"
	desc = "This is a fucking Russian jacket for raptors."
	icon_state = "zanozkin_coat_korea"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/aqua_cloak // тут действительно в виде suit.
	name = "short shirt FZ"
	desc = "This is a short shirt from an unknown company for small winged creatures"
	icon_state = "zanozkin_aquacloak"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/teshari/aqua_cloak/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon)

/obj/item/clothing/under/teshari/consultant
	name = "crocs suit"
	desc = "Crocs clothes for little winged creatures!"
	icon_state = "zanozkin_consultant"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/consultant/female
	name = "crocs skirt"
	icon_state = "zanozkin_consultant_skirt"

/obj/item/clothing/under/teshari/nt_combineso
	name = "combeniso NT"
	desc = "This jumpsuit was custom-made for workers of the Avali race near their homeland."
	icon_state = "zanozkin_nt"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/meme
	name = "shirt and shorts"
	desc = "It's just a shirt and shorts, but it reminds me of something."
	icon_state = "zanozkin_meme"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/elite_suit
	name = "elite feathered"
	desc = "White shirt, black bow tie and beige pants. This suit doesn't look bad."
	icon_state = "zanozkin_elite"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/elite_suit/plus
	name = "elite feathered deluxe"
	desc = "White shirt, black bow tie, beige jacket and beige pants. This suit doesn't look bad"
	icon_state = "zanozkin_eliteplus"

/obj/item/clothing/under/teshari/waistcoat
	name = "delicate suit"
	desc = "Costume for winged pick-up artist."
	icon_state = "zanozkin_waistcoat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/teshari/mechsuit
	name = "rivka"
	desc = "Personalized suit, it seems it was made to order and given as a gift"
	icon_state = "zanozkin_mechsuit"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/neck/cloak/teshari/tenkacoat
	name = "small cloak"
	desc = "Just a small cloak... for avali?"
	icon = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'
	icon_state = "zanozkin_tenkacoat"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'
	worn_icon_teshari = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/neck/cloak/trenchcloak
	name = "senior commander's trenchcloak"
	desc = "Dark trenchcloak made to order for senior officers. Consists of really strong leather and armored fabric. The inside of the collar has a label with ''V'' written on it."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/cloaks.dmi'
	icon_state = "romontesque_cloak"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'

/obj/item/clothing/neck/cloak/tendercloak
	name = "bayou old mantle"
	desc = "This is a very shabby (and time-worn) cape, it smells funny of silt."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/cloaks.dmi'
	icon_state = "ten_neck"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'

/obj/item/clothing/neck/cloak/eldercoat
	name = "hunter's cloak"
	desc = "Just part of hunter's coat."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/cloaks.dmi'
	icon_state = "eldercoat"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/neck.dmi'
	resistance_flags = FIRE_PROOF

/obj/item/clothing/under/cloaked
	var/cloaktype
	var/alternative_mode = FALSE
	var/cloak_up_suffix = "_t"
	var/cloak_down_suffix = ""
	var/obj/item/clothing/neck/cloak/cloak

/obj/item/clothing/under/cloaked/Initialize(mapload)
	. = ..()
	if (!cloaktype)
		return
	AddComponent(\
		/datum/component/toggle_attached_clothing/left_side_cloak,\
		deployable_type = cloaktype,\
		equipped_slot = ITEM_SLOT_NECK,\
		action_name = "Toggle Cloak",\
		destroy_on_removal = alternative_mode,\
		parent_icon_state_suffix = cloak_up_suffix,\
		down_overlay_state_suffix = cloak_down_suffix,\
		deployable_icon_up_state_suffix = cloak_up_suffix,\
		deployable_icon_down_state_suffix = cloak_down_suffix,\
		pre_creation_check = CALLBACK(src, PROC_REF(can_create_cloak)),\
		on_created = CALLBACK(src, PROC_REF(on_cloak_created)),\
		on_deployed = CALLBACK(src, PROC_REF(on_cloak_up)),\
		on_removed = CALLBACK(src, PROC_REF(on_cloak_removed)),\
	)

/obj/item/clothing/under/cloaked/Destroy()
	cloak = null
	return ..()

/obj/item/clothing/under/cloaked/proc/can_create_cloak()
	return TRUE

/obj/item/clothing/under/cloaked/proc/on_cloak_created(obj/item/clothing/neck/cloak)
	SHOULD_CALL_PARENT(TRUE)
	src.cloak = cloak
	RegisterSignal(cloak, COMSIG_QDELETING, PROC_REF(on_cloak_deleted))

/obj/item/clothing/under/cloaked/proc/on_cloak_deleted()
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	cloak = null

/obj/item/clothing/under/cloaked/proc/on_cloak_up(obj/item/clothing/neck/cloak)
	return

/obj/item/clothing/under/cloaked/proc/on_cloak_removed(obj/item/clothing/neck/cloak)
	return

/obj/item/clothing/under/cloaked/eldercoat
	cloaktype = /obj/item/clothing/neck/cloak/eldercoat
	name = "hunter's uniform"
	desc = "Old-fashioned robes with a patterned pattern all over the clothes and a cape hanging from the left shoulder."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/under.dmi'
	icon_state = "eldercoat"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/under.dmi'
	resistance_flags = FIRE_PROOF

/obj/item/clothing/shoes/eldercoat
	name = "leather boots"
	desc = "Old-fashioned leather boots in a dark shade"
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/shoes.dmi'
	icon_state = "eldercoat"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/shoes.dmi'
	resistance_flags = FIRE_PROOF

/obj/item/clothing/gloves/eldercoat
	name = "leather gloves"
	desc = "Elongated leather gloves of an old-fashioned kind."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/gloves.dmi'
	icon_state = "eldercoat"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/gloves.dmi'
	resistance_flags = FIRE_PROOF

/obj/item/clothing/head/eldercoat
	name = "three-cornered hat"
	desc = "A pointed leather hat in a dark shade with a protruding feather."
	icon = 'tff_modular/master_files/icons/donator/obj/clothing/head.dmi'
	icon_state = "eldercoat"
	worn_icon = 'tff_modular/master_files/icons/donator/mob/clothing/head.dmi'
	resistance_flags = FIRE_PROOF
