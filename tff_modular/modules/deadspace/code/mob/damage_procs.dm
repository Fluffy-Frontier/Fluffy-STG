/mob/living
	var/lasting_damage = 0 //Damage which doesn't heal under normal circumstances

/mob/living/proc/adjustLastingDamage(amount)
	lasting_damage += amount
	setMaxHealth(floor(getAdjustedMaxHealth()))
	updatehealth()

/mob/living/proc/getLastingDamage()
	return lasting_damage

/mob/living/proc/getAdjustedMaxHealth()
	return max(1, (initial(maxHealth) - getLastingDamage()))
