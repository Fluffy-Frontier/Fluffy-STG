/mob/living/basic/mouse
	mobility_flags = MOBILITY_FLAGS_REST_CAPABLE_DEFAULT
	icon = 'tff_modular/modules/mouse_ghost/icons/mob/simple/mouse.dmi'

/mob/living/basic/mouse/Initialize()
	. = ..()
	add_verb(src, /mob/living/proc/toggle_resting)

/mob/living/basic/mouse/death()
	if(client)
		client.time_died_as_mouse = world.time
	. = ..()

/mob/living/basic/mouse/update_resting()
	. = ..()
	if(stat == DEAD)
		return
	update_appearance(UPDATE_ICON_STATE)

/mob/living/basic/mouse/update_icon_state()
	. = ..()
	if (resting)
		icon_state = "[icon_living]_rest"
		return
	icon_state = "[icon_living]"

/datum/language_holder/mouse
  understood_languages = list(
    /datum/language/mouse = list(LANGUAGE_ATOM),
  )
  spoken_languages = list(
    /datum/language/mouse = list(LANGUAGE_ATOM),
  )

/datum/language/mouse
  name = "Squeekspeak"
  desc = "Ancient language of the mousekind. Allegedly has over 300 words for cheese."
  key = "n"
  default_priority = 10

  icon = 'tff_modular/modules/mouse_ghost/icons/ui/chat/language.dmi'
  icon_state = "mouse"

  syllables = list(
    list(
      "skee", "ree", "chit", "pip", "squeak", "whik", "fik", "tik", "zit", "kee", "pik", "mip", "skrit", "chirk", "frip",
    ),
  )

/mob/living/basic/mouse
  initial_language_holder = /datum/language_holder/mouse
