/client/verb/eventmakerwho()
	set category = "Admin"
	set name = "EventersWho"
	var/msg = "<b>Current Eventmakers:</b>\n"
	for(var/X in GLOB.eventmakers)
		var/client/C = X
		if(!C)
			GLOB.eventmakers -= C
			continue // weird runtime that happens randomly
		var/suffix = ""
		if(holder)
			if(isobserver(C.mob))
				suffix += " - Observing"
			else if(istype(C.mob,/mob/dead/new_player))
				suffix += " - Lobby"
			else
				suffix += " - Playing"

			if(C.is_afk())
				suffix += " (AFK)"
		msg += span_infoplain("\t[C][suffix]\n")
	to_chat(src, msg)

/client/proc/reeventmake()
	set name = "ReEvent"
	set category = "Admin"
	set desc = "Regain your eventer powers."

	var/datum/admins/eventmakers/eventmaker = GLOB.deadmins[ckey]
	if(!eventmaker)
		eventmaker = GLOB.eventmaker_datums[ckey]
		if (!eventmaker)
			var/msg = " is trying to reeventer but they have no eventmaker entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	eventmaker.associate(src)

	if (!holder)
		return //This can happen if an admin attempts to vv themself into somebody elses's deadmin datum by getting ref via brute force

	to_chat(src, span_interface("You are now an eventmaker."), confidential = TRUE)
	message_admins("[src] re-eventmakered themselves\[Eventmaker\].")
	log_admin("[src] re-eventmakered themselves\[Eventmaker\].")
	BLACKBOX_LOG_ADMIN_VERB("ReEventered")

/client/proc/deeventmake()
	set name = "DeEvent"
	set category = "Admin"
	set desc = "Lose your eventer powers."

	if(holder && is_eventmaker())
		holder.deactivate()
		to_chat(src, span_interface("You are now a normal player."))
		log_admin("[key_name(src)] deeventmakered themselves.")
		message_admins("[key_name_admin(src)] deeventmakered themselves.")
		BLACKBOX_LOG_ADMIN_VERB("DeEventered")

ADMIN_VERB(cmd_eventmaker_say, R_NONE, "ESay", "Send a message to eventmakes", ADMIN_CATEGORY_MAIN, message as text)
	message = emoji_parse(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	if(!message)
		return

	user.mob.log_talk(message, LOG_ASAY)
	message = keywords_lookup(message)
	message = "[span_eventmaker("[span_prefix("EVENTCHAT:")] <EM>[key_name_admin(user)]</EM> [ADMIN_FLW(user.mob)]: <span class='message linkify'>[message]")]</span></font>"
	to_chat(GLOB.admins | GLOB.eventmakers,
		type = MESSAGE_TYPE_ADMINCHAT,
		html = message,
		confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Esay")
