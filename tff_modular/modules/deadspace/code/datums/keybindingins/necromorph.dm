/datum/keybinding/necromorph
	category = CATEGORY_NECRO

/datum/keybinding/necromorph/can_use(client/user)
	return isnecromorph(user.mob)

/datum/keybinding/necromorph/charge
	hotkey_keys = list("Unbound")
	name = "use_charge"
	full_name = "Necromorph Charge"
	description = "Charge at a enemy or targeted area."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_CHARGE_DOWN

/datum/keybinding/necromorph/dodge
	hotkey_keys = list("Unbound")
	name = "use_dodge"
	full_name = "Necromorph Dodge"
	description = "Dodge to gain temporary health."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_DODGE_DOWN

/datum/keybinding/necromorph/shout
	hotkey_keys = list("Unbound")
	name = "use_shout"
	full_name = "Necromorph Shout"
	description = "Shout to disorientate the enemy."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_SHOUT_DOWN

/datum/keybinding/necromorph/scream
	hotkey_keys = list("Unbound")
	name = "use_scream"
	full_name = "Necromorph Scream"
	description = "Scream to disorientate the enemy"
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_SCREAM_DOWN

/datum/keybinding/necromorph/sense
	hotkey_keys = list("Unbound")
	name = "use_sense"
	full_name = "Necromorph Sense"
	description = "Reveals nearby living creatures around you, to yourself and allies."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_SENSE_DOWN

/datum/keybinding/necromorph/snapshot
	hotkey_keys = list("Unbound")
	name = "use_snapshot"
	full_name = "Necromorph Snapshot"
	description = "A moderate-strength projectile that auto-aims at targets within 3 tiles of you."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_SNAPSHOT_DOWN

/datum/keybinding/necromorph/longshot
	hotkey_keys = list("Unbound")
	name = "use_longshot"
	full_name = "Necromorph Longshot"
	description = "A powerful projectile for longrange shooting."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_LONGSHOT_DOWN

/datum/keybinding/necromorph/toggleshell
	hotkey_keys = list("Unbound")
	name = "use_toggleshell"
	full_name = "Lurker Toggleshell"
	description = "Retracts or closes your protective plating, exposing or protecting your tentacles."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_TOGGLESHELL_DOWN

/datum/keybinding/necromorph/spinelaunch
	hotkey_keys = list("Unbound")
	name = "use_spinelaunch"
	full_name = "Lurker Spinelaunch"
	description = "A three-shot spread of bone spines, with varying accuracy."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_SPINELAUNCH_DOWN

/datum/keybinding/necromorph/gallop
	hotkey_keys = list("Unbound")
	name = "use_gallop"
	full_name = "Leaper Gallop"
	description = "Gives a huge burst of speed, but makes you vulnerable."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_GALLOP_DOWN

/datum/keybinding/necromorph/tailstab
	hotkey_keys = list("Unbound")
	name = "use_tailstab"
	full_name = "Leaper Tailstab"
	description = "Stab a victim with your tails."
	keybind_signal =COMSIG_KB_NECROMORPH_ABILITY_TAILSTAB_DOWN

/datum/keybinding/necromorph/explode
	hotkey_keys = list("Unbound")
	name = "use_explode"
	full_name = "Exploder Explode"
	description = "Violently explode."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_EXPLODE_DOWN

/datum/keybinding/necromorph/explodecharge
	hotkey_keys = list("Unbound")
	name = "use_explode_charge"
	full_name = "Exploder Charge Explosion"
	description = "Charge at a tile or target, and explode on impact."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_EXPLODECHARGE_DOWN

/datum/keybinding/necromorph/hunterswing
	hotkey_keys = list("Unbound")
	name = "use_hunter_swing"
	full_name = "Hunter Swing"
	description = "A short range charge with a swing at the end, pulling in all enemies it hits."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_HUNTERSWING_DOWN

/datum/keybinding/necromorph/taunt
	hotkey_keys = list("Unbound")
	name = "use_taunt"
	full_name = "Necromorph Taunt"
	description = "Provides a defensive buff to the hunter, and a larger one to his allies."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_TAUNT_DOWN

/datum/keybinding/necromorph/regenerate
	hotkey_keys = list("Unbound")
	name = "use_regenerate"
	full_name = "Necromorph Regeneration"
	description = "Regrows a missing limb and restores some of your health."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_REGENERATE_DOWN

/datum/keybinding/necromorph/slam
	hotkey_keys = list("Unbound")
	name = "use_slam"
	full_name = "Brute Slam"
	description = "Slams everything in a direction."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_SLAM_DOWN

/datum/keybinding/necromorph/curl
	hotkey_keys = list("Unbound")
	name = "use_curl"
	full_name = "Brute Curl"
	description = "Curl up to greatly reduce damage."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_CURL_DOWN

/datum/keybinding/necromorph/stepstrike
	hotkey_keys = list("Unbound")
	name = "use_stepstrike"
	full_name = "Twitcher Stepstrike"
	description = "Step in a direction of the target, and automatically attack. Stacks with normal attacks."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_STEPSTRIKE_DOWN

/datum/keybinding/necromorph/frenzy
	hotkey_keys = list("Unbound")
	name = "use_frenzy_shout"
	full_name = "Necromorph Frenzy Shout"
	description = "Grants a 30% move and attackspeed buff to other nearby necromorphs, damages non necromorphs."
	keybind_signal = COMSIG_KB_NECROMORPH_ABILITY_FRENZY_DOWN
