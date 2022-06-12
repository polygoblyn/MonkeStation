#define MEAT 		(1<<0)
#define VEGETABLES 	(1<<1)
#define RAW 		(1<<2)
#define JUNKFOOD 	(1<<3)
#define GRAIN 		(1<<4)
#define FRUIT 		(1<<5)
#define DAIRY 		(1<<6)
#define FRIED 		(1<<7)
#define ALCOHOL 	(1<<8)
#define SUGAR 		(1<<9)
#define GROSS 		(1<<10)
#define TOXIC 		(1<<11)
#define PINEAPPLE	(1<<12)
#define BREAKFAST	(1<<13)
#define CLOTH 		(1<<14)

#define DRINK_BAD   1
#define DRINK_NICE	2
#define DRINK_GOOD	3
#define DRINK_VERYGOOD	4
#define DRINK_FANTASTIC	5

#define FOOD_IN_CONTAINER (1<<0)
#define FOOD_FINGER_FOOD (1<<1)

#define STOP_SERVING_BREAKFAST (15 MINUTES)

///Amount of reagents you start with on crafted food excluding the used parts
#define CRAFTED_FOOD_BASE_REAGENT_MODIFIER 0.7
///Modifier of reagents you get when crafting food from the parts used
#define CRAFTED_FOOD_INGREDIENT_REAGENT_MODIFIER  0.5

#define IS_EDIBLE(O) (istype(O, /obj/item/reagent_containers/food/snacks) || O.GetComponent(/datum/component/edible))

///Food preference enums
#define FOOD_LIKED 1
#define FOOD_DISLIKED 2
#define FOOD_TOXIC 3
