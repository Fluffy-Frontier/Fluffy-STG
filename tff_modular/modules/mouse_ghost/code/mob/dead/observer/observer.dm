/mob/ghostize()
	. = ..()
	var/mob/dead/observer/ghost = .
	ghost?.client?.time_died_as_mouse = ghost?.client?.player_details.time_of_death

/mob/dead/observer/verb/become_mouse()
	set name = "Become mouse"
	set category = "Ghost"

	if(CONFIG_GET(flag/mouse_ghost_disable))
		to_chat(src, span_warning("Spawning as a mouse is currently disabled."))
		return

	if(!client)
		return
	if(mind && mind.current && mind.current.stat != DEAD && can_reenter_corpse)
		to_chat(src, span_warning("Your non-dead body prevent you from respawning."))
		return

	if (CONFIG_GET(flag/mouse_ghost_only_veteran) && !SSplayer_ranks.is_veteran(client))
		to_chat(src, span_warning("At the moment, this requires veteran rank."))
		return

	var/mouse_ghost_respawn_time = CONFIG_GET(number/mouse_ghost_respawn_time)
	var/timedifference = world.time - client.time_died_as_mouse
	if(client.time_died_as_mouse && timedifference <= mouse_ghost_respawn_time * 600)
		var/timedifference_text
		timedifference_text = time2text(mouse_ghost_respawn_time * 600 - timedifference,"mm:ss")
		to_chat(src, span_warning("You may only spawn again as a mouse more than [mouse_ghost_respawn_time] minutes after your death. You have [timedifference_text] left."))
		return

	var/response = tgui_alert(src, "Are you -sure- you want to become a mouse?","Are you sure you want to squeek?",list("Squeek!","Nope!"))
	if(response != "Squeek!") return  //Hit the wrong key...again.

	var/mob/living/basic/mouse/host
	var/obj/machinery/atmospherics/components/unary/vent_pump/vent_found
	var/list/vents = list()
	// Поиск подходящей вентиляции
	for(var/obj/machinery/atmospherics/components/unary/vent_pump/temp_vent in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/atmospherics/components/unary/vent_pump))
		if(QDELETED(temp_vent))
			continue
		if(is_station_level(temp_vent.loc.z) && !temp_vent.welded)
			var/datum/pipeline/temp_vent_parent = temp_vent.parents[1]
			if(!temp_vent_parent)
				continue
			if(length(temp_vent_parent.other_atmos_machines) > 20)
				vents += temp_vent
	if(vents.len)
		vent_found = pick(vents)
		host = new /mob/living/basic/mouse/(get_turf(vent_found))
	else
		to_chat(src, span_warning("Unable to find any unwelded vents to spawn mice at."))

	if(host)
		host.ckey = src.ckey
		host.move_into_vent(vent_found)
		to_chat(host, span_info("You are now a mouse. Try to avoid interaction with players, and do not give hints away that you are more than a simple rodent."))
