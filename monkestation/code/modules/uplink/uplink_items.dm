/datum/uplink_item/role_restricted/boom_boots
	name = "Boom Boots"
	desc = "The pinnacle of clown footwear technology.  Fit for only the loudest and proudest! \
			Fully functional hydraulic clown shoes with anti-slip technology.  Anyone who tries \
			to remove these from your person will be in for an explosive surprise, to boot. "
	item = /obj/item/clothing/shoes/magboots/boomboots
	cost = 20
	restricted_roles = list("Clown")

/datum/uplink_item/role_restricted/psycho_scroll
	name = "The Rants of the Debtor"
	desc = "This roll of toilet paper has writings on it that will allow you to master the art of the Psychotic Brawl, but beware the cost to your own sanity."
	item = /obj/item/book/granter/martial/psychotic_brawl
	cost = 8
	restricted_roles = list("Debtor")
	surplus = 0

/datum/uplink_item/role_restricted/arcane_beacon
	name = "Beacon of Magical Items"
	desc = "This beacon allows you to choose a rare magitech item that will make your performance truly unforgettable."
	item = /obj/item/choice_beacon/magic
	cost = 5
	restricted_roles = list("Stage Magician")
	surplus = 0

/datum/uplink_item/implants/freedom
	name = "Hardlight Spear Implant"
	desc = "An implant injected into the body, and later activated at the user's will. It will summon a spear \
			made out of hardlight that the user can use to wreak havoc."
	item = /obj/item/storage/box/syndie_kit/imp_hard_spear
	cost = 10

/datum/uplink_item/stealthy_tools/id_emag_chip
	name = "Cryptographic Sequencer Chip"
	desc = "Thanks to newly developed technology, the cryptographic sequencer can be shrunk into a small chip, turning your existing card into an emag."
	item = /obj/item/id_emag_chip
	cost = 9 // less than the 6 for emag and 7 for storage implant
