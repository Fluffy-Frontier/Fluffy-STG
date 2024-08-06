#define COMP_SECURITY_ARREST_AMOUNT_TO_FLAG 10
#define PRINTOUT_MISSING "Missing"
#define PRINTOUT_RAPSHEET "Rapsheet"
#define PRINTOUT_WANTED "Wanted"
/// Editing this will cause UI issues.
#define MAX_CRIME_NAME_LEN 24

/datum/computer_file/program/disk_binded/records/security
	filename = "fullrecordssecurity"
	filedesc = "Security Records Expanded"
	program_open_overlay = "security"
	extended_desc = "This can be used to check security records."
	tgui_id = "NtosRecordsSecurity"
	program_icon = FA_ICON_FILE_SHIELD
	download_access = list(ACCESS_SECURITY, ACCESS_HOP)
	icon_keyboard = "security_key"
	/// The current state of the printer
	var/printing = FALSE

/datum/computer_file/program/disk_binded/records/security/on_install(datum/computer_file/source, obj/item/modular_computer/computer_installing)
	. = ..()
	RegisterSignal(computer.physical, COMSIG_ATOM_EMP_ACT, PROC_REF(emp_act))


/datum/computer_file/program/disk_binded/records/security/Destroy()
	UnregisterSignal(computer.physical, COMSIG_ATOM_EMP_ACT)
	. = ..()

/datum/computer_file/program/disk_binded/records/security/proc/emp_act(datum/source, severity, protection)
	SIGNAL_HANDLER

	if(protection & EMP_PROTECT_SELF)
		return

	if (!computer.enabled && computer.active_program != src)
		return

	for(var/datum/record/crew/target in GLOB.manifest.general)
		if(prob(10/severity))
			switch(rand(1,5))
				if(1)
					target.name = generate_random_name()

				if(2)
					target.gender = pick("Male", "Female", "Other")
				if(3)
					target.age = rand(5, 85)
				if(4)
					target.wanted_status = pick(WANTED_STATUSES())
				if(5)
					target.species = pick(get_selectable_species())
			continue

		else if(prob(1))
			qdel(target)
			continue

/datum/computer_file/program/disk_binded/records/security/application_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/photo))
		return NONE
	insert_new_record(user, tool)
	return ITEM_INTERACT_SUCCESS

/datum/computer_file/program/disk_binded/records/security/ui_data(mob/user)
	var/list/data = ..()

	data["available_statuses"] = WANTED_STATUSES()
	data["current_user"] = user.name
	data["higher_access"] = has_armory_access(user)

	var/list/records = list()
	for(var/datum/record/crew/target in GLOB.manifest.general)
		var/list/citations = list()
		for(var/datum/crime/citation/warrant in target.citations)
			citations += list(list(
				author = warrant.author,
				crime_ref = REF(warrant),
				details = warrant.details,
				fine = warrant.fine,
				name = warrant.name,
				paid = warrant.paid,
				time = warrant.time,
				valid = warrant.valid,
			))

		var/list/crimes = list()
		for(var/datum/crime/crime in target.crimes)
			crimes += list(list(
				author = crime.author,
				crime_ref = REF(crime),
				details = crime.details,
				name = crime.name,
				time = crime.time,
				valid = crime.valid,
			))

		records += list(list(
			age = target.age,
			chrono_age = target.chrono_age, // NOVA EDIT ADDITION - Chronological age
			citations = citations,
			crew_ref = REF(target),
			crimes = crimes,
			fingerprint = target.fingerprint,
			gender = target.gender,
			name = target.name,
			note = target.security_note,
			rank = target.rank,
			species = target.species,
			trim = target.trim,
			wanted_status = target.wanted_status,
			// NOVA EDIT ADDITION - RP Records
			past_general_records = target.past_general_records,
			past_security_records = target.past_security_records,
			// NOVA EDIT END
		))

	data["records"] = records

	return data

/datum/computer_file/program/disk_binded/records/security/ui_static_data(mob/user)
	var/list/data = list()
	data["min_age"] = AGE_MIN
	data["max_age"] = AGE_MAX
	data["max_chrono_age"] = AGE_CHRONO_MAX // NOVA EDIT ADDITION - Chronological age
	return data

/datum/computer_file/program/disk_binded/records/security/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = ui.user

	var/datum/record/crew/target
	if(params["crew_ref"])
		target = locate(params["crew_ref"]) in GLOB.manifest.general
	if(!target)
		return FALSE

	switch(action)
		if("add_crime")
			add_crime(user, target, params)
			return TRUE

		if("delete_record")
			owner_object.investigate_log("[user] deleted record: \"[target]\".", INVESTIGATE_RECORDS)
			qdel(target)
			return TRUE

		if("edit_crime")
			edit_crime(user, target, params)
			return TRUE

		if("invalidate_crime")
			invalidate_crime(user, target, params)
			return TRUE

		if("print_record")
			print_record(user, target, params)
			return TRUE

		if("set_note")
			var/note = strip_html_full(params["note"], MAX_MESSAGE_LEN)
			owner_object.investigate_log("[user] has changed the security note of record: \"[target]\" from \"[target.security_note]\" to \"[note]\".")
			target.security_note = note
			return TRUE

		if("set_wanted")
			var/wanted_status = params["status"]
			if(!wanted_status || !(wanted_status in WANTED_STATUSES()))
				return FALSE
			if(wanted_status == WANTED_ARREST && !length(target.crimes))
				return FALSE

			owner_object.investigate_log("[target.name] has been set from [target.wanted_status] to [wanted_status] by [key_name(usr)].", INVESTIGATE_RECORDS)
			target.wanted_status = wanted_status

			update_matching_security_huds(target.name)

			return TRUE

	return FALSE

/// Handles adding a crime to a particular record.
/datum/computer_file/program/disk_binded/records/security/proc/add_crime(mob/user, datum/record/crew/target, list/params)
	var/input_name = strip_html_full(params["name"], MAX_CRIME_NAME_LEN)
	if(!input_name)
		to_chat(usr, span_warning("You must enter a name for the crime."))
		playsound(computer.physical, 'sound/machines/terminal_error.ogg', 75, TRUE)
		return FALSE

	var/max = CONFIG_GET(number/maxfine)
	if(params["fine"] > max)
		to_chat(usr, span_warning("The maximum fine is [max] credits."))
		playsound(computer.physical, 'sound/machines/terminal_error.ogg', 75, TRUE)
		return FALSE

	var/input_details
	if(params["details"])
		input_details = strip_html_full(params["details"], MAX_MESSAGE_LEN)

	if(params["fine"] == 0)
		var/datum/crime/new_crime = new(name = input_name, details = input_details, author = usr)
		target.crimes += new_crime
		owner_object.investigate_log("New Crime: <strong>[input_name]</strong> | Added to [target.name] by [key_name(user)]. Their previous status was [target.wanted_status]", INVESTIGATE_RECORDS)
		target.wanted_status = WANTED_ARREST

		update_matching_security_huds(target.name)

		return TRUE

	var/datum/crime/citation/new_citation = new(name = input_name, details = input_details, author = usr, fine = params["fine"])

	target.citations += new_citation
	new_citation.alert_owner(user, computer.physical, target.name, "You have been issued a [params["fine"]]cr citation for [input_name]. Fines are payable at Security.")
	owner_object.investigate_log("New Citation: <strong>[input_name]</strong> Fine: [params["fine"]] | Added to [target.name] by [key_name(user)]", INVESTIGATE_RECORDS)
	SSblackbox.ReportCitation(REF(new_citation), user.ckey, user.real_name, target.name, input_name, params["fine"])

	return TRUE

/// Handles editing a crime on a particular record.
/datum/computer_file/program/disk_binded/records/security/proc/edit_crime(mob/user, datum/record/crew/target, list/params)
	var/datum/crime/editing_crime = locate(params["crime_ref"]) in target.crimes
	if (!editing_crime)
		editing_crime = locate(params["crime_ref"]) in target.citations
	if(!editing_crime?.valid)
		return FALSE

	if(user != editing_crime.author && !has_armory_access(user)) // only warden/hos/command can edit crimes they didn't author
		owner_object.investigate_log("[user] attempted to edit crime: \"[editing_crime.name]\" for target: \"[target.name]\" but failed due to lacking armoury access and not being the author of the crime.", INVESTIGATE_RECORDS)
		return FALSE

	if(params["name"] && length(params["name"]) > 2 && params["name"] != editing_crime.name)
		var/new_name = strip_html_full(params["name"], MAX_CRIME_NAME_LEN)
		owner_object.investigate_log("[user] edited crime: \"[editing_crime.name]\" for target: \"[target.name]\", changing the name to: \"[new_name]\".", INVESTIGATE_RECORDS)
		editing_crime.name = new_name
		return TRUE

	if(params["description"] && length(params["description"]) > 2 && params["name"] != editing_crime.name)
		var/new_details = strip_html_full(params["description"], MAX_MESSAGE_LEN)
		owner_object.investigate_log("[user] edited crime \"[editing_crime.name]\" for target: \"[target.name]\", changing the details to: \"[new_details]\" from: \"[editing_crime.details]\".", INVESTIGATE_RECORDS)
		editing_crime.details = new_details
		return TRUE

	return FALSE

/// Deletes security information from a record.
/datum/computer_file/program/disk_binded/records/security/expunge_record_info(datum/record/crew/target)
	target.citations.Cut()
	target.crimes.Cut()
	target.security_note = null
	target.wanted_status = WANTED_NONE

	return TRUE

/// Only qualified personnel can edit records.
/datum/computer_file/program/disk_binded/records/security/proc/has_armory_access(mob/user)
	if(!isliving(user))
		return FALSE
	var/mob/living/player = user

	if (HAS_SILICON_ACCESS(player))
		return TRUE

	var/obj/item/card/id/auth = player.get_idcard(TRUE)
	if(!auth)
		return FALSE

	if(!(ACCESS_ARMORY in auth.GetAccess()))
		return FALSE

	return TRUE

/// Voids crimes, or sets someone to discharged if they have none left.
/datum/computer_file/program/disk_binded/records/security/proc/invalidate_crime(mob/user, datum/record/crew/target, list/params)
	var/datum/crime/to_void = locate(params["crime_ref"]) in target.crimes
	if(!to_void)
		// Citations
		to_void = locate(params["crime_ref"]) in target.citations
		if(!to_void)
			return FALSE

	if(!has_armory_access(user) && to_void.author != user)
		return FALSE

	to_void.valid = FALSE
	owner_object.investigate_log("[key_name(user)] has invalidated [target.name]'s crime: [to_void.name]", INVESTIGATE_RECORDS)

	var/acquitted = TRUE
	for(var/datum/crime/incident in target.crimes)
		if(!incident.valid)
			continue
		acquitted = FALSE
		break

	if(acquitted)
		target.wanted_status = WANTED_DISCHARGED
		owner_object.investigate_log("[key_name(user)] has invalidated [target.name]'s last valid crime. Their status is now [WANTED_DISCHARGED].", INVESTIGATE_RECORDS)

		update_matching_security_huds(target.name)
	return TRUE

/// Finishes printing, resets the printer.
/datum/computer_file/program/disk_binded/records/security/proc/print_finish(obj/item/printable)
	printing = FALSE
	playsound(computer.physical, 'sound/machines/terminal_eject.ogg', 100, TRUE)
	printable.forceMove(computer.physical.loc)

	return TRUE

/// Handles printing records via UI. Takes the params from UI_act.
/datum/computer_file/program/disk_binded/records/security/proc/print_record(mob/user, datum/record/crew/target, list/params)
	if(printing)
		computer.physical.balloon_alert(user, "printer busy")
		playsound(computer.physical, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	if (!computer.stored_paper)
		computer.physical.balloon_alert(user, "paper bin empty")
		playsound(computer.physical, 'sound/machines/terminal_error.ogg', 100, TRUE)
		return FALSE

	computer.stored_paper--
	printing = TRUE
	computer.physical.balloon_alert(user, "printing")
	playsound(computer.physical, 'sound/machines/printer.ogg', 100, TRUE)

	var/obj/item/printable
	var/input_alias = strip_html_full(params["alias"], MAX_NAME_LEN) || target.name
	var/input_description = strip_html_full(params["desc"], MAX_BROADCAST_LEN) || "No further details."
	var/input_header = strip_html_full(params["head"], 8) || capitalize(params["type"])

	switch(params["type"])
		if("missing")
			var/obj/item/photo/mugshot = target.get_front_photo()
			var/obj/item/poster/wanted/missing/missing_poster = new(null, mugshot.picture.picture_image, input_alias, input_description, input_header)

			printable = missing_poster

		if("wanted")
			var/list/crimes = target.crimes
			if(!length(crimes))
				computer.physical.balloon_alert(user, "no crimes")
				return FALSE

			input_description += "\n\n<b>WANTED FOR:</b>"
			for(var/datum/crime/incident in crimes)
				if(!incident.valid)
					input_description += "<b>--REDACTED--</b>"
					continue
				input_description += "\n<bCrime:</b> [incident.name]\n"
				input_description += "<b>Details:</b> [incident.details]\n"

			var/obj/item/photo/mugshot = target.get_front_photo()
			var/obj/item/poster/wanted/wanted_poster = new(null, mugshot.picture.picture_image, input_alias, input_description, input_header)

			printable = wanted_poster

		if("rapsheet")
		/// NOVA EDIT REMOVE - REMOVE CRIMES REQUIREMENT FOR PRINTING RECORDS
			//var/list/crimes = target.crimes
			//if(!length(crimes))
				//balloon_alert(user, "no crimes")
				//return FALSE
		/// NOVA EDIT REMOVE END

			var/obj/item/paper/rapsheet = target.get_rapsheet(input_alias, input_header, input_description)
			printable = rapsheet

	addtimer(CALLBACK(src, PROC_REF(print_finish), printable), 2 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)

	return TRUE


/**
 * Security circuit component
 */

/*
/obj/item/circuit_component/arrest_console_data
	display_name = "Security Records Data"
	desc = "Outputs the security records data, where it can then be filtered with a Select Query component"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The records retrieved
	var/datum/port/output/records

	/// Sends a signal on failure
	var/datum/port/output/on_fail

	var/obj/machinery/computer/records/security/attached_console

/obj/item/circuit_component/arrest_console_data/populate_ports()
	records = add_output_port("Security Records", PORT_TYPE_TABLE)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/arrest_console_data/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/records/security))
		attached_console = shell

/obj/item/circuit_component/arrest_console_data/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/arrest_console_data/get_ui_notices()
	. = ..()
	. += create_table_notices(list(
		"name",
		"id",
		"rank",
		"arrest_status",
		"gender",
		"age",
		"species",
		"fingerprint",
	))

/obj/item/circuit_component/arrest_console_data/input_received(datum/port/input/port)
	if(!attached_console || !attached_console.authenticated)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	if(isnull(GLOB.manifest.general))
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/list/new_table = list()
	for(var/datum/record/crew/player_record as anything in GLOB.manifest.general)
		var/list/entry = list()
		entry["age"] = player_record.age
		entry["arrest_status"] = player_record.wanted_status
		entry["fingerprint"] = player_record.fingerprint
		entry["gender"] = player_record.gender
		entry["name"] = player_record.name
		entry["rank"] = player_record.rank
		entry["record"] = REF(player_record)
		entry["species"] = player_record.species

		new_table += list(entry)

	records.set_output(new_table)
/obj/item/circuit_component/arrest_console_arrest
	display_name = "Security Records Set Status"
	desc = "Receives a table to use to set people's arrest status. Table should be from the security records data component. If New Status port isn't set, the status will be decided by the options."
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

	/// The targets to set the status of.
	var/datum/port/input/targets

	/// Sets the new status of the targets.
	var/datum/port/input/option/new_status

	/// Returns the new status set once the setting is complete. Good for locating errors.
	var/datum/port/output/new_status_set

	/// Sends a signal on failure
	var/datum/port/output/on_fail

	var/obj/machinery/computer/records/security/attached_console

/obj/item/circuit_component/arrest_console_arrest/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/computer/records/security))
		attached_console = shell

/obj/item/circuit_component/arrest_console_arrest/unregister_usb_parent(atom/movable/shell)
	attached_console = null
	return ..()

/obj/item/circuit_component/arrest_console_arrest/populate_options()
	if(!attached_console)
		return
	var/list/available_statuses = WANTED_STATUSES()
	new_status = add_option_port("Arrest Options", available_statuses)

/obj/item/circuit_component/arrest_console_arrest/populate_ports()
	targets = add_input_port("Targets", PORT_TYPE_TABLE)
	new_status_set = add_output_port("Set Status", PORT_TYPE_STRING)
	on_fail = add_output_port("Failed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/arrest_console_arrest/input_received(datum/port/input/port)
	if(!attached_console || !attached_console.authenticated)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/status_to_set = new_status.value

	new_status_set.set_output(status_to_set)
	var/list/target_table = targets.value
	if(!target_table)
		on_fail.set_output(COMPONENT_SIGNAL)
		return

	var/successful_set = 0
	var/list/names_of_entries = list()
	for(var/list/target in target_table)
		var/datum/record/crew/sec_record = target["security_record"]
		if(!sec_record)
			continue

		if(sec_record.wanted_status != status_to_set)
			successful_set++
			names_of_entries += target["name"]
		sec_record.wanted_status = status_to_set


	if(successful_set > 0)
		investigate_log("[names_of_entries.Join(", ")] have been set to [status_to_set] by [parent.get_creator()].", INVESTIGATE_RECORDS)
		if(successful_set > COMP_SECURITY_ARREST_AMOUNT_TO_FLAG)
			message_admins("[successful_set] security entries have been set to [status_to_set] by [parent.get_creator_admin()]. [ADMIN_COORDJMP(src)]")
		update_all_security_huds()
*/

/*
/obj/machinery/computer/records/security/laptop
	name = "security laptop"
	desc = "A cheap Nanotrasen security laptop, it functions as a security records console. It's bolted to the table."
	icon_state = "laptop"
	icon_screen = "seclaptop"
	icon_keyboard = "laptop_key"
	pass_flags = PASSTABLE

/obj/machinery/computer/records/security/laptop/syndie
	desc = "A cheap, jailbroken security laptop. It functions as a security records console. It's bolted to the table."
	req_one_access = list(ACCESS_SYNDICATE)
*/

/obj/item/computer_console_disk/security/records
	program = /datum/computer_file/program/disk_binded/records/security
	light_color = COLOR_SOFT_RED

/obj/machinery/modular_computer/preset/battery_less/console/records_security
	name = "security records console"
	desc = "Used to view and edit personnel's security records."
	console_disk = /obj/item/computer_console_disk/security/records

/datum/computer_file/program/disk_binded/records/security/syndie
	icon_keyboard = "syndie_key"
	download_access = list(ACCESS_SYNDICATE)

/obj/machinery/modular_computer/preset/battery_less/console/records_security/syndie
	starting_programs = list(/datum/computer_file/program/disk_binded/records/security/syndie)
	console_disk = null





#undef COMP_SECURITY_ARREST_AMOUNT_TO_FLAG
#undef PRINTOUT_MISSING
#undef PRINTOUT_RAPSHEET
#undef PRINTOUT_WANTED
#undef MAX_CRIME_NAME_LEN
