// Designed to be used only by brute!!!
/datum/action/cooldown/necro/curl
	name = "Toggle Curl"
	desc = "Use curl to take less damage but be completely immobilized."
	cooldown_time = 0

/datum/action/cooldown/necro/curl/Activate(atom/target)
	var/mob/living/carbon/human/necromorph/brute/brute = target
	if(brute.curling)
		if(brute.forced_curl)
			to_chat(brute, span_notice("You were forced to curl! You will stop curling in [(brute.forced_curl_next - world.time) SECONDS] seconds."))
			return TRUE
		to_chat(brute, span_notice("You stop curling and stand up."))
		INVOKE_ASYNC(brute, TYPE_PROC_REF(/mob/living/carbon/human/necromorph/brute, stop_curl))
	else
		to_chat(brute, span_notice("You start curling."))
		INVOKE_ASYNC(brute, TYPE_PROC_REF(/mob/living/carbon/human/necromorph/brute, start_curl))
	return TRUE

