/datum/action/cooldown/necro/psy/scrawl
	name = "Bloody Scrawl"
	desc = "Writes a message in blood. Should be at least 3 tiles away from another bloody scrawl!"
	button_icon_state = "writing"
	cost = 15

/datum/action/cooldown/necro/psy/scrawl/Activate(atom/target)
	var/turf/target_turf = get_turf(target)
	if(isgroundlessturf(target_turf) || target_turf.density)
		to_chat(owner, span_warning("There is no space to write on!"))
		return
	//Using for loop because of compiler optiization
	for(var/obj/effect/decal/cleanable/blood/writing/writing in range(3, target_turf))
		to_chat(owner, span_warning("Another bloody scrawl is too close!"))
		return
	var/text = tgui_input_text(owner, "Write a message", "Bloody Scrawl")
	if(!text)
		return TRUE
	..()
	new /obj/effect/decal/cleanable/blood/writing(target_turf, text, TRUE)
	target_turf.visible_message(span_warning("Invisible fingers crudely paint something in blood on \the [target_turf]."))
	return TRUE

/obj/effect/decal/cleanable/blood/writing
	icon_state = "tracks"
	desc = "It looks like a writing in blood."
	icon = 'tff_modular/modules/deadspace/icons/effects/blood.dmi'
	gender = NEUTER
	random_icon_states = list("writing1","writing2","writing3","writing4","writing5")
	should_dry = FALSE
	color = COLOR_BLOOD_WRITING
	transform = matrix(2, 0, 0, 0, 2, 0)
	var/message
	var/creator

/obj/effect/decal/cleanable/blood/writing/Initialize(mapload, text, fade_in)
	. = ..()
	message = text
	creator = usr?.ckey
	if(fade_in)
		alpha = 0
		animate(src, alpha = 255, time = 1 SECONDS, flags = ANIMATION_PARALLEL)	//Cool fade in effect

/obj/effect/decal/cleanable/blood/writing/examine(mob/user)
	. = ..()
	. += "It reads: <font color='[color]'>\"[message]\"</font>"
