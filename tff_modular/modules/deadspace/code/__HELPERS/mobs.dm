/mob/proc/enemy_in_view(require_standing = FALSE)
	for(var/mob/living/carbon/human/H in dview(center = loc))
		//People who are downed don't count
		if (require_standing && (H.stat))
			continue

		//Other necros don't count
		if (faction_check(faction, H.faction))
			continue

		return TRUE
	return FALSE
