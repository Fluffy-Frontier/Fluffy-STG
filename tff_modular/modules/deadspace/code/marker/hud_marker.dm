#define MARKER_DETECT_HUD "17"

/datum/hud/marker_signal/marker
	var/atom/movable/screen/marker_control

/datum/atom_hud/marker_detector
	hud_icons = list(MARKER_DETECT_HUD)

/datum/atom_hud/marker_detector/show_to(mob/new_viewer)
	. = ..()
	if(!new_viewer || hud_users_all_z_levels.len != 1)
		return
	for(var/mob/camera/marker_signal/eye as anything in GLOB.markers_signals)
		eye.update_marker_detect_hud()
