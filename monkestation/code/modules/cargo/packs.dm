//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/datum/supply_pack/misc/sticker_set
	name = "Sticker Set"
	desc = "Seven superior selected sticker sets shipped swiftly soon to a station that which you stand. Shaking, shivering, so stimulated! Sticky satisfaction secured, shall someone ship some specialty stickables?"
	cost = 500
	small_item = TRUE
	contains = list(/obj/item/storage/box/stickers)
	crate_name = "Specialty Sticker Set"

/datum/supply_pack/emergency/spatialriftnullifier
	name = "Spatial Rift Nullifier Pack"
	desc = "Everything that the crew needs to take down a rogue Singularity or Tesla."
	cost = 10000
	contains = list(/obj/item/gun/ballistic/SRN_rocketlauncher = 3)
	crate_name = "Spatial Rift Nullifier (SRN)"
	crate_type = /obj/structure/closet/crate/secure

/datum/supply_pack/engine/fuel_rod
	name = "Uranium Fuel Rod crate"
	desc = "Two additional fuel rods for use in a reactor, requires CE access to open. Caution: Radioactive"
	cost = 4000
	access = ACCESS_CE
	contains = list(/obj/item/twohanded/required/fuel_rod,
					/obj/item/twohanded/required/fuel_rod)
	crate_name = "Uranium-235 Fuel Rod crate"
	crate_type = /obj/structure/closet/crate/secure/engineering
	dangerous = TRUE
