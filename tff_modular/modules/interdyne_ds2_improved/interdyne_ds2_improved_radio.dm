/obj/item/radio/headset/interdyne
	freerange = FALSE
	freqlock = TRUE

/obj/item/radio/headset/interdyne/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_INTERDYNE)

/obj/item/radio/intercom/interdyne
	name = "Interdyne Intercom"
	desc = "A trusty branded intercom. The bolts are sealed with seals and there is a sign on the housing - “Do not disassemble by yourself!”."
	freerange = FALSE
	freqlock = TRUE
	canhear_range = 4

/obj/item/radio/intercom/interdyne/Initialize(mapload, ndir, building)
	. = ..()
	set_frequency(MIN_FREE_FREQ)

MAPPING_DIRECTIONAL_HELPERS(/obj/item/radio/intercom/interdyne, 27)

/obj/item/radio/headset/tarkon
	freerange = FALSE
	freqlock = TRUE

/obj/item/radio/headset/tarkon/Initialize(mapload)
	. = ..()
	set_frequency(FREQ_TARKON)
