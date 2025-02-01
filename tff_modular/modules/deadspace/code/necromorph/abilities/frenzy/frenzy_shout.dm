
/datum/action/cooldown/necro/frenzy_shout
	name = "Battle Cry"
	desc = "Grants a 30% move and attackspeed buff to other nearby necromorphs, damages non necromorphs."
	cooldown_time = 30 SECONDS
	activate_keybind = COMSIG_KB_NECROMORPH_ABILITY_FRENZY_DOWN
	var/distance = 7
	var/duration = 60 SECONDS
	var/type_buff = /datum/component/statmod/frenzy_buff

/datum/action/cooldown/necro/frenzy_shout/PreActivate(atom/target)
	//First lets check we can actually do it
	if (owner.incapacitated)
		return FALSE

	var/mob/living/carbon/human/H = owner
	if (!istype(H))
		return FALSE

	var/check_head = FALSE
	for(var/obj/item/bodypart/bp as anything in H.bodyparts)
		if(bp.body_zone == BODY_ZONE_HEAD)
			check_head = TRUE

	if(!check_head)
		return FALSE

	. = ..()

/datum/action/cooldown/necro/frenzy_shout/Activate(atom/target)
	StartCooldown()
	var/list/tobuff = list()

	//Okay we are good to go. Lets find our list of allies
	for (var/mob/living/L in range(owner, distance))

		if (L == owner)
			continue //Its a support ability, doesnt affect yourself

		//Selective buffing
		if (!faction_check(owner.faction, L.faction))
			continue

		if (L.stat == DEAD)
			continue //No point buffing the dead


		tobuff += L

	//Alrighty lets do this!
	for (var/mob/living/L in tobuff)
		var/datum/component/statmod/frenzy_buff/FB = GetComponent(L, type_buff)
		//Check if its already buffed, unlikely but we don't want duplicate extensions
		//If it already exists, we'll extend the duration instead of remaking it. This ensures the message about muscle twitching doesn't repeat
		if (istype(FB))
			FB.set_timer(duration)
		else
			L.AddComponent(type_buff, duration)

	if (tobuff.len)
		to_chat(owner, span_notice("You have empowered your allies! [english_list(tobuff,"","","\n")]"))
	else
		to_chat(owner, span_notice("Nobody hears your call."))

	return TRUE
