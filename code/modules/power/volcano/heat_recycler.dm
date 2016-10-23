/**
* We have to call this: connect_to_network(), everytime it gets wrenched down
* Heat Recycler is working, it sends the temperature of the tile through the powerline as expected.
**/
/obj/machinery/power/heat_recycler
	name = "Heat Recycler Unit"
	desc = "Basically a little bucket that turns lava into thermal energy, why? how? Don't ask me."
	icon = 'icons/effects/fire.dmi'
	icon_state = "heat_recycler0"
	density = 0
	anchored = 0


/obj/machinery/power/heat_recycler/New()
	..()
	process()

/obj/machinery/power/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		if(!anchored)
			usr.visible_message("<span class='notice'>[user] secures the bolts of the [src]</span>", "<span class='notice'>You secure the bolts of the [src]</span>", "Someone's securing some bolts")
			src.anchored = 1
			src.density = 1
			connect_to_network()
		else
			usr.visible_message("<span class='danger'>[user] unsecures the bolts of the [src]!</span>", "<span class='notice'>You unsecure the bolts of the [src]</span>", "Someone's unsecuring some bolts")
			src.anchored = 0
			src.density = 0
			disconnect_from_network()
	icon_state = "heat_recycler[anchored]"

/obj/machinery/power/heat_recycler/process()
	var/turf/T = src.loc
	var/amount = T.temperature
	if(anchored)
		spawn(30)
		add_avail((amount * 325))
		// * 100 = 209315W
