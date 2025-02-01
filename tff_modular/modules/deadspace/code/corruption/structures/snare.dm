/obj/structure/necromorph/snare
	name = "snare"
	desc = "A coiling looped biomass that twists and trips anything that comes too close."
	desc_controls = "Tripping only occurs when running or sprinting, walk to avoid being tripped."
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption.dmi'
	icon_state = "snare"
	max_integrity = 50

/obj/structure/necromorph/snare/Initialize(mapload)
	.=..()
	AddComponent(/datum/component/slippery/necro, 5 SECONDS, NO_SLIP_WHEN_WALKING|SLIDE|GALOSHES_DONT_HELP)

/datum/action/cooldown/necro/corruption/snare
	name = "Snare"
	button_icon_state = "snare"
	place_structure = /obj/structure/necromorph/snare
	can_place_in_sight = TRUE
	cost = 40

//This can stay empty, since we don't really need to change anything in the parent
/datum/component/slippery/necro

//The special check, if it wasn't for slippery/clowning existing I wouldn't even do this
/datum/component/slippery/necro/Slip(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(isnecromorph(arrived)) //The entire reason we made a child component, ain't it nasty?
		return
	..()
