/obj/machinery/medipen_refiller
	name = "Medipen Refiller"
	desc = "A machine that refills used medipens with chemicals."
	icon = 'icons/obj/machines/medipen_refiller.dmi'
	icon_state = "medipen_refiller"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/medipen_refiller

	///List of medipen subtypes it can refill and the chems needed for it to work.
	var/static/list/allowed_pens = list(
		/obj/item/reagent_containers/hypospray/medipen = /datum/reagent/medicine/epinephrine,
		/obj/item/reagent_containers/hypospray/medipen/atropine = /datum/reagent/medicine/atropine,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = /datum/reagent/medicine/salbutamol,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = /datum/reagent/medicine/oxandrolone,
		/obj/item/reagent_containers/hypospray/medipen/salacid = /datum/reagent/medicine/sal_acid,
		/obj/item/reagent_containers/hypospray/medipen/penacid = /datum/reagent/medicine/pen_acid,
		/obj/item/reagent_containers/hypospray/medipen/mutadone = /datum/reagent/medicine/mutadone,
		/obj/item/reagent_containers/hypospray/medipen/methamphetamine = /datum/reagent/drug/methamphetamine,
		/obj/item/reagent_containers/hypospray/medipen/survival = /datum/reagent/medicine/c2/libital,
		/obj/item/reagent_containers/hypospray/medipen/survival/luxury = /datum/reagent/medicine/c2/penthrite,
		/obj/item/reagent_containers/hypospray/medipen/invisibility = /datum/reagent/drug/saturnx,
		// NOVA EDIT BEGIN - Universal medipen and lathe medipens
		/obj/item/reagent_containers/hypospray/medipen/universal = null,
		/obj/item/reagent_containers/hypospray/medipen/universal/lowpressure = null,
		/obj/item/reagent_containers/hypospray/medipen/empty = /datum/reagent/medicine/epinephrine,
		/obj/item/reagent_containers/hypospray/medipen/atropine/empty = /datum/reagent/medicine/atropine,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol/empty = /datum/reagent/medicine/salbutamol,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone/empty = /datum/reagent/medicine/oxandrolone,
		/obj/item/reagent_containers/hypospray/medipen/salacid/empty = /datum/reagent/medicine/sal_acid,
		/obj/item/reagent_containers/hypospray/medipen/penacid/empty = /datum/reagent/medicine/pen_acid,
		// NOVA EDIT END
	)

	// NOVA EDIT BEGIN - Universal medipen
	///List containing chemicals which custom medipens can contain.
	var/static/list/allowed_pen_medicine = list(
		/datum/reagent/medicine,
		/datum/reagent/vaccine,
	)
	///Blacklist containing chemicals which custom medipens can't contain.
	var/static/list/disallowed_pen_medicine = list(
		/datum/reagent/inverse,
		/datum/reagent/medicine/morphine,
	)
	// NOVA EDIT END

/obj/machinery/medipen_refiller/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand)
	register_context()
	CheckParts()

/obj/machinery/medipen_refiller/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(held_item)
		if(held_item.tool_behaviour == TOOL_WRENCH)
			context[SCREENTIP_CONTEXT_LMB] = anchored ? "Unsecure" : "Secure"
		else if(held_item.tool_behaviour == TOOL_CROWBAR && panel_open)
			context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		else if(held_item.tool_behaviour == TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_LMB] = panel_open ? "Close panel" : "Open panel"
		else if(is_reagent_container(held_item) && held_item.is_open_container())
			context[SCREENTIP_CONTEXT_LMB] = "Refill machine"
		// NOVA EDIT - Universal medipen
		// ORIGINAL: else if(istype(held_item, /obj/item/reagent_containers/hypospray/medipen) && reagents.has_reagent(allowed_pens[held_item.type]))
		else if(istype(held_item, /obj/item/reagent_containers/hypospray/medipen/universal) || istype(held_item, /obj/item/reagent_containers/hypospray/medipen) && reagents.has_reagent(allowed_pens[held_item.type]))
		// NOVA EDIT END
			context[SCREENTIP_CONTEXT_LMB] = "Refill medipen"
		else if(istype(held_item, /obj/item/plunger))
			context[SCREENTIP_CONTEXT_LMB] = "Plunge machine"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/medipen_refiller/RefreshParts()
	. = ..()
	var/new_volume = 100
	for(var/datum/stock_part/matter_bin/matter_bin in component_parts)
		new_volume += (100 * matter_bin.tier)
	if(!reagents)
		create_reagents(new_volume, TRANSPARENT)
	reagents.maximum_volume = new_volume
	return TRUE

/obj/machinery/medipen_refiller/attackby(obj/item/weapon, mob/user, params)
	if(DOING_INTERACTION(user, src))
		balloon_alert(user, "already interacting!")
		return
	if(is_reagent_container(weapon) && weapon.is_open_container())
		var/obj/item/reagent_containers/reagent_container = weapon
		if(!length(reagent_container.reagents.reagent_list))
			balloon_alert(user, "nothing to transfer!")
			return
		var/units = reagent_container.reagents.trans_to(src, reagent_container.amount_per_transfer_from_this, transferred_by = user)
		if(units)
			balloon_alert(user, "[units] units transferred")
		else
			balloon_alert(user, "reagent storage full!")
		return
	if(istype(weapon, /obj/item/reagent_containers/hypospray/medipen))
		var/obj/item/reagent_containers/hypospray/medipen/medipen = weapon
		if(!(LAZYFIND(allowed_pens, medipen.type)))
			balloon_alert(user, "medipen incompatible!")
			return
		if(medipen.reagents?.reagent_list.len)
			balloon_alert(user, "medipen full!")
			return
		// NOVA EDIT BEGIN - Universal medipen
		var/is_custom = istype(medipen, /obj/item/reagent_containers/hypospray/medipen/universal)
		if(is_custom)
			if(reagents.total_volume < medipen.volume)
				balloon_alert(user, "not enough reagents!")
				return
			for(var/datum/reagent/meds in reagents.reagent_list)
				if(!is_type_in_list(meds, allowed_pen_medicine) || is_type_in_list(meds, disallowed_pen_medicine))
					balloon_alert(user, "reagents incompatible!")
					return
		// NOVA EDIT END
		if(!reagents.has_reagent(allowed_pens[medipen.type], 10))
			balloon_alert(user, "not enough reagents!")
			return
		add_overlay("active")
		if(do_after(user, 2 SECONDS, src))
			medipen.used_up = FALSE
			// NOVA EDIT BEGIN - Universal medipen
			if(is_custom)
				reagents.trans_to(medipen, medipen.volume)
			else
				medipen.add_initial_reagents()
				reagents.remove_reagent(allowed_pens[medipen.type], medipen.volume)
			// NOVA EDIT END
			balloon_alert(user, "refilled")
			use_energy(active_power_usage)
		cut_overlays()
		return
	return ..()

/obj/machinery/medipen_refiller/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	user.balloon_alert_to_viewers("furiously plunging...", "plunging medipen refiller...")
	if(do_after(user, 3 SECONDS, target = src))
		user.balloon_alert_to_viewers("finished plunging")
		reagents.expose(get_turf(src), TOUCH)
		reagents.clear_reagents()

/obj/machinery/medipen_refiller/wrench_act(mob/living/user, obj/item/tool)
	default_unfasten_wrench(user, tool)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/medipen_refiller/crowbar_act(mob/living/user, obj/item/tool)
	default_deconstruction_crowbar(tool)
	return TRUE

/obj/machinery/medipen_refiller/screwdriver_act(mob/living/user, obj/item/tool)
	return default_deconstruction_screwdriver(user, "[initial(icon_state)]_open", initial(icon_state), tool)
