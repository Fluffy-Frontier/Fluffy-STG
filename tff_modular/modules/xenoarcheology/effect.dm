#define ARTIFACT_SMALL_POWER "small"
#define ARTIFACT_MEDIUM_POWER "medium"
#define ARTIFACT_LARGE_POWER "big"

#define ARTIFACT_ACTIVATION_MESSAGES list(\
	"momentarily glows brightly!",\
	"distorts slightly for a moment!",\
	"flickers slightly!",\
	"vibrates!",\
	"shimmers slightly for a moment!")

#define ARTIFACT_DEACTIVATION_MESSAGES list(\
	"grows dull!",\
	"fades in intensity!",\
	"suddenly becomes very still!",\
	"suddenly becomes very quiet!")

#define NO_ANOMALY_PROTECTION 1
#define FULL_ANOMALY_PROTECTION 0

/datum/artifact_effect
	///what is our energy release method
	var/release_method = ARTIFACT_EFFECT_TOUCH
	///our effect range
	var/range = 4
	///our trigger to become activated
	var/trigger = TRIGGER_TOUCH
	///where are we
	var/atom/holder
	///is our artifact is processing
	var/activated = FALSE
	///current ammount of charges
	var/current_charge = 0
	///maximum ammount of charges
	var/maximum_charges = 10
	///our recharge speed, process in artifact
	var/recharge_speed = 1
	///used in radiocarbon_spectrometer
	var/artifact_id = ""
	///activation cost for touch cast
	var/activation_touch_cost = 3
	///activation cost for aura cast
	var/activation_aura_cost = 0
	///activation cost for pulse cast
	var/activation_pulse_cost = 0
	///used for logs and science tool
	var/log_name = "unknown"
	///purely used for getDescription
	var/type_name = ARTIFACT_EFFECT_UNKNOWN

/datum/artifact_effect/New(atom/location)
	..()
	holder = location
	release_method = pick(ARTIFACT_ALL_RELEASE_METHODS)
	trigger = pick(ARTIFACT_POSSIBLE_TRIGGERS)
	create_artifact_type(50, 70, 30)
	activation_pulse_cost = maximum_charges

/datum/artifact_effect/Destroy(force, ...)
	STOP_PROCESSING(SSobj, src)
	return ..()

/**
 * Picks artifact type
 */
/datum/artifact_effect/proc/create_artifact_type(chance_small, chance_medium, chance_large)
	var/artifact_power = pick_weight(list(
		ARTIFACT_SMALL_POWER = chance_small,
		ARTIFACT_MEDIUM_POWER = chance_medium,
		ARTIFACT_LARGE_POWER = chance_large))
	switch(artifact_power)
		if(ARTIFACT_SMALL_POWER)
			maximum_charges = rand(5, 20)
			range = rand(2, 4)
		else if(ARTIFACT_MEDIUM_POWER)
			maximum_charges = rand(15, 30)
			range = rand(5, 7)
		else if(ARTIFACT_LARGE_POWER)
			maximum_charges = rand(20, 50)
			range = rand(7, 10)
		else
			message_admins("Failed to create artifact type. Tell coders about it.")

/**
 * Invokes async toggle artifact
 */
/datum/artifact_effect/proc/ToggleActivate(reveal_toggle = TRUE)
	INVOKE_ASYNC(src, PROC_REF(toggle_artifact_effect), reveal_toggle)

/**
 * Stops/starts processing, updates artifact icon, displays visible_message
 */
/datum/artifact_effect/proc/toggle_artifact_effect(reveal_toggle)
	activated = !activated
	if(activated)
		START_PROCESSING(SSobj, src)
	if(!activated)
		STOP_PROCESSING(SSobj, src)
	if(istype(holder, /obj/machinery/artifact))
		var/obj/machinery/artifact/Artifact = holder
		Artifact.update_icon()
	if(!reveal_toggle)
		return
	if(!holder)
		return
	var/display_msg = activated ? pick(ARTIFACT_ACTIVATION_MESSAGES): pick(ARTIFACT_DEACTIVATION_MESSAGES)
	var/atom/toplevelholder = holder
	while(!istype(toplevelholder.loc, /turf))
		toplevelholder = toplevelholder.loc
	if(iscarbon(toplevelholder)) // When utilizer works, the holder is human and we dont display his icon (costs too much)
		toplevelholder.visible_message("<span class='warning'>[toplevelholder] [display_msg]</span>")
	else
		toplevelholder.visible_message("<span class='warning'>[toplevelholder] [display_msg]</span>")

/**
 * Turns effect off, no icon update, doesnt display message
 */
/datum/artifact_effect/proc/turn_effect_off()
	if(activated)
		STOP_PROCESSING(SSobj, src)
		activated = FALSE

/**
 * Checks for a user, anomaly protection, tries to drain artifact charg
 * returns true if charge was drained, otherwise returns false
 */
/datum/artifact_effect/proc/DoEffectTouch(mob/user)
	if(!user)
		return FALSE
	if(!get_anomaly_protection(user)) //we ignore things with full anomaly protection
		return FALSE
	if(try_drain_charge(activation_touch_cost))
		return TRUE
	return FALSE

/**
 * Tries to drain charge
 * returns true if charge was drained, otherwise returns false
 */
/datum/artifact_effect/proc/DoEffectAura()
	if(try_drain_charge(activation_aura_cost))
		return TRUE
	return FALSE

/**
 * Tries to drain charge
 * returns true if charge was drained, otherwise returns false
 */
/datum/artifact_effect/proc/DoEffectPulse()
	if(try_drain_charge(activation_pulse_cost))
		return activation_pulse_cost
	return FALSE

/**
 * Only called in artifact_unknown code on qdel
 */
/datum/artifact_effect/proc/DoEffectDestroy()
	return

/**
 * Updates effect on /move
 */
/datum/artifact_effect/proc/UpdateMove()
	return

/**
 * Tries to subtract given number from current_charge
 * returns true if the result above zero, returns false otherwise
 */
/datum/artifact_effect/proc/try_drain_charge(charges_drained)
	if((current_charge - charges_drained) < 0)
		return FALSE
	current_charge -= charges_drained
	return TRUE

/datum/artifact_effect/process()
	current_charge = min(current_charge + recharge_speed, maximum_charges)
	if(release_method == ARTIFACT_EFFECT_AURA)
		DoEffectAura()
	if(release_method == ARTIFACT_EFFECT_PULSE)
		DoEffectPulse()

/**
 * Returns type effect
 * used in artifact analyser
 */
/datum/artifact_effect/proc/getDescription()
	. = "<b>"
	switch(type_name)
		if(ARTIFACT_EFFECT_ENERGY)
			. += "Concentrated energy emissions"
		if(ARTIFACT_EFFECT_PSIONIC)
			. += "Intermittent psionic wavefront"
		if(ARTIFACT_EFFECT_ELECTRO)
			. += "Electromagnetic energy"
		if(ARTIFACT_EFFECT_PARTICLE)
			. += "High frequency particles"
		if(ARTIFACT_EFFECT_ORGANIC)
			. += "Organically reactive exotic particles"
		if(ARTIFACT_EFFECT_BLUESPACE)
			. += "Interdimensional/bluespace? phasing"
		if(ARTIFACT_EFFECT_SYNTH)
			. += "Atomic synthesis"
		else
			. += "Low level energy emissions"

	. += "</b> have been detected <b>"

	switch(release_method)
		if(ARTIFACT_EFFECT_TOUCH)
			. += "interspersed throughout substructure and shell."
		if(ARTIFACT_EFFECT_AURA)
			. += "emitting in an ambient energy field."
		if(ARTIFACT_EFFECT_PULSE)
			. += "emitting in periodic bursts."
		else
			. += "emitting in an unknown way."

	. += "</b>"

	switch(trigger)
		if(TRIGGER_TOUCH, TRIGGER_WATER, TRIGGER_ACID, TRIGGER_VOLATILE, TRIGGER_TOXIN)
			. += " Activation index involves <b>physical interaction</b> with artifact surface."
		if(TRIGGER_FORCE, TRIGGER_ENERGY, TRIGGER_HEAT, TRIGGER_COLD)
			. += " Activation index involves <b>energetic interaction</b> with artifact surface."
		if(TRIGGER_PHORON, TRIGGER_OXY, TRIGGER_CO2, TRIGGER_NITRO)
			. += " Activation index involves <b>precise local atmospheric conditions</b>."
		else
			. += " Unable to determine any data about activation trigger."


/**
 * Calculates mob effect protection
 * returns NO_ANOMALY_PROTECTION if not human, returns calculated protection otherwise
 * higher returning number means less protection
 */
/proc/get_anomaly_protection(mob/living/carbon/human/Human)
	if(!ishuman(Human))
		return NO_ANOMALY_PROTECTION
	var/protection = 0
	var/obj/item/bodypart/chest/userchest
	var/obj/item/bodypart/head/userhead
	for (var/obj/item/bodypart/checkpart in Human.bodyparts)
		if (istype(checkpart, /obj/item/bodypart/chest))
			userchest = checkpart
		else if (istype(checkpart, /obj/item/bodypart/head))
			userhead = checkpart
	// use biohazard suits!
	if(userchest && Human.check_armor(userchest, BIO) >= 85)
		protection += 0.5
	if(userhead && Human.check_armor(userhead, BIO) >= 85)
		protection += 0.3
	// latex gloves and science goggles also give a bit of bonus protection
	if(istype(Human.gloves, /obj/item/clothing/gloves/latex))
		protection += 0.1
	if(istype(Human.glasses, /obj/item/clothing/glasses/science))
		protection += 0.1
	return clamp(NO_ANOMALY_PROTECTION - protection, FULL_ANOMALY_PROTECTION, NO_ANOMALY_PROTECTION)

#undef ARTIFACT_SMALL_POWER
#undef ARTIFACT_MEDIUM_POWER
#undef ARTIFACT_LARGE_POWER
#undef ARTIFACT_ACTIVATION_MESSAGES
#undef ARTIFACT_DEACTIVATION_MESSAGES
#undef NO_ANOMALY_PROTECTION
#undef FULL_ANOMALY_PROTECTION
