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

//Why is this on simple_animal_vr.dm if it's a carbon/human thing? -Sansaur
/mob/living/carbon/human/verb/micro_crush(var/mob/living/target in view(1)-usr)
	set name = "Crush Micro"
	set desc = "Attempt to crush a micro."
	set category = "Vore"
	set src in oview(1)
	var/mob/living/carbon/human/user = usr

	if(user.size_multiplier - target.size_multiplier >= 0.75)
		var/confirm = alert(usr, "Are you sure you want to crush [name]? This WILL kill them.", "Crushing [name]", "Crush", "Don't Crush")
		if(confirm == "Crush")
			var/T = get_turf(target)
			if(istype(user) && istype(user.tail_style, /datum/sprite_accessory/tail/taur/naga))
				user.visible_message("[user] positions their tail above [target], preparing to crush them!")
				if (do_after(usr,40))
					user.visible_message("[user] slams their tail down ontop of [target], crushing them out completely!")
					new /obj/effect/decal/cleanable/blood/gibs/core(T)
					target.apply_damage(400, BRUTE) //Yikes!
					qdel(target)
			else
				user.visible_message("[user] positions their foot above [target], preparing to crush them!")
				if (do_after(usr,40))
					user.visible_message("[user] slams their foot down ontop of [target], twisting and grinding them out like a cigarette!")
					new /obj/effect/decal/cleanable/blood/gibs/core(T)
					target.apply_damage(400, BRUTE)
					qdel(target)
		else
			return