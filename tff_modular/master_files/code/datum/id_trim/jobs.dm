/datum/id_trim/job/blueshield/New()
	. = ..()

	var/musthave_access = list(
		ACCESS_BRIG,
		ACCESS_CARGO,
		ACCESS_COURT,
		ACCESS_GATEWAY,
		ACCESS_SECURITY,
		ACCESS_CHANGE_IDS,
	)

	minimal_access |= musthave_access

/datum/id_trim/job/nanotrasen_consultant/New()
	. = ..()

	var/musthave_access = list(
		ACCESS_BRIG,
		ACCESS_CARGO,
		ACCESS_COURT,
		ACCESS_GATEWAY,
		ACCESS_SECURITY,
		ACCESS_CHANGE_IDS,
	)

	minimal_access |= musthave_access
