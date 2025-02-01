//Practically stolen from xenomorph larva, since it is simple and works fine
/datum/action/cooldown/necro/hide
	name = "Hide"
	desc = "Hide underneath random debris, tables, ectera."
	button_icon_state = "alien_hide"
	cooldown_time = 5 SECONDS //So they can't spam hide and unhide
	/// The layer we are on while hiding
	var/hide_layer = ABOVE_NORMAL_TURF_LAYER

/datum/action/cooldown/necro/hide/Activate(atom/target)
	if(owner.layer == hide_layer)
		owner.layer = initial(owner.layer)
		owner.visible_message(
			span_notice("[owner] slowly peeks up from the ground..."),
			span_noticealien("You stop hiding."),
		)
		owner.pass_flags &= ~PASSMOB //Removes mob passing when not hiding

	else
		owner.layer = hide_layer
		owner.visible_message(
			span_name("[owner] scurries to the ground!"),
			span_noticealien("You are now hiding."),
		)
		owner.pass_flags |= PASSMOB //Lets hopper pass through mobs when hiding

	return TRUE
