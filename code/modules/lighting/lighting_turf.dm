/turf
	var/dynamic_lighting = TRUE
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/atom/movable/lighting_object/lighting_object // Our lighting object.
	///Lighting Corner datums.
	var/tmp/datum/lighting_corner/lighting_corner_NE
	var/tmp/datum/lighting_corner/lighting_corner_SE
	var/tmp/datum/lighting_corner/lighting_corner_SW
	var/tmp/datum/lighting_corner/lighting_corner_NW

	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	lighting_corner_NE?.vis_update()
	lighting_corner_SE?.vis_update()
	lighting_corner_SW?.vis_update()
	lighting_corner_NW?.vis_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_object)
		qdel(lighting_object, TRUE)

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if (lighting_object)
		qdel(lighting_object,force=TRUE) //Shitty fix for lighting objects persisting after death

	new/atom/movable/lighting_object(src)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(var/minlum = 0, var/maxlum = 1)
	if (!lighting_object)
		return 1

	var/totallums = 0
	var/datum/lighting_corner/L
	var/totalSunFalloff
	L = lighting_corner_NE
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_SE
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_SW
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff
	L = lighting_corner_NW
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
		totalSunFalloff += L.sunFalloff

	if(outdoor_effect && outdoor_effect.state) /* SKY_BLOCKED is 0 */
		totalSunFalloff = 4
	/* sunlight / 4 corners */
	totallums += totalSunFalloff / 4

	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)

	totallums += dynamic_lumcount

	return CLAMP01(totallums)

// Returns a boolean whether the turf is on soft lighting.
// Soft lighting being the threshold at which point the overlay considers
// itself as too dark to allow sight and see_in_dark becomes useful.
// So basically if this returns true the tile is unlit black.
/turf/proc/is_softly_lit()
	if (!lighting_object)
		return FALSE

	return !lighting_object.luminosity

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
	has_opaque_atom = opacity
	if (!has_opaque_atom)
		for (var/atom/A in src.contents) // Loop through every movable atom on our tile PLUS ourselves (we matter too...)
			if (A.opacity)
				has_opaque_atom = TRUE
				break

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (Obj?.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/proc/change_area(var/area/old_area, var/area/new_area)
	if(SSlighting.initialized)
		if (new_area.static_lighting != old_area.static_lighting)
			if (new_area.static_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()
		//Inherit overlay of new area
	if(old_area.lighting_effect)
		cut_overlay(old_area.lighting_effect)
	if(new_area.lighting_effect)
		add_overlay(new_area.lighting_effect)

/turf/proc/generate_missing_corners()
	if (!lighting_corner_NE)
		lighting_corner_NE = new/datum/lighting_corner(src, NORTH|EAST)

	if (!lighting_corner_SE)
		lighting_corner_SE = new/datum/lighting_corner(src, SOUTH|EAST)

	if (!lighting_corner_SW)
		lighting_corner_SW = new/datum/lighting_corner(src, SOUTH|WEST)

	if (!lighting_corner_NW)
		lighting_corner_NW = new/datum/lighting_corner(src, NORTH|WEST)

	lighting_corners_initialised = TRUE
