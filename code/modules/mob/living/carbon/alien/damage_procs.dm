
/mob/living/carbon/alien/getToxLoss()
	return 0

/mob/living/carbon/alien/adjustToxLoss(amount, updating_health = TRUE, forced = FALSE) //alien immune to tox damage
	return FALSE

///aliens are immune to stamina damage.
/mob/living/carbon/alien/pre_stamina_change(diff as num)
	return 0
