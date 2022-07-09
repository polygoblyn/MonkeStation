/mob/living/simple_animal/chick
	name = "\improper chick"
	desc = "Adorable! They make such a racket though."
	icon_state = "chick"
	icon_living = "chick"
	icon_dead = "chick_dead"
	icon_gib = "chick_gib"
	can_be_held = TRUE
	worn_slot_flags = ITEM_SLOT_HEAD
	held_state = "chick"
	gender = FEMALE
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
	speak = list("Cherp.","Cherp?","Chirrup.","Cheep!")
	speak_emote = list("cheeps")
	emote_hear = list("cheeps.")
	emote_see = list("pecks at the ground.","flaps its tiny wings.")
	density = FALSE
	speak_chance = 2
	turns_per_move = 2
	butcher_results = list(/obj/item/food/meat/slab/chicken = 1)
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicks"
	health = 3
	maxHealth = 3
	ventcrawler = VENTCRAWLER_ALWAYS
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN
	chat_color = "#FFDC9B"

	do_footstep = TRUE

	///How close to being an adult is this chicken
	var/amount_grown = 0
	///What type of chicken is this?
	var/grown_type
	///Glass chicken exclusive:what reagent were the eggs filled with?
	var/list/glass_egg_reagent = list()

/mob/living/simple_animal/chick/Initialize(mapload)
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.total_chickens++

/mob/living/simple_animal/chick/Life()
	. =..()
	if(!.)
		return
	if(!stat && !ckey)
		amount_grown += rand(1,2)
		if(amount_grown >= 100)
			var/mob/living/simple_animal/chicken/new_chicken = new grown_type(src.loc)
			if(prob(30))
				new_chicken.gender = MALE
			if(istype(new_chicken, /mob/living/simple_animal/chicken/glass))
				for(var/list_item in glass_egg_reagent)
					new_chicken.glass_egg_reagents.Add(list_item)
			qdel(src)

/mob/living/simple_animal/chick/death(gibbed)
	GLOB.total_chickens--
	..()

/mob/living/simple_animal/chick/Destroy()
	if(stat != DEAD)
		GLOB.total_chickens--
	return ..()

/mob/living/simple_animal/chick/holo/Life()
	..()
	amount_grown = 0

/mob/living/simple_animal/chicken
	name = "\improper chicken"
	desc = "Hopefully the eggs are good this season."
	gender = FEMALE
	health = 15
	maxHealth = 15
	mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)

	icon_state = "chicken_white"
	icon_living = "chicken_white"
	icon_dead = "chicken_white_dead"
	head_icon = 'icons/mob/pets_held_large.dmi'
	held_state = "chicken_white"

	speak_chance = 2
	speak = list("Cluck!","BWAAAAARK BWAK BWAK BWAK!","Bwaak bwak.")
	speak_emote = list("clucks","croons")
	emote_hear = list("clucks.")
	emote_see = list("pecks at the ground.","flaps its wings viciously.")

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = "kicks"

	density = FALSE
	turns_per_move = 3
	butcher_results = list(/obj/item/food/meat/slab/chicken = 2)
	ventcrawler = VENTCRAWLER_ALWAYS
	can_be_held = TRUE
	worn_slot_flags = ITEM_SLOT_HEAD
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	gold_core_spawnable = FRIENDLY_SPAWN
	chat_color = "#FFDC9B"
	mobchatspan = "stationengineer"

	do_footstep = TRUE

	///How many eggs can the chicken still lay?
	var/eggsleft = 0
	///can it still lay eggs?
	var/eggsFertile = TRUE
	///Message you get when it is fed
	var/list/feedMessages = list("It clucks happily.","It clucks happily.")
	///Message that is sent when an egg is layed
	var/list/layMessage = EGG_LAYING_MESSAGES
	//Global amount of chickens
	var/static/chicken_count = 0
	///Type of egg that is layed
	var/egg_type = /obj/item/food/egg
	///How hpapy the chicken is, used on egg hatch to determine if it should branch into a new chicken
	var/happiness = 0
	///The type of chicken it is
	var/mob/living/simple_animal/chicken/chicken_type
	///Consumed food
	var/list/consumed_food = list()
	///All Consumed reagents
	var/list/datum/reagent/consumed_reagents = new/list()
	///ALL possible mutations this chicken can lay
	var/list/mutation_list = list(/datum/ranching/mutation/spicy, /datum/ranching/mutation/brown)
	///Glass Chicken exclusive: reagents for eggs
	var/list/glass_egg_reagents = list()
	///Needed cause i can't iterate a new spawn with the ref to a mob
	var/chicken_path = /mob/living/simple_animal/chicken
	///Breed of the chicken needed for naming
	var/breed_name = "White"
	///Do we wanna call the male rooster something different?
	var/breed_name_male

/mob/living/simple_animal/chicken/Initialize(mapload)
	. = ..()
	pixel_x = rand(-6, 6)
	pixel_y = rand(0, 10)
	GLOB.total_chickens++
	chicken_type = src
	if(gender == MALE)
		if(breed_name_male)
			name = " [breed_name_male]"
		else
			name = "[breed_name] Rooster"
	else
		name = "[breed_name] Chicken"

/mob/living/simple_animal/chicken/death(gibbed)
	GLOB.total_chickens--
	..()

/mob/living/simple_animal/chicken/Destroy()
	if(stat != DEAD)
		GLOB.total_chickens--
	return ..()

/mob/living/simple_animal/chicken/attackby(obj/item/given_item, mob/user, params)
	if(istype(given_item, /obj/item/food)) //feedin' dem chickens
		if(!stat && eggsleft < 8)
			for(var/datum/reagent/reagent in given_item.reagents.reagent_list)
				if(!(reagent in consumed_reagents))
					consumed_reagents.Add(reagent)

			if(!(given_item in consumed_food))
				consumed_food.Add(given_item)

			var/feedmsg = "[user] feeds [given_item] to [name]! [pick(feedMessages)]"
			user.visible_message(feedmsg)
			qdel(given_item)
			eggsleft += rand(1, 4)
		else
			to_chat(user, "<span class='warning'>[name] doesn't seem hungry!</span>")
	else
		..()

/mob/living/simple_animal/chicken/Life()
	. =..()
	if(!.)
		return
	if((!stat && prob(100) && eggsleft > 0) && egg_type && GLOB.total_chickens < CONFIG_GET(number/max_chickens)) //3
		visible_message("[src] [pick(layMessage)]")
		eggsleft--

		var/obj/item/food/egg/layed_egg = new egg_type(get_turf(src))
		layed_egg.layer_hen_type = src.chicken_type
		layed_egg.happiness = src.happiness
		layed_egg.consumed_food = src.consumed_food
		layed_egg.consumed_reagents = src.consumed_reagents
		layed_egg.mutations = src.mutation_list
		layed_egg.pixel_x = rand(-6,6)
		layed_egg.pixel_y = rand(-6,6)
		if(glass_egg_reagents)
			layed_egg.food_reagents = glass_egg_reagents
		if(eggsFertile)
			if(prob(100)) //25
				START_PROCESSING(SSobj, layed_egg)


/obj/item/food/egg/process(delta_time)
	amount_grown += rand(30,60) * delta_time // 1,2
	if(amount_grown >= 200)
		pre_hatch()

/obj/item/food/egg/proc/pre_hatch()
	var/list/possible_mutations = list()
	if(layer_hen_type)
		for(var/raw_list_item in layer_hen_type.mutation_list)
			var/datum/ranching/mutation/mutation = new raw_list_item
			if(cycle_requirements(mutation))
				possible_mutations.Add(mutation)
				message_admins("[possible_mutations]")
	hatch(possible_mutations)

/obj/item/food/egg/proc/hatch(list/possible_mutations)
	var/mob/living/simple_animal/chick/birthed = new /mob/living/simple_animal/chick(get_turf(src))
	STOP_PROCESSING(SSobj, src)

	if(possible_mutations.len && prob(100))
		var/datum/ranching/mutation/chosen_mutation = pick(possible_mutations)
		birthed.grown_type = chosen_mutation.chicken_type
		if(chosen_mutation.nearby_items.len)
			absorbed_required_items(chosen_mutation.nearby_items)
	else
		birthed.grown_type = layer_hen_type.chicken_path

	if(birthed.grown_type == /mob/living/simple_animal/chicken/glass)
		for(var/list_item in src.reagents.reagent_list)
			birthed.glass_egg_reagent.Add(list_item)

	visible_message("[src] hatches with a quiet cracking sound.")
	qdel(src)

/obj/item/food/egg/proc/absorbed_required_items(list/required_items)
	for(var/item in required_items)
		var/obj/item/removal_item = item
		var/obj/item/temp = locate(removal_item) in view(3, src.loc)
		if(temp)
			visible_message("[src] absorbs the nearby [temp] into itself.")
			qdel(temp)

/mob/living/simple_animal/chicken/turkey
	name = "\improper turkey"
	desc = "it's that time again."
	icon_state = "turkey_plain"
	icon_living = "turkey_plain"
	icon_dead = "turkey_plain_dead"
	speak = list("Gobble!","GOBBLE GOBBLE GOBBLE!","Cluck.")
	speak_emote = list("clucks","gobbles")
	emote_hear = list("gobbles.")
	emote_see = list("pecks at the ground.","flaps its wings viciously.")
	density = FALSE
	health = 15
	maxHealth = 15
	attacktext = "pecks"
	attack_sound = 'sound/creatures/turkey.ogg'
	ventcrawler = VENTCRAWLER_ALWAYS
	feedMessages = list("It gobbles up the food voraciously.","It clucks happily.")
	gold_core_spawnable = FRIENDLY_SPAWN
	chat_color = "#FFDC9B"
