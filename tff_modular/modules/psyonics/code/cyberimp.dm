#define ORGAN_SLOT_BRAIN_PSYONIC "brain_psyonic"

// Не позволяет мане регенерироваться
/obj/item/organ/internal/cyberimp/brain/anti_psyonic
	name = "Psyonic Amplifier Model N"
	desc = "This implant will prohibit psyonics from regenereting their energy."
	icon_state = "brain_implant_rebooter"
	slot = ORGAN_SLOT_BRAIN_PSYONIC

/obj/item/organ/internal/cyberimp/brain/anti_psyonic/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	ADD_TRAIT(organ_owner, TRAIT_NO_PSYONICS, IMPLANT_TRAIT)

/obj/item/organ/internal/cyberimp/brain/anti_psyonic/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	REMOVE_TRAIT(organ_owner, TRAIT_NO_PSYONICS, IMPLANT_TRAIT)

// Увеличивает реген маны в 2 раза
/obj/item/organ/internal/cyberimp/brain/pro_psyonic
	name = "Psyonic Amplifier Model A"
	desc = "This implant will boost psyonics energy regeneration."
	icon_state = "brain_implant_rebooter"
	slot = ORGAN_SLOT_BRAIN_PSYONIC

/obj/item/organ/internal/cyberimp/brain/pro_psyonic/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	ADD_TRAIT(organ_owner, TRAIT_PRO_PSYONICS, IMPLANT_TRAIT)

/obj/item/organ/internal/cyberimp/brain/pro_psyonic/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	REMOVE_TRAIT(organ_owner, TRAIT_PRO_PSYONICS, IMPLANT_TRAIT)

/datum/supply_pack/medical/psyonic_implants
	name = "Psyonic Implants"
	desc = "A crate containing two experimental psyonic implants, which work ONLY on psyonic users. No warranty."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/organ/internal/cyberimp/brain/anti_psyonic = 1,
					/obj/item/organ/internal/cyberimp/brain/pro_psyonic = 1)
	crate_name = "Psyonic implant crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
