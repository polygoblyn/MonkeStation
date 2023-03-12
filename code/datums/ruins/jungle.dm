/datum/map_template/ruin/jungle
	prefix = "_maps/RandomRuins/JungleRuins/"
	allow_duplicates = FALSE
	cost = 5

/datum/map_template/ruin/jungle/dying/crashed_ship
	name = "Crashed Ship"
	id = "jungle-crashed-ship"
	description = "The remains of a long crashed ship, weathered away into scrap."
	suffix = "jungleland_dead_crashedship.dmm"

/datum/map_template/ruin/jungle/dying/testing_facility
	name = "Testing-facility"
	id = "jungle-testing-facility"
	description = "A testing facility, were bodily experiments were conducted on people, safely remote from scrutiny."
	suffix = "jungleland_dead_testingfacility.dmm"

/datum/map_template/ruin/jungle/proper/old_temple
	name = "Ancient Temple"
	id = "jungle-old-temple"
	description = "A temple bearing signs of the occult. It seems the spirits inside have been corrupted..."
	suffix = "jungleland_jungle_oldtemple.dmm"

/datum/map_template/ruin/jungle/proper/xenos
	name = "Xeno Nest"
	id = "jungle-xenos"
	description = "Once an expeditionary camp for soldiers, it fell to predatory alien creatures."
	suffix = "jungleland_jungle_xenos.dmm"

/datum/map_template/ruin/jungle/proper/geode
	name = "Geode"
	id = "jungle-geode"
	description = "Geode"
	suffix = "jungleland_jungle_geode.dmm"

/datum/map_template/ruin/jungle/proper/felinid
	name = "Felinid Party"
	id = "jungle-felinid"
	description = "Felinid party"
	suffix = "jungleland_jungle_felinid.dmm"

/datum/map_template/ruin/jungle/swamp/burial_grounds
	name = "Drowned Burial Grounds"
	id = "jungle-burial-grounds"
	description = "Flooded burial grounds, filled with toxic water and the reanimated dead of those buried inside."
	suffix = "jungleland_swamp_drownedburialgrounds.dmm"

/datum/map_template/ruin/jungle/swamp/farm
	name = "Abandoned Farm"
	id = "jungle-farm"
	description = "A large field of rotting, tilled soil next to a small home."
	suffix = "jungleland_swamp_farm.dmm"

/datum/map_template/ruin/jungle/swamp/hut
	name = "Old Hut"
	id = "jungle-hut"
	description = "An old hut that belonged to a witch."
	suffix = "jungleland_swamp_oldhut.dmm"

/datum/map_template/ruin/jungle/swamp/carp_pond
	name = "Carp Pond"
	id = "jungle-carp-pond"
	description = "A few ponds full of rancid and toxic water, guarded by overgrown carp. \
	 	However, it looks like it could've been pretty, at least in the past..."
	suffix = "jungleland_swamp_carp_pond.dmm"

/datum/map_template/ruin/jungle/all/miningbase //THIS IS THE MINING BASE. DO NOT FUCK WITH THIS UNLESS YOU ARE 100% CERTAIN YOU KNOW WHAT YOU'RE DOING, OR THE MINING BASE WILL DISAPPEAR
	name = "Mining Base"
	id = "miningbase"
	description = "The mining base that Nanotrasen uses for their mining operations."
	suffix = "miningbase.dmm"
	always_place = TRUE
	unpickable = TRUE
	cost = 0

//TAR TEMPLES
/datum/map_template/ruin/jungle/all/tar_temple0
	name = "Tar Temple 0"
	id = "tar_temple"
	description = "Old ruin of a civilization long gone, only echoes of the past remain..."
	suffix = "tar_temple0.dmm"
	always_place = TRUE
	cost = 0

/datum/map_template/ruin/jungle/all/tar_altar
	name = "Tar altar"
	id = "tar_altar"
	description = "Old ruin of a civilization long gone, only echoes of the past remain..."
	suffix = "tar_altar.dmm"
	always_place = TRUE
	allow_duplicates = TRUE
	cost = 5
/datum/map_template/ruin/jungle/all/tar_temple1
	name = "Tar temple 1"
	id = "jungle-dying-tar-temple"
	description = "Old ruin of a civilization long gone, only echoes of the past remain..."
	suffix = "jungleland_dead_tartemple.dmm"
	always_place = TRUE
	cost = 0

/datum/map_template/ruin/jungle/all/tar_temple2
	name = "Tar temple 2"
	id = "jungle-swamp-tar-temple"
	description = "Old ruin of a civilization long gone, only echoes of the past remain..."
	suffix = "jungleland_swamp_tartemple.dmm"
	always_place = TRUE
	cost = 0

/datum/map_template/ruin/jungle/all/tar_temple3
	name = "Tar temple 3"
	id = "jungle-proper-tar-temple"
	description = "Old ruin of a civilization long gone, only echoes of the past remain..."
	suffix = "jungleland_jungle_tartemple.dmm"
	always_place = TRUE
	cost = 0

//MEGAFAUNA
/datum/map_template/ruin/jungle/swamp/miner
	name = "Blood Drunk Miner"
	id = "swamp_miner"
	description = "Miner's hideout"
	suffix = "jungleland_swamp_miner.dmm"
	always_place = TRUE

/datum/map_template/ruin/jungle/dying/colossus
	name = "Colossus"
	id = "dying_colossus"
	description = "Colossus"
	suffix = "jungleland_dead_colossus.dmm"
	always_place = TRUE

/datum/map_template/ruin/jungle/dying/bubblegum
	name = "Bubblegum"
	id = "dying_bubblegum"
	description = "Bubblegum"
	suffix = "jungleland_dead_bubblegum.dmm"
	always_place = TRUE

/datum/map_template/ruin/jungle/barren/drake
	name = "Ash Drake"
	id = "barren_drake"
	description = "Ash Drake"
	suffix = "jungleland_barren_drake.dmm"
	always_place = TRUE
	allow_duplicates = TRUE
	cost = 20

//NESTS
/datum/map_template/ruin/jungle/dying/dead_nest
	name = "Dying Forest Nest"
	id = "jungle-dying-nest"
	description = "a nest"
	suffix = "jungleland_dead_nest.dmm"
	allow_duplicates = TRUE
	always_place = TRUE
	cost = 2

/datum/map_template/ruin/jungle/proper/jungle_nest
	name = "Jungle Nest"
	id = "jungle-proper-nest"
	description = "a nest"
	suffix = "jungleland_jungle_nest.dmm"
	allow_duplicates = TRUE
	always_place = TRUE
	cost = 2

/datum/map_template/ruin/jungle/swamp/swamp_nest
	name = "Swamp Nest"
	id = "jungle-swamp-nest"
	description = "a nest"
	suffix = "jungleland_swamp_nest.dmm"
	allow_duplicates = TRUE
	always_place = TRUE
	cost = 2

/datum/map_template/ruin/jungle/barren/barren_nest
	name = "Barren Nest"
	id = "jungle-barren-nest"
	description = "a nest"
	suffix = "jungleland_barren_nest.dmm"
	allow_duplicates = TRUE
	always_place = TRUE
