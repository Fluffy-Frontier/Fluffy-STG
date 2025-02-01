#define CYST_SHOOT_ANGLE 90

/obj/structure/necromorph/cyst
	name = "cyst"
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption.dmi'
	icon_state = "cyst-empty"
	max_integrity = 50
	set_dir_on_move = FALSE
	//If we are ready to shoot
	var/ready = FALSE

/obj/structure/necromorph/cyst/Initialize(mapload)
	.=..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_INITIALIZED_ON = PROC_REF(on_entered),
	)
	AddComponent(/datum/component/connect_range, src, loc_connections, 6, FALSE)
	addtimer(CALLBACK(src, PROC_REF(set_ready)), 8 SECONDS)

/obj/structure/necromorph/cyst/update_icon_state()
	icon_state = ready ? "cyst-full" : "cyst-empty"
	return ..()

/obj/structure/necromorph/cyst/proc/on_entered(atom/source, mob/living/carbon/human/arrived)
	if(!ready || isnecromorph(arrived) || isprojectile(arrived))
		return
	var/angle = SIMPLIFY_DEGREES(get_angle(src, arrived) - dir2angle(src.dir))
	if(angle > CYST_SHOOT_ANGLE*0.5)
		return
	if(!can_see(src, arrived, 4))
		return
	shoot_at(arrived)

/obj/structure/necromorph/cyst/proc/shoot_at(atom/movable/target)
	if(!ready)
		return
	ready = FALSE
	update_icon(UPDATE_ICON_STATE)
	var/turf/startloc = get_turf(src)
	var/obj/projectile/cyst/P = new /obj/projectile/cyst(startloc)
	playsound(src,pick(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/cyst/cyst_fire_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/cyst/cyst_fire_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/cyst/cyst_fire_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/cyst/cyst_fire_4.ogg',
	), VOLUME_HIGH, TRUE)
	P.starting = startloc
	P.firer = src
	P.fired_from = src
	P.yo = target.y - startloc.y
	P.xo = target.x - startloc.x
	P.original = target
	P.def_zone = ran_zone()
	P.fire(null, target)
	addtimer(CALLBACK(src, PROC_REF(set_ready)), 8 SECONDS)

/obj/structure/necromorph/cyst/proc/set_ready()
	ready = TRUE
	update_icon(UPDATE_ICON_STATE)

/obj/projectile/cyst
	name = "bio bomb"
	desc = "A wiggling creature which looks fit to burst any moment"
	icon = 'tff_modular/modules/deadspace/icons/effects/corruption.dmi'
	icon_state= "cyst-bomb-primed"
	damage = 45
	damage_type = BURN
	armor_flag = BIO

/datum/action/cooldown/necro/corruption/cyst
	name = "Cyst"
	button_icon_state = "cyst"
	place_structure = /obj/structure/necromorph/cyst
	cost = 15
	can_place_in_sight = FALSE

/datum/action/cooldown/necro/corruption/cyst/can_place(turf/turf_loc)
	.=..()
	if(.)
		return .
	for(var/direction in GLOB.cardinals)
		if(direction & ~REVERSE_DIR(template.dir))
			continue
		var/turf/T = get_step(turf_loc, direction)
		if(T?.density)
			continue
		T = get_step(turf_loc, REVERSE_DIR(template.dir))
		if(T?.density)
			return
		return "You need a wall behind you to place a cyst."
	return

#undef CYST_SHOOT_ANGLE
