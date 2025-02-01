//Still need some tweaks. Kinda useless in it's current state
/datum/action/cooldown/necro/dodge
	name = "Dodge"
	desc = "Allows you to dodge bullets."
	cooldown_time = 20 SECONDS
	click_to_activate = TRUE
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_DODGE_DOWN

/datum/action/cooldown/necro/dodge/Activate(atom/target)
	. = TRUE
	var/mob/living/carbon/human/necromorph/holder = owner
	if(!isturf(holder.loc))
		to_chat(holder, span_notice("You need more space to dodge."))
		return
	//To ensure people won't spam
	StartCooldown(1 SECONDS)

	var/atom/old_loc = holder.loc
	step_to(holder, get_step(owner, get_dir(holder, target)))

	if(old_loc != holder.loc)
		StartCooldown()
		holder.visible_message(span_danger("[holder] nimbly dodges to the side!"))
		//Randomly selected sound
		var/sound_type = pick_weight(list(SOUND_SPEECH = 6, SOUND_ATTACK = 2, SOUND_PAIN = 1.5, SOUND_SHOUT = 1))
		holder.play_necro_sound(sound_type, VOLUME_QUIET)
		holder.add_shield()
	else
		to_chat(owner, span_notice("You need more space to dodge."))
