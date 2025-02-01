#define LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE 192

/mob/living/carbon/human/necromorph
	name = "Necromorph"
	desc = "What the hell is THAT?"
	icon = 'tff_modular/modules/deadspace/icons/necromorphs/slasher/fleshy.dmi'
	verb_say = "roars"
	verb_ask = "roars"
	verb_exclaim = "roars"
	verb_whisper = "roars"
	verb_sing = "roars"
	verb_yell = "roars"
	melee_damage_upper = 5
	melee_damage_lower = 5
	health = 5
	maxHealth = 5
	armor_type = null
	//TRUE for now
	rotate_on_lying = TRUE
	mob_size = MOB_SIZE_HUMAN
	see_in_dark = 8
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
	hud_type = /datum/hud/necromorph
	faction = list(FACTION_NECROMORPH)
	initial_language_holder = /datum/language_holder/necro_talk
	type_of_meat = /obj/item/food/meat/slab/human/mutant/necro
	mob_biotypes = MOB_ORGANIC|MOB_UNDEAD|MOB_HUMANOID
	mobility_flags = MOBILITY_MOVE|MOBILITY_STAND|MOBILITY_PULL|MOBILITY_REST|MOBILITY_LIEDOWN|MOBILITY_UI
	base_pixel_x = -8
	base_pixel_y = 0
	pixel_x = -8
	alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	var/nicknumber = 0

	/// "Shield" that appears after dodging. Absorbs incom
	var/dodge_shield = 0

	/// Necromorph class type we are using, shouldn't be a ref
	/// Use marker?.necro_classes[class].your_var||initial(class.your_var) if you need to get a var
	var/datum/necro_class/class = /datum/necro_class

	var/necro_species = /datum/species/necromorph

	var/obj/structure/marker/marker

	/// whether the necromorph mobhud is activated or not.
	var/necro_mobhud = FALSE

	/// whether the necromorph has been selected by the marker as a leader.
	var/marker_chosen_lead

	/// Notification spam controls
	var/recent_notice = 0
	var/notice_delay = 2 SECONDS

	/// The necromorph currently tracked by the necro_tracker arrow
	var/atom/tracked

	/// see_in_dark value while consicious
	var/conscious_see_in_dark = 8
	/// see_in_dark value while unconscious
	var/unconscious_see_in_dark = 5

	/// bitwise flags denoting things a necromorph can and cannot do, or things a necromorph is or is not. uses defines.
	var/necro_flags = NONE

	/// Wether this necromorph is charging at the moment
	var/charging = FALSE

	/// How good are we at penetrating armour
	var/armour_penetration = 0

	var/attack_effect = ATTACK_EFFECT_SLASH
	/// Signal controlling this necromorph at the moment
	var/mob/camera/marker_signal/controlling


/datum/reagent/blood/necromorph
	name = "X"
	color = rgb(94, 44, 4)

/obj/item/food/meat/slab/human/mutant/necro
	desc = "Eating it doesn't sound like a good idea."
	food_reagents = list(/datum/reagent/toxin/carpotoxin = 5)
	tastes = list("rotten" = 1)
	foodtypes = MEAT|JUNKFOOD|RAW|TOXIC
	venue_value = FOOD_MEAT_MUTANT

/datum/language_holder/necro_talk
	understood_languages = list(/datum/language/necro = list(LANGUAGE_MIND))
	spoken_languages = list(/datum/language/necro = list(LANGUAGE_MIND))
	omnitongue = TRUE

/datum/language/necro
	name = "Necromorph"
	desc = "Growling sounds necromorphs use to communicate."
	flags = NO_STUTTER|TONGUELESS_SPEECH|LANGUAGE_HIDE_ICON_IF_NOT_UNDERSTOOD
	key = "x"
	syllables = list("Hrr", "rHr", "rrr")
	default_priority = 50

	icon_state = "xeno"

///Checks if the necro is enhanced, and if so do a different interaction in the ability.
///Can be used in pretty much anything to do special stuff without needing new procs, sky is the limit.
/proc/is_enhanced(mob/living/carbon/human/necromorph/N)
	.=FALSE
	if(initial(N.class.tier) >= 2) //Necro tier would only change through adminbus, so we can just grab the initial
		return TRUE
	return


/datum/movespeed_modifier/dsnecro_brute
	multiplicative_slowdown = 2.5

/datum/movespeed_modifier/dsnecro_divider
	multiplicative_slowdown = -0.1

/datum/movespeed_modifier/dsnecro_e_exploder
	multiplicative_slowdown = 0.1

/datum/movespeed_modifier/dsnecro_e_infector
	multiplicative_slowdown = 0.3

/datum/movespeed_modifier/dsnecro_exploder
	multiplicative_slowdown = 0.2

/datum/movespeed_modifier/dsnecro_hopper
	multiplicative_slowdown = -1

/datum/movespeed_modifier/dsnecro_hunter
	multiplicative_slowdown = 0.2

/datum/movespeed_modifier/dsnecro_infector
	multiplicative_slowdown = 0.6

/datum/movespeed_modifier/dsnecro_lurker
	multiplicative_slowdown = -0.1

/datum/movespeed_modifier/dsnecro_e_twitcher
	multiplicative_slowdown = -1

/datum/movespeed_modifier/dsnecro_puker
	multiplicative_slowdown = 0.1

/datum/movespeed_modifier/dsnecro_slasher
	multiplicative_slowdown = 0.1

/datum/movespeed_modifier/dsnecro_twitcher
	multiplicative_slowdown = -0.7

/datum/movespeed_modifier/dsnecro_ubermorph
	multiplicative_slowdown = -0.3

#undef LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
