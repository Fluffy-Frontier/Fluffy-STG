/**
 * Test if icon states for each datum actually exist in the DMI.
 */
/datum/unit_test/barsigns_icon
<<<<<<< HEAD
	var/list/blacklisted_sign_types = list(/datum/barsign/fluffy, /datum/barsign/skyrat, /datum/barsign/skyrat/large) // NOVA EDIT ADDITION - Modular barsigns // THE FLUFFY FRONTIER EDIT ADDITION - Modular barsigns
=======
	var/list/blacklisted_sign_types = list(/datum/barsign/nova, /datum/barsign/nova/large) // NOVA EDIT ADDITION - Modular barsigns
>>>>>>> 42930d1c74b ([MIRROR] Turns mush cap into an extorgan (#491))

/datum/unit_test/barsigns_icon/Run()
	var/obj/machinery/barsign_type = /obj/machinery/barsign
	var/icon/barsign_icon = initial(barsign_type.icon)
	var/list/barsign_icon_states = icon_states(barsign_icon)
<<<<<<< HEAD
	barsign_icon_states += icon_states(SKYRAT_BARSIGN_FILE) // NOVA EDIT ADDITION - Need to check modular barsigns
	barsign_icon_states += icon_states(TFF_BARSIGN_FILE) // THE FLUFFY FRONTIER - Need to check modular barsigns
	barsign_icon_states += icon_states(SKYRAT_LARGE_BARSIGN_FILE) // NOVA EDIT ADDITION - Need to check modular  barsigns
=======
	barsign_icon_states += icon_states(NOVA_BARSIGN_FILE) // NOVA EDIT ADDITION - Need to check modular barsigns
	barsign_icon_states += icon_states(NOVA_LARGE_BARSIGN_FILE) // NOVA EDIT ADDITION - Need to check modular  barsigns
>>>>>>> 42930d1c74b ([MIRROR] Turns mush cap into an extorgan (#491))

	// Check every datum real bar sign
	for(var/sign_type in (subtypesof(/datum/barsign) - /datum/barsign/hiddensigns))
		// NOVA EDIT ADDITION BEGIN - MODULAR BARSIGNS
		if(sign_type in blacklisted_sign_types)
			continue
		// NOVA EDIT ADDITION END
		var/datum/barsign/sign = new sign_type()

		if(!(sign.icon_state in barsign_icon_states))
			TEST_FAIL("Icon state for [sign_type] does not exist in [barsign_icon].")

/**
 * Check that bar signs have a name and desc, and that the name is unique.
 */
/datum/unit_test/barsigns_name
<<<<<<< HEAD
	var/list/blacklisted_sign_types = list(/datum/barsign/fluffy, /datum/barsign/skyrat, /datum/barsign/skyrat/large) // NOVA EDIT ADDITION - Modular barsigns // THE FLUFFY FRONTIER EDIT ADDITION - Modular barsigns
=======
	var/list/blacklisted_sign_types = list(/datum/barsign/nova, /datum/barsign/nova/large) // NOVA EDIT ADDITION - Modular barsigns
>>>>>>> 42930d1c74b ([MIRROR] Turns mush cap into an extorgan (#491))

/datum/unit_test/barsigns_name/Run()
	var/list/existing_names = list()

	for(var/sign_type in (subtypesof(/datum/barsign) - /datum/barsign/hiddensigns))
		// NOVA EDIT ADDITION BEGIN - MODULAR BARSIGNS
		if(sign_type in blacklisted_sign_types)
			continue
		// NOVA EDIT ADDITION END
		var/datum/barsign/sign = new sign_type()

		if(!sign.name)
			TEST_FAIL("[sign_type] does not have a name.")
		if(!sign.desc)
			TEST_FAIL("[sign_type] does not have a desc.")

		if(sign.name in existing_names)
			TEST_FAIL("[sign_type] does not have a unique name.")

		existing_names += sign.name

/**
 * Test that an emped barsign displays correctly
 */
/datum/unit_test/barsigns_emp

/datum/unit_test/barsigns_emp/Run()
	var/obj/machinery/barsign/testing_sign = allocate(/obj/machinery/barsign)
	var/datum/barsign/hiddensigns/empbarsign/emp_bar_sign = /datum/barsign/hiddensigns/empbarsign

	testing_sign.emp_act(EMP_HEAVY)

	// make sure we get the correct chosen_sign set
	if(!istype(testing_sign.chosen_sign, emp_bar_sign))
		TEST_FAIL("[testing_sign] got EMPed but did not get its chosen_sign set correctly.")

	// make sure the sign's icon_state actually got set
	var/expected_icon_state = initial(emp_bar_sign.icon_state)
	if(testing_sign.icon_state != expected_icon_state)
		TEST_FAIL("[testing_sign]'s icon_state was [testing_sign.icon_state] when it should have been [expected_icon_state].")

