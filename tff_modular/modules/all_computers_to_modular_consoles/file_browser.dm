#define EJECT_TIME_SKILLED		0 SECONDS
// 2 to unscrew, 3 to eject glass, cut wires and eject circuit
#define EJECT_TIME_UNSKILLED	5 SECONDS

/datum/computer_file/program/filemanager
	var/obj/item/computer_console_disk/console_disk

/datum/computer_file/program/filemanager/application_item_interaction(mob/living/user, obj/item/computer_console_disk/tool, list/modifiers)
	if (!istype(tool))
		return NONE

	if (console_disk)
		if (user)
			to_chat(user, span_warning("It's secure disk drive already occupied!"))
		return ITEM_INTERACT_BLOCKING
	if (!tool.program)
		say("I/O ERROR: Unable to access encrypted data disk. Ejecting...")
		return ITEM_INTERACT_BLOCKING

	if (!tool.program.is_supported_by_hardware(computer.hardware_flag))
		var/supported_hardware = tool.program.can_run_on_flags_to_text()
		if (supported_hardware == "Anything")
			// how you aren't supported, if you support anything?!
			say("HARDWARE ERROR: Software compatibility mismatch! Please report that info to NTTechSupport. PC hardware code: [computer.hardware_flag]. Filename: [tool.program.filename].[lowertext(tool.program.filetype)]")
			return ITEM_INTERACT_BLOCKING
		else
			say("HARDWARE ERROR: Incompatible software. Ejecting... Supported devices: [supported_hardware]")
			return ITEM_INTERACT_BLOCKING

	if(user && !user.transferItemToLoc(tool, computer))
		return ITEM_INTERACT_BLOCKING
	console_disk = tool
	playsound(computer, 'sound/machines/terminal_insert_disc.ogg', 50, FALSE)
	console_disk.RegisterPC(computer)

	if (console_disk.program)
		// Remove BSOD if present
		var/datum/computer_file/program/bsod/bsod = computer.find_file_by_name("nt_recovery")
		if (bsod)
			computer.remove_file(bsod)

		// We are supreme! Delete our pale imitation!
		var/datum/computer_file/program/already_present = computer.find_file_by_name(console_disk.program.filename)
		if (already_present)
			to_chat(user, span_notice("You was able to notice an popup which says that [filedesc] runs reinstallation of [console_disk.program.filename].[lowertext(console_disk.program.filetype)]"))
			computer.remove_file(already_present)

		var/datum/computer_file/program/clone = console_disk.program.clone()
		console_disk.installed_clone = clone
		computer.store_file(clone)
		console_disk.CloneInstalled()
		// Initial start
		computer.open_program(user, clone, computer.enabled)

	return ITEM_INTERACT_SUCCESS

/datum/computer_file/program/filemanager/try_eject(mob/living/user, forced = FALSE)
	if (!console_disk)
		return TRUE

	if (forced || !user || HAS_TRAIT(user, TRAIT_KNOW_ENGI_WIRES) || issilicon(user))
		if (user && !HAS_SILICON_ACCESS(user))
			user.visible_message(span_notice("[user] quickly presses few buttons on [computer]."), span_notice("You use 'Safely Remove Hardware' option to eject [console_disk] from [computer].."))
			if (do_after(user, EJECT_TIME_SKILLED, computer.physical ? computer.physical : get_turf(computer)))
				user.put_in_hands(console_disk)
				user.visible_message(span_warning("[user] removes [console_disk] from [computer]!"), span_notice("[computer] spews [console_disk] out."))
			else
				to_chat(user, span_warning("You should be near \the [computer.physical ? computer.physical : computer]!"))
				return FALSE
		else
			console_disk.forceMove(computer.drop_location())
		console_disk.CloneUnInstalled()
		computer.remove_file(console_disk.installed_clone)
		console_disk.UnRegisterPC()
		console_disk.installed_clone = null
		console_disk = null
		return TRUE
	else
		user.visible_message(span_warning("[user] tries to rip off [console_disk] from [computer]!"), span_notice("You try to forcibly remove stuck [console_disk] from [computer]..."))
		if (do_after(user, EJECT_TIME_UNSKILLED, computer.physical ? computer.physical : get_turf(computer)))
			var/datum/computer_file/program/bsod/bsod = new(lowertext("[console_disk.program.filename].[console_disk.program.filetype]"))

			console_disk.CloneUnInstalled()
			computer.remove_file(console_disk.installed_clone)
			user.put_in_hands(console_disk)
			console_disk.UnRegisterPC()
			console_disk.installed_clone = null
			console_disk = null

			computer.store_file(bsod)
			return TRUE
		to_chat(user, span_warning("You should be near \the [computer.physical ? computer.physical : computer]!"))
	return FALSE

#undef EJECT_TIME_UNSKILLED
#undef EJECT_TIME_SKILLED
