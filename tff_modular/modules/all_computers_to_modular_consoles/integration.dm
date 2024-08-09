GLOBAL_LIST_INIT(consoles_replacement_map, list(
	// Unique disk_binded consoles
	/obj/machinery/computer/rdservercontrol = /obj/machinery/modular_computer/preset/battery_less/console/rdservercontrol,
	/obj/machinery/computer/cargo = /obj/machinery/modular_computer/preset/battery_less/console/cargo,
	/obj/machinery/computer/cargo/request = /obj/machinery/modular_computer/preset/battery_less/console/cargo/request,
	/obj/machinery/computer/accounting = /obj/machinery/modular_computer/preset/battery_less/console/accounting,
	/obj/machinery/computer/operating = /obj/machinery/modular_computer/preset/battery_less/console/operating,
	/obj/machinery/computer/atmos_alert = /obj/machinery/modular_computer/preset/battery_less/console/atmos_alert,
	/obj/machinery/computer/crew = /obj/machinery/modular_computer/preset/battery_less/console/crewmonitor,
	/obj/machinery/computer/crew/syndie = /obj/machinery/modular_computer/preset/battery_less/console/crewmonitor/syndie,
	/obj/machinery/computer/records/medical = /obj/machinery/modular_computer/preset/battery_less/console/records_medical,
	/obj/machinery/computer/records/medical/syndie = /obj/machinery/modular_computer/preset/battery_less/console/records_medical/syndie,
	/obj/machinery/computer/records/security = /obj/machinery/modular_computer/preset/battery_less/console/records_security,
	/obj/machinery/computer/records/security/syndie = /obj/machinery/modular_computer/preset/battery_less/console/records_security/syndie,
	/obj/machinery/computer/holodeck = /obj/machinery/modular_computer/preset/battery_less/console/holodeck,

	// Disk_binded disks instead circuits in fabricators
	/obj/item/circuitboard/computer/rdservercontrol = /obj/item/computer_console_disk/command/rdservercontrol,
	/obj/item/circuitboard/computer/cargo = /obj/item/computer_console_disk/cargo/budgetorders/master,
	/obj/item/circuitboard/computer/cargo/request = /obj/item/computer_console_disk/cargo/budgetorders/master/slave,
	/obj/item/circuitboard/computer/accounting = /obj/item/computer_console_disk/command/accounting,
	/obj/item/circuitboard/computer/operating = /obj/item/computer_console_disk/medical/operating,
	/obj/item/circuitboard/computer/atmos_alert = /obj/item/computer_console_disk/engineering/station_alert,
	/obj/item/circuitboard/computer/crew = /obj/item/computer_console_disk/medical/crewmonitor,
	/obj/item/circuitboard/computer/med_data = /obj/item/computer_console_disk/medical/records,
	/obj/item/circuitboard/computer/secure_data = /obj/item/computer_console_disk/security/records,

	// Consoles with regular programs. We just boost behavior with our disks
	/obj/machinery/computer/aifixer = /obj/machinery/modular_computer/preset/battery_less/console/aifixer,
	/obj/machinery/computer/rdconsole = /obj/machinery/modular_computer/preset/battery_less/console/rdconsole,
	/obj/machinery/computer/station_alert = /obj/machinery/modular_computer/preset/battery_less/console/station_alert,
	/obj/machinery/computer/security = /obj/machinery/modular_computer/preset/battery_less/console/security,
	/obj/machinery/computer/security/mining = /obj/machinery/modular_computer/preset/battery_less/console/security/mining,
	/obj/machinery/computer/security/research = /obj/machinery/modular_computer/preset/battery_less/console/security/science,
	/obj/machinery/computer/security/hos = /obj/machinery/modular_computer/preset/battery_less/console/security/hos,
	/obj/machinery/computer/security/labor = /obj/machinery/modular_computer/preset/battery_less/console/security/labor,
	/obj/machinery/computer/security/qm = /obj/machinery/modular_computer/preset/battery_less/console/security/qm,
	/obj/machinery/computer/monitor = /obj/machinery/modular_computer/preset/battery_less/console/monitor,

	// Disk_binded disks instead circuits in fabricators for regular programs
	/obj/item/circuitboard/computer/aifixer = /obj/item/computer_console_disk/science/aifixer,
	/obj/item/circuitboard/computer/rdconsole = /obj/item/computer_console_disk/science/rdconsole,
	/obj/item/circuitboard/computer/stationalert = /obj/item/computer_console_disk/engineering/station_alert,
	/obj/item/circuitboard/computer/security = /obj/item/computer_console_disk/security/secureye,
	/obj/item/circuitboard/computer/mining = /obj/item/computer_console_disk/cargo/secureye,
	/obj/item/circuitboard/computer/research = /obj/item/computer_console_disk/science/secureye,
	/obj/item/circuitboard/computer/powermonitor = /obj/item/computer_console_disk/engineering/monitor,
))

/obj/machinery/computer/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	if (mapload && (src.type in GLOB.consoles_replacement_map))
		var/obj/machinery/modular_computer/preset/battery_less/console/console = GLOB.consoles_replacement_map[src.type]
		console = new console(src.loc)
		if (!transfer_data_to_modular_console(console))
			// Abort replacement
			qdel(console)
			return .
		console.update_appearance()
		return INITIALIZE_HINT_QDEL

/obj/machinery/computer/proc/transfer_data_to_modular_console(obj/machinery/modular_computer/preset/battery_less/console/console)
	SHOULD_CALL_PARENT(TRUE)

	console.setDir(dir)
	console.name = name

	// Oh shit! I am an holoconsole!
	var/area/station/holodeck/computer_area = get_area(src)
	if(istype(computer_area))
		var/datum/computer_file/program/disk_binded/holodeck/holocontrols = computer_area.linked
		if (!istype(holocontrols, /obj/machinery/computer/holodeck))
			var/obj/machinery/modular_computer/mc = holocontrols
			if(!istype(mc) || !mc.cpu)
				stack_trace("Holoconsole was asked for data transfer to modular_console. But holocontrols PC is broken, so I can't bind it")
				return FALSE
			holocontrols = mc.cpu.find_file_by_name("holodeck_admin")
			if(!holocontrols)
				stack_trace("Holoconsole was asked for data transfer to modular_console. But I am unable to locate holocontrols program, so I can't bind it")
				return FALSE

		holocontrols.effects += console
		if (console.cpu)
			holocontrols.effects += console.cpu
			var/datum/computer_file/program/filemanager/fm = console.cpu.find_file_by_name("filemanager")
			if (fm && fm.console_disk)
				holocontrols.effects += fm.console_disk

	if (console.cpu)
		console.cpu.desc = desc

	return TRUE

/datum/design/board/New()
	. = ..()
	if (build_path in GLOB.consoles_replacement_map)
		build_path = GLOB.consoles_replacement_map[build_path]
