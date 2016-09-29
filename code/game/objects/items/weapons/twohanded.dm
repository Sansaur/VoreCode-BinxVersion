/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 *		Spears
 *		CHAINSAWS
 *		Bone Axe and Spear
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.


/*

/*
 * Twohanded
 */
/obj/item/weapon/twohanded
	var/wielded = 0
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null

/obj/item/weapon/twohanded/proc/unwield(mob/living/carbon/user)
	if(!wielded || !user)
		return
	wielded = 0
	if(force_unwielded)
		force = force_unwielded
	var/sf = findtext(name," (Wielded)")
	if(sf)
		name = copytext(name,1,sf)
	else //something wrong
		name = "[initial(name)]"
	update_icon()
	if(isrobot(user))
		user << "<span class='notice'>You free up your module.</span>"
	else if(istype(src, /obj/item/weapon/twohanded/required))
		user << "<span class='notice'>You drop \the [name].</span>"
	else
		user << "<span class='notice'>You are now carrying the [name] with one hand.</span>"
	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_held_item()
	if(O && istype(O))
		O.unwield()
	return

/obj/item/weapon/twohanded/proc/wield(mob/living/carbon/user)
	if(wielded)
		return
	if(istype(user,/mob/living/carbon/monkey) )
		user << "<span class='warning'>It's too heavy for you to wield fully.</span>"
		return
	if(user.get_inactive_held_item())
		user << "<span class='warning'>You need your other hand to be empty!</span>"
		return
	if(user.get_num_arms() < 2)
		user << "<span class='warning'>You don't have enough hands.</span>"
		return
	wielded = 1
	if(force_wielded)
		force = force_wielded
	name = "[name] (Wielded)"
	update_icon()
	if(isrobot(user))
		user << "<span class='notice'>You dedicate your module to [name].</span>"
	else
		user << "<span class='notice'>You grab the [name] with both hands.</span>"
	if (wieldsound)
		playsound(loc, wieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name] - offhand"
	O.desc = "Your second grip on the [name]"
	user.put_in_inactive_hand(O)
	return

/obj/item/weapon/twohanded/dropped(mob/user)
	..()
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/weapon/twohanded/O = user.get_inactive_held_item()
		if(istype(O))
			O.unwield(user)
	return	unwield(user)

/obj/item/weapon/twohanded/update_icon()
	return

/obj/item/weapon/twohanded/attack_self(mob/user)
	..()
	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)

/obj/item/weapon/twohanded/equip_to_best_slot(mob/M)
	if(..())
		unwield(M)
		return

/obj/item/weapon/twohanded/equipped(mob/user, slot)
	..()
	if(!user.is_holding(src) && wielded)
		unwield(user)

///////////OFFHAND///////////////
/obj/item/weapon/twohanded/offhand
	name = "offhand"
	icon_state = "offhand"
	w_class = 5
	flags = ABSTRACT

/obj/item/weapon/twohanded/offhand/unwield()
	qdel(src)

/obj/item/weapon/twohanded/offhand/wield()
	qdel(src)

///////////Two hand required objects///////////////
//This is for objects that require two hands to even pick up
/obj/item/weapon/twohanded/required/
	w_class = 5

/obj/item/weapon/twohanded/required/attack_self()
	return

/obj/item/weapon/twohanded/required/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	if(wielded && !slot_flags)
		M << "<span class='warning'>\The [src] is too cumbersome to carry with anything but your hands!</span>"
		return 0
	return ..()

/obj/item/weapon/twohanded/required/attack_hand(mob/user)//Can't even pick it up without both hands empty
	var/obj/item/weapon/twohanded/required/H = user.get_inactive_held_item()
	if(get_dist(src,user) > 1)
		return 0
	if(H != null)
		user << "<span class='notice'>\The [src] is too cumbersome to carry in one hand!</span>"
		return
	if(src.loc != user)
		wield(user)
	..()

/obj/item/weapon/twohanded/required/equipped(mob/user, slot)
	..()
	if(slot == slot_hands)
		wield(user)
	else
		unwield(user)
*/