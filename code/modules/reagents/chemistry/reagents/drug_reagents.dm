/datum/reagent/drug
	name = "Drug"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "bitterness"
	var/trippy = TRUE //Does this drug make you trip?

/datum/reagent/drug/on_mob_end_metabolize(mob/living/M)
	if(trippy)
		SEND_SIGNAL(M, COMSIG_CLEAR_MOOD_EVENT, "[type]_high")

/datum/reagent/drug/space_drugs
	name = "Space drugs"
	description = "An illegal chemical compound used as drug."
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 30
	addiction_types = list(/datum/addiction/hallucinogens = 10) //4 per 2 seconds

/datum/reagent/drug/space_drugs/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(15)
	if(isturf(M.loc) && !isspaceturf(M.loc))
		if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED))
			if(prob(10))
				step(M, pick(GLOB.cardinals))
	if(prob(7))
		M.emote(pick("twitch","drool","moan","giggle"))
	..()

/datum/reagent/drug/space_drugs/overdose_start(mob/living/M)
	to_chat(M, "<span class='userdanger'>You start tripping hard!</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[type]_overdose", /datum/mood_event/overdose, name)

/datum/reagent/drug/space_drugs/overdose_process(mob/living/M)
	if(M.hallucination < volume && prob(20))
		M.hallucination += 5
	..()

/datum/reagent/drug/nicotine
	name = "Nicotine"
	description = "Slightly reduces stun times. If overdosed it will deal toxin and oxygen damage."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	taste_description = "smoke"
	trippy = FALSE
	overdose_threshold=15
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	addiction_types = list(/datum/addiction/nicotine = 18) // 7.2 per 2 seconds

/datum/reagent/drug/nicotine/on_mob_life(mob/living/carbon/M)
	if(prob(1))
		var/smoke_message = pick("You feel relaxed.", "You feel calmed.","You feel alert.","You feel rugged.")
		to_chat(M, "<span class='notice'>[smoke_message]</span>")
	SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "smoked", /datum/mood_event/smoked, name)
	M.AdjustStun(-5)
	M.AdjustKnockdown(-5)
	M.AdjustUnconscious(-5)
	M.AdjustParalyzed(-5)
	M.AdjustImmobilized(-5)
	..()
	. = 1

/datum/reagent/drug/nicotine/overdose_process(mob/living/M)
	M.adjustToxLoss(0.1*REM, 0)
	M.adjustOxyLoss(1.1*REM, 0)
	..()
	. = 1

/datum/reagent/drug/crank
	name = "Crank"
	description = "Reduces stun times by about 200%. If overdosed it will deal significant Toxin, Brute and Brain damage."
	reagent_state = LIQUID
	color = "#FA00C8"
	overdose_threshold = 20
	addiction_types = list(/datum/addiction/stimulants = 14) //5.6 per 2 seconds


/datum/reagent/drug/crank/on_mob_metabolize(mob/living/L)
	ADD_TRAIT(L, TRAIT_NOBLOCK, type)
	..()

/datum/reagent/drug/crank/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_NOBLOCK, type)
	..()

/datum/reagent/drug/crank/on_mob_life(mob/living/carbon/M)
	if(prob(5))
		var/high_message = pick("You feel jittery.", "You feel like you gotta go fast.", "You feel like you need to step it up.")
		to_chat(M, "<span class='notice'>[high_message]</span>")
	if(prob(8))
		M.adjustBruteLoss(rand(1,4))
		M.Stun(5, 0)
		to_chat(M, "<span class='notice'>You stop to furiously scratch at your skin.</span>")
	M.AdjustStun(-20)
	M.AdjustKnockdown(-20)
	M.AdjustUnconscious(-20)
	M.AdjustImmobilized(-20)
	M.AdjustParalyzed(-20)
	M.adjustToxLoss(0.75, 0)
	M.adjustStaminaLoss(-18, 0)
	..()
	. = 1

/datum/reagent/drug/crank/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2*REM)
	M.adjustToxLoss(2*REM, 0)
	M.adjustBruteLoss(2*REM, FALSE, FALSE, BODYTYPE_ORGANIC)
	..()
	. = 1

/datum/reagent/drug/krokodil
	name = "Krokodil"
	description = "Cools and calms you down. If overdosed it will deal significant Brain and Toxin damage. If addicted it will begin to deal fatal amounts of Brute damage as the subject's skin falls off."
	reagent_state = LIQUID
	color = "#0064B4"
	overdose_threshold = 20
	addiction_types = list(/datum/addiction/opiods = 18) //7.2 per 2 seconds


/datum/reagent/drug/krokodil/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel calm.", "You feel collected.", "You feel like you need to relax.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	if(current_cycle == 35)
		if(!istype(M.dna.species, /datum/species/human/krokodil_addict))
			to_chat(M, "<span class='userdanger'>Your skin falls off easily!</span>")
			M.adjustBruteLoss(50*REM, 0) // holy shit your skin just FELL THE FUCK OFF
			M.set_species(/datum/species/human/krokodil_addict)
	..()

/datum/reagent/drug/krokodil/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25*REM)
	M.adjustToxLoss(0.25*REM, 0)
	..()
	. = 1

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine"
	description = "Reduces stun times by about 300%, speeds the user up, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	addiction_types = list(/datum/addiction/stimulants = 12) //4.8 per 2 seconds
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/methamphetamine/on_mob_metabolize(mob/living/L)
	..()
	if(L.client)
		L.client.give_award(/datum/award/achievement/misc/meth, L)

	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-0.75, blacklisted_movetypes=(FLYING|FLOATING))
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	ADD_TRAIT(L, TRAIT_NOBLOCK, type)

/datum/reagent/drug/methamphetamine/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_NOBLOCK, type)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	L.remove_movespeed_modifier(type)
	..()

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.AdjustStun(-40)
	M.AdjustKnockdown(-40)
	M.AdjustUnconscious(-40)
	M.AdjustParalyzed(-40)
	M.AdjustImmobilized(-40)
	M.adjustStaminaLoss(-40, 0)
	M.drowsyness = max(0,M.drowsyness-30)
	M.Jitter(2)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
	if(prob(5))
		M.emote(pick("twitch", "shiver"))
	..()
	. = 1

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/M)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !ismovableatom(M.loc))
		for(var/i in 1 to 4)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote("laugh")
	if(prob(33))
		M.visible_message("<span class='danger'>[M]'s hands flip out and flail everywhere!</span>")
		M.drop_all_held_items()
	..()
	M.adjustToxLoss(1, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, pick(0.5, 0.6, 0.7, 0.8, 0.9, 1))
	. = 1


/datum/reagent/drug/bath_salts
	name = "Bath Salts"
	description = "Makes you impervious to stuns and grants a stamina regeneration buff, but you will be a nearly uncontrollable tramp-bearded raving lunatic."
	reagent_state = LIQUID
	color = "#FAFAFA"
	overdose_threshold = 20
	addiction_types = list(/datum/addiction/stimulants = 25) //8 per 2 seconds
	taste_description = "salt" // because they're bathsalts?
	var/datum/brain_trauma/special/psychotic_brawling/bath_salts/rage

/datum/reagent/drug/bath_salts/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	ADD_TRAIT(L, TRAIT_NOSTAMCRIT, type)
	ADD_TRAIT(L, TRAIT_NOLIMBDISABLE, type)
	ADD_TRAIT(L, TRAIT_NOBLOCK, type)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		rage = new()
		C.gain_trauma(rage, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/drug/bath_salts/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	REMOVE_TRAIT(L, TRAIT_NOSTAMCRIT, type)
	REMOVE_TRAIT(L, TRAIT_NOLIMBDISABLE, type)
	REMOVE_TRAIT(L, TRAIT_NOBLOCK, type)
	if(rage)
		QDEL_NULL(rage)
	..()

/datum/reagent/drug/bath_salts/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustStaminaLoss(-5, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 4)
	M.hallucination += 5
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !ismovableatom(M.loc))
		step(M, pick(GLOB.cardinals))
		step(M, pick(GLOB.cardinals))
	..()
	. = 1

/datum/reagent/drug/bath_salts/overdose_process(mob/living/M)
	M.hallucination += 5
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED) && !ismovableatom(M.loc))
		for(var/i in 1 to 8)
			step(M, pick(GLOB.cardinals))
	if(prob(20))
		M.emote(pick("twitch","drool","moan"))
	if(prob(33))
		M.drop_all_held_items()
	..()


/datum/reagent/drug/aranesp
	name = "Aranesp"
	description = "Amps you up, gets you going, and rapidly restores stamina damage. Side effects include breathlessness and toxicity."
	reagent_state = LIQUID
	color = "#78FFF0"
	addiction_types = list(/datum/addiction/stimulants = 8)

/datum/reagent/drug/aranesp/on_mob_metabolize(mob/living/L)
	ADD_TRAIT(L, TRAIT_NOBLOCK, type)
	..()

/datum/reagent/drug/aranesp/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_NOBLOCK, type)
	..()

/datum/reagent/drug/aranesp/on_mob_life(mob/living/carbon/M)
	var/high_message = pick("You feel amped up.", "You feel ready.", "You feel like you can push it to the limit.")
	if(prob(5))
		to_chat(M, "<span class='notice'>[high_message]</span>")
	M.adjustStaminaLoss(-20, 0)
	M.adjustToxLoss(0.5, 0)
	if(prob(50))
		M.losebreath++
		M.adjustOxyLoss(1, 0)
	..()
	. = 1

/datum/reagent/drug/happiness
	name = "Happiness"
	description = "Fills you with ecstasic numbness and causes minor brain damage. Highly addictive. If overdosed causes sudden mood swings."
	reagent_state = LIQUID
	color = "#FFF378"
	addiction_types = list(/datum/addiction/hallucinogens = 18)
	overdose_threshold = 20

/datum/reagent/drug/happiness/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_FEARLESS, type)
	SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug)

/datum/reagent/drug/happiness/on_mob_delete(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FEARLESS, type)
	SEND_SIGNAL(L, COMSIG_CLEAR_MOOD_EVENT, "happiness_drug")
	..()

/datum/reagent/drug/happiness/on_mob_life(mob/living/carbon/M)
	M.jitteriness = 0
	M.confused = 0
	M.disgust = 0
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2)
	..()
	. = 1

/datum/reagent/drug/happiness/overdose_process(mob/living/M)
	if(prob(30))
		var/reaction = rand(1,3)
		switch(reaction)
			if(1)
				M.emote("laugh")
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug_good_od)
			if(2)
				M.emote("sway")
				M.Dizzy(25)
			if(3)
				M.emote("frown")
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "happiness_drug", /datum/mood_event/happiness_drug_bad_od)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.5)
	..()
	. = 1


//I had to do too much research on this to make this a thing. Hopefully the FBI won't kick my door down.
/datum/reagent/drug/ketamine
	name = "Ketamine"
	description = "A heavy duty tranquilizer found to also invoke feelings of euphoria, and assist with pain. Popular at parties and amongst small frogmen who drive Honda Civics."
	reagent_state = LIQUID
	color = "#c9c9c9"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	addiction_types = list(/datum/addiction/hallucinogens = 18)
	overdose_threshold = 16

/datum/reagent/drug/ketamine/on_mob_metabolize(mob/living/L)
	ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	. = ..()

/datum/reagent/drug/ketamine/on_mob_delete(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	. = ..()

/datum/reagent/drug/ketamine/on_mob_life(mob/living/carbon/M)
	//Friendly Reminder: Ketamine is a tranquilizer and will sleep you.
	switch(current_cycle)
		if(10)
			to_chat(M, "<span class='warning'>You start to feel tired...</span>" )
		if(11 to 25)
			M.drowsyness ++
		if(26 to INFINITY)
			M.Sleeping(60, 0)
			. = 1
	//Providing a Mood Boost
	M.confused -= 3
	M.jitteriness -= 5
	M.disgust -= 3
	//Ketamine is also a dissociative anasthetic which means Hallucinations!
	M.hallucination += 5
	..()

/datum/reagent/drug/ketamine/overdose_process(mob/living/M)
	//Dissociative anesthetics? Overdosing? Time to dissociate hard.
	var/obj/item/organ/brain/B = M.getorgan(/obj/item/organ/brain)
	if(B.can_gain_trauma(/datum/brain_trauma/severe/split_personality, 5))
		B.brain_gain_trauma(/datum/brain_trauma/severe/split_personality, 5)
		. = 1
	M.hallucination += 10
	//Uh Oh Someone is tired
	if(prob(40))
		if(HAS_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN))
			REMOVE_TRAIT(M, TRAIT_IGNOREDAMAGESLOWDOWN, type)
		if(prob(33))
			to_chat(M, "<span class='warning'>Your limbs begin to feel heavy...</span>")
		else if(prob(33))
			to_chat(M, "<span class='warning'>It feels hard to move...</span>")
		else
			to_chat(M, "<span class='warning'>You feel like you your limbs won't move...</span>")
		M.drop_all_held_items()
		M.Dizzy(5)
	..()
