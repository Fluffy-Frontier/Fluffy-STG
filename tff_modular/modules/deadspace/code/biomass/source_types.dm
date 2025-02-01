/datum/biomass_source/baseline
	remaining_mass = INFINITY //Never runs out
	mass_per_tick = 0.5

/// It's not supposed to ever deplet
/datum/biomass_source/baseline/absorb_biomass(delta_time)
	return mass_per_tick * delta_time

/datum/biomass_source/harvester
	mass_per_tick = 0

/// It's not supposed to ever deplet
/datum/biomass_source/harvester/absorb_biomass(delta_time)
	var/obj/structure/necromorph/harvester/harvester = source
	if(harvester.active)
		return harvester.biomass_per_tick * delta_time

/datum/biomass_source/maw
	mass_per_tick = 0

/datum/biomass_source/maw/absorb_biomass(delta_time)
	var/obj/structure/necromorph/maw/maw = source
	for(var/mob/living/target as anything in maw.buckled_mobs)
		if(isnecromorph(target))
			maw.bite_necro(target, delta_time)
		else if(ishuman(target))
			maw.bite_human(target, delta_time)
		else
			maw.bite_living(target, delta_time)
	//The least amount of biomass we can gain is 1 * delta_time, or 5% of the biomass we're processing, whichever is higher
	var/gained_biomass = clamp(max(1 * delta_time, maw.processing_biomass * (0.05 * delta_time)), 0, maw.processing_biomass)
	maw.processing_biomass -= gained_biomass
	return gained_biomass
