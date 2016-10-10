///////////////////// Simple Animal /////////////////////
/mob/living/simple_animal
	var/isPredator = 1 					//Are they capable of performing and pre-defined vore actions for their species? Changed so by default all animals are predators - Sansaur
	var/swallowTime = 30 				//How long it takes to eat its prey in 1/10 of a second. The default is 3 seconds.
	var/list/prey_excludes = list()		//For excluding people from being eaten.

//
// Simple nom proc for if you get ckey'd into a simple_animal mob! Avoids grabs.
//
/mob/living/proc/animal_nom(var/mob/living/T in oview(1))
	set name = "Animal Nom"
	set category = "Vore"
	set desc = "Since you can't grab, you get a verb!"

	//This method is too simple, needs checks to see if the T mob wants to be eaten or not, or if whoever is going to eat is inside others.
	if (stat != CONSCIOUS) //If the animal is unconcious, it doesn't eat anyone
		return
		/*
 	//If the animal is in the T's loc it won't work
 	if(istype(src.loc,/mob/living))
 		checker = 0
		return
	if(checker == 1)*/
	feed_grabbed_to_self(src,T)
	return
//
// Simple proc for animals to have their digestion toggled on/off externally
//
/mob/living/simple_animal/verb/toggle_digestion()
	set name = "Toggle Animal's Digestion"
	set desc = "Enables digestion on this mob for 20 minutes."
	set category = "Vore"
	set src in oview(1)

	var/datum/belly/B = vore_organs[vore_selected]
	if(faction != usr.faction)
		usr << "<span class='warning'>This predator isn't friendly, and doesn't give a shit about your opinions of it digesting you.</span>"
		return
	if(B.digest_mode == "Hold")
		var/confirm = alert(usr, "Enabling digestion on [name] will cause it to digest all stomach contents. Using this to break OOC prefs is against the rules. Digestion will disable itself after 20 minutes.", "Enabling [name]'s Digestion", "Enable", "Cancel")
		if(confirm == "Enable")
			B.digest_mode = "Digest"
			spawn(12000) //12000=20 minutes
				if(src)	B.digest_mode = "Hold"
	else
		var/confirm = alert(usr, "This mob is currently set to digest all stomach contents. Do you want to disable this?", "Disabling [name]'s Digestion", "Disable", "Cancel")
		if(confirm == "Disable")
			B.digest_mode = "Hold"
