/datum/component/mutation
	///list of all mutations possible
	var/list/possible_mutations = list()
	///does it produce eggs?
	var/produces_eggs = FALSE
	///time it stays inside the body if its not an egg production
	var/gestate_timer = 60 SECONDS


/datum/component/mutation/Initialize(list/possible_mutations, produces_eggs, gestate_timer)
	. = ..()
	src.possible_mutations = possible_mutations
	src.produces_eggs = produces_eggs
	src.gestate_timer = gestate_timer

	RegisterSignal(parent, COMSIG_MUTATION_TRIGGER, .proc/trigger_mutation)

/datum/component/mutation/proc/trigger_mutation(atom/source, turf/source_turf, passes_minimum_checks)
	var/mob/living/simple_animal/parent_animal = parent
	if(produces_eggs)
		var/obj/item/food/egg/layed_egg
		if(!passes_minimum_checks)
			layed_egg = new parent_animal.egg_type(source_turf)
			layed_egg.layer_hen_type = parent_animal.type ///this is set for now but changed later if a possible mutation is met
			parent_animal.pass_stats(layed_egg)
			return

		var/list/real_mutation = list()
		for(var/raw_list_item in parent_animal.mutation_list)
			var/datum/mutation/ranching/chicken/mutation = new raw_list_item
			real_mutation |= mutation

		if(real_mutation.len)
			var/datum/mutation/ranching/chicken/picked_mutation = pick(real_mutation)
			layed_egg = new picked_mutation.egg_type(source_turf)
			layed_egg.possible_mutations |= picked_mutation
		else
			layed_egg = new parent_animal.egg_type(source_turf)
		layed_egg.layer_hen_type = parent_animal.type ///this is set for now but changed later if a possible mutation is met
		parent_animal.pass_stats(layed_egg)

	else
		addtimer(CALLBACK(src, .proc/finished_gestate, passes_minimum_checks), gestate_timer)


/datum/component/mutation/proc/finished_gestate(passes_minimum_checks)
	var/turf/open/source_turf = get_turf(parent)
	var/mob/living/simple_animal/parent_animal = parent
	if(!passes_minimum_checks)
		var/mob/living/simple_animal/child = new parent_animal.child_type(source_turf)

		parent_animal.pass_stats(child)
