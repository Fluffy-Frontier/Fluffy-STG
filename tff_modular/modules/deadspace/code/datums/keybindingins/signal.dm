/datum/keybinding/marker_signal
	category = CATEGORY_MISC

/datum/keybinding/marker_signal/can_use(client/user)
	return ismarkereye(user.mob)

/datum/keybinding/marker_signal/rotate_necromorph_structure
	hotkey_keys = list("R", "Southwest")
	name = "rotate_necromorph_structure"
	full_name = "Rotate structure"
	description = "Rotates necromorph structure while in placing mode."
	keybind_signal = COMSIG_KB_MSIGNAL_ROTATE_STRUCTURE_DOWN

/datum/keybinding/marker_signal/rotate_necromorph_structure/down(client/user)
	. = ..()
	if(.)
		return
	if(istype(user.mob.click_intercept, /datum/action/cooldown/necro/corruption))
		var/datum/action/cooldown/necro/corruption/placement_action = user.mob.click_intercept
		var/image/template = placement_action.template
		template.dir = turn(template.dir, 45)
		template.color = placement_action.can_place(template.loc) ?  COLOR_RED : COLOR_GREEN
	return TRUE
