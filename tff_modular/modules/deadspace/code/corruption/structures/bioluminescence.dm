/obj/structure/necromorph/lamp
	name = "bioluminescence nodule"
	desc = "A candle to light the way home"
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption.dmi'
	icon_state = "light"
	light_power = 1
	light_range = 3
	light_color = COLOR_BRIGHT_ORANGE
	max_integrity = 20

/datum/action/cooldown/necro/corruption/lamp
	name = "Bioluminescence"
	button_icon_state = "bioluminescence"
	place_structure = /obj/structure/necromorph/lamp
	can_place_in_sight = TRUE
	cost = 2
