/// Little demons for cult related necropolis. Cult construct based behaviour suits nice due hit n run which is much more interesting than just pushing.
/mob/living/basic/mining/ancient_demon
	name = "Ancient Demon"
	real_name = "Ancient Demon"
	desc = "A demonic creature of the ancient world. Did they ruled here before?"
	basic_mob_flags = 0
	icon = 'modular_nova/master_files/icons/mob/newmobs32x64.dmi'
	icon_state = "engorgedemon"
	icon_living = "engorgedemon"
	icon_dead = "demondead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	unique_name = FALSE

	speed = 0
	health = 420
	maxHealth = 420
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 0, STAMINA = 0, OXY = 0)

	faction = list(FACTION_MINING,FACTION_CULT)

	melee_attack_cooldown = 0.25 SECONDS
	melee_damage_lower = 3
	melee_damage_upper = 10
	melee_damage_type = "burn"//miners hande burn damage just fine, while borgs - dont.
	attack_verb_continuous = "maniacally tears"
	attack_verb_simple = "tears"
	attack_vis_effect = ATTACK_EFFECT_CLAW
	death_message = "collapses in ashes."
	attack_sound = 'sound/effects/wounds/crackandbleed.ogg'

	/// Mending touch base. Sort of.
	var/list/construct_spells = list()
	var/can_repair = TRUE
	var/can_repair_self = FALSE
	var/smashes_walls = FALSE

	butcher_results = list(/obj/item/food/grown/mushroom/glowshroom/shadowshroom = 1,/obj/item/food/meat/slab/human/mutant/shadow = 1,/obj/item/organ/external/tail/lizard = 1,/obj/item/organ/internal/eyes/shadow = 1,/obj/structure/trap/fire=1)

	ai_controller = /datum/ai_controller/basic_controller/proteon

/mob/living/basic/mining/ancient_demon/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_FLOATING_ANIM, INNATE_TRAIT)//prevent floating
	AddElement(/datum/element/door_pryer)
	AddElement(/datum/element/footstep, FOOTSTEP_MOB_SHOE)
	AddElement(/datum/element/mob_grabber, steal_from_others = FALSE)
	AddElement(/datum/element/simple_flying)
	if(smashes_walls)
		AddElement(/datum/element/wall_tearer, allow_reinforced = FALSE)
	if(can_repair)
		AddComponent(\
			/datum/component/healing_touch,\
			heal_brute = 5,\
			heal_burn = 0,\
			heal_time = 0,\
			valid_targets_typecache = typecacheof(list(/mob/living/basic/mining/ancient_demon)),\
			valid_biotypes = MOB_ORGANIC|MOB_HUMANOID,\
			self_targeting = can_repair_self ? HEALING_TOUCH_ANYONE : HEALING_TOUCH_NOT_SELF,\
			action_text = "%SOURCE% begins mending %TARGET%'s dents.",\
			complete_text = "%TARGET%'s health restored.",\
			show_health = TRUE,\
			heal_color = COLOR_CULT_RED,\
		)
		var/static/list/structure_types = typecacheof(list(/obj/structure/destructible/cult))
		AddElement(\
			/datum/element/structure_repair,\
			structure_types_typecache = structure_types,\
			)
	add_traits(list(TRAIT_HEALS_FROM_CULT_PYLONS, TRAIT_SPACEWALK), INNATE_TRAIT)
	grant_actions_by_list(construct_spells)

	var/spell_count = 1
	for(var/datum/action/spell as anything in actions)
		if(!(spell.type in construct_spells))
			continue

		var/pos = 2 + spell_count * 31
		if(construct_spells.len >= 4)
			pos -= 31 * (construct_spells.len - 4)
		spell.default_button_position = "6:[pos],4:-2" // Set the default position to this random position
		spell_count++
		update_action_buttons()

	var/datum/callback/retaliate_callback = CALLBACK(src, PROC_REF(ai_retaliate_behaviour))
	AddComponent(/datum/component/ai_retaliate_advanced, retaliate_callback)
/mob/living/basic/mining/ancient_demon/examine(mob/user)
	var/text_span = "cult"
	. = list("<span class='[text_span]'>This is [icon2html(src, user)] \a <b>[src]</b>!\n[desc]")
	if(health < maxHealth)
		if(health >= maxHealth/2)
			. += span_warning("[p_They()] look[p_s()] slightly damaged.")
		else
			. += span_warning(span_bold("[p_They()] look[p_s()] severely damaged!"))
	. += "</span>"
	return .


/// Set a timer to clear our retaliate list
/mob/living/basic/mining/ancient_demon/proc/ai_retaliate_behaviour(mob/living/attacker)
	if (!istype(attacker))
		return
	var/random_timer = rand(1 SECONDS, 3 SECONDS) //for unpredictability
	addtimer(CALLBACK(src, PROC_REF(clear_retaliate_list)), random_timer)

/mob/living/basic/mining/ancient_demon/proc/clear_retaliate_list()
	if(!ai_controller.blackboard_key_exists(BB_BASIC_MOB_RETALIATE_LIST))
		return
	ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)



/mob/living/basic/mining/ancient_demon/ancient_demon_lesser
	name = "Lesser Ancient Demon"
	health = 55
	maxHealth = 55
	melee_damage_lower = 1
	melee_damage_upper = 3
	current_size = 0.75
	base_pixel_y = 5
	butcher_results = list(/obj/item/food/meat/slab/human/mutant/shadow = 1)
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK


/// Basilisk based cuz pushing with ranged
/mob/living/basic/mining/ancient_demon/eldritch_horror
	name = "Eldritch Horror"
	desc = "This creature is terror itself, a manifestation of the raw hunger and avarice of mortals."
	icon = 'modular_nova/master_files/icons/mob/newmobs32x64.dmi'
	icon_state = "devourdemon"
	icon_living = "devourdemon"
	icon_dead = "demondead"
	speak_emote = list("echoes")
	speed = 0.35
	maxHealth = 1200
	health = 1200

	melee_attack_cooldown = 0.25 SECONDS
	melee_damage_lower = 3
	melee_damage_upper = 7
	obj_damage = 600
	attack_verb_continuous = "devours"
	attack_verb_simple = "reaps"
	throw_blocked_message = "bounces off the shell of"
	attack_sound = 'sound/effects/wounds/crackandbleed.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	butcher_results = list(/obj/item/food/grown/mushroom/glowshroom/shadowshroom = 1,/obj/item/food/meat/slab/human/mutant/shadow = 1,/obj/item/organ/internal/eyes/shadow = 1)
	guaranteed_butcher_results = list(/obj/item/book/granter/action/spell/true_random = 2,/obj/item/melee/cultblade=2,/obj/item/clothing/suit/hooded/cultrobes=2)

	ai_controller = /datum/ai_controller/basic_controller/basilisk
	/// The component we use for making ranged attacks
	var/datum/component/ranged_attacks/ranged_attacks

/mob/living/basic/mining/ancient_demon/eldritch_horror/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/basic_mob_attack_telegraph)
	ranged_attacks = AddComponent(/datum/component/ranged_attacks, projectile_type = /obj/projectile/temp/watcher, projectile_sound = 'sound/weapons/pierce.ogg')
	AddComponent(\
		/datum/component/spawner,\
		spawn_types = list(/mob/living/basic/mining/ancient_demon/ancient_demon_lesser),\
		spawn_time = 7 SECONDS,\
		max_spawned = 7,\
		spawn_text = "rifts from within of",\
		faction = faction,\
	)

/mob/living/basic/mining/ancient_demon/eldritch_horror/Destroy()
	QDEL_NULL(ranged_attacks)
	return ..()

/datum/ai_controller/basic_controller/basilisk
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
		BB_AGGRO_RANGE = 9,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/ranged_skirmish,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)




//Nemesis legion!
/mob/living/basic/mining/legion/massive
	name = "Massive legion"
	desc = "A hideous, groaning mass of skulls and bones."
	current_size = 1.25
	base_pixel_y = -7.5
	health_doll_icon = "legion"
	speed = 0.5
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 25
	obj_damage = 30

/mob/living/basic/mining/legion/massive/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/spawner,\
		spawn_types = list(/mob/living/basic/mining/legion/dwarf),\
		spawn_time = 12 SECONDS,\
		max_spawned = 2,\
		spawn_text = "peels itself off from",\
		faction = faction,\
	)
/mob/living/basic/mining/legion/massive/get_loot_list()
	var/static/list/death_loot = list(/obj/item/organ/internal/monster_core/regenerative_core/legion = 3, /obj/effect/mob_spawn/corpse/human/legioninfested = 1)
	return death_loot

/// Raptor
/mob/living/basic/mining/ancient_demon/demoraptor
	name = "Demoraptor"
	real_name = "Demoraptor"
	desc = "An Agressive predatory feathery beast. This one just won't tolerate you."
	faction = list("mining","cult")
	icon = 'icons/mob/simple/lavaland/raptor_big.dmi'
	icon_dead = "raptor_red_dead"
	icon_state = "raptor_red"
	icon_living = "raptor_red"
	current_size = 1
	base_pixel_y = 0
	speed = 0.32
	health = 240
	maxHealth = 240
	melee_damage_lower = 3
	melee_damage_upper = 15
	melee_attack_cooldown = 1 SECONDS
	melee_damage_type = "brute"
	attack_verb_continuous = "pecks"
	attack_verb_simple = "chomps"
	butcher_results = list(/obj/item/organ/external/tail/lizard = 1,/obj/item/feather=4,/obj/item/food/egg/raptor_egg=1,/obj/item/food/meat/slab/chicken=3)
	guaranteed_butcher_results = list(/obj/item/feather=4)
	death_message = "falls down."

/// Goliath
/mob/living/basic/mining/ancient_demon/goliath_pup //kinda junky, but this ai just nice
	name = "Goliath pup"
	desc = "In one day it will grow to something majestic. Or not. Do it. Stomp it."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_dead = "goliath_baby_dead"
	icon_state = "goliath_baby"
	icon_living = "goliath_baby"
	speed = 0.5
	health = 16
	maxHealth = 16
	melee_damage_lower = 5
	melee_damage_upper = 15
	melee_attack_cooldown = 1 SECONDS
	melee_damage_type = "stamina"//miners hande burn damage just fine, while borgs - dont.
	attack_verb_continuous = "punches"
	attack_verb_simple = "punch"
	attack_vis_effect = null
	attack_sound = 'sound/weapons/punch1.ogg'
	butcher_results = list(/obj/item/food/meat/slab/goliath = 1)
	death_message = "slaps."
	move_force = MOVE_FORCE_WEAK
	move_resist = MOVE_FORCE_WEAK
	pull_force = MOVE_FORCE_WEAK



/mob/living/basic/mining/goliath/young
	name = "Young goliath"
	desc = "Tentacle thing... But smaller. "
	health = 75
	maxHealth = 75
	melee_attack_cooldown = 10
	melee_damage_lower = 7
	melee_damage_upper = 15
	current_size = 0.75
	base_pixel_y = 5
	speed = 1
	butcher_results = list(/obj/effect/spawner/random/entertainment/coin = 1,/obj/effect/gibspawner/generic = 1,/obj/item/stack/sheet/animalhide/goliath_hide = 1,/obj/item/food/meat/slab/goliath = 1, /obj/item/stack/sheet/bone = 1)
	guaranteed_butcher_results = list(/obj/item/stack/sheet/animalhide/goliath_hide = 1,/obj/item/food/meat/slab/goliath = 1, /obj/item/stack/sheet/bone = 1)


/mob/living/basic/mining/goliath/chonk
	name = "Chonk goliath"
	desc = "That armored monster is definitely well fed."
	health = 520
	maxHealth = 520
	melee_attack_cooldown = 20
	melee_damage_lower = 35
	melee_damage_upper = 64
	current_size = 1.25
	base_pixel_y = -7.5
	speed = 3
	butcher_results = list(/obj/effect/spawner/random/entertainment/coin = 5,/obj/effect/spawner/random/medical/minor_healing = 1, /obj/item/ammo_casing/rebar = 1)
	guaranteed_butcher_results = list(/obj/effect/gibspawner/generic = 3,/obj/item/stack/sheet/animalhide/goliath_hide = 2,/obj/item/food/meat/slab/goliath = 3, /obj/item/stack/sheet/bone = 3)

/mob/living/basic/mining/goliath/gigachonk
	name = "Gigachonk"
	desc = "!!! OH LAWD, HE COMIN' !!!"
	health = 2480
	maxHealth = 2480
	melee_attack_cooldown = 25
	melee_damage_lower = 85
	melee_damage_upper = 125
	current_size = 2
	base_pixel_y = -32
	speed = 5
	tameable = FALSE
	butcher_results = list(/obj/effect/mob_spawn/corpse/human/miner = 2,/obj/item/reagent_containers/hypospray/medipen/survival/luxury = 2,/obj/item/pen/survival = 1,/obj/item/survivalcapsule/bathroom = 1,/obj/item/survivalcapsule/luxuryelite = 1,/obj/item/knife/combat = 1)
	guaranteed_butcher_results = list(/obj/effect/gibspawner/generic = 6,/obj/item/stack/sheet/animalhide/goliath_hide = 5,/obj/item/food/meat/slab/goliath = 12,/obj/item/stack/sheet/bone = 8,/obj/effect/mob_spawn/corpse/human/miner/mod = 1,/obj/effect/spawner/random/medical/medkit_rare = 1)


/mob/living/basic/mining/goliath/ancient/immortal/broodmother
	name = "Goliath young broodmother"
	desc = "Majestic..."
	health = 880
	maxHealth = 880
	melee_attack_cooldown = 20
	melee_damage_lower = 15
	melee_damage_upper = 44
	current_size = 1.25
	base_pixel_y = -7.5
	speed = 2
	melee_damage_type = "brute"
	attack_verb_continuous = "beats down on"
	attack_verb_simple = "beat down on"
	butcher_results = list(/obj/item/food/meat/slab/goliath = 6, /obj/item/stack/sheet/bone = 6)
	guaranteed_butcher_results = list(/obj/item/stack/sheet/animalhide/goliath_hide = 4,/obj/structure/closet/crate/necropolis/tendril=1,/obj/item/crusher_trophy/goliath_tentacle=1)
/mob/living/basic/mining/brimdemon/infused/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/spawner,\
		spawn_types = list(/mob/living/basic/mining/ancient_demon/goliath_pup),\
		spawn_time = 3 SECONDS,\
		max_spawned = 5,\
		spawn_text = "crawls out from under a",\
		faction = faction,\
	)

/// Brimdemons
/mob/living/basic/mining/brimdemon/awakened
	name = "Awakened brimdemon"
	desc = "A volatile creature resembling an enormous horned skull. Its response to almost any stimulus is to unleash a beam of infernal energy. This one looks angry."
	maxHealth = 70
	health = 70
	melee_damage_lower = 5
	melee_damage_upper = 12
	melee_attack_cooldown = 0.4 SECONDS
	current_size = 0.75
	base_pixel_y = 5
	speed = 0
	light_power = 8
	light_range = 1

/mob/living/basic/mining/brimdemon/infused
	name = "Infused brimdemon"
	desc = "Runic creature that looks like an enormous horned skull. This one looks REALLY angry."
	speed = 1
	maxHealth = 450
	health = 450
	melee_damage_lower = 15
	melee_damage_upper = 24
	melee_attack_cooldown = 0.4 SECONDS
	current_size = 1.25
	base_pixel_y = -7.5
	speed = 0
	light_power = 8
	light_range = 2
/mob/living/basic/mining/brimdemon/infused/Initialize(mapload)
	. = ..()
	AddComponent(\
		/datum/component/spawner,\
		spawn_types = list(/mob/living/basic/mining/brimdemon/awakened),\
		spawn_time = 12 SECONDS,\
		max_spawned = 2,\
		spawn_text = "peels itself off from",\
		faction = faction,\
	)

/// Random spawners
/obj/effect/spawner/random/mob/goliath
	name = "Random goliath spawner"
	desc = "Spawns a random size goliath"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters_wide.dmi'
	icon_state = "goliath"
	pixel_x = -12
	base_pixel_x = -12
	spawn_loot_chance = 50
	loot = list(
		/mob/living/basic/mining/ancient_demon/goliath_pup = 50,
		/mob/living/basic/mining/goliath/young = 45,
		/mob/living/basic/mining/goliath = 30,
		/mob/living/basic/mining/goliath/chonk = 10,
	)

/obj/effect/spawner/random/mob/brimdemon
	name = "Random brimdemon spawner"
	desc = "Spawns a random size brimdemon"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "brimdemon"
	pixel_x = -12
	base_pixel_x = -12
	spawn_loot_chance = 50
	loot = list(
		/mob/living/basic/mining/brimdemon/awakened = 50,
		/mob/living/basic/mining/brimdemon = 45,
		/mob/living/basic/mining/brimdemon/infused = 30,
	)

/// For map generation, has a chance to instantiate as a special subtype
/obj/effect/spawner/random/mob/necropolis_mob
	name = "Random necropolis monster"
	desc = "Spawns a random necropolis mob."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	spawn_loot_chance = 50
	loot = list(
		/mob/living/basic/mining/ancient_demon/goliath_pup = 1,
		/mob/living/basic/mining/goliath/young = 1.5,
		/mob/living/basic/mining/goliath = 1,
		/mob/living/basic/mining/goliath/chonk = 0.5,
		/mob/living/basic/mining/brimdemon/awakened = 1.5,
		/mob/living/basic/mining/brimdemon = 1,
		/mob/living/basic/mining/brimdemon/infused = 1,
		/mob/living/basic/mining/legion/dwarf = 1.5,
		/mob/living/basic/mining/legion = 1,
		/mob/living/basic/mining/legion/massive = 0.5,
		/mob/living/basic/mining/lobstrosity/lava = 1,
		/mob/living/basic/mining/watcher = 1,
	)
