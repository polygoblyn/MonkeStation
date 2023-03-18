/datum/component/footstep
	var/steps = 0
	var/volume
	var/e_range

/datum/component/footstep/Initialize(volume_ = 0.5, e_range_ = -1)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	volume = volume_
	e_range = e_range_
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), .proc/play_footstep)

/datum/component/footstep/proc/play_footstep()
	SIGNAL_HANDLER

	var/turf/open/T = get_turf(parent)
	if(!istype(T))
		return

	var/mob/living/LM = parent
	var/v = volume
	var/e = e_range
	if(!T.footstep || LM.buckled || LM.throwing || LM.movement_type & (VENTCRAWLING | FLYING) || HAS_TRAIT(LM, TRAIT_IMMOBILIZED))
		return

	if(LM.body_position == LYING_DOWN) //play crawling sound if we're lying
		playsound(LM, 'sound/effects/footstep/crawl1.ogg', 15 * volume, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
		return

	if(iscarbon(LM))
		var/mob/living/carbon/C = LM
		if(!C.get_bodypart(BODY_ZONE_L_LEG) && !C.get_bodypart(BODY_ZONE_R_LEG))
			return
		if(ishuman(C) && C.m_intent == MOVE_INTENT_WALK)
			return // stealth
	steps++

	if(steps >= 6)
		steps = 0

	if(steps % 2)
		return

	if(!LM.has_gravity(T) && steps != 0) // don't need to step as often when you hop around
		return

	//begin playsound shenanigans//

	//for barefooted non-clawed mobs like monkeys
	if(isbarefoot(LM))
		playsound(LM, pick(GLOB.barefootstep[T.barefootstep][1]),
			GLOB.barefootstep[T.barefootstep][2] * v,
			TRUE,
			GLOB.barefootstep[T.barefootstep][3] + e, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
		return

	//for xenomorphs, dogs, and other clawed mobs
	if(isclawfoot(LM))
		if(isalienadult(LM)) //xenos are stealthy and get quieter footsteps
			v /= 2
			e -= 5

		playsound(LM, pick(GLOB.clawfootstep[T.clawfootstep][1]),
				GLOB.clawfootstep[T.clawfootstep][2] * v,
				TRUE,
				GLOB.clawfootstep[T.clawfootstep][3] + e, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
		return

	//for megafauna and other large and imtimidating mobs such as the bloodminer
	if(isheavyfoot(LM))
		playsound(LM, pick(GLOB.heavyfootstep[T.heavyfootstep][1]),
				GLOB.heavyfootstep[T.heavyfootstep][2] * v,
				TRUE,
				GLOB.heavyfootstep[T.heavyfootstep][3] + e, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
		return

	//for slimes
	if(isslime(LM))
		playsound(LM, 'sound/effects/footstep/slime1.ogg', 15 * v, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
		return

	//for (simple) humanoid mobs (clowns, russians, pirates, etc.)
	if(isshoefoot(LM))
		if(!ishuman(LM))
			playsound(LM, pick(GLOB.footstep[T.footstep][1]),
				GLOB.footstep[T.footstep][2] * v,
				TRUE,
				GLOB.footstep[T.footstep][3] + e, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
			return
		if(ishuman(LM)) //for proper humans, they're special
			var/mob/living/carbon/human/H = LM
			var/feetCover = (H.wear_suit && (H.wear_suit.body_parts_covered & FEET)) || (H.w_uniform && (H.w_uniform.body_parts_covered & FEET))

			if(H.shoes || feetCover) //are we wearing shoes
				playsound(LM, pick(GLOB.footstep[T.footstep][1]),
					GLOB.footstep[T.footstep][2] * v,
					TRUE,
					GLOB.footstep[T.footstep][3] + e, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)

			//Sound of wearing shoes always plays, special movement sound
			// IE (server motors wont play bare footed.)
			if(H.dna.species.special_step_sounds)
				playsound(LM, pick(H.dna.species.special_step_sounds), 50, TRUE, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)

			else if((!H.shoes && !feetCover)) //are we NOT wearing shoes
				playsound(LM, pick(GLOB.barefootstep[T.barefootstep][1]),
					GLOB.barefootstep[T.barefootstep][2] * v,
					TRUE,
					GLOB.barefootstep[T.barefootstep][3] + e, mixer_channel = CHANNEL_SOUND_FOOTSTEPS)
