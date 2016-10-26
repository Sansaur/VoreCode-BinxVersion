/*
* LAVA for the heat engine
* -Lava should destroy anything but:
* Reinforced walls, Plasma Glass, Reinforced Blast Doors, the Heat Recyclers, Cables, Pipes
* -Lava should spray around like foam does
* -Lava should have a lifespan
* message_admins("Emitter deleted at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)

*/

/obj/effect/lava
	name = "lava"
	icon = 'icons/turf/flooring/lava.dmi'
	icon_state = "lava"
	invisibility = 0		//You can see the lava even if it's just an effect.
	anchored = 1
	density = 0
	opacity = 0
	var/obj/effect/malpais/DeathWall
	var/lava_amount = 1000
	var/obj/effect/step_trigger/lava_fire/lavastep // = new(loc)

	var/list/unbreakable_objects = list( /obj/structure/cable,
								 /obj/machinery/power/heat_recycler,
								 /obj/effect/lava)
	var/list/impassable_terrain = list( /turf/simulated/wall/r_wall,
								/turf/simulated/wall/phoron)

	var/list/impassable_objects = list( /obj/machinery/door/blast,
								/obj/structure/window/phoronreinforced )

/obj/effect/lava/permalava

/obj/effect/lava/permalava/ReduceLavaAmount()
	spawn(100)
	expand()
//Create a new Step Trigger for the lava on the same spot it is and then erase it when lava erases
//This is erasing the lava, it shouldn't be doing that.
/obj/effect/lava/New()
	..(loc)
	set_light(4, 4, "#ff4500")
	if(prob(1))
		playsound(src, 'sound/effects/lava.wav', 50, 1)
	for(var/obj/item/I in loc)
		if(I in unbreakable_objects)
			continue
		qdel(I)
	for(var/mob/living/carbon/M in loc) //This is what kills mobs in contact with newly created lava.
		M.adjust_fire_stacks(5)
		M.IgniteMob()
		var/mob/living/carbon/human/HU = M
		HU.adjustFireLoss(50, 0)
	spawn(50)
		expand()
	process()

/obj/effect/lava/Destroy()
	for(var/obj/effect/step_trigger/lava_fire/LavaFireHere in loc)
		qdel(LavaFireHere)
	for(var/turf/here in loc)
		here.temperature = 298 //Return floor heat to normal.
	return ..()

/obj/effect/lava/proc/expand()
	lavastep = new(loc)

	for(var/turf/here in loc)
		if(here.temperature < 1000)
			here.temperature += 1800 //Heats up the floor a lot

	for(var/direction in cardinal)
		var/checkIfPassable = 1
		var/turf/T = get_step(src, direction)
		if(!T) //If there is no turfs on any cardinal directions
			continue
		//var/turf/simulated/floor/HEATFLOOR
		if(T.temperature < 1000)
			T.temperature += 1800 //Heats up the floor a lot

		//THIS STARTS A LIST OF ITEMS THAT DISALLOW LAVA TO PASS.
		//OBJECTS AND MOBS USE "locate()".
		//TURFS USE "istype"

		//TURF CHECKING
		if(istype(T, /turf/simulated/wall/r_wall))
			checkIfPassable = 0
			continue

		else if(istype(T, /turf/simulated/wall/phoron))
			checkIfPassable = 0
			continue

		else if(istype(T, /turf/simulated/wall)) //Actually, when you reinforce a wall it doesn't create a r_wall, it just gives some "reinf_material" value
			var/turf/simulated/wall/ThisWall = T
			if(ThisWall.reinf_material)
				checkIfPassable = 0
				continue

		 //OBJECT CHECKING
		var/obj/effect/lava/L = locate() in T
		if(L)
			checkIfPassable = 0
			continue
		var/obj/structure/window/phoronreinforced/PR = locate() in T

		if(PR)
			if(PR.dir == 10) //This checks that the window is full tile
				checkIfPassable = 0
				continue
		var/obj/machinery/door/airlock/AIRLOCK = locate() in T

		if(AIRLOCK)
			if(AIRLOCK.density == 1)
				checkIfPassable = 0
				continue
		var/obj/machinery/door/blast/regular/BLAST = locate() in T

		if(BLAST)
			if(BLAST.density == 1)
				checkIfPassable = 0
				continue
		var/obj/effect/malpais/MAL = locate() in T

		if(MAL)
			checkIfPassable = 0
			continue
		var/obj/effect/lavastopper/LAVASTOP = locate() in T

		if(LAVASTOP)
			checkIfPassable = 0
			continue

		if(checkIfPassable)
			L = new(T)
			L.lava_amount = lava_amount - 30

	for(var/turf/T in oview())
		if(T.carbon_dioxide < 100)
			T.carbon_dioxide += 200
	process()

/obj/effect/lava/process()
	ReduceLavaAmount()


/obj/effect/lava/proc/ReduceLavaAmount()
	spawn(50)
	if(prob(50))
		lava_amount -= 1
	spawn(50)
	if(prob(20))
		lava_amount -= 1
	//if(prob(10))
		//expand()
	spawn(50)
	if(lava_amount < 0)
		DeathWall = new(loc)
		for(var/obj/effect/step_trigger/lava_fire/LavaFireHere in loc)
			qdel(LavaFireHere)
		for(var/turf/here in loc)
			here.temperature = 298 //Return floor heat to normal.
		qdel(src)
	else
		expand()

/**
* The lava Step Trigger, what happens when a mob enters into Lava
**/

/obj/effect/step_trigger/lava_fire

/obj/effect/step_trigger/lava_fire/Trigger(mob/living/carbon/M as mob)
	M.adjust_fire_stacks(5)
	M.IgniteMob()
	var/mob/living/carbon/human/HU = M
	HU.adjustFireLoss(50, 0)

/**
* The Malpais, basically frozen lava
**/
/obj/effect/malpais
	name = "malpais"
	desc = "it's frozen lava, looks like you could mine your way through... Or maybe use a crowbar to break it."
	icon = 'icons/turf/walls.dmi'
	icon_state = "malpais"
	opacity = 1
	density = 1
	anchored = 1

/obj/effect/malpais/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/turf/T = user.loc
	if(istype(W, /obj/item/weapon/crowbar))
		user << "<span class='notice'>You struggle to slowly break the piece of solid lava.</span>"
		//playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		if(!do_after(user,100) || !istype(src, /obj/effect/malpais) || !user || !W )
			return
		if(user.loc == T && user.get_active_hand() == W )
			user << "<span class='notice'>The wall crumbles.</span>"
			qdel(src)

	if(istype(W, /obj/item/weapon/pickaxe))
		user << "<span class='notice'>You pick the lava off.</span>"
		//playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		if(!do_after(user,10) || !istype(src, /obj/effect/malpais) || !user || !W )
			return
		if(user.loc == T && user.get_active_hand() == W )
			user << "<span class='notice'>The wall crumbles.</span>"
			qdel(src)

	if(istype(W, /obj/item/weapon/shovel))
		user << "<span class='notice'>You dig through the frozen lava.</span>"
		//playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		if(!do_after(user,55) || !istype(src, /obj/effect/malpais) || !user || !W )
			return
		if(user.loc == T && user.get_active_hand() == W )
			user << "<span class='notice'>The wall crumbles.</span>"
			qdel(src)

/**
* The Lava Stopper, to avoid lava from spreading infinitely out the station
**/
/obj/effect/lavastopper
	name = "lavastopper"
	desc = "YOU SHOULDN'T BE SEEING THIS."
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	opacity = 0
	density = 0
	anchored = 0
	invisibility = 101