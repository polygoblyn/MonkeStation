/datum/ai_behavior/chicken_attack_mob
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM //performs to increase frustration

/datum/ai_behavior/chicken_attack_mob/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/target = controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]
	var/mob/living/living_pawn = controller.pawn

	if(!target || target.stat != CONSCIOUS)
		finish_action(controller, TRUE) //we don't want chickens to kill or maybe we do this can be adjusted

	if(isturf(target.loc) && !IS_DEAD_OR_INCAP(living_pawn)) // Check if they're a valid target
		chicken_attack(controller, target, delta_time, FALSE)

/datum/ai_behavior/chicken_attack_mob/finish_action(datum/ai_controller/controller, succeeded)
	. = ..()
	var/mob/living/living_pawn = controller.pawn
	SSmove_manager.stop_looping(living_pawn)
	controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] = null

/// attack using a projectile otherwise unarmed the enemy, then if we are angry there is a chance we might calm down a little
/datum/ai_behavior/chicken_attack_mob/proc/shoot(atom/targeted_atom, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/atom/target_from = living_pawn
	if(QDELETED(targeted_atom) || targeted_atom == target_from.loc || targeted_atom == target_from )
		return
	var/turf/startloc = get_turf(target_from)
	if(controller.blackboard[BB_CHICKEN_PROJECTILE])
		var/projectile_type = controller.blackboard[BB_CHICKEN_PROJECTILE]
		var/obj/item/projectile/used_projectile = new projectile_type(startloc)
		used_projectile.starting = startloc
		used_projectile.firer = living_pawn
		used_projectile.fired_from = living_pawn
		used_projectile.yo = targeted_atom.y - startloc.y
		used_projectile.xo = targeted_atom.x - startloc.x
		used_projectile.original = targeted_atom
		used_projectile.preparePixelProjectile(targeted_atom, living_pawn)
		used_projectile.fire()
		return used_projectile

/datum/ai_behavior/chicken_attack_mob/proc/chicken_attack(datum/ai_controller/controller, mob/living/target, delta_time, disarm)
	var/mob/living/living_pawn = controller.pawn

	if(living_pawn.next_move > world.time)
		return

	living_pawn.changeNext_move(CLICK_CD_MELEE) //We play fair

	living_pawn.face_atom(target)

	living_pawn.a_intent = INTENT_HARM

	// check for projectile and roll a dice, than fire that bad boy
	if(controller.blackboard[BB_CHICKEN_PROJECTILE] && DT_PROB(5, delta_time))
		shoot(target, controller)

	// attack with weapon if we have one (we don't as of now as sword chickens are frauds)
	if(living_pawn.CanReach(target))
		living_pawn.UnarmedAttack(target)

	living_pawn.a_intent = INTENT_HELP

	// no de-aggro
	if(controller.blackboard[BB_CHICKEN_AGGRESSIVE])
		return

	// reduce aggro
	if(DT_PROB(CHICKEN_HATRED_REDUCTION_PROB, delta_time))
		controller.blackboard[BB_CHICKEN_SHITLIST][target]--

	// if we are not angry at our target, go back to idle
	if(controller.blackboard[BB_CHICKEN_SHITLIST][target] <= 0)
		var/list/enemies = controller.blackboard[BB_CHICKEN_SHITLIST]
		enemies.Remove(target)
		if(controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET] == target)
			finish_action(controller, TRUE)

/datum/ai_behavior/recruit_chickens/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	controller.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] = world.time + CHICKEN_RECRUIT_COOLDOWN
	var/mob/living/living_pawn = controller.pawn

	for(var/mob/living/living_viewers in view(living_pawn, CHICKEN_ENEMY_VISION))
		if(!HAS_AI_CONTROLLER_TYPE(living_viewers, /datum/ai_controller/chicken))
			continue

		if(!DT_PROB(CHICKEN_RECRUIT_PROB, delta_time))
			continue

		var/datum/ai_controller/chicken/chicken_ai = living_viewers.ai_controller

		var/atom/your_enemy = controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]
		var/list/enemies = living_viewers.ai_controller.blackboard[BB_CHICKEN_SHITLIST]
		enemies[your_enemy] = CHICKEN_RECRUIT_HATED_AMOUNT
		chicken_ai.blackboard[BB_CHICKEN_RECRUIT_COOLDOWN] = world.time + CHICKEN_RECRUIT_COOLDOWN
	finish_action(controller, TRUE)

/datum/ai_behavior/chicken_flee

/datum/ai_behavior/chicken_flee/perform(delta_time, datum/ai_controller/controller)
	. = ..()

	var/mob/living/living_pawn = controller.pawn

	var/mob/living/target = null

	// flee from anyone who attacked us and we didn't beat down
	for(var/mob/living/viewed_living in view(living_pawn, CHICKEN_FLEE_VISION))
		if(controller.blackboard[BB_CHICKEN_SHITLIST][viewed_living] && viewed_living.stat == CONSCIOUS)
			target = viewed_living
			break

	if(target)
		SSmove_manager.move_away(living_pawn, target, max_dist = CHICKEN_ENEMY_VISION, delay = 5)
	else
		finish_action(controller, TRUE)

/datum/ai_behavior/eat_ground_food

/datum/ai_behavior/eat_ground_food/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/simple_animal/chicken/living_pawn = controller.pawn
	controller.blackboard[BB_CHICKEN_FOOD_COOLDOWN] = world.time + 15 SECONDS
	if(living_pawn.current_feed_amount > 3) // so no vomit
		finish_action(controller, TRUE)

	var/list/blacklisted_foods = typesof(/obj/item/food/egg) //blacklist all eggs as they hate eggs
	var/list/floor_foods = list()
	for(var/obj/item/food/food_item in view(3, living_pawn.loc))
		if(!(food_item.type in blacklisted_foods))
			floor_foods |= food_item
	if(floor_foods.len)
		var/obj/item/food/chosen_one = pick(floor_foods)

		if(!SSmove_manager.jps_move(living_pawn, chosen_one, 4, timeout = 5 SECONDS))
			finish_action(controller, TRUE)

		if(living_pawn.CanReach(chosen_one))
			living_pawn.feed_food(chosen_one)
			SSmove_manager.stop_looping(living_pawn) // since we added gotta also remove
			finish_action(controller, TRUE)
		if(!chosen_one)
			SSmove_manager.stop_looping(living_pawn) // since we added gotta also remove
			finish_action(controller, TRUE)
	else
		finish_action(controller, TRUE)


/datum/ai_behavior/follow_leader

/datum/ai_behavior/follow_leader/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/living_pawn = controller.pawn
	var/mob/living/target = controller.blackboard[BB_CHICKEN_CURRENT_LEADER]

	if(controller.blackboard[BB_CHICKEN_CURRENT_ATTACK_TARGET]) // they care more about attacking right now
		finish_action(controller, TRUE)
	if(target)
		step_to(living_pawn, target,1)
	else
		finish_action(controller, TRUE)

/datum/ai_behavior/find_and_lay

/datum/ai_behavior/find_and_lay/perform(delta_time, datum/ai_controller/controller)
	var/mob/living/simple_animal/chicken/living_pawn = controller.pawn

	var/obj/structure/nestbox/target
	for(var/obj/structure/nestbox/nesting_box in view(3, living_pawn.loc))
		target = nesting_box
		break

	if(!target)
		controller.blackboard[BB_CHICKEN_READY_LAY] = FALSE
		finish_action(controller, TRUE)

	if(!SSmove_manager.jps_move(living_pawn, target, 4, timeout = 5 SECONDS))
		finish_action(controller, TRUE)
	if(target.loc == living_pawn.loc)
		SSmove_manager.stop_looping(living_pawn)

		living_pawn.visible_message("[living_pawn] [pick(living_pawn.layMessage)]")
		var/passes_minimum_checks = FALSE
		if(living_pawn.total_times_eaten > 4 && prob(25))
			passes_minimum_checks = TRUE
		SEND_SIGNAL(living_pawn, COMSIG_MUTATION_TRIGGER, get_turf(living_pawn), passes_minimum_checks)
		living_pawn.eggs_left--

		controller.blackboard[BB_CHICKEN_READY_LAY] = FALSE
		finish_action(controller, TRUE)
