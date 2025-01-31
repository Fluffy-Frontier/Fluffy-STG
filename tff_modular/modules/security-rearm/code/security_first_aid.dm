/obj/item/storage/medkit/tac_security
	name = "security emergency medkit"
	desc = "Standard-issue medical kit issued to NanoTrasen security operatives. Contains first-aid supplies meant to keep an officer alive until proper medical staff can take over."
	icon = 'modular_nova/modules/deforest_medical_items/icons/storage.dmi'
	icon_state = "frontier"
	lefthand_file = 'modular_nova/modules/deforest_medical_items/icons/inhands/cases_lefthand.dmi'
	righthand_file = 'modular_nova/modules/deforest_medical_items/icons/inhands/cases_righthand.dmi'
	inhand_icon_state = "frontier"
	worn_icon_state = "frontier"
	worn_icon = 'modular_nova/modules/deforest_medical_items/icons/worn/worn.dmi'
	worn_icon_teshari = 'modular_nova/modules/deforest_medical_items/icons/worn/worn_teshari.dmi'

/obj/item/storage/medkit/tac_security/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL //holds the same equipment as a medibelt
	atom_storage.max_slots = 6
	atom_storage.max_total_storage = 12
	atom_storage.set_holdable(list_of_everything_medkits_can_hold)

/obj/item/storage/medkit/tac_security/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/stack/medical/gauze = 1,
		/obj/item/stack/medical/suture = 1,
		/obj/item/stack/medical/mesh = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/reagent_containers/hypospray/medipen/deforest/coagulants = 1,
	)
	generate_items_inside(items_inside,src)
