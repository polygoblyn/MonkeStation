/obj/effect/abstract/liquid_turf
	name = "liquid"
	icon = 'monkestation/code/modules/liquids/icons/obj/effects/liquid.dmi'
	icon_state = "water-0"
	base_icon_state = "water"
	anchored = TRUE
	plane = FLOOR_PLANE
	color = "#DDF"
	alpha = 175
	//For being on fire
	light_range = 0
	light_power = 1
	light_color = LIGHT_COLOR_FIRE

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WATER)
	canSmoothWith = list(SMOOTH_GROUP_WALLS, SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WATER)

	mouse_opacity = FALSE

	var/datum/liquid_group/liquid_group
	var/turf/my_turf

	var/immutable = FALSE

	var/fire_state = LIQUID_FIRE_STATE_NONE
	var/liquid_state = LIQUID_STATE_PUDDLE
	var/no_effects = FALSE


	var/static/obj/effect/abstract/fire/small_fire/small_fire
	var/static/obj/effect/abstract/fire/medium_fire/medium_fire
	var/static/obj/effect/abstract/fire/big_fire/big_fire

	var/mutable_appearance/displayed_content
	/// State-specific message chunks for examine_turf()
	var/static/list/liquid_state_messages = list(
		"[LIQUID_STATE_PUDDLE]" = "a puddle of $",
		"[LIQUID_STATE_ANKLES]" = "$ going [span_warning("up to your ankles")]",
		"[LIQUID_STATE_WAIST]" = "$ going [span_warning("up to your waist")]",
		"[LIQUID_STATE_SHOULDERS]" = "$ going [span_warning("up to your shoulders")]",
		"[LIQUID_STATE_FULLTILE]" = "$ going [span_danger("over your head")]",
	)

/obj/effect/abstract/liquid_turf/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	return


/obj/effect/abstract/liquid_turf/proc/process_evaporation()
	if(immutable)
		SSliquids.evaporation_queue -= my_turf
		return

	if(liquid_group.expected_turf_height > LIQUID_ANKLES_LEVEL_HEIGHT)
		SSliquids.evaporation_queue -= my_turf
		return

	//See if any of our reagents evaporates
	var/any_change = FALSE
	var/datum/reagent/R //Faster declaration
	for(var/reagent_type in liquid_group.reagents.reagent_list)
		R = reagent_type
		//We evaporate. bye bye
		if(initial(R.evaporates))
			var/remove_amount = min((initial(R.evaporation_rate)), R.volume, (liquid_group.reagents_per_turf / liquid_group.reagents.reagent_list.len))
			passthrough_evaporation_reaction(R, remove_amount)
			liquid_group.remove_specific(src, remove_amount, R)
			any_change = TRUE

	if(!any_change)
		SSliquids.evaporation_queue -= my_turf
		return

/obj/effect/abstract/liquid_turf/forceMove(atom/destination, no_tp=FALSE, harderforce = FALSE)
	if(harderforce)
		. = ..()

/obj/effect/abstract/liquid_turf/proc/passthrough_evaporation_reaction(datum/reagent/reagent, reac_volume)
	var/datum/reagent/evaporated_reagent = GLOB.chemical_reagents_list[reagent.type]
	var/turf/open/evaporated_turf = get_turf(src)
	evaporated_reagent.reaction_evaporation(evaporated_turf, reac_volume)

/obj/effect/abstract/liquid_turf/proc/set_new_liquid_state(new_state)
	if(no_effects)
		return
	cut_overlays()
	liquid_state = new_state
	switch(new_state)
		if(LIQUID_STATE_PUDDLE)
			QUEUE_SMOOTH(src)
			QUEUE_SMOOTH_NEIGHBORS(src)
		if(LIQUID_STATE_ANKLES)
			var/mutable_appearance/overlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage1_bottom")
			var/mutable_appearance/underlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage1_top")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			underlay.plane = GAME_PLANE
			underlay.layer = 2.85
			add_overlay(overlay)
			add_overlay(underlay)
		if(LIQUID_STATE_WAIST)
			var/mutable_appearance/overlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage2_bottom")
			var/mutable_appearance/underlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage2_top")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			underlay.plane = GAME_PLANE
			underlay.layer = 2.85
			add_overlay(overlay)
			add_overlay(underlay)
		if(LIQUID_STATE_SHOULDERS)
			var/mutable_appearance/overlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage3_bottom")
			var/mutable_appearance/underlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage3_top")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			underlay.plane = GAME_PLANE
			underlay.layer = 2.85
			add_overlay(overlay)
			add_overlay(underlay)
		if(LIQUID_STATE_FULLTILE)
			var/mutable_appearance/overlay = mutable_appearance('monkestation/code/modules/liquids/icons/obj/effects/liquid_overlays.dmi', "stage4_bottom")
			overlay.plane = GAME_PLANE
			overlay.layer = ABOVE_MOB_LAYER
			add_overlay(overlay)

/obj/effect/abstract/liquid_turf/proc/set_fire_effect()
	if(displayed_content)
		vis_contents -= displayed_content

	if(!liquid_group)
		return

	switch(liquid_group.group_fire_state)
		if(LIQUID_FIRE_STATE_SMALL)
			displayed_content = small_fire
		if(LIQUID_FIRE_STATE_MILD)
			displayed_content = small_fire
		if(LIQUID_FIRE_STATE_MEDIUM)
			displayed_content = medium_fire
		if(LIQUID_FIRE_STATE_HUGE)
			displayed_content = big_fire
		if(LIQUID_FIRE_STATE_INFERNO)
			displayed_content = big_fire
		else
			displayed_content = null

	if(displayed_content)
		vis_contents |= displayed_content

//Takes a flat of our reagents and returns it, possibly qdeling our liquids
/obj/effect/abstract/liquid_turf/proc/take_reagents_flat(flat_amount)
	liquid_group.remove_any(src, flat_amount)

/obj/effect/abstract/liquid_turf/fire_act(temperature, volume)
	return

/obj/effect/abstract/liquid_turf/proc/set_reagent_color_for_liquid()
	liquid_group.group_color = mix_color_from_reagent_list(liquid_group.reagents.reagent_list)

/obj/effect/abstract/liquid_turf/proc/calculate_height()
	return

///old proc only used on immutables
/obj/effect/abstract/liquid_turf/proc/set_height(new_height)
	var/prev_height = liquid_group.expected_turf_height
	liquid_group.expected_turf_height = new_height
	if(abs(liquid_group.expected_turf_height - prev_height) > WATER_HEIGH_DIFFERENCE_DELTA_SPLASH)
		//Splash
		if(prob(WATER_HEIGH_DIFFERENCE_SOUND_CHANCE))
			var/sound_to_play = pick(list(
				'monkestation/code/modules/liquids/sound/effects/water_wade1.ogg',
				'monkestation/code/modules/liquids/sound/effects/water_wade2.ogg',
				'monkestation/code/modules/liquids/sound/effects/water_wade3.ogg',
				'monkestation/code/modules/liquids/sound/effects/water_wade4.ogg'
				))
			playsound(my_turf, sound_to_play, 60, 0)
		var/obj/splashy = new /obj/effect/temp_visual/liquid_splash(my_turf)
		splashy.color = color
		if(liquid_group.expected_turf_height >= LIQUID_WAIST_LEVEL_HEIGHT)
			//Push things into some direction, like space wind
			var/turf/dest_turf
			var/last_height = liquid_group.expected_turf_height
			for(var/turf in my_turf.atmos_adjacent_turfs)
				var/turf/T = turf
				if(T.z != my_turf.z)
					continue
				if(!T.liquids) //Automatic winner
					dest_turf = T
					break
				if(T.liquids.liquid_group.expected_turf_height < last_height)
					dest_turf = T
					last_height = T.liquids.liquid_group.expected_turf_height
			if(dest_turf)
				var/dir = get_dir(my_turf, dest_turf)
				var/atom/movable/AM
				for(var/thing in my_turf)
					AM = thing
					if(!AM.anchored && !AM.pulledby && !isobserver(AM) && (AM.move_resist < INFINITY))
						if(iscarbon(AM))
							var/mob/living/carbon/C = AM
							if(!(C.shoes && C.shoes.clothing_flags & NOSLIP))
								step(C, dir)
								if(prob(60) && MOBILITY_STAND)
									to_chat(C, span_userdanger("The current knocks you down!"))
									C.Paralyze(60)
						else
							step(AM, dir)

/obj/effect/abstract/liquid_turf/proc/movable_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	var/turf/T = source
	if(isobserver(AM))
		return //ghosts, camera eyes, etc. don't make water splashy splashy
	if(liquid_group.group_overlay_state >= LIQUID_STATE_ANKLES)
		if(prob(30))
			var/sound_to_play = pick(list(
				'monkestation/code/modules/liquids/sound/effects/water_wade1.ogg',
				'monkestation/code/modules/liquids/sound/effects/water_wade2.ogg',
				'monkestation/code/modules/liquids/sound/effects/water_wade3.ogg',
				'monkestation/code/modules/liquids/sound/effects/water_wade4.ogg'
				))
			playsound(T, sound_to_play, 50, 0)
		if(iscarbon(AM))
			var/mob/living/carbon/C = AM
			C.apply_status_effect(/datum/status_effect/water_affected)
	else if (isliving(AM))
		var/mob/living/L = AM
		if(prob(7) && !(L.movement_type & FLYING))
			L.slip(30, T, NO_SLIP_WHEN_WALKING, 0, TRUE)

	if(fire_state)
		AM.fire_act((T20C+50) + (50*fire_state), 125)

/obj/effect/abstract/liquid_turf/proc/mob_fall(datum/source, mob/M)
	SIGNAL_HANDLER
	var/turf/T = source
	if(liquid_group.group_overlay_state >= LIQUID_STATE_ANKLES && T.has_gravity(T))
		playsound(T, 'monkestation/code/modules/liquids/sound/effects/splash.ogg', 50, 0)
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			if(C.wear_mask && C.wear_mask.flags_cover & MASKCOVERSMOUTH)
				to_chat(C, span_userdanger("You fall in the water!"))
			else
				liquid_group.transfer_to_atom(src, CHOKE_REAGENTS_INGEST_ON_FALL_AMOUNT, C)
				C.adjustOxyLoss(5)
				//C.emote("cough")
				INVOKE_ASYNC(C, /mob.proc/emote, "cough")
				to_chat(C, span_userdanger("You fall in and swallow some water!"))
		else
			to_chat(M, span_userdanger("You fall in the water!"))

/obj/effect/abstract/liquid_turf/Initialize(mapload, datum/liquid_group/group_to_add)
	. = ..()
	if(!small_fire)
		small_fire = new
	if(!medium_fire)
		medium_fire = new
	if(!big_fire)
		big_fire = new

	if(!my_turf)
		my_turf = loc

	if(!my_turf.liquids)
		my_turf.liquids = src

	if(group_to_add)
		group_to_add.add_to_group(my_turf)
		set_new_liquid_state(liquid_group.group_overlay_state)

	if(!liquid_group && !group_to_add)
		liquid_group = new(1, src)

	if(!SSliquids)
		CRASH("Liquid Turf created with the liquids sybsystem not yet initialized!")
	if(!immutable)
		my_turf = loc
		RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, .proc/movable_entered)
		RegisterSignal(my_turf, COMSIG_TURF_MOB_FALL, .proc/mob_fall)
		RegisterSignal(my_turf, COMSIG_PARENT_EXAMINE, .proc/examine_turf)
		SSliquids.add_active_turf(my_turf)

		SEND_SIGNAL(my_turf, COMSIG_TURF_LIQUIDS_CREATION, src)

	if(z)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

	/* //Cant do it immediately, hmhm
	if(isspaceturf(my_turf))
		qdel(src, TRUE)
	*/

/obj/effect/abstract/liquid_turf/Destroy(force)
	UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_TURF_MOB_FALL, COMSIG_PARENT_EXAMINE))
	if(liquid_group)
		liquid_group.remove_from_group(my_turf)
	if(my_turf in SSliquids.active_edge_turfs)
		SSliquids.active_edge_turfs -= my_turf
	if(my_turf in SSliquids.evaporation_queue)
		SSliquids.evaporation_queue -= my_turf
	if(my_turf in SSliquids.burning_turfs)
		SSliquids.burning_turfs -= my_turf
	my_turf.liquids = null
	my_turf = null
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/abstract/liquid_turf/proc/ChangeToNewTurf(turf/NewT)
	if(NewT.liquids)
		stack_trace("Liquids tried to change to a new turf, that already had liquids on it!")

	UnregisterSignal(my_turf, list(COMSIG_ATOM_ENTERED, COMSIG_TURF_MOB_FALL))
	if(SSliquids.active_turfs[my_turf])
		SSliquids.active_turfs -= my_turf
		SSliquids.active_turfs[NewT] = TRUE
	if(SSliquids.evaporation_queue[my_turf])
		SSliquids.evaporation_queue -= my_turf
		SSliquids.evaporation_queue[NewT] = TRUE
	my_turf.liquids = null
	my_turf = NewT
	liquid_group.move_liquid_group(src)
	NewT.liquids = src
	loc = NewT
	RegisterSignal(my_turf, COMSIG_ATOM_ENTERED, .proc/movable_entered)
	RegisterSignal(my_turf, COMSIG_TURF_MOB_FALL, .proc/mob_fall)

/**
 * Handles COMSIG_PARENT_EXAMINE for the turf.
 *
 * Adds reagent info to examine text.
 * Arguments:
 * * source - the turf we're peekin at
 * * examiner - the user
 * * examine_text - the examine list
 *  */
/obj/effect/abstract/liquid_turf/proc/examine_turf(turf/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER

	// This should always have reagents if this effect object exists, but as a sanity check...
	if(!length(liquid_group.reagents.reagent_list))
		return

	var/liquid_state_template = liquid_state_messages["[liquid_group.group_overlay_state]"]

	examine_list +=  "<hr>"

	if(examiner.can_see_reagents())
		examine_list +=  "<hr>"

		if(length(liquid_group.reagents.reagent_list) == 1)
			// Single reagent text.
			var/datum/reagent/reagent_type = liquid_group.reagents.reagent_list[1]
			var/reagent_name = initial(reagent_type.name)
			var/volume = round(reagent_type.volume / length(liquid_group.members), 0.01)

			examine_list += span_notice("There is [replacetext(liquid_state_template, "$", "[volume] units of [reagent_name]")] here.")
		else
			// Show each individual reagent
			examine_list += "There is [replacetext(liquid_state_template, "$", "the following")] here:"

			for(var/datum/reagent/reagent_type as anything in liquid_group.reagents.reagent_list)
				var/reagent_name = initial(reagent_type.name)
				var/volume = round(reagent_type.volume / length(liquid_group.members), 0.01)
				examine_list += "&bull; [volume] units of [reagent_name]"

		examine_list += span_notice("The solution has a temperature of [liquid_group.group_temperature]K.")
		examine_list +=  "<hr>"
		return

	// Otherwise, just show the total volume
	examine_list += span_notice("There is [replacetext(liquid_state_template, "$", "liquid")] here.")

/obj/effect/temp_visual/liquid_splash
	icon = 'monkestation/code/modules/liquids/icons/obj/effects/splash.dmi'
	icon_state = "splash"
	layer = FLY_LAYER
	randomdir = FALSE

/obj/effect/abstract/fire
	icon = 'monkestation/code/modules/liquids/icons/obj/effects/liquid.dmi'
	plane = FLOOR_PLANE
	layer = BELOW_MOB_LAYER
	mouse_opacity = FALSE
	appearance_flags = RESET_COLOR | RESET_ALPHA

/obj/effect/abstract/fire/small_fire
	icon_state = "fire_small"

/obj/effect/abstract/fire/medium_fire
	icon_state = "fire_medium"

/obj/effect/abstract/fire/big_fire
	icon_state = "fire_big"
