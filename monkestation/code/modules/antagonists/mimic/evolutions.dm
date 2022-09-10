//Greater mimics

/mob/living/simple_animal/hostile/alien_mimic/greater
	name = "greater mimic"
	real_name = "greater mimic"
	maxHealth = 175
	health = 175
	melee_damage = 9
	secondary_damage_type = BRUTE
	hivemind_modifier = "Greater"
	can_evolve = FALSE

/mob/living/simple_animal/hostile/alien_mimic/greater/allowed(atom/movable/target_item)
	return isitem(target_item) || (get_dist(src,target_item) > 1 && ismachinery(target_item) && !istype(target_item,/obj/machinery/atmospherics)) //dist check so you can still break things

//Voltaic Mimics

/mob/living/simple_animal/hostile/alien_mimic/voltaic
	name = "voltaic mimic"
	real_name = "voltaic mimic"
	melee_damage = 5
	secondary_damage_type = BURN
	hivemind_modifier = "Voltaic"
	can_evolve = FALSE

/mob/living/simple_animal/hostile/alien_mimic/voltaic/Initialize(mapload)
	. = ..()
	var/obj/effect/proc_holder/spell/self/mimic_emp/emp = new
	AddSpell(emp)

/mob/living/simple_animal/hostile/alien_mimic/voltaic/death(gibbed)
	tesla_zap(src, 5, 4000)
	..()

/mob/living/simple_animal/hostile/alien_mimic/voltaic/AttackingTarget()
	if(!isliving(target))
		return ..()

	var/mob/living/victim = target
	if(buckled && buckled == victim)
		victim.Stun(1 SECONDS)
		victim.electrocute_act(1, src)
	..()

/obj/effect/proc_holder/spell/self/mimic_emp
	name = "EMP"
	desc = "Send out electromagnetic pulses, scrambling electronics in the area."
	action_icon_state = "emp"
	clothes_req = FALSE
	action_background_icon_state = "bg_alien"
	charge_max = 1 MINUTES
	sound = 'sound/weapons/zapbang.ogg'

/obj/effect/proc_holder/spell/self/mimic_emp/cast(mob/living/carbon/human/user)
	playsound(get_turf(user), sound, 50,1)
	empulse(get_turf(user), 4, 7)
	return

//Thermal Mimics

/mob/living/simple_animal/hostile/alien_mimic/thermal
	name = "thermal mimic"
	real_name = "thermal mimic"
	melee_damage = 7
	melee_damage_type = BURN
	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	hivemind_modifier = "Thermal"
	can_evolve = FALSE

/mob/living/simple_animal/hostile/alien_mimic/thermal/death(gibbed)
	new /obj/effect/hotspot(get_turf(src))
	..()

/mob/living/simple_animal/hostile/alien_mimic/thermal/AttackingTarget()
	if(buckled && buckled == target)
		new /obj/effect/hotspot(get_turf(target))
	..()

//Shifty Mimics

/mob/living/simple_animal/hostile/alien_mimic/shifty
	name = "shifty mimic"
	real_name = "shifty mimic"
	hivemind_modifier = "Shifty"
	melee_damage = 5
	can_evolve = FALSE

/mob/living/simple_animal/hostile/alien_mimic/shifty/Initialize(mapload)
	. = ..()
	var/obj/effect/proc_holder/spell/pointed/mimic_phantom_shift/shift = new
	AddSpell(shift)

/obj/effect/proc_holder/spell/pointed/mimic_phantom_shift
	name = "Phantom Shift"
	desc = "Quickly reform in another position."
	clothes_req = FALSE
	action_background_icon_state = "bg_alien"
	charge_max = 30 SECONDS

/obj/effect/proc_holder/spell/pointed/mimic_phantom_shift/cast(list/targets,mob/user = usr)
	for(var/target in targets)
		var/turf/target_turf = get_turf(target)
		if(target_turf.density)
			to_chat(user,"<span class='notice'>You can't teleport there!</span>")
			revert_cast(user)
			return
		var/mob/living/teleport_with
		if(user.buckled)
			teleport_with = user.buckled
		do_teleport(user, target_turf)
		if(teleport_with)
			do_teleport(teleport_with, target_turf)
			teleport_with.buckle_mob(user,TRUE)
		return
	revert_cast(user)


