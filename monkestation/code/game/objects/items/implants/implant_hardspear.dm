/obj/item/implant/hardspear
	name = "hardlight spear implant"
	icon = 'monkestation/icons/obj/implants.dmi'
	icon_state = "lightspear" //Shows up as the action button icon
	implant_color = "b"
	uses = -1
	COOLDOWN_DECLARE(hardlight_implant_cooldown)

/obj/item/implant/hardspear/activate()
	if(!COOLDOWN_FINISHED(src, hardlight_implant_cooldown)) //Thanks implant_abductor.dm for the help <3
		to_chat(imp_in, "<span class='warning'>You must wait [COOLDOWN_TIMELEFT(src, hardlight_implant_cooldown)*0.1] seconds to use [src] again!</span>")
		return

	var/obj/item/spear/awesomespear
	awesomespear = new /obj/item/spear/hardlightspear(imp_in.loc)
	if(imp_in.put_in_hands(awesomespear))
		to_chat(imp_in, "A spear manifests in your hand.")
		COOLDOWN_START(src, hardlight_implant_cooldown, 30 SECONDS)
	else
		to_chat(imp_in, "You must have a free hand to summon a spear!")
		qdel(awesomespear) //not so awesome anymore, are you buddy?
		return

/obj/item/implanter/hardspear
	name = "implanter (hardlight spear)"
	imp_type = /obj/item/implant/hardspear

/obj/item/implantcase/hardspear
	name = "implant case - 'Hardlight Spear'"
	desc = "A glass case containing a freedom implant."
	imp_type = /obj/item/implant/hardspear

/obj/item/spear/hardlightspear
	icon = 'monkestation/icons/obj/items_and_weapons.dmi'
	icon_state = "lightspear"
	lefthand_file = 'monkestation/icons/mob/inhands/polearms_lefthand.dmi'
	righthand_file = 'monkestation/icons/mob/inhands/polearms_righthand.dmi'
	name = "hardlight spear"
	desc = "A spear made out of hardened light."
	force = 15
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 1
	block_upgrade_walk = 1
	throwforce = 25
	throw_speed = 6
	armour_penetration = 18
	hitsound = 'sound/weapons/blade1.ogg'
	attack_verb = list()
	sharpness = IS_SHARP

/obj/item/spear/hardlightspear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(hit_atom && !QDELETED(hit_atom))
		SEND_SIGNAL(src, COMSIG_MOVABLE_IMPACT, hit_atom, throwingdatum)
		if(is_hot() && isliving(hit_atom))
			var/mob/living/L = hit_atom
			L.IgniteMob()
		var/itempush = 0 //too light to push anything (haha)
		if(istype(hit_atom, /mob/living)) //Living mobs handle hit sounds differently.
			var/volume = get_volume_by_throwforce_and_or_w_class()
			playsound(hit_atom, 'sound/weapons/genhit.ogg',volume, TRUE, -1)
		else
			playsound(src, drop_sound, THROW_SOUND_VOLUME, ignore_walls = FALSE)
		qdel(src) //Deletes when it gets thrown at somethign
		return hit_atom.hitby(src, 0, itempush, throwingdatum=throwingdatum)

/obj/item/spear/hardlightspear/update_icon()
	return //Fixes spear turning invisible on attack

/obj/item/spear/hardlightspear/unembedded()
	. = ..()
	QDEL_NULL(src) //Deletes itself when unembedded
	return TRUE


