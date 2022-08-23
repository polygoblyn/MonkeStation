#define CAMERA_UPGRADE_XRAY (1<<0)
#define CAMERA_UPGRADE_EMP_PROOF (1<<1)
#define CAMERA_UPGRADE_MOTION (1<<2)

/obj/machinery/camera
	name = "security camera"
	desc = "A wireless camera used to monitor rooms. It is powered by a long-life internal battery."
	icon = 'icons/obj/machines/camera.dmi'
	icon_state = "camera" //mapping icon to represent upgrade states. if you want a different base icon, update default_camera_icon as well as this.
	use_power = ACTIVE_POWER_USE
	idle_power_usage = 5
	active_power_usage = 10
	layer = WALL_OBJ_LAYER
	resistance_flags = FIRE_PROOF

	armor = list("melee" = 50, "bullet" = 20, "laser" = 20, "energy" = 20, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 90, "acid" = 50, "stamina" = 0)
	max_integrity = 100
	integrity_failure = 50
	var/default_camera_icon = "camera" //the camera's base icon used by update_icon - icon_state is primarily used for mapping display purposes.
	var/list/network = list("ss13")
	var/c_tag = null
	var/status = TRUE
	var/start_active = FALSE //If it ignores the random chance to start broken on round start
	var/invuln = null
	var/obj/item/camera_bug/bug = null
	var/datum/weakref/assembly_ref = null
	var/area/myarea = null

	FASTDMM_PROP(\
		pinned_vars = list("name", "network", "c_tag")\
	)

	//OTHER

	var/view_range = 7
	var/short_range = 2

	var/alarm_on = FALSE
	var/busy = FALSE
	var/emped = FALSE  //Number of consecutive EMP's on this camera
	var/in_use_lights = 0

	// Upgrades bitflag
	var/upgrades = 0
	var/datum/component/empprotection/emp_component

	var/internal_light = TRUE //Whether it can light up when an AI views it

	///Represents a signel source of camera alarms about movement or camera tampering
	var/datum/alarm_handler/alarm_manager


/obj/machinery/camera/preset/toxins //Bomb test site in space
	name = "Hardened Bomb-Test Camera"
	desc = "A specially-reinforced camera with a long lasting battery, used to monitor the bomb testing site. An external light is attached to the top."
	c_tag = "Bomb Testing Site"
	network = list("rd","toxins")
	use_power = NO_POWER_USE //Test site is an unpowered area
	invuln = TRUE
	light_range = 10
	start_active = TRUE

/obj/machinery/camera/Initialize(mapload, obj/structure/camera_assembly/old_assembly)
	. = ..()
	for(var/i in network)
		network -= i
		network += lowertext(i)
	var/obj/structure/camera_assembly/assembly
	if(old_assembly) //check to see if the camera assembly was upgraded at all.
		assembly = old_assembly
		assembly_ref = WEAKREF(assembly) //important to do this now since upgrades call back to the assembly_ref
		if(assembly.xray_module)
			upgradeXRay()
		else if(assembly.malf_xray_firmware_present) //if it was secretly upgraded via the MALF AI Upgrade Camera Network ability
			upgradeXRay(TRUE)

		if(assembly.emp_module)
			upgradeEmpProof()
		else if(assembly.malf_xray_firmware_present) //if it was secretly upgraded via the MALF AI Upgrade Camera Network ability
			upgradeEmpProof(TRUE)

		if(assembly.proxy_module)
			upgradeMotion()
	else
		assembly = new(src)
		assembly.state = 4 //STATE_FINISHED
		assembly_ref = WEAKREF(assembly)
	GLOB.cameranet.cameras += src
	GLOB.cameranet.addCamera(src)
	if (isturf(loc))
		myarea = get_area(src)
		LAZYADD(myarea.cameras, src)
	proximity_monitor = new(src, 1)

	if(mapload && is_station_level(z) && prob(3) && !start_active)
		toggle_cam()
	else //this is handled by toggle_camera, so no need to update it twice.
		update_icon()

	alarm_manager = new(src)

/obj/machinery/camera/Destroy()
	if(can_use())
		toggle_cam(null, 0) //kick anyone viewing out and remove from the camera chunks
	GLOB.cameranet.removeCamera(src)
	GLOB.cameranet.cameras -= src
	cancelCameraAlarm()
	if(isarea(myarea))
		LAZYREMOVE(myarea.cameras, src)
	QDEL_NULL(alarm_manager)
	QDEL_NULL(assembly_ref)
	if(bug)
		bug.bugged_cameras -= c_tag
		if(bug.current == src)
			bug.current = null
		bug = null
	return ..()

/obj/machinery/camera/examine(mob/user)
	. += ..()
	if(isEmpProof(TRUE)) //don't reveal it's upgraded if was done via MALF AI Upgrade Camera Network ability
		. += "It has electromagnetic interference shielding installed."
	else
		. += "<span class='info'>It can be shielded against electromagnetic interference with some <b>plasma</b>.</span>"
	if(isXRay(TRUE)) //don't reveal it's upgraded if was done via MALF AI Upgrade Camera Network ability
		. += "It has an X-ray photodiode installed."
	else
		. += "<span class='info'>It can be upgraded with an X-ray photodiode with an <b>analyzer</b>.</span>"
	if(isMotion())
		. += "It has a proximity sensor installed."
	else
		. += "<span class='info'>It can be upgraded with a <b>proximity sensor</b>.</span>"

	if(!status)
		. += "<span class='info'>It's currently deactivated.</span>"
		if(!panel_open && powered())
			. += "<span class='notice'>You'll need to open its maintenance panel with a <b>screwdriver</b> to turn it back on.</span>"
	if(panel_open)
		. += "<span class='info'>Its maintenance panel is currently open.</span>"
		if(!status && powered())
			. += "<span class='info'>It can reactivated with a <b>screwdriver</b>.</span>"

/obj/machinery/camera/emp_act(severity)
	. = ..()
	if(!status)
		return
	if(!(. & EMP_PROTECT_SELF))
		if(prob(150/severity))
			update_icon()
			var/list/previous_network = network
			network = list()
			GLOB.cameranet.removeCamera(src)
			set_machine_stat(machine_stat | EMPED)
			set_light(0)
			emped = emped+1  //Increase the number of consecutive EMP's
			update_icon()
			var/thisemp = emped //Take note of which EMP this proc is for
			spawn(900)
				if(loc) //qdel limbo
					triggerCameraAlarm() //camera alarm triggers even if multiple EMPs are in effect.
					if(emped == thisemp) //Only fix it if the camera hasn't been EMP'd again
						network = previous_network
						set_machine_stat(machine_stat & ~EMPED)
						update_icon()
						if(can_use())
							GLOB.cameranet.addCamera(src)
						emped = 0 //Resets the consecutive EMP count
						addtimer(CALLBACK(src, .proc/cancelCameraAlarm), 100)
			for(var/i in GLOB.player_list)
				var/mob/M = i
				if (M.client?.eye == src)
					M.unset_machine()
					M.reset_perspective(null)
					to_chat(M, "The screen bursts into static.")

/obj/machinery/camera/ex_act(severity, target)
	if(invuln)
		return
	..()

/obj/machinery/camera/proc/setViewRange(num = 7)
	src.view_range = num
	GLOB.cameranet.updateVisibility(src, 0)

/obj/machinery/camera/proc/shock(mob/living/user)
	if(!istype(user))
		return
	user.electrocute_act(10, src)

/obj/machinery/camera/singularity_pull(S, current_size)
	if (status && current_size >= STAGE_FIVE) // If the singulo is strong enough to pull anchored objects and the camera is still active, turn off the camera as it gets ripped off the wall.
		toggle_cam(null, 0)
	..()

// Construction/Deconstruction
/obj/machinery/camera/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	panel_open = !panel_open
	to_chat(user, "<span class='notice'>You screw the camera's panel [panel_open ? "open" : "closed"].</span>")
	I.play_tool_sound(src)
	update_icon()
	return TRUE

/obj/machinery/camera/wirecutter_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE
	toggle_cam(user, 1)
	obj_integrity = max_integrity //this is a pretty simplistic way to heal the camera, but there's no reason for this to be complex.
	I.play_tool_sound(src)
	return TRUE

/obj/machinery/camera/multitool_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE

	setViewRange((view_range == initial(view_range)) ? short_range : initial(view_range))
	to_chat(user, "<span class='notice'>You [(view_range == initial(view_range)) ? "restore" : "mess up"] the camera's focus.</span>")
	return TRUE

/obj/machinery/camera/welder_act(mob/living/user, obj/item/I)
	if(!panel_open)
		return FALSE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, "<span class='notice'>You start to weld [src]...</span>")
	if(I.use_tool(src, user, 100, volume=50))
		user.visible_message("<span class='warning'>[user] unwelds [src], leaving it as just a frame bolted to the wall.</span>",
			"<span class='warning'>You unweld [src], leaving it as just a frame bolted to the wall.</span>")
		deconstruct(TRUE)

	return TRUE

/obj/machinery/camera/attackby(obj/item/I, mob/living/user, params)
	// UPGRADES
	if(panel_open)
		var/obj/structure/camera_assembly/assembly = assembly_ref?.resolve()
		if(!assembly)
			assembly_ref = null
		if(I.tool_behaviour == TOOL_ANALYZER)
			if(!isXRay(TRUE)) //don't reveal it was already upgraded if was done via MALF AI Upgrade Camera Network ability
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				upgradeXRay(FALSE, TRUE)
				to_chat(user, "<span class='notice'>You attach [I] into [assembly]'s inner circuits.</span>")
				qdel(I)
			else
				to_chat(user, "<span class='notice'>[src] already has that upgrade!</span>")
			return

		else if(istype(I, /obj/item/stack/sheet/mineral/plasma))
			if(!isEmpProof(TRUE)) //don't reveal it was already upgraded if was done via MALF AI Upgrade Camera Network ability
				if(I.use_tool(src, user, 0, amount=1))
					upgradeEmpProof(FALSE, TRUE)
					to_chat(user, "<span class='notice'>You attach [I] into [assembly]'s inner circuits.</span>")
			else
				to_chat(user, "<span class='notice'>[src] already has that upgrade!</span>")
			return

		else if(istype(I, /obj/item/assembly/prox_sensor))
			if(!isMotion())
				if(!user.temporarilyRemoveItemFromInventory(I))
					return
				upgradeMotion()
				to_chat(user, "<span class='notice'>You attach [I] into [assembly]'s inner circuits.</span>")
				qdel(I)
			else
				to_chat(user, "<span class='notice'>[src] already has that upgrade!</span>")
			return

	// OTHER
	if((istype(I, /obj/item/paper) || istype(I, /obj/item/pda)) && isliving(user))
		var/mob/living/U = user
		var/obj/item/paper/X = null
		var/obj/item/pda/P = null

		var/itemname = ""
		var/info = ""
		if(istype(I, /obj/item/paper))
			X = I
			itemname = X.name
			info = X.info
		else
			P = I
			itemname = P.name
			info = P.notehtml
		itemname = sanitize(itemname)
		to_chat(U, "<span class='notice'>You hold \the [itemname] up to the camera...</span>")
		U.changeNext_move(CLICK_CD_MELEE)
		for(var/mob/O in GLOB.player_list)
			if(isAI(O))
				var/mob/living/silicon/ai/AI = O
				if(AI.control_disabled || (AI.stat == DEAD))
					return
				if(U.name == "Unknown")
					to_chat(AI, "<b>[U]</b> holds <a href='?_src_=usr;show_paper=1;'>\a [itemname]</a> up to one of your cameras ...")
				else
					to_chat(AI, "<b><a href='?src=[REF(AI)];track=[html_encode(U.name)]'>[U]</a></b> holds <a href='?_src_=usr;show_paper=1;'>\a [itemname]</a> up to one of your cameras ...")
				AI.last_paper_seen = "<HTML><HEAD><TITLE>[itemname]</TITLE></HEAD><BODY><TT>[info]</TT></BODY></HTML>"
			else if (O.client && O.client?.eye == src)
				to_chat(O, "[U] holds \a [itemname] up to one of the cameras ...")
				O << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", itemname, info), text("window=[]", itemname))
		return

	else if(istype(I, /obj/item/camera_bug))
		if(!can_use())
			to_chat(user, "<span class='notice'>Camera non-functional.</span>")
			return
		if(bug)
			to_chat(user, "<span class='notice'>Camera bug removed.</span>")
			bug.bugged_cameras -= src.c_tag
			bug = null
		else
			to_chat(user, "<span class='notice'>Camera bugged.</span>")
			bug = I
			bug.bugged_cameras[src.c_tag] = WEAKREF(src)
		return

	else if(istype(I, /obj/item/pai_cable))
		var/obj/item/pai_cable/cable = I
		cable.plugin(src, user)
		return

	return ..()

/obj/machinery/camera/run_obj_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == "melee" && damage_amount < 12 && !(machine_stat & BROKEN))
		return 0
	. = ..()

/obj/machinery/camera/obj_break(damage_flag)
	if(status && !(flags_1 & NODECONSTRUCT_1))
		triggerCameraAlarm()
		toggle_cam(null, 0)

/obj/machinery/camera/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			var/obj/structure/camera_assembly/assembly = assembly_ref?.resolve()
			if(!assembly)
				assembly = new()
			assembly.forceMove(drop_location())
			assembly.state = 1
			assembly.setDir(dir)
			assembly_ref = null
		else
			var/obj/item/I = new /obj/item/wallframe/camera (loc)
			I.obj_integrity = I.max_integrity * 0.5
			new /obj/item/stack/cable_coil(loc, 2)
	qdel(src)

/obj/machinery/camera/update_icon() //TO-DO: Make panel open states, xray camera, and indicator lights overlays instead.
	var/xray_module
	if(isXRay(TRUE))
		xray_module = "xray"
	if(!status)
		icon_state = "[xray_module][default_camera_icon]_off"
	else if (machine_stat & EMPED)
		icon_state = "[xray_module][default_camera_icon]_emp"
	else
		icon_state = "[xray_module][default_camera_icon][in_use_lights ? "_in_use" : ""]"

/obj/machinery/camera/proc/toggle_cam(mob/user, displaymessage = TRUE)
	status = !status
	if(can_use())
		GLOB.cameranet.addCamera(src)
		if (isturf(loc))
			myarea = get_area(src)
			LAZYADD(myarea.cameras, src)
		else
			myarea = null
	else
		set_light(0)
		GLOB.cameranet.removeCamera(src)
		if (isarea(myarea))
			LAZYREMOVE(myarea.cameras, src)
	GLOB.cameranet.updateChunk(x, y, z)
	var/change_msg = "deactivates"
	if(status)
		change_msg = "reactivates"
		triggerCameraAlarm()
		addtimer(CALLBACK(src, .proc/cancelCameraAlarm), 100)
	if(displaymessage)
		if(user)
			visible_message("<span class='danger'>[user] [change_msg] [src]!</span>")
			add_hiddenprint(user)
		else
			visible_message("<span class='danger'>\The [src] [change_msg]!</span>")

		playsound(src, 'sound/items/wirecutter.ogg', 100, TRUE)
	update_icon() //update Initialize() if you remove this.

	// now disconnect anyone using the camera
	//Apparently, this will disconnect anyone even if the camera was re-activated.
	//I guess that doesn't matter since they can't use it anyway?
	for(var/mob/O in GLOB.player_list)
		if (O.client?.eye == src)
			O.unset_machine()
			O.reset_perspective(null)
			to_chat(O, span_warning("The screen bursts into static!"))

/obj/machinery/camera/proc/triggerCameraAlarm()
	alarm_on = TRUE
	alarm_manager.send_alarm(ALARM_CAMERA, src, src)

/obj/machinery/camera/proc/cancelCameraAlarm()
	alarm_on = FALSE
	alarm_manager.clear_alarm(ALARM_CAMERA)

/obj/machinery/camera/proc/can_use()
	if(!status)
		return FALSE
	if(machine_stat & EMPED)
		return FALSE
	if(is_jammed())
		return FALSE
	return TRUE

/obj/machinery/camera/proc/can_see()
	var/list/see = null
	var/turf/pos = get_turf(src)
	if(isXRay())
		see = range(view_range, pos)
	else
		see = get_hear(view_range, pos)
	return see

/atom/proc/auto_turn()
	//Automatically turns based on nearby walls.
	var/turf/closed/wall/T = null
	for(var/i in GLOB.cardinals)
		T = get_ranged_target_turf(src, i, 1)
		if(istype(T))
			setDir(turn(i, 180))
			break

//Return a working camera that can see a given mob
//or null if none
/proc/seen_by_camera(var/mob/M)
	for(var/obj/machinery/camera/C in oview(4, M))
		if(C.can_use())	// check if camera disabled
			return C
	return null

/proc/near_range_camera(var/mob/M)
	for(var/obj/machinery/camera/C in range(4, M))
		if(C.can_use())	// check if camera disabled
			return C

	return null

/obj/machinery/camera/proc/Togglelight(on=0)
	for(var/mob/living/silicon/ai/A in GLOB.ai_list)
		for(var/obj/machinery/camera/cam in A.lit_cameras)
			if(cam == src)
				return
	if(on)
		set_light(AI_CAMERA_LUMINOSITY)
	else
		set_light(0)

/obj/machinery/camera/get_remote_view_fullscreens(mob/user)
	if(view_range == short_range) //unfocused
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, 2)

/obj/machinery/camera/update_remote_sight(mob/living/user)
	user.see_invisible = SEE_INVISIBLE_LIVING //can't see ghosts through cameras
	if(isXRay())
		user.sight |= (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		user.see_in_dark = max(user.see_in_dark, 8)
	else
		user.sight = 0
		user.see_in_dark = 2
	return 1
