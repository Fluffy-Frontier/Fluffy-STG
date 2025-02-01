/datum/action/cooldown/necro/psy/meddle
	name = "Meddle"
	desc = "A context sensitive spell which does different things depending on the target. Interfaces with machines, moves items, messes with computers and office appliances."
	button_icon_state = "meddle"
	cost = 10

/datum/action/cooldown/necro/psy/meddle/PreActivate(obj/target)
	if(!isobj(target))
		return TRUE
	return ..()

/datum/action/cooldown/necro/psy/meddle/Activate(obj/target)
	..()
	target.meddle_act(owner)
	return TRUE

/obj/proc/meddle_act(mob/user)
	var/direction = prob(50) ? -1 : 1
	animate(src, pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
	animate(pixel_x = pixel_x - (SHAKE_ANIMATION_OFFSET * 2 * direction), time = 1)
	animate(pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_IN)
