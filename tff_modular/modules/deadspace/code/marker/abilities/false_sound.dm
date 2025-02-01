/datum/action/cooldown/necro/psy/false_sound
	name = "False Sound"
	desc = "Generates realistic auditory illusions, including ambient noises or necromorph sounds. Effective for distraction, deception, or stealth."
	button_icon_state = "false_sound"
	cost = 100
	cooldown_time = 2 MINUTES
	marker_flags = SIGNAL_ABILITY_PRE_ACTIVATION

/datum/action/cooldown/necro/psy/false_sound/Activate(turf/target)
	var/mob/camera/marker_signal/caller = owner
	target = get_turf(target)
	if(!target)
		return
	..() //This comes earlier due to spam potential, starts cooldown and cost
	//Add more necromorphs here, perhaps we should make it a define to make sure it's updated
	var/list/category = tgui_input_list(owner, "Pick a necromorph type", "False Sound", GLOB.necromorph_sounds)
	if(!category)
		caller.change_psy_energy(cost) //Refund the cost if nothing is picked
		return TRUE
	var/list/picked_sound = tgui_input_list(owner, "Pick sound type to play", "False Sound", GLOB.necromorph_sounds[category])
	if(!picked_sound)
		caller.change_psy_energy(cost) //Refund the cost if nothing is picked
		return TRUE
	var/volume = VOLUME_MID
	if (picked_sound == SOUND_SHOUT || picked_sound == SOUND_SHOUT_LONG || picked_sound == SOUND_DEATH)
		volume = VOLUME_HIGH
	playsound(target, pick(GLOB.necromorph_sounds[category][picked_sound]), volume, 1, 2)
	return TRUE

/datum/action/cooldown/necro/psy/false_sound/after_activation
	cost = 25
	cooldown_time = 15 SECONDS
	marker_flags = SIGNAL_ABILITY_POST_ACTIVATION
