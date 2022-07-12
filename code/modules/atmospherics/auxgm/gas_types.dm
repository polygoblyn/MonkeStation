/datum/gas/oxygen
	id = GAS_O2
	specific_heat = 20
	name = "Oxygen"
	oxidation_temperature = T0C - 100 // it checks max of this and fire temperature, so rarely will things spontaneously combust

/datum/gas/oxygen/generate_TLV()
	return new/datum/tlv(16, 19, 40, 50)

/datum/gas/nitrogen
	id = GAS_N2
	specific_heat = 20
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_nitro",
			alert_type = /atom/movable/screen/alert/not_enough_nitro
		),
		too_much_alert = list(
			alert_category = "too_much_nitro",
			alert_type = /atom/movable/screen/alert/too_much_nitro
		)
	)
	name = "Nitrogen"

/datum/gas/carbon_dioxide //what the fuck is this?
	id = GAS_CO2
	specific_heat = 30
	name = "Carbon Dioxide"
	breath_results = GAS_O2
	breath_alert_info = list(
		not_enough_alert = list(
			alert_category = "not_enough_co2",
			alert_type = /atom/movable/screen/alert/not_enough_co2
		),
		too_much_alert = list(
			alert_category = "too_much_co2",
			alert_type = /atom/movable/screen/alert/too_much_co2
		)
	)
	fusion_power = 3
	enthalpy = -393500

/datum/gas/carbon_dioxide/generate_TLV()
	return new/datum/tlv(-1, -1, 5, 10)

/datum/gas/plasma
	id = GAS_PLASMA
	specific_heat = 200
	name = "Plasma"
	gas_overlay = "plasma"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fire_burn_rate = OXYGEN_BURN_RATE_BASE // named when plasma fires were the only fires, surely
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST
	fire_products = FIRE_PRODUCT_PLASMA
	enthalpy = FIRE_PLASMA_ENERGY_RELEASED // 3000000, 3 megajoules, 3000 kj

/datum/gas/water_vapor
	id = GAS_H2O
	specific_heat = 40
	name = "Water Vapor"
	gas_overlay = "water_vapor"
	moles_visible = MOLES_GAS_VISIBLE
	fusion_power = 8
	enthalpy = -241800 // FIRE_HYDROGEN_ENERGY_RELEASED is actually what this was supposed to be
	breath_reagent = /datum/reagent/water

/datum/gas/hypernoblium
	id = GAS_HYPERNOB
	specific_heat = 2000
	name = "Hyper-noblium"
	gas_overlay = "freon"
	moles_visible = MOLES_GAS_VISIBLE

/datum/gas/nitrous_oxide
	id = GAS_NITROUS
	specific_heat = 40
	name = "Nitrous Oxide"
	gas_overlay = "nitrous_oxide"
	moles_visible = MOLES_GAS_VISIBLE * 2
	flags = GAS_FLAG_DANGEROUS
	fire_products = list(GAS_N2 = 1)
	enthalpy = 81600
	oxidation_rate = 0.5
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST + 100

/datum/gas/nitryl
	id = GAS_NITRYL
	specific_heat = 20
	name = "Nitryl"
	color = "#963"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 15
	enthalpy = 33200
	fire_products = list(GAS_N2 = 0.5)
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/hydrogen
	id = GAS_HYDROGEN
	specific_heat = 10
	name = "Hydrogen"
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 0
	fire_products = list(GAS_H2O = 2)
	fire_burn_rate = 2
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/tritium
	id = GAS_TRITIUM
	specific_heat = 10
	name = "Tritium"
	gas_overlay = "tritium"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 1
	fire_products = list(GAS_H2O = 1)
	enthalpy = 300000
	fire_burn_rate = 2
	fire_radiation_released = 50 // arbitrary number, basically 60 moles of trit burning will just barely start to harm you
	fire_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST - 50

/datum/gas/bz
	id = GAS_BZ
	specific_heat = 20
	name = "BZ"
	flags = GAS_FLAG_DANGEROUS
	enthalpy = FIRE_CARBON_ENERGY_RELEASED // it is a mystery
	fusion_power = 8

/datum/gas/stimulum
	id = GAS_STIMULUM
	specific_heat = 5
	name = "Stimulum"
	fusion_power = 7

/datum/gas/pluoxium
	id = GAS_PLUOXIUM
	specific_heat = 80
	name = "Pluoxium"
	fusion_power = 10
	oxidation_temperature = FIRE_MINIMUM_TEMPERATURE_TO_EXIST * 1000 // it is VERY stable
	oxidation_rate = 8
	enthalpy = -50000 // but it reduces the heat output a bit

/datum/gas/pluoxium/generate_TLV()
	return new/datum/tlv(-1, -1, 5, 6)

/datum/gas/miasma
	id = GAS_MIASMA
	specific_heat = 20
	fusion_power = 50
	name = "Miasma"
	gas_overlay = "miasma"
	moles_visible = MOLES_GAS_VISIBLE * 60
	flags = GAS_FLAG_DANGEROUS

//NUCLEIUM Waste Gas from RBMK Nuclear Reactor	//Monkestation Edit
/datum/gas/nucleium
	id = "nucleium"
	specific_heat = 180 /// Default was 450
	name = "Nucleium"
	gas_overlay = "nucleium"
	moles_visible = MOLES_GAS_VISIBLE
	flags = GAS_FLAG_DANGEROUS
	fusion_power = 1

/datum/gas/bromine
	id = GAS_BROMINE
	specific_heat = 76
	name = "Bromine"
	flags = GAS_FLAG_DANGEROUS
	group = GAS_GROUP_CHEMICALS
	enthalpy = 193 // yeah it's small but it's good to include it
	breath_reagent = /datum/reagent/bromine

/datum/gas/ammonia
	id = GAS_AMMONIA
	specific_heat = 35
	name = "Ammonia"
	flags = GAS_FLAG_DANGEROUS
	group = GAS_GROUP_CHEMICALS
	enthalpy = -45900
	breath_reagent = /datum/reagent/ammonia
	fire_products = list(GAS_H2O = 1.5, GAS_N2 = 0.5)
	fire_burn_rate = 4/3
	fire_temperature = 924
