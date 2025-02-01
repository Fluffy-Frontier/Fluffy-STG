/datum/biomass_source
	/// How much total mass is left in this source
	var/remaining_mass = -1
	/// How much mass is absorbed per tick
	var/mass_per_tick = 1
	/// The datum this source bound to. Optional
	var/datum/source = null
	/// Marker that absorbs biomass from this source
	var/obj/structure/marker/master = null

/datum/biomass_source/New(obj/structure/marker, datum/new_source)
	master = marker
	source = new_source
	RegisterSignal(new_source, COMSIG_QDELETING, PROC_REF(on_source_deleted))

/datum/biomass_source/Destroy(force, ...)
	if (source)
		UnregisterSignal(source, COMSIG_QDELETING)
		source = null
	master = null
	return ..()

/// Called from obj/structure/marker/process()
/datum/biomass_source/proc/absorb_biomass(delta_time)
	. = clamp(mass_per_tick * delta_time, 0, remaining_mass)
	remaining_mass -= .
	if(remaining_mass <= 0)
		on_biomass_depletion()

/// Called when biomass source is depleted
/datum/biomass_source/proc/on_biomass_depletion()
	master.remove_biomass_source(src)

/datum/biomass_source/proc/on_source_deleted()
	master.remove_biomass_source(src)
