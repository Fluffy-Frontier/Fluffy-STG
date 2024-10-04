/obj/item/clothing/suit/jacket/playbunny //parent type
	name = "tailcoat"
	desc = "A coat usually worn by bunny themed waiters and the like."
	worn_icon = 'tff_modular/modules/bunny/icons/mob/suit.dmi'
	worn_icon_digi = 'tff_modular/modules/bunny/icons/mob/suit_digi.dmi'
	icon = 'tff_modular/modules/bunny/icons/obj/suit.dmi'
	icon_state = "tailcoat"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/wizrobe/playbunny/magician //Not really a robe but it's MAGIC
	name = "magician's tailcoat"
	desc = "A magnificent, gold-lined tailcoat that seems to radiate power."
	worn_icon = 'tff_modular/modules/bunny/icons/mob/suit.dmi'
	worn_icon_digi = 'tff_modular/modules/bunny/icons/mob/suit_digi.dmi'
	icon = 'tff_modular/modules/bunny/icons/obj/suit.dmi'
	icon_state = "wiz"
	inhand_icon_state = null
	flags_inv = null

/obj/item/clothing/suit/jacket/playbunny/security_tailcoat/centcom
	name = "centcom tailcoat"
	desc = "A reinforced tailcoat worn by bunny themed centcom officers."
	icon_state = "centcom"

/obj/item/clothing/suit/jacket/playbunny/syndi
	name = "blood-red tailcoat"
	desc = "The staple of any bunny themed syndicate assassins. Features an extra layer for concealment."
	icon_state = "syndi"

/obj/item/clothing/suit/jacket/playbunny/brit
	name = "british tailcoat"
	desc = "The staple of any bunny themed monarchists. Smells like a cup of tea."
	icon_state = "brit"

/obj/item/clothing/suit/jacket/playbunny/communist
	name = "really red tailcoat"
	desc = "The staple of any bunny themed communists. It suits you just right, comrade!"
	icon_state = "communist"

/obj/item/clothing/suit/jacket/playbunny/plasma
	name = "plasma tailcoat"
	desc = "A tailcoat of a marvellous purple substance. Would it ignite like plasma?"
	icon_state = "plasma"

/obj/item/clothing/suit/jacket/playbunny/stars
	name = "stellar tailcoat"
	desc = "A tailcoat covered in stars. You can look at it so endlessly.... Are they moving?"
	icon_state = "stars"

//CAPTAIN

/obj/item/clothing/suit/jacket/playbunny/captain
	name = "captain's tailcoat"
	desc = "A nautical coat usually worn by bunny themed captains. It’s reinforced with genetically modified armored blue rabbit fluff."
	icon_state = "captain"
	inhand_icon_state = null
	dog_fashion = null

//CARGO

/obj/item/clothing/suit/jacket/playbunny/qm
	name = "quartermaster's tailcoat"
	desc = "A fancy brown coat worn by bunny themed quartermasters. The gold accents show everyone who's in charge."
	icon_state = "qm"

/obj/item/clothing/suit/jacket/playbunny/cargo
	name = "cargo tailcoat"
	desc = "A simple brown coat worn by bunny themed cargo technicians. Significantly less stripy than the quartermasters."
	icon_state = "cargo_tech"

/obj/item/clothing/suit/jacket/playbunny/miner
	name = "explorer tailcoat"
	desc = "An adapted explorer suit worn by bunny themed shaft miners. It has attachment points for goliath plates but comparatively little armor."
	icon_state = "explorer"
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|ARMS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor_type = /datum/armor/hooded_explorer
	allowed = list(
		/obj/item/flashlight,
		/obj/item/gun/energy/recharge/kinetic_accelerator,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/resonator,
		/obj/item/storage/bag/ore,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/tank/internals,
		)
	resistance_flags = FIRE_PROOF
	clothing_traits = list(TRAIT_SNOWSTORM_IMMUNE)

/obj/item/clothing/suit/jacket/playbunny/miner/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate)

/obj/item/clothing/suit/jacket/playbunny/bitrunner
	name = "bitrunner tailcoat"
	desc = "A black and gold coat worn by bunny themed cargo technicians. Open your Space Colas and let's fuckin' game!"
	icon_state = "bitrunner"

//ENGI

/obj/item/clothing/suit/jacket/playbunny/engineer
	name = "engineering tailcoat"
	desc = "A high visibility tailcoat worn by bunny themed engineers. Great for working in low-light conditions."
	icon_state = "engi"
	allowed = list(
		/obj/item/fireaxe/metal_h2_axe,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/storage/bag/construction,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/t_scanner,
		/obj/item/gun/ballistic/rifle/boltaction/pipegun/prime,
	)

/obj/item/clothing/suit/jacket/playbunny/engineer/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/suit/jacket/playbunny/atmos_tech
	name = "atmospheric technician's tailcoat"
	desc = "A heavy duty fire-tailcoat worn by bunny themed atmospheric technicians. Reinforced with asbestos weave that makes this both stylish and lung-cancer inducing."
	icon_state = "atmos"

/obj/item/clothing/suit/jacket/playbunny/ce
	name = "chief engineer's tailcoat"
	desc = "A heavy duty green and white coat worn by bunny themed chief engineers. Made of a three layered composite fabric that is both insulating and fireproof, it also has an open face rendering all this useless."
	icon_state = "ce"
	clothing_flags = null

//MEDICAL

/obj/item/clothing/suit/toggle/labcoat/playbunny
	name = "medical tailcoat"
	desc = "A sterile white and blue coat worn by bunny themed doctors. Great for keeping the blood off."
	icon_state = "doctor"
	worn_icon = 'tff_modular/modules/bunny/icons/mob/suit.dmi'
	icon = 'tff_modular/modules/bunny/icons/obj/suit.dmi'

/obj/item/clothing/suit/toggle/labcoat/playbunny/paramedic
	name = "paramedic's tailcoat"
	desc = "A heavy duty coat worn by bunny themed paramedics. Marked with high visibility lines for emergency operations in the dark."
	icon_state = "paramedic"

/obj/item/clothing/suit/toggle/labcoat/playbunny/chemist
	name = "chemist's tailcoat"
	desc = "A sterile white and orange coat worn by bunny themed chemists. The open chest isn't the greatest when working with dangerous substances."
	icon_state = "chem"

/obj/item/clothing/suit/toggle/labcoat/playbunny/pathologist
	name = "pathologist's tailcoat"
	desc = "A sterile white and green coat worn by bunny themed pathologists. The more stylish and ineffective alternative to a biosuit."
	icon_state = "virologist"

/obj/item/clothing/suit/toggle/labcoat/playbunny/coroner
	name = "pathologist's tailcoat"
	desc = "A sterile black and white coat worn by bunny themed coroners. Adorned with a skull on the back."
	icon_state = "coroner"

/obj/item/clothing/suit/toggle/labcoat/playbunny/cmo
	name = "chief medical officer's tailcoat"
	desc = "A sterile blue coat worn by bunny themed chief medical officers. The blue helps both the wearer and bloodstains stand out from other, lower ranked, and cleaner doctors."
	icon_state = "cmo"

//SCIENCE

/obj/item/clothing/suit/toggle/labcoat/playbunny/science
	name = "scientist's tailcoat"
	desc = "A smart white coat worn by bunny themed scientists. Decent protection against slimes."
	icon_state = "science"

/obj/item/clothing/suit/toggle/labcoat/playbunny/robotics
	name = "roboticist's tailcoat"
	desc = "A smart white coat with red pauldrons worn by bunny themed roboticists. Looks surprisingly good with oil stains on it."
	icon_state = "roboticist"


/obj/item/clothing/suit/toggle/labcoat/playbunny/genetics
	name = "geneticist's tailcoat"
	desc = "A smart white and blue coat worn by bunny themed geneticists. Nearly looks like a real doctor's lab coat."
	icon_state = "genetics"

/obj/item/clothing/suit/jacket/playbunny/rd
	name = "research director's tailcoat"
	desc = "A smart purple coat worn by bunny themed head researchers. Created from captured abductor technology, what looks like a coat is actually an advanced hologram emitted from the pauldrons. Feels exactly like the real thing, too."
	icon_state = "rd"
	body_parts_covered = CHEST|ARMS|GROIN

//SECURITY

/obj/item/clothing/suit/jacket/playbunny/security_tailcoat
	name = "security tailcoat"
	desc = "A reinforced tailcoat worn by bunny themed security officers. Uses the same lightweight armor as the MK 1 vest, though obviously has lighter protection in the chest area."
	icon_state = "sec"
	inhand_icon_state = "armor"
	dog_fashion = null
	armor_type = /datum/armor/security_tailcoat

/datum/armor/security_tailcoat
	melee = 10
	fire = 30
	acid = 30
	wound = 10

/obj/item/clothing/suit/jacket/playbunny/security_tailcoat/assistant
	name = "security assistant's tailcoat"
	desc = "A reinforced tailcoat worn by bunny themed security assistants. The duller color scheme denotes a lower rank on the chain of bunny command."
	icon_state = "sec_assistant"

/obj/item/clothing/suit/jacket/playbunny/security_tailcoat/warden
	name = "warden's tailcoat"
	desc = "A reinforced tailcoat worn by bunny themed wardens. Stylishly holds hidden flak plates."
	icon_state = "warden"

/obj/item/clothing/suit/toggle/labcoat/playbunny/sec
	name = "brig physician's tailcoat"
	desc = "A mostly sterile red and grey coat worn by bunny themed brig physicians. It lacks the padding of the \"standard\" security tailcoat."
	icon_state = "brig_phys"

/obj/item/clothing/suit/jacket/det_suit/playbunny
	name = "detective's tailcoat"
	desc = "A reinforced tailcoat worn by bunny themed detectives. Perfect for a hard boiled no-nonsense type of gal."
	icon_state = "detective"
	worn_icon = 'tff_modular/modules/bunny/icons/mob/suit.dmi'
	icon = 'tff_modular/modules/bunny/icons/obj/suit.dmi'

/obj/item/clothing/suit/jacket/det_suit/playbunny/noir
	name = "noir detective's tailcoat"
	desc = "A reinforced tailcoat worn by noir bunny themed detectives. Perfect for a hard boiled no-nonsense type of gal."
	icon_state = "detective_noir"

/obj/item/clothing/suit/jacket/playbunny/security_tailcoat/hos
	name = "head of security's tailcoat"
	desc = "A reinforced tailcoat worn by bunny themed security commanders. Enhanced with a special alloy for some extra protection and style."
	icon_state = "hos"
	inhand_icon_state = "armor"
	dog_fashion = null
	strip_delay = 80

//SERVICE

/obj/item/clothing/suit/jacket/playbunny/janitor
	name = "janitor's tailcoat"
	desc = "A clean looking coat usually worn by bunny themed janitors. The purple sleeves are a late 24th century style."
	icon_state = "janitor"

/obj/item/clothing/suit/jacket/playbunny/cook
	name = "cook's tailcoat"
	desc = "A professional white coat worn by bunny themed chefs. The red accents pair nicely with the monkey blood that often stains this."
	icon_state = "chef"
	allowed = list(
		/obj/item/kitchen,
		/obj/item/knife/kitchen,
		/obj/item/storage/bag/tray,
	)

/obj/item/clothing/suit/jacket/playbunny/botanist
	name = "botanist's tailcoat"
	desc = "A green leather coat worn by bunny themed botanists. Great for keeping the sun off your back."
	icon_state = "botany"
	allowed = list(
		/obj/item/cultivator,
		/obj/item/geneshears,
		/obj/item/graft,
		/obj/item/hatchet,
		/obj/item/plant_analyzer,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/spray/pestspray,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/secateurs,
		/obj/item/seeds,
		/obj/item/storage/bag/plants,
	)

/obj/item/clothing/suit/jacket/playbunny/clown
	name = "clown's tailcoat"
	desc = "An orange polkadot coat worn by bunny themed clowns. Shows everyone who the real ringmaster is."
	icon_state = "clown"

/obj/item/clothing/suit/jacket/playbunny/mime
	name = "mime's tailcoat"
	desc = "A stripy sleeved black coat worn by bunny themed mimes. The red accents mimic the suspenders seen in more standard mime outfits."
	icon_state = "mime"

/obj/item/clothing/suit/jacket/playbunny/chaplain
	name = "chaplain's tailcoat"
	desc = "A gilded black coat worn by bunny themed chaplains. Traditional vestments of the lagomorphic cults of Cairead."
	icon_state = "chaplain"
	allowed = list(
		/obj/item/nullrod,
		/obj/item/reagent_containers/cup/glass/bottle/holywater,
		/obj/item/storage/fancy/candle_box,
		/obj/item/flashlight/flare/candle,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman
	)

/obj/item/clothing/suit/jacket/playbunny/curator_red
	name = "curator's red tailcoat"
	desc = "A red linen coat worn by bunny themed librarians. Keeps the dust off your shoulders during long shifts in the archives."
	icon_state = "curator_red"

/obj/item/clothing/suit/jacket/playbunny/curator_green
	name = "curator's green tailcoat"
	desc = "A green linen coat worn by bunny themed librarians. Keeps the dust off your shoulders during long shifts in the archives."
	icon_state = "curator_green"

/obj/item/clothing/suit/jacket/playbunny/curator_teal
	name = "curator's teal tailcoat"
	desc = "A teal linen coat worn by bunny themed librarians. Keeps the dust off your shoulders during long shifts in the archives."
	icon_state = "curator_teal"

/obj/item/clothing/suit/jacket/playbunny/lawyer_black
	name = "lawyer's black tailcoat"
	desc = "The staple of any bunny themed lawyers. EXTREMELY professional."
	icon_state = "lawyer_black"

/obj/item/clothing/suit/jacket/playbunny/lawyer_blue
	name = "lawyer's blue tailcoat"
	desc = "A blue linen coat worn by bunny themed lawyers. May or may not contain souls of the damned in suit pockets."
	icon_state = "lawyer_blue"

/obj/item/clothing/suit/jacket/playbunny/lawyer_red
	name = "lawyer's red tailcoat"
	desc = "A red linen coat worn by bunny themed lawyers. May or may not contain souls of the damned in suit pockets."
	icon_state = "lawyer_red"

/obj/item/clothing/suit/jacket/playbunny/lawyer_good
	name = "good lawyer's tailcoat"
	desc = "A beige linen coat worn by bunny themed lawyers. May or may not contain souls of the damned in suit pockets."
	icon_state = "lawyer_good"

/obj/item/clothing/suit/jacket/playbunny/psychologist
	name = "psychologist's tailcoat"
	desc = "A black linen coat worn by bunny themed psychologists. A casual open coat for making you seem approachable, maybe too casual."
	icon_state = "psychologist"

/obj/item/clothing/suit/jacket/playbunny/hop
	name = "head of personnel's tailcoat"
	desc = "A strict looking coat usually worn by bunny themed bureaucrats. The pauldrons are sure to make people finally take you seriously."
	icon_state = "hop"
	inhand_icon_state = "armor"
	dog_fashion = null
