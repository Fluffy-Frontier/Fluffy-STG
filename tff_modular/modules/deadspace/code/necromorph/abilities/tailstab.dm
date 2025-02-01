/datum/action/cooldown/necro/swing/leaper
	name = "Tail Stab"
	desc = "Stab your victim with your tails."
	click_to_activate = TRUE
	cooldown_time = 10 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_TAILSTAB_DOWN
	swing_time = 0.7 SECONDS //ORIGINAL 1.2
	move_time = 0.5 SECONDS
	angle = 40
	range = 1
	visual_type = /obj/effect/temp_visual/swing/leaper
	hitsound = 'sound/items/weapons/guillotine.ogg' //I really like the sound of this one
	damage = 30 //Same as leap
	knockdown_time = 0
	actively_moving = FALSE

/datum/action/cooldown/necro/swing/leaper/enhanced
	name = "Enhanced Tail Stab"
	desc = "Stab your victim with your tails, this does more damage and has a wider angle then the usual tail stab."
	cooldown_time = 9 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_TAILSTAB_DOWN
	angle = 55
	visual_type = /obj/effect/temp_visual/swing/leaper/enhanced
	damage = 50 //Same as enhanced leap
	knockdown_time = 5 //In deciseconds. Very short knockdown, very dangerous to fight e-leapers alone

/datum/action/cooldown/necro/swing/leaper/PreActivate(atom/target)
	var/mob/living/carbon/leaper = owner
	if(!leaper.get_bodypart(BODY_ZONE_L_LEG) && !leaper.get_bodypart(BODY_ZONE_R_LEG)) //Check for tails
		to_chat(owner, span_warning("You have no tails, you cannot tail stab!"))
		StartCooldown(20 SECONDS) //Cooldown is longer without tails, so you don't spam it
		return FALSE //We don't want the leaper tailstabbing if it has no tails

	return ..()

//We want a custom one that doesn't move you and checks for tails
/datum/action/cooldown/necro/swing/leaper/Activate(atom/target)
	StartCooldown()
	target = get_turf(target)
	owner.face_atom(target)

	actively_moving = FALSE
	swing_target = target
	windup()
	return TRUE

/datum/action/cooldown/necro/swing/leaper/windup()
	var/cached_pixel_x = owner.pixel_x
	var/cached_pixel_y = owner.pixel_y

	//Absolutely silly check so leaper doesn't try to backflip when facing west
	//I could just make a matrix, but this kind of situation will only show up twice in DS13
	if(owner.dir == WEST)
		animate(
			owner,
			transform = turn(matrix(), -45),
			time = 0.3 SECONDS, //ORIGINAL 0.6
			easing = BACK_EASING
		)
	else
		animate(
			owner,
			transform = turn(matrix(), 45),
			time = 0.3 SECONDS, //ORIGINAL 0.6
			easing = BACK_EASING
		)
	animate(
		transform = null,
		pixel_x = cached_pixel_x,
		pixel_y = cached_pixel_y,
		time = 0.3 SECONDS, //ORIGINAL 0.5
		easing = BACK_EASING
	)
	sleep(0.3 SECONDS) //Should be exactly as long as the first animation
	swing() //Should swing just as the first animation ends

/obj/effect/temp_visual/swing/leaper
	name = "tail"
	icon = 'tff_modular/modules/deadspace/icons/necromorphs/swinging_limbs.dmi'
	base_icon_state = "tongue"
	icon_state = "tongue" //This is a placeholder until we get a leaper tail stab sprite
	randomdir = FALSE
	pixel_x = -53
	pixel_y = -48
	variable_icon = FALSE
	swing_sound = list(
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/leaper/leaper_tailswing_1.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/leaper/leaper_tailswing_2.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/leaper/leaper_tailswing_3.ogg',
		'tff_modular/modules/deadspace/sound/effects/creatures/necromorph/leaper/leaper_tailswing_4.ogg',
		)

/obj/effect/temp_visual/swing/leaper/enhanced
	icon = 'tff_modular/modules/deadspace/icons/necromorphs/swinging_limbs.dmi'
	base_icon_state = "tongue"
	icon_state = "tongue" //This is a placeholder until we get a enhanced leaper tail stab sprite
	pixel_x = -53
	pixel_y = -48

