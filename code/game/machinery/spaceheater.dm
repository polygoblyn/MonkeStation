#define HEATER_MODE_STANDBY	"standby"
#define HEATER_MODE_HEAT	"heat"
#define HEATER_MODE_COOL	"cool"

/obj/machinery/space_heater
	anchored = FALSE
	density = TRUE
	interaction_flags_machine = INTERACT_MACHINE_WIRES_IF_OPEN | INTERACT_MACHINE_ALLOW_SILICON | INTERACT_MACHINE_OPEN
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater/cooler is guaranteed not to set the station on fire. Warranty void if used in engines."
	max_integrity = 250
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 100, "rad" = 100, "fire" = 80, "acid" = 10, "stamina" = 0)
	circuit = /obj/item/circuitboard/machine/space_heater

	var/obj/item/stock_parts/cell/cell
	var/on = FALSE
	var/mode = HEATER_MODE_STANDBY
	var/setMode = "auto" // Anything other than "heat" or "cool" is considered auto.
	///The temperature we trying to get to
	var/target_temperature = T20C
	///How much heat/cold we can deliver
	var/heating_power = 40000
	///How efficiently we can deliver that heat/cold (higher indicates less cell consumption)
	var/efficiency = 20000
	///The amount of degrees above and below the target temperature for us to change mode to heater or cooler
	var/temperature_tolerance = 1
	///What's the middle point of our settable temperature (30 °C)
	var/settable_temperature_median = 30 + T0C
	///Range of temperatures above and below the median that we can set our target temperature (increase by upgrading the capacitors)
	var/settable_temperature_range = 30
	///Should we add an overlay for open spaceheaters
	var/display_panel = TRUE

/obj/machinery/space_heater/get_cell()
	return cell

/obj/machinery/space_heater/Initialize(mapload)
	. = ..()
	cell = new(src)
	update_icon()

/obj/machinery/space_heater/on_construction()
	qdel(cell)
	cell = null
	panel_open = TRUE
	update_icon()
	return ..()

/obj/machinery/space_heater/on_deconstruction()
	if(cell)
		component_parts += cell
		cell = null
	return ..()

/obj/machinery/space_heater/examine(mob/user)
	. = ..()
	. += "\The [src] is [on ? "on" : "off"], and the hatch is [panel_open ? "open" : "closed"]."
	if(cell)
		. += "The charge meter reads [cell ? round(cell.percent(), 1) : 0]%."
	else
		. += "There is no power cell installed."
	if(in_range(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Temperature range at <b>[settable_temperature_range]°C</b>.<br>Heating power at <b>[siunit(heating_power, "W", 1)]</b>.<br>Power consumption at <b>[(efficiency*-0.0025)+150]%</b>.</span>" //100%, 75%, 50%, 25%

/obj/machinery/space_heater/update_icon()
	if(on)
		icon_state = "sheater-[mode]"
	else
		icon_state = "sheater-off"

	cut_overlays()
	if(panel_open)
		add_overlay("sheater-open")

/obj/machinery/space_heater/process_atmos() //TODO figure out delta_time
	if(!on || !is_operational)
		if (on) // If it's broken, turn it off too
			on = FALSE
		return PROCESS_KILL

	if(cell && cell.charge > 0)
		var/turf/L = loc
		if(!istype(L))
			if(mode != HEATER_MODE_STANDBY)
				mode = HEATER_MODE_STANDBY
				update_icon()
			return

		var/datum/gas_mixture/env = L.return_air()

		var/newMode = HEATER_MODE_STANDBY
		if(setMode != HEATER_MODE_COOL && env.return_temperature() < target_temperature - temperature_tolerance)
			newMode = HEATER_MODE_HEAT
		else if(setMode != HEATER_MODE_HEAT && env.return_temperature() > target_temperature + temperature_tolerance)
			newMode = HEATER_MODE_COOL

		if(mode != newMode)
			mode = newMode
			update_icon()

		if(mode == HEATER_MODE_STANDBY)
			return

		var/heat_capacity = env.heat_capacity()
		var/requiredPower = abs(env.return_temperature() - target_temperature) * heat_capacity
		requiredPower = min(requiredPower, heating_power)

		if(requiredPower < 1)
			return

		var/deltaTemperature = requiredPower / heat_capacity
		if(mode == HEATER_MODE_COOL)
			deltaTemperature *= -1
		if(deltaTemperature)
			env.set_temperature(env.return_temperature() + deltaTemperature)
			air_update_turf()
		cell.use(requiredPower / efficiency)
	else
		on = FALSE
		update_icon()
		return PROCESS_KILL

/obj/machinery/space_heater/RefreshParts()
	. = ..()
	var/laser = 0
	var/cap = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		laser += M.rating
	for(var/obj/item/stock_parts/capacitor/M in component_parts)
		cap += M.rating

	heating_power = laser * 20000

	settable_temperature_range = cap * 30
	efficiency = (cap + 1) * 10000

	target_temperature = clamp(target_temperature,
		max(settable_temperature_median - settable_temperature_range, TCMB),
		settable_temperature_median + settable_temperature_range)

/obj/machinery/space_heater/emp_act(severity)
	. = ..()
	if(machine_stat & (NOPOWER|BROKEN) || . & EMP_PROTECT_CONTENTS)
		return
	if(cell)
		cell.emp_act(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user, params)
	add_fingerprint(user)
	if(default_unfasten_wrench(user, I))
		return
	else if(istype(I, /obj/item/stock_parts/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "<span class='warning'>There is already a power cell inside!</span>")
				return
			else if(!user.transferItemToLoc(I, src))
				return
			cell = I
			I.add_fingerprint(usr)

			user.visible_message("<span class='notice'>\The [user] inserts a power cell into \the [src].</span>", "<span class='notice'>You insert the power cell into \the [src].</span>")
			SStgui.update_uis(src)
		else
			to_chat(user, "<span class='warning'>The hatch must be open to insert a power cell!</span>")
			return
	else if(I.tool_behaviour == TOOL_SCREWDRIVER)
		panel_open = !panel_open
		user.visible_message("<span class='notice'>\The [user] [panel_open ? "opens" : "closes"] the hatch on \the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on \the [src].</span>")
		update_icon()
	else if(default_deconstruction_crowbar(I))
		return
	else
		return ..()


/obj/machinery/space_heater/ui_state(mob/user)
	return GLOB.physical_state

/obj/machinery/space_heater/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater")
		ui.set_autoupdate(TRUE) // Displays temperature
		ui.open()

/obj/machinery/space_heater/ui_data()
	var/list/data = list()
	data["open"] = panel_open
	data["on"] = on
	data["mode"] = setMode
	data["hasPowercell"] = !!cell
	if(cell)
		data["powerLevel"] = round(cell.percent(), 1)
	data["targetTemp"] = round(target_temperature - T0C, 1)
	data["minTemp"] = max(settable_temperature_median - settable_temperature_range - T0C, TCMB)
	data["maxTemp"] = settable_temperature_median + settable_temperature_range - T0C

	var/turf/L = get_turf(loc)
	var/curTemp
	if(istype(L))
		var/datum/gas_mixture/env = L.return_air()
		curTemp = env.return_temperature()
	else if(isturf(L))
		curTemp = L.return_temperature()
	if(isnull(curTemp))
		data["currentTemp"] = "N/A"
	else
		data["currentTemp"] = round(curTemp - T0C, 1)
	return data

/obj/machinery/space_heater/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("power")
			on = !on
			mode = HEATER_MODE_STANDBY
			usr.visible_message("<span class='notice'>[usr] switches [on ? "on" : "off"] \the [src].</span>", "<span class='notice'>You switch [on ? "on" : "off"] \the [src].</span>")
			update_icon()
			if (on)
				SSair.atmos_air_machinery += src
			. = TRUE
		if("mode")
			setMode = params["mode"]
			. = TRUE
		if("target")
			if(!panel_open)
				return
			var/target = params["target"]
			if(text2num(target) != null)
				target= text2num(target) + T0C
				. = TRUE
			if(.)
				target_temperature = clamp(round(target),
					max(settable_temperature_median - settable_temperature_range, TCMB),
					settable_temperature_median + settable_temperature_range)
		if("eject")
			if(panel_open && cell)
				cell.forceMove(drop_location())
				cell = null
				. = TRUE

#undef HEATER_MODE_STANDBY
#undef HEATER_MODE_HEAT
#undef HEATER_MODE_COOL
