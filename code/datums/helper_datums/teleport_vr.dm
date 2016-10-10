/datum/teleport/proc/try_televore()
	var/datum/belly/target_belly
	var/mob/living/belly_owner
	//Destination is a living thing
	target_belly = check_belly(destination)

	//Destination has a living thing on it
	if(!target_belly)
		for(var/mob/living/M in get_turf(destination))
			if(M.vore_organs.len)
				var/I = M.vore_organs[1]
				target_belly = M.vore_organs[I]
				belly_owner = M

	if(target_belly)
		if(destination.loc == belly_owner) //If the destination is the owner of the target belly you can't go there.
			return 0
		else
			teleatom.forceMove(destination.loc)
			playSpecials(destination,effectout,soundout)
			target_belly.internal_contents += teleatom
			playsound(destination, target_belly.vore_sound, 100, 1)
			return 1

	//No fun!
	return 0