GLOBAL_LIST_EMPTY(necromorph_markers)
/obj/structure/marker
	name = "Marker"
	icon = 'tff_modular/modules/deadspace/icons/obj/marker_giant.dmi'
	icon_state = "marker_giant_dormant"
	appearance_flags = PIXEL_SCALE|LONG_GLIDE
	layer = WALL_OBJ_LAYER
	plane = GAME_PLANE
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	bound_width = 96
	bound_x = -32
	pixel_x = -33
	base_pixel_x = -33
	move_resist = MOVE_FORCE_OVERPOWERING
	density = TRUE
	flags_1 = ON_BORDER_1
	plane = ABOVE_GAME_PLANE
	var/active = FALSE
	///Whether we should use necroqueue when spawning necromorphs
	var/use_necroqueue = TRUE
	var/list/necroqueue = list()
	var/mob/camera/marker_signal/marker/camera_mob
	var/list/marker_signals = list()
	var/list/necromorphs = list()
	/// Biomass stored
	var/marker_biomass = 0
	/// Biomass signals can use
	var/signal_biomass = 0
	/// Biomass marker spent since the start of the round
	var/biomass_invested = 0
	/// Sources of biomass income
	var/list/datum/biomass_source/biomass_sources = list()
	/// Biomass recieve by the marker in the last process() call
	var/last_biomass_income = 0
	/// Percent of biomass signals recieve from marker income
	var/signal_biomass_percent = 0.1
	/// An assoc list of all necro class types = their references
	var/list/datum/necro_class/necro_classes = list()
	/// A list of all corruption nodes
	var/list/nodes = list()
	/// A list of atoms that let us spawn necromorphs 6 tiles away from them
	var/list/necro_spawn_atoms = list()
