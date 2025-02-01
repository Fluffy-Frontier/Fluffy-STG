/datum/necro_class
	var/display_name = ""
	var/desc = ""
	var/ui_icon = 'tff_modular/modules/deadspace/icons/necromorphs/base_necromorph.dmi'

	var/tier = 0

	var/necromorph_type_path = null

	///If nests can spawn this necromorph
	var/nest_allowed = FALSE

	///Biomass required to spawn this necromorph
	var/biomass_cost = INFINITY

	///Biomass required to unlock this necromorph
	var/biomass_spent_required = INFINITY

	// *** Melee Attacks *** //
	///The amount of damage a necromorph will do with a 'slash' attack.
	var/melee_damage_lower = 10
	var/melee_damage_upper = 10

	var/armour_penetration = 0

	///see_in_dark value while consicious
	var/conscious_see_in_dark = 8
	///see_in_dark value while unconscious
	var/unconscious_see_in_dark = 5

	///bitwise flags denoting things a necromorph can and cannot do, or things a necromorph is or is not. uses defines.
	var/necro_flags = NONE

	// *** Defense *** //
	var/datum/armor/armor_type = NONE

	///the 'abilities' available to a necromorph.
	var/list/datum/action/cooldown/necro/actions = list()

	///The iconstate for the necromorph on the minimap
	var/minimap_icon = "xenominion"

	///If there is necromorph cant be spawned by a marker
	///-1 = unlimited
	var/spawn_limit = -1

	///Number of spawned necromorphs by the marker
	var/spawned_number = 0

	//TODO: Get rid of this
	var/implemented = FALSE

/datum/necro_class/proc/load_data(mob/living/carbon/human/necromorph/necro)
	for(var/datum/action/cooldown/necro/action_datum as anything in actions)
		action_datum = new action_datum(necro)
		action_datum.Grant(necro)
/* DO I NEED IT?
	necro.armor_type = armor_type
*/
	necro.melee_damage_upper = melee_damage_upper

	necro.melee_damage_lower = melee_damage_lower

	necro.armour_penetration = armour_penetration

	necro.conscious_see_in_dark = conscious_see_in_dark

	necro.unconscious_see_in_dark = unconscious_see_in_dark

	necro.necro_flags = necro_flags
