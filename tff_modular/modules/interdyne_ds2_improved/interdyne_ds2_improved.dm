// Создаем ноутбук с НТ_Фронтиер - консоли сломаны, а эксперименты делать надо.
/obj/item/modular_computer/laptop/preset/syndicate/interdyne
	starting_programs = list(
		/datum/computer_file/program/ntnetdownload,
		/datum/computer_file/program/scipaper_program,
	)

////// RND BLOCK ///////
// создаём и регистрируем РНД-сеть
/datum/controller/subsystem/research/Initialize()
	. = ..()
	new /datum/techweb/interdyne

/datum/techweb/interdyne
	id = "INTERDYNE"
	organization = "Interdyne Pharmaceutics"
	should_generate_points = TRUE

/datum/techweb/interdyne/New()
	. = ..()
	research_node_id(TECHWEB_NODE_OLDSTATION_SURGERY, TRUE, TRUE, FALSE)

// создаём сервер под сеть
/obj/item/circuitboard/machine/rdserver/interdyne
	name = "Interdyne Pharmaceutics R&D Server board"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/server/interdyne
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/scanning_module = 4,
	)

/obj/machinery/rnd/server/interdyne
	name = "\improper Interdyne Pharmaceutics R&D Server"
	circuit = /obj/item/circuitboard/machine/rdserver/interdyne
	req_access = list(ACCESS_AWAY_SCIENCE)

/obj/machinery/rnd/server/interdyne/Initialize(mapload)
	var/datum/techweb/interdyne/interdyne_techweb = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	stored_research = interdyne_techweb
	return ..()

////// PROC BLOCK ///////
//самое сложное - делаем консоль с раундстарт-линком на Дюносеть. Ненавижу айсмун.
/obj/item/circuitboard/computer/rdconsole/interdyne
	name = "Interdyne R&D Console"
	build_path = /obj/machinery/computer/rdconsole/interdyne

/obj/machinery/computer/rdconsole/interdyne
	name = "Interdyne R&D Console"
	circuit = /obj/item/circuitboard/computer/rdconsole/interdyne

/obj/machinery/computer/rdconsole/proc/override_default_techweb(datum/techweb/new_techweb)
	if(stored_research)
		stored_research.consoles_accessing -= src
		log_research("[src] disconnected from techweb [stored_research] when connected to [new_techweb].")
	stored_research = new_techweb
	stored_research.consoles_accessing += src

/obj/machinery/computer/rdconsole/interdyne/post_machine_initialize()
	. = ..()
	var/datum/techweb/interdyne/active_web = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	override_default_techweb(active_web)

////// CRAFT BLOCK ///////
//протолат.
/obj/item/circuitboard/machine/protolathe/offstation/interdyne
	name = "Interdyne protolathe board"
	build_path = /obj/machinery/rnd/production/protolathe/offstation/inerdyne

/obj/machinery/rnd/production/protolathe/offstation/inerdyne
	name = "Interdyne protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe/offstation/interdyne

/obj/machinery/rnd/production/protolathe/offstation/inerdyne/post_machine_initialize()
	. = ..()
	var/datum/techweb/interdyne/active_web = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	connect_techweb(active_web)

//Автолат//
/obj/item/circuitboard/machine/autolathe/interdyne
	name = "Interdyne autolathe board"
	build_path = /obj/machinery/autolathe/hacked/interdyne

/obj/machinery/autolathe/hacked/interdyne
	name = "Interdyne autolathe"
	circuit = /obj/item/circuitboard/machine/autolathe/interdyne

// Печатор плат
/obj/item/circuitboard/machine/circuit_imprinter/interdyne
	name = "Interdyne Circuit Imprinter board"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/offstation/interdyne

/obj/machinery/rnd/production/circuit_imprinter/offstation/interdyne
	name = "Interdyne Circuit Imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/interdyne

/obj/machinery/rnd/production/circuit_imprinter/offstation/interdyne/post_machine_initialize()
	. = ..()
	var/datum/techweb/interdyne/active_web = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	connect_techweb(active_web)

// меха-фабрикатор
/obj/item/circuitboard/machine/mechfab/interdyne
	name = "Interdyne Exosuit Fabricator board"
	build_path = /obj/machinery/mecha_part_fabricator/interdyne

/obj/machinery/mecha_part_fabricator/interdyne
	name = "Interdyne Exosuit Fabricator"
	circuit = /obj/item/circuitboard/machine/mechfab/interdyne

/obj/machinery/mecha_part_fabricator/interdyne/post_machine_initialize()
	. = ..()
	var/datum/techweb/interdyne/active_web = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	connect_techweb(active_web)

// Деструктив-Аналайзер
/obj/item/circuitboard/machine/destructive_analyzer/interdyne
	name = "Interdyne Destructive Analyzer board"
	build_path = /obj/machinery/rnd/destructive_analyzer/interdyne

/obj/machinery/rnd/destructive_analyzer/interdyne
	name = "Interdyne Destructive Analyzer"
	circuit = /obj/item/circuitboard/machine/destructive_analyzer/interdyne

/obj/machinery/rnd/destructive_analyzer/interdyne/post_machine_initialize()
	. = ..()
	var/datum/techweb/interdyne/active_web = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	connect_techweb(active_web)

// Компонент принтер
/obj/item/circuitboard/machine/component_printer/interdyne
	name = "Interdyne Component Printer board"
	build_path = /obj/machinery/component_printer/interdyne

/obj/machinery/component_printer/interdyne
	name = "Interdyne Component Printer"
	circuit = /obj/item/circuitboard/machine/component_printer/interdyne

/obj/machinery/component_printer/interdyne/post_machine_initialize()
	. = ..()
	var/datum/techweb/interdyne/active_web = locate(/datum/techweb/interdyne) in SSresearch.techwebs
	connect_techweb(active_web)

// Дубликатор модулей
/obj/item/circuitboard/machine/module_duplicator/interdyne
	name = "Interdyne Module Duplicator board"
	build_path = /obj/machinery/module_duplicator/interdyne

/obj/machinery/module_duplicator/interdyne
	name = "Interdyne Module Duplicator"
	circuit = /obj/item/circuitboard/machine/module_duplicator/interdyne

/////////// DS-2 BLOCK ///////////
////// RND BLOCK ///////
// создаём и регистрируем РНД-сеть
/datum/controller/subsystem/research/Initialize()
	. = ..()
	new /datum/techweb/ds2

/datum/techweb/ds2
	id = "CYBERSUN"
	organization = "Cybersun Industries"
	should_generate_points = TRUE

/datum/techweb/ds2/New()
	. = ..()
	research_node_id(TECHWEB_NODE_OLDSTATION_SURGERY, TRUE, TRUE, FALSE)

// создаём сервер под сеть
/obj/item/circuitboard/machine/rdserver/ds2
	name = "Cybersun R&D Server board"
	greyscale_colors = CIRCUIT_COLOR_SCIENCE
	build_path = /obj/machinery/rnd/server/ds2
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/datum/stock_part/scanning_module = 4,
	)

/obj/machinery/rnd/server/ds2
	name = "\improper Cybersun R&D Server"
	circuit = /obj/item/circuitboard/machine/rdserver/ds2
	req_access = list(ACCESS_AWAY_SCIENCE)

/obj/machinery/rnd/server/ds2/Initialize(mapload)
	var/datum/techweb/ds2/ds2_techweb = locate(/datum/techweb/ds2) in SSresearch.techwebs
	stored_research = ds2_techweb
	return ..()

//самое сложное - делаем консоль с раундстарт-линком на Дюносеть. Ненавижу айсмун.
/obj/item/circuitboard/computer/rdconsole/ds2
	name = "Cybersun R&D Console"
	build_path = /obj/machinery/computer/rdconsole/ds2

/obj/machinery/computer/rdconsole/ds2
	name = "Cybersun R&D Console"
	circuit = /obj/item/circuitboard/computer/rdconsole/ds2


/obj/machinery/computer/rdconsole/ds2/post_machine_initialize()
	. = ..()
	var/datum/techweb/ds2/active_web = locate(/datum/techweb/ds2) in SSresearch.techwebs
	override_default_techweb(active_web)

////// CRAFT BLOCK ///////
//протолат
/obj/item/circuitboard/machine/protolathe/offstation/ds2
	name = "Cybersun protolathe board"
	build_path = /obj/machinery/rnd/production/protolathe/offstation/ds2

/obj/machinery/rnd/production/protolathe/offstation/ds2
	name = "Cybersun protolathe"
	circuit = /obj/item/circuitboard/machine/protolathe/offstation/ds2

/obj/machinery/rnd/production/protolathe/offstation/ds2/post_machine_initialize()
	. = ..()
	var/datum/techweb/ds2/active_web = locate(/datum/techweb/ds2) in SSresearch.techwebs
	connect_techweb(active_web)

//Автолат//
/obj/item/circuitboard/machine/autolathe/ds2
	name = "Cybersun autolathe board"
	build_path = /obj/machinery/autolathe/hacked/ds2

/obj/machinery/autolathe/hacked/ds2
	name = "Cybersun autolathe"
	circuit = /obj/item/circuitboard/machine/autolathe/ds2

// Печатор плат
/obj/item/circuitboard/machine/circuit_imprinter/ds2
	name = "Cybersun Circuit Imprinter board"
	build_path = /obj/machinery/rnd/production/circuit_imprinter/offstation/ds2

/obj/machinery/rnd/production/circuit_imprinter/offstation/ds2
	name = "Cybersun Circuit Imprinter"
	circuit = /obj/item/circuitboard/machine/circuit_imprinter/ds2

/obj/machinery/rnd/production/circuit_imprinter/offstation/ds2/post_machine_initialize()
	. = ..()
	var/datum/techweb/ds2/active_web = locate(/datum/techweb/ds2) in SSresearch.techwebs
	connect_techweb(active_web)

// меха-фабрикатор
/obj/item/circuitboard/machine/mechfab/ds2
	name = "Cybersun Exosuit Fabricator board"
	build_path = /obj/machinery/mecha_part_fabricator/ds2

/obj/machinery/mecha_part_fabricator/ds2
	name = "Cybersun Exosuit Fabricator"
	circuit = /obj/item/circuitboard/machine/mechfab/ds2

/obj/machinery/mecha_part_fabricator/ds2/post_machine_initialize()
	. = ..()
	var/datum/techweb/ds2/active_web = locate(/datum/techweb/ds2) in SSresearch.techwebs
	connect_techweb(active_web)

// Деструктив-Аналайзер
/obj/item/circuitboard/machine/destructive_analyzer/ds2
	name = "Cybersun Destructive Analyzer board"
	build_path = /obj/machinery/rnd/destructive_analyzer/ds2

/obj/machinery/rnd/destructive_analyzer/ds2
	name = "Cybersun Destructive Analyzer"
	circuit = /obj/item/circuitboard/machine/destructive_analyzer/ds2

/obj/machinery/rnd/destructive_analyzer/ds2/post_machine_initialize()
	. = ..()
	var/datum/techweb/ds2/active_web = locate(/datum/techweb/ds2) in SSresearch.techwebs
	connect_techweb(active_web)

// Компонент принтер
/obj/item/circuitboard/machine/component_printer/ds2
	name = "Cybersun Component Printer board"
	build_path = /obj/machinery/component_printer/ds2

/obj/machinery/component_printer/ds2
	name = "Cybersun Component Printer"
	circuit = /obj/item/circuitboard/machine/component_printer/ds2

/obj/machinery/component_printer/ds2/post_machine_initialize()
	. = ..()
	var/datum/techweb/ds2/active_web = locate(/datum/techweb/ds2) in SSresearch.techwebs
	connect_techweb(active_web)

// Дубликатор модулей
/obj/item/circuitboard/machine/module_duplicator/ds2
	name = "Cybersun Module Duplicator board"
	build_path = /obj/machinery/module_duplicator/ds2

/obj/machinery/module_duplicator/ds2
	name = "Cybersun Module Duplicator"
	circuit = /obj/item/circuitboard/machine/module_duplicator/ds2
