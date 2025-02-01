///The percentage of damage at which a bodypart can start to be dismembered.
#define LIMB_DISMEMBERMENT_PERCENT 0.9

/// Shown to all mobs not just the user
#define DO_PUBLIC (1<<5) //ffdefines/code/flags.dm

/// Deafult atmos for Mara 17 outside
#define MARASTATION_DEFAULT_ATMOS list(GAS_OXYGEN = 14, GAS_NITROGEN = 30, GAS_CO2 = 60) ; temperature = 180 //atmospherics

/// As of now only used when placing marker structures
/mob
	var/datum/mouse_move_intercept //code/modules/mob/mob_defines.dm

// Anything aboe this layer is not "on" a turf for the purposes of washing
#define NECROMORPH_CORRUPTION_LAYER 2.56 //layers.dm


#define SMOOTH_GROUP_NECROMORPHS S_OBJ(78) ///obj/structure/corruption //icon_smoothing.dm

#define SHAKE_ANIMATION_OFFSET 4 //code/modules/mob/living/carbon/carbon_defence
//helpers/matrices
/atom/proc/shake_animation() //CHANGE TO ORIGINAL?
		var/direction = prob(50) ? -1 : 1
		animate(src, pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = QUAD_EASING | EASE_OUT, flags = ANIMATION_PARALLEL)
		animate(pixel_x = pixel_x - (SHAKE_ANIMATION_OFFSET * 2 * direction), time = 1)
		animate(pixel_x = pixel_x + SHAKE_ANIMATION_OFFSET * direction, time = 1, easing = ELASTIC_EASING)
//datums/keybinding/_defines
#define CATEGORY_NECRO "NECRO"
#define ismarkereye(A) (istype(A, /mob/camera/marker_signal)) //youknow

///A 3x4 for the marker
#define SEE_THROUGH_MAP_MARKER "marker"
//HELPERS see_through maps

#define isnecromorph(A) (is_species(A, /datum/species/necromorph))

#define BODYTYPE_NECROMORPH (1<<13)
