/datum/action/cooldown/necro/psy/whisper
	name = "Whisper"
	desc = "Allows you to broadcast a subliminal message into the mind of a receptive target. Can be used on anyone visible."
	button_icon_state = "whisper"
	cost = 30

/datum/action/cooldown/necro/psy/whisper/PreActivate(mob/living/target)
	if(!istype(target))
		return FALSE
	if(!target.client)
		to_chat(owner, span_notice("[target] is SSD or doesn't have a player."))
		return FALSE
	return ..()

/datum/action/cooldown/necro/psy/whisper/Activate(mob/living/target)
	var/mob/camera/marker_signal/caller = owner
	var/message = tgui_input_text(caller, "Write a message to send to [target.name]", "Whisper")
	if(!message)
		return TRUE
	.=..()
	to_chat(target, "<span class='necromorph'>[message]</span>")
	caller.marker.hive_mind_message(caller, "[caller] -> [target] <span class='necromorph'>[message]</span>")
