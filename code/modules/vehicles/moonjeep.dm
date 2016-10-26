/obj/vehicle/moonjeep
	name = "Moon Jeep"
	icon = 'icons/obj/vehicles48x48.dmi'
	icon_state = "moonjeep"
	layer = MOB_LAYER + 0.1 //so it sits above objects including mobs
	density = 1
	anchored = 1
	pixel_x = -8
	pixel_y = 0
	animate_movement=1
	light_range = 3
	can_buckle = 1
	buckle_movable = 1
	buckle_lying = 0
	attack_log = null
	on = 0
	health = 300	//do not forget to set health for your vehicle!
	maxhealth = 300
	fire_dam_coeff = 1.2
	brute_dam_coeff = 1.0
	open = 0	//Maint panel
	locked = 1
	stat = 0
	emagged = 0
	powered = 0		//set if vehicle is powered and should use fuel when moving
	move_delay = 1	//set this to limit the speed of the vehicle
	charge_use = 5	//set this to adjust the amount of power the vehicle uses per move
	//var/atom/movable/load		//all vehicles can take a load, since they should all be a least drivable
	var/mob/driver
	var/mob/passenger1
	var/mob/passenger2
	var/mob/passenger3
	load_item_visible = 0	//set if the loaded item should be overlayed on the vehicle sprite
	load_offset_x = 0		//pixel_x offset for item overlay
	load_offset_y = 0		//pixel_y offset for item overlay
	mob_offset_y = 0		//pixel_y offset for mob overlay

/obj/vehicle/moonjeep/New()
	..()
	cell = new(src)

/obj/vehicle/moonjeep/load(var/atom/movable/C)
	if(ismob(C) && !driver)
		C.forceMove(loc)
		C.set_dir(dir)
		C.anchored = 1
		buckle_mob(C)
		make_driver(C)
	if(ismob(C))
		C.forceMove(loc)
		C.set_dir(dir)
		C.anchored = 1
		buckle_mob(C)
		make_passenger(C)
	else
		buckle_mob(C)
	return 1
/obj/vehicle/moonjeep/unload(var/mob/user, var/direction)
	if(!load && !passenger1 && !passenger2 && !passenger3)
		return

	var/turf/dest = null

	//find a turf to unload to
	if(direction)	//if direction specified, unload in that direction
		dest = get_step(src, direction)
	else if(user)	//if a user has unloaded the vehicle, unload at their feet
		dest = get_turf(user)

	if(!dest)
		dest = get_step_to(src, get_step(src, turn(dir, 90))) //try unloading to the side of the vehicle first if neither of the above are present

	//if these all result in the same turf as the vehicle or nullspace, pick a new turf with open space
	if(!dest || dest == get_turf(src))
		var/list/options = new()
		for(var/test_dir in alldirs)
			var/new_dir = get_step_to(src, get_step(src, test_dir))
			if(new_dir && load.Adjacent(new_dir))
				options += new_dir
		if(options.len)
			dest = pick(options)
		else
			dest = get_turf(src)	//otherwise just dump it on the same turf as the vehicle

	if(!isturf(dest))	//if there still is nowhere to unload, cancel out since the vehicle is probably in nullspace
		return 0

	if(user == load)
		load.forceMove(dest)
		load.set_dir(get_dir(loc, dest))
		load.pixel_x = initial(load.pixel_x)
		load.pixel_y = initial(load.pixel_y)
		load.layer = initial(load.layer)
		unbuckle_mob(load)
		user.buckled = null //This is a hack due to how "unbuckle_mob" works, it was designed to only have one person buckled at a time.
		remove_driver(load)
		load = null

	if(user == passenger1)
		passenger1.forceMove(dest)
		passenger1.set_dir(get_dir(loc, dest))
		passenger1.pixel_x = initial(passenger1.pixel_x)
		passenger1.pixel_y = initial(passenger1.pixel_y)
		passenger1.layer = initial(passenger1.layer)
		unbuckle_mob(passenger1)
		passenger1.buckled = null
		remove_passenger(passenger1)

	if(user == passenger2)
		passenger2.forceMove(dest)
		passenger2.set_dir(get_dir(loc, dest))
		passenger2.pixel_x = initial(passenger2.pixel_x)
		passenger2.pixel_y = initial(passenger2.pixel_y)
		passenger2.layer = initial(passenger2.layer)
		unbuckle_mob(passenger2)
		passenger2.buckled = null
		remove_passenger(passenger2)

	if(user == passenger3)
		passenger3.forceMove(dest)
		passenger3.set_dir(get_dir(loc, dest))
		passenger3.pixel_x = initial(passenger3.pixel_x)
		passenger3.pixel_y = initial(passenger3.pixel_y)
		passenger3.layer = initial(passenger3.layer)
		unbuckle_mob(passenger3)
		passenger3.buckled = null
		remove_passenger(passenger3)

	return 1

/obj/vehicle/moonjeep/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(user.buckled || user.stat || user.restrained() || !Adjacent(user) || !user.Adjacent(C) || !istype(C) || (user == C && !user.canmove))
		return
	if(!load(C))
		user << "\red You were unable to load [C] on [src]."

/obj/vehicle/moonjeep/attack_hand(mob/user as mob)
	if(user.stat || user.restrained() || !Adjacent(user))
		return 0
	if(user != load && user != passenger1 && user != passenger2 && user != passenger3) // && (user in src)
		user.forceMove(loc)			//This is what causes a person to move on top of the car even if it' full, it's an antibug
	if(load || passenger1 || passenger2 || passenger3)
		if(user == load)
			unload(load)
			return 1
		else if(!user.buckled)
			load(user)
		if(user == passenger1)
			unload(passenger1)
			return 1
		else if(!user.buckled)
			load(user)
		if(user == passenger2)
			unload(passenger2)
			return 1
		else if(!user.buckled)
			load(user)
		if(user == passenger3)
			unload(passenger3)
			return 1
		else if(!user.buckled)
			load(user)
	else
		load(user)
	return 0

/obj/vehicle/moonjeep/relaymove(mob/user, direction)
	if(user != load)
		return 0
	if(user != driver)
		return 0
	if(Move(get_step(src, direction)))
		return 1
	else
		return 0
	return 0

/obj/vehicle/moonjeep/proc/make_driver(mob/C)
	src.driver = C
	src.load = C
	src.desc = "[src] has a driver! It's [driver.name]"

/obj/vehicle/moonjeep/proc/make_passenger(mob/C)
	if(!passenger1)
		if(C != src.driver)
			src.passenger1 = C
			return 1
	else if(!passenger2)
		if(C != src.driver)
			src.passenger2 = C
			return 1
	else if(!passenger3)
		if(C != src.driver)
			src.passenger3 = C
			return 1
	else
		C << "The [src] is full!"
		return 0

/obj/vehicle/moonjeep/proc/remove_driver()
	src.driver = null
	src.load = null
	src.desc = "[src] does not have a driver"

/obj/vehicle/moonjeep/proc/remove_passenger(mob/C)
	if(passenger1 == C)
		src.passenger1 = null
		return 1
	else if(passenger2 == C)
		src.passenger2 = null
		return 1
	else if(passenger3 == C)
		src.passenger3 = null
		return 1
	else
		return 0

/obj/vehicle/moonjeep/buckle_mob(mob/living/M)
	if(!can_buckle || !istype(M) || (M.loc != loc) || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
		return 0
	if(driver && passenger1 && passenger2 && passenger3) //If all seats are taken
		M  << "<span class='notice'>\The [src] already has someone buckled to it.</span>"
		return 0
	M.buckled = src
	M.facing_dir = null
	M.set_dir(buckle_dir ? buckle_dir : dir)
	M.update_canmove()
	buckled_mob = M
	post_buckle_mob(M)
	return 1

/obj/vehicle/moonjeep/Move()
	if(world.time > l_move_time + move_delay)
		var/old_loc = get_turf(src)
		if(on && powered && cell.charge < charge_use)
			turn_off()

		var/init_anc = anchored
		anchored = 0
		if(!..())
			anchored = init_anc
			return 0

		set_dir(get_dir(old_loc, loc))
		anchored = init_anc

		if(on && powered)
			cell.use(charge_use)

		//Dummy loads do not have to be moved as they are just an overlay
		//See load_object() proc in cargo_trains.dm for an example
		if(load && !istype(load, /datum/vehicle_dummy_load))
			load.forceMove(loc)
			load.set_dir(dir)
		if(passenger1 && !istype(passenger1, /datum/vehicle_dummy_load))
			passenger1.forceMove(loc)
			passenger1.set_dir(dir)
		if(passenger2 && !istype(passenger2, /datum/vehicle_dummy_load))
			passenger2.forceMove(loc)
			passenger2.set_dir(dir)
		if(passenger3 && !istype(passenger3, /datum/vehicle_dummy_load))
			passenger3.forceMove(loc)
			passenger3.set_dir(dir)

		return 1
	else
		return 0