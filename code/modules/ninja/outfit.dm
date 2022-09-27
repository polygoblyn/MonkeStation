/datum/outfit/ninja
	name = "Space Ninja"
	uniform = /obj/item/clothing/under/syndicate/ninja
	suit = /obj/item/clothing/suit/space/space_ninja
	glasses = /obj/item/clothing/glasses/night
	mask = /obj/item/clothing/mask/gas/space_ninja
	head = /obj/item/clothing/head/helmet/space/space_ninja
	ears = /obj/item/radio/headset/syndicate/alt
	shoes = /obj/item/clothing/shoes/space_ninja
	gloves = /obj/item/clothing/gloves/space_ninja
	l_pocket = /obj/item/grenade/plastic/c4/ninja
	r_pocket = /obj/item/tank/internals/emergency_oxygen/double
	internals_slot = ITEM_SLOT_RPOCKET
	back = /obj/item/energy_katana
	implants = list(/obj/item/implant/explosive)


/datum/outfit/ninja/post_equip(mob/living/carbon/human/human)
	if(istype(human.wear_suit, suit))
		var/obj/item/clothing/suit/space/space_ninja/ninja_suit = human.wear_suit
		if(istype(human.back, back))
			ninja_suit.energyKatana = human.back
	if(istype(human.l_store, l_pocket))
		var/obj/item/grenade/plastic/c4/ninja/charge = human.l_store
		charge.set_detonation_area(human.mind?.has_antag_datum(/datum/antagonist/ninja))
