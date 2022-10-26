//Here are the procs used to modify status effects of a mob.
//The effects include: stun, knockdown, unconscious, sleeping, resting, jitteriness, dizziness,
// eye damage, eye_blind, eye_blurry, druggy, TRAIT_BLIND trait, and TRAIT_NEARSIGHT trait.


////////////////////////////// STUN ////////////////////////////////////

/mob/living/proc/IsStun() //If we're stunned
	return has_status_effect(STATUS_EFFECT_STUN)

/mob/living/proc/AmountStun() //How many deciseconds remain in our stun
	var/datum/status_effect/incapacitating/stun/S = IsStun()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Stun(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(S)
			S.duration = max(world.time + amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_STUN, amount)
		return S

/mob/living/proc/SetStun(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(amount <= 0)
			if(S)
				qdel(S)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(S)
				S.duration = world.time + amount
			else
				S = apply_status_effect(STATUS_EFFECT_STUN, amount)
		return S

/mob/living/proc/AdjustStun(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_STUN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANSTUN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/stun/S = IsStun()
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_STUN, amount)
		return S

///////////////////////////////// KNOCKDOWN /////////////////////////////////////

/mob/living/proc/IsKnockdown() //If we're knocked down
	return has_status_effect(STATUS_EFFECT_KNOCKDOWN)

/mob/living/proc/AmountKnockdown() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		return K.duration - world.time
	return 0

/mob/living/proc/Knockdown(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(K)
			K.duration = max(world.time + amount, K.duration)
		else if(amount > 0)
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount)
		return K

/mob/living/proc/SetKnockdown(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(amount <= 0)
			if(K)
				qdel(K)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(K)
				K.duration = world.time + amount
			else
				K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount)
		return K

/mob/living/proc/AdjustKnockdown(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_KNOCKDOWN, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
		if(K)
			K.duration += amount
		else if(amount > 0)
			K = apply_status_effect(STATUS_EFFECT_KNOCKDOWN, amount)
		return K

///////////////////////////////// IMMOBILIZED ////////////////////////////////////
/mob/living/proc/IsImmobilized() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_IMMOBILIZED)

/mob/living/proc/AmountImmobilized() //How many deciseconds remain in our Immobilized status effect
	var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
	if(I)
		return I.duration - world.time
	return 0

/mob/living/proc/Immobilize(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
		if(I)
			I.duration = max(world.time + amount, I.duration)
		else if(amount > 0)
			I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount)
		return I

/mob/living/proc/SetImmobilized(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
		if(amount <= 0)
			if(I)
				qdel(I)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(I)
				I.duration = world.time + amount
			else
				I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount)
		return I

/mob/living/proc/AdjustImmobilized(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_IMMOBILIZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/immobilized/I = IsImmobilized()
		if(I)
			I.duration += amount
		else if(amount > 0)
			I = apply_status_effect(STATUS_EFFECT_IMMOBILIZED, amount)
		return I

///////////////////////////////// PARALYZED //////////////////////////////////
/mob/living/proc/IsParalyzed() //If we're immobilized
	return has_status_effect(STATUS_EFFECT_PARALYZED)

/mob/living/proc/AmountParalyzed() //How many deciseconds remain in our Paralyzed status effect
	var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
	if(P)
		return P.duration - world.time
	return 0

/mob/living/proc/Paralyze(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		drop_all_held_items()
		var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
		if(P)
			P.duration = max(world.time + amount, P.duration)
		else if(amount > 0)
			P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount)
		return P

/mob/living/proc/SetParalyzed(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
		if(amount <= 0)
			if(P)
				qdel(P)
		else
			if(absorb_stun(amount, ignore_canstun))
				return
			if(P)
				P.duration = world.time + amount
			else
				P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount)
		return P

/mob/living/proc/AdjustParalyzed(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_PARALYZE, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANKNOCKDOWN) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		if(absorb_stun(amount, ignore_canstun))
			return
		var/datum/status_effect/incapacitating/paralyzed/P = IsParalyzed(FALSE)
		if(P)
			P.duration += amount
		else if(amount > 0)
			P = apply_status_effect(STATUS_EFFECT_PARALYZED, amount)
		return P

/* DISORIENTED */
/**
 * Applies the "disoriented" status effect to the mob, among other potential statuses.
 * Args:
 * * amount : duration for src to be disoriented
 * * stamina_amount : stamina damage to deal before LERP
 * * ignore_canstun : ignore stun immunities, if using a secondary form of status
 * * knockdown : duration to knock src down
 * * stun : duration to stun src
 * * paralyze : duration to paralyze src
 * * overstam : If TRUE, stamina_amount will be able to deal stamina damage over the waekened threshold, allowing it to also stamina stun.
 * * stack_status : Should the given status value(s) stack ontop of existing status values?
 */
/mob/living/proc/Disorient(amount, stamina_amount, ignore_canstun, knockdown, stun, paralyze, overstam, stack_status = TRUE)
	var/protection_amt = 0
	///placeholder
	var/disorient_multiplier = 1 - (protection_amt/100)
	var/stamina_multiplier = LERP(disorient_multiplier, 1, 0.25)

	var/stam2deal = stamina_amount * stamina_multiplier

	//You can never be stam-stunned w/o overstam
	if(overstam)
		stamina.adjust(-stam2deal)
	else
		var/threshold = (stamina.maximum * STAMINA_STUN_THRESHOLD_MODIFIER)
		stam2deal = stamina.current - stam2deal < threshold ? (stam2deal - threshold) : (stam2deal)
		if(stam2deal)
			stamina.adjust(-stam2deal)

	if(HAS_TRAIT(src, TRAIT_EXHAUSTED))
		if(knockdown)
			if(stack_status)
				AdjustKnockdown(knockdown, ignore_canstun)
			else
				Knockdown(knockdown, ignore_canstun)

		if(paralyze)
			if(stack_status)
				AdjustParalyzed(paralyze, ignore_canstun)
			else
				Paralyze(paralyze, ignore_canstun)

		if(stun)
			if(stack_status)
				AdjustStun(stun, ignore_canstun)
			else
				Stun(stun, ignore_canstun)

	if(amount > 0)
		adjust_timed_status_effect(amount, /datum/status_effect/incapacitating/disoriented, 15 SECONDS)

	return


/mob/living/proc/IsDisoriented() //If we're paralyzed
	return has_status_effect(/datum/status_effect/incapacitating/disoriented)

/mob/living/proc/AmountDisoriented() //How many deciseconds remain in our Paralyzed status effect
	var/datum/status_effect/incapacitating/disoriented/P = IsDisoriented()
	if(P)
		return P.duration - world.time
	return 0

//Blanket
/mob/living/proc/AllImmobility(amount)
	Paralyze(amount)
	Knockdown(amount)
	Stun(amount)
	Immobilize(amount)


/mob/living/proc/SetAllImmobility(amount)
	SetParalyzed(amount)
	SetKnockdown(amount)
	SetStun(amount)
	SetImmobilized(amount)


/mob/living/proc/AdjustAllImmobility(amount)
	AdjustParalyzed(amount)
	AdjustKnockdown(amount)
	AdjustStun(amount)
	AdjustImmobilized(amount)

//////////////////UNCONSCIOUS
/mob/living/proc/IsUnconscious() //If we're unconscious
	return has_status_effect(STATUS_EFFECT_UNCONSCIOUS)

/mob/living/proc/AmountUnconscious() //How many deciseconds remain in our unconsciousness
	var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
	if(U)
		return U.duration - world.time
	return 0

/mob/living/proc/Unconscious(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE))  || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration = max(world.time + amount, U.duration)
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount)
		return U

/mob/living/proc/SetUnconscious(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(amount <= 0)
			if(U)
				qdel(U)
		else if(U)
			U.duration = world.time + amount
		else
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount)
		return U

/mob/living/proc/AdjustUnconscious(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_UNCONSCIOUS, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if(((status_flags & CANUNCONSCIOUS) && !HAS_TRAIT(src, TRAIT_STUNIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/unconscious/U = IsUnconscious()
		if(U)
			U.duration += amount
		else if(amount > 0)
			U = apply_status_effect(STATUS_EFFECT_UNCONSCIOUS, amount)
		return U

/////////////////////////////////// SLEEPING ////////////////////////////////////

/mob/living/proc/IsSleeping() //If we're asleep
	return has_status_effect(STATUS_EFFECT_SLEEPING)

/mob/living/proc/AmountSleeping() //How many deciseconds remain in our sleep
	var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
	if(S)
		return S.duration - world.time
	return 0

/mob/living/proc/Sleeping(amount, ignore_canstun = FALSE) //Can't go below remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(S)
			S.duration = max(world.time + amount, S.duration)
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount)
		return S

/mob/living/proc/SetSleeping(amount, ignore_canstun = FALSE) //Sets remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(amount <= 0)
			if(S)
				qdel(S)
		else if(S)
			S.duration = world.time + amount
		else
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount)
		return S

/mob/living/proc/AdjustSleeping(amount, ignore_canstun = FALSE) //Adds to remaining duration
	if(SEND_SIGNAL(src, COMSIG_LIVING_STATUS_SLEEP, amount, ignore_canstun) & COMPONENT_NO_STUN)
		return
	if((!HAS_TRAIT(src, TRAIT_SLEEPIMMUNE)) || ignore_canstun)
		var/datum/status_effect/incapacitating/sleeping/S = IsSleeping()
		if(S)
			S.duration += amount
		else if(amount > 0)
			S = apply_status_effect(STATUS_EFFECT_SLEEPING, amount)
		return S

///////////////////////////////// FROZEN /////////////////////////////////////

/mob/living/proc/IsFrozen()
	return has_status_effect(/datum/status_effect/freon)

///////////////////////////////////// STUN ABSORPTION /////////////////////////////////////

/mob/living/proc/add_stun_absorption(key, duration, priority, message, self_message, examine_message)
//adds a stun absorption with a key, a duration in deciseconds, its priority, and the messages it makes when you're stun/examined, if any
	if(!islist(stun_absorption))
		stun_absorption = list()
	if(stun_absorption[key])
		stun_absorption[key]["end_time"] = world.time + duration
		stun_absorption[key]["priority"] = priority
		stun_absorption[key]["stuns_absorbed"] = 0
	else
		stun_absorption[key] = list("end_time" = world.time + duration, "priority" = priority, "stuns_absorbed" = 0, \
		"visible_message" = message, "self_message" = self_message, "examine_message" = examine_message)

/mob/living/proc/absorb_stun(amount, ignoring_flag_presence)
	if(amount < 0 || stat || ignoring_flag_presence || !islist(stun_absorption))
		return FALSE
	if(!amount)
		amount = 0
	var/priority_absorb_key
	var/highest_priority
	for(var/i in stun_absorption)
		if(stun_absorption[i]["end_time"] > world.time && (!priority_absorb_key || stun_absorption[i]["priority"] > highest_priority))
			priority_absorb_key = stun_absorption[i]
			highest_priority = priority_absorb_key["priority"]
	if(priority_absorb_key)
		if(amount) //don't spam up the chat for continuous stuns
			if(priority_absorb_key["visible_message"] || priority_absorb_key["self_message"])
				if(priority_absorb_key["visible_message"] && priority_absorb_key["self_message"])
					visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>", "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
				else if(priority_absorb_key["visible_message"])
					visible_message("<span class='warning'>[src][priority_absorb_key["visible_message"]]</span>")
				else if(priority_absorb_key["self_message"])
					to_chat(src, "<span class='boldwarning'>[priority_absorb_key["self_message"]]</span>")
			priority_absorb_key["stuns_absorbed"] += amount
		return TRUE

/////////////////////////////////// STASIS ///////////////////////////////////

/mob/living/proc/IsInStasis()
	. = has_status_effect(STATUS_EFFECT_STASIS)

/mob/living/proc/SetStasis(apply, updating = TRUE)
	. = apply ? apply_status_effect(STATUS_EFFECT_STASIS, null, updating) : remove_status_effect(STATUS_EFFECT_STASIS)

/////////////////////////////////// DISABILITIES ////////////////////////////////////
/mob/living/proc/add_quirk(quirktype, spawn_effects) //separate proc due to the way these ones are handled
	if(HAS_TRAIT(src, quirktype))
		return
	var/datum/quirk/T = quirktype
	var/qname = initial(T.name)
	if(!SSquirks || !SSquirks.quirks[qname])
		return
	new quirktype (src, spawn_effects)
	return TRUE

/mob/living/proc/remove_quirk(quirktype)
	for(var/datum/quirk/Q in roundstart_quirks)
		if(Q.type == quirktype)
			qdel(Q)
			return TRUE
	return FALSE

/mob/living/proc/has_quirk(quirktype)
	for(var/datum/quirk/Q in roundstart_quirks)
		if(Q.type == quirktype)
			return TRUE
	return FALSE

/////////////////////////////////// TRAIT PROCS ////////////////////////////////////

/mob/living/proc/cure_blind(source)
	REMOVE_TRAIT(src, TRAIT_BLIND, source)
	if(!HAS_TRAIT(src, TRAIT_BLIND))
		update_blindness()

/mob/living/proc/become_blind(source)
	if(!HAS_TRAIT(src, TRAIT_BLIND)) // not blind already, add trait then overlay
		ADD_TRAIT(src, TRAIT_BLIND, source)
		update_blindness()
	else
		ADD_TRAIT(src, TRAIT_BLIND, source)

/mob/living/proc/cure_nearsighted(source)
	REMOVE_TRAIT(src, TRAIT_NEARSIGHT, source)
	if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
		clear_fullscreen("nearsighted")

/mob/living/proc/become_nearsighted(source)
	if(!HAS_TRAIT(src, TRAIT_NEARSIGHT))
		overlay_fullscreen("nearsighted", /atom/movable/screen/fullscreen/impaired, 1)
	ADD_TRAIT(src, TRAIT_NEARSIGHT, source)

/mob/living/proc/cure_husk(source)
	REMOVE_TRAIT(src, TRAIT_HUSK, source)
	if(!HAS_TRAIT(src, TRAIT_HUSK))
		REMOVE_TRAIT(src, TRAIT_DISFIGURED, "husk")
		update_body()
		return TRUE

/mob/living/proc/become_husk(source)
	if(!HAS_TRAIT(src, TRAIT_HUSK))
		ADD_TRAIT(src, TRAIT_HUSK, source)
		ADD_TRAIT(src, TRAIT_DISFIGURED, "husk")
		update_body()
	else
		ADD_TRAIT(src, TRAIT_HUSK, source)

/mob/living/proc/cure_fakedeath(source)
	REMOVE_TRAIT(src, TRAIT_FAKEDEATH, source)
	REMOVE_TRAIT(src, TRAIT_DEATHCOMA, source)
	if(stat != DEAD)
		tod = null

/mob/living/carbon/proc/fakedeath(source, silent = FALSE)
	if(stat == DEAD)
		return
	if(!silent)
		emote("deathgasp")
	for(var/datum/disease/advance/D in diseases)
		for(var/symptom in D.symptoms)
			var/datum/symptom/S = symptom
			S.OnDeath(D)
	ADD_TRAIT(src, TRAIT_FAKEDEATH, source)
	ADD_TRAIT(src, TRAIT_DEATHCOMA, source)
	tod = station_time_timestamp()

/mob/living/proc/unignore_slowdown(source)
	REMOVE_TRAIT(src, TRAIT_IGNORESLOWDOWN, source)
	update_movespeed(FALSE)

/mob/living/proc/ignore_slowdown(source)
	ADD_TRAIT(src, TRAIT_IGNORESLOWDOWN, source)
	update_movespeed(FALSE)
	client?.move_delay = world.time

/**
 * Sets the [SHOCKED_1] flag on this mob.
 */
/mob/living/proc/set_shocked()
	flags_1 |= SHOCKED_1

/**
 * Unsets the [SHOCKED_1] flag on this mob.
 */
/mob/living/proc/reset_shocked()
	flags_1 &= ~ SHOCKED_1

/**
 * Adjusts a timed status effect on the mob,taking into account any existing timed status effects.
 * This can be any status effect that takes into account "duration" with their initialize arguments.
 *
 * Positive durations will add deciseconds to the duration of existing status effects
 * or apply a new status effect of that duration to the mob.
 *
 * Negative durations will remove deciseconds from the duration of an existing version of the status effect,
 * removing the status effect entirely if the duration becomes less than zero (less than the current world time).
 *
 * duration - the duration, in deciseconds, to add or remove from the effect
 * effect - the type of status effect being adjusted on the mob
 * max_duration - optional - if set, positive durations will only be added UP TO the passed max duration
 */
/mob/living/proc/adjust_timed_status_effect(duration, effect, max_duration)
	if(!isnum(duration))
		CRASH("adjust_timed_status_effect: called with an invalid duration. (Got: [duration])")

	if(!ispath(effect, /datum/status_effect))
		CRASH("adjust_timed_status_effect: called with an invalid effect type. (Got: [effect])")

	// If we have a max duration set, we need to check our duration does not exceed it
	if(isnum(max_duration))
		if(max_duration <= 0)
			CRASH("adjust_timed_status_effect: Called with an invalid max_duration. (Got: [max_duration])")

		if(duration >= max_duration)
			duration = max_duration

	var/datum/status_effect/existing = has_status_effect(effect)
	if(existing)
		if(isnum(max_duration) && duration > 0)
			// Check the duration remaining on the existing status effect
			// If it's greater than / equal to our passed max duration, we don't need to do anything
			var/remaining_duration = existing.duration - world.time
			if(remaining_duration >= max_duration)
				return

			// Otherwise, add duration up to the max (max_duration - remaining_duration),
			// or just add duration if it doesn't exceed our max at all
			existing.duration += min(max_duration - remaining_duration, duration)

		else
			existing.duration += duration

		// If the duration was decreased and is now less 0 seconds,
		// qdel it / clean up the status effect immediately
		// (rather than waiting for the process tick to handle it)
		if(existing.duration <= world.time)
			qdel(existing)

	else if(duration > 0)
		apply_status_effect(effect, duration)

/**
 * Sets a timed status effect of some kind on a mob to a specific value.
 * If only_if_higher is TRUE, it will only set the value up to the passed duration,
 * so any pre-existing status effects of the same type won't be reduced down
 *
 * duration - the duration, in deciseconds, of the effect. 0 or lower will either remove the current effect or do nothing if none are present
 * effect - the type of status effect given to the mob
 * only_if_higher - if TRUE, we will only set the effect to the new duration if the new duration is longer than any existing duration
 */
/mob/living/proc/set_timed_status_effect(duration, effect, only_if_higher = FALSE)
	if(!isnum(duration))
		CRASH("set_timed_status_effect: called with an invalid duration. (Got: [duration])")

	if(!ispath(effect, /datum/status_effect))
		CRASH("set_timed_status_effect: called with an invalid effect type. (Got: [effect])")

	var/datum/status_effect/existing = has_status_effect(effect)
	if(existing)
		// set_timed_status_effect to 0 technically acts as a way to clear effects,
		// though remove_status_effect would achieve the same goal more explicitly.
		if(duration <= 0)
			qdel(existing)
			return

		if(only_if_higher)
			// If the existing status effect has a higher remaining duration
			// than what we aim to set it to, don't downgrade it - do nothing (return)
			var/remaining_duration = existing.duration - world.time
			if(remaining_duration >= duration)
				return

		// Set the duration accordingly
		existing.duration = world.time + duration

	else if(duration > 0)
		apply_status_effect(effect, duration)

/**
 * Gets how many deciseconds are remaining in
 * the duration of the passed status effect on this mob.
 *
 * If the mob is unaffected by the passed effect, returns 0.
 */
/mob/living/proc/get_timed_status_effect_duration(effect)
	if(!ispath(effect, /datum/status_effect))
		CRASH("get_timed_status_effect_duration: called with an invalid effect type. (Got: [effect])")

	var/datum/status_effect/existing = has_status_effect(effect)
	if(!existing)
		return 0
	// Infinite duration status effects technically are not "timed status effects"
	// by name or nature, but support is included just in case.
	if(existing.duration == -1)
		return INFINITY

	return existing.duration - world.time
