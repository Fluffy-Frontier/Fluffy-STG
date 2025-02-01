/mob/living/carbon/human/necromorph/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, message_range, datum/saymode/saymode, list/message_mods = list())
	if(!message || stat)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_boldwarning("You cannot send IC messages (muted)."))
			return
		if (!(ignore_spam || forced) && src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if(!marker)
		to_chat(src, span_warning("There is no connection between you and the Marker!"))
		return

	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))

	message = "<span class='necromorph'>[name]([client.key]): [message]</span>"

	marker.hive_mind_message(src, message)

	return TRUE

/mob/living/carbon/human/necromorph/proc/generate_name()
	//We don't have a nicknumber yet, assign one to stick with us
	if(!nicknumber)
		nicknumber = rand(1, 999)
	fully_replace_character_name(real_name, nicknumber)//initial(class.display_name [nicknumber])

/mob/living/carbon/human/necromorph/proc/play_necro_sound(audio_type, volume, vary, extra_range)
	CRASH("play_necro_sound() wasn't overriden")

/mob/living/carbon/human/necromorph/verb/evacuate()
	set name = "Evacuate"
	set category = "Necromorph"

	if(controlling)
		controlling.abstract_move(get_turf(src))
		mind.transfer_to(controlling, TRUE)
		controlling = null

/mob/living/carbon/human/necromorph/proc/add_shield()
	dodge_shield = 5 + (maxHealth*0.15)
	if(hud_used)
		var/datum/hud/necromorph/hud = hud_used
		hud.update_shieldbar(src)
	addtimer(CALLBACK(src, PROC_REF(remove_shield)), 5 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/carbon/human/necromorph/proc/remove_shield()
	dodge_shield = 0
	if(hud_used)
		var/datum/hud/necromorph/hud = hud_used
		hud.update_shieldbar(src)

/mob/living/carbon/human/necromorph/proc/reduce_shield(amount)
	dodge_shield -= amount
	if(hud_used)
		var/datum/hud/necromorph/hud = hud_used
		hud.update_shieldbar(src)

ADMIN_VERB_AND_CONTEXT_MENU(spawn_necromorph, R_NONE, "Spawn a necromorph", "Spawn a necromorph.", ADMIN_CATEGORY_DEBUG)
	user.spawn_necromorph()

/client/proc/spawn_necromorph()
	set category = "Debug"
	set desc = "Spawn a necromorph"
	set name = "Spawn Necromorph"

	if(!check_rights(R_SPAWN))
		return

	if(!length(GLOB.necromorph_markers))
		to_chat(mob, span_warning("There are no markers present!"))
		return

	var/list/list_to_pick = list()
	for(var/datum/necro_class/class as anything in subtypesof(/datum/necro_class))
		if(initial(class.implemented))
			list_to_pick[initial(class.display_name)] = initial(class.necromorph_type_path)

	var/type_to_spawn = list_to_pick[tgui_input_list(usr, "Pick a necromorph to spawn", "Spawning", list_to_pick)]
	if(!type_to_spawn)
		return

	if(!length(GLOB.necromorph_markers))
		to_chat(mob, span_warning("There are no markers present!"))
		return

	var/obj/structure/marker/marker = tgui_input_list(usr, "Pick a marker", "Marker", GLOB.necromorph_markers)

	if(QDELETED(marker))
		return

	var/mob/living/carbon/human/necromorph/necro = new type_to_spawn(get_turf(usr), marker)
	necro.flags_1 |= ADMIN_SPAWNED_1

	log_admin("[key_name(usr)] spawned [type_to_spawn] at [AREACOORD(usr)]")
	SSblackbox.record_feedback("tally", "necro_spawn", 1, "Spawn Necromorph") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


ADMIN_VERB_AND_CONTEXT_MENU(brethren_message, R_NONE, "Brethren Message", "Send a message to the entire necromorph hive as a brethren moon.", ADMIN_CATEGORY_DEBUG, msg as text)
	user.brethren_message(msg)

///Send a message to a marker's entire hivemind as a Brethren Moon.
///Basically the equivelent of answering a prayer or directly messaging as admin, just for the necro hivemind
/client/proc/brethren_message(msg as text)
	set category = "Admin.Fun"
	set desc = "Send a message to the entire necromorph hive as a brethren moon."
	set name = "Brethren Message"

	if(!msg) //If we have no message we don't want to continue
		return

	if(!length(GLOB.necromorph_markers))
		to_chat(src, span_warning("There are no markers!"))
		return //Make sure there is a marker to actually send this to

	var/obj/structure/marker/marker = tgui_input_list(src, "Pick a marker to send a hivemind message to.", "Brethren Message", GLOB.necromorph_markers)
	if(QDELETED(marker))
		return //On the off-chance the marker is destroyed before we send it

	msg = trim(copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN))

	msg = "<span class='brethrenmoon'>Brethren Moons : [msg]</span>"

	marker.hive_mind_message(src, msg)

	return TRUE
