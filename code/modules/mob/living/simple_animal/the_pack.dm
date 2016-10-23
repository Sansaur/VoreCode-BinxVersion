/mob/living/simple_animal/packleader
	name = "Pack Leader"
	desc = "A powerful cryo wolf who leads the pack, it's blue stare pierce right through your soul."
	health = 250
	maxHealth = 250
	speed = -3
	icon_state = "packleader"
	item_state = "packleader"
	icon_living = "packleader"
	icon_dead = "packleader_dead"
	speak = list("Aroooo!","Grrrrr...","Grrrrr.","Rrrr.", "Arf", "Wrarrr")
	speak_emote = list("pants", "growls", "snarls")
	emote_hear = list("pants", "growls")
	emote_see = list("shakes their head", "looks around", "scans the area for prey", "yawns")
	speak_chance = 1
	turns_per_move = 1
	see_in_dark = 14
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "strikes"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/list/packwolves //The list of all his packwolves
	var/mob/hostile_target
	var/max_wolves = 8	//How many wolves can the packleader have
	min_oxy = 0 		//Doesn't need oxygen
	minbodytemp = 0		//Can survive freezing
	maxbodytemp = 323	//Above 50 Degrees Celcius
	//holder_type = /obj/item/weapon/holder/cat
	mob_size = MOB_MEDIUM

/mob/living/simple_animal/packleader/New()
	..()

/mob/living/simple_animal/packleader/Life()
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(isPredator) //If the snake is a predator,
					movement_target = null
					custom_emote(1, "greedily stuffs [M] into their kitty mouth!")
					if(M in oview(1, src))
						animal_nom(M)
					else
						M << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
					break
				if(!M.stat)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
					movement_target = null
					stop_automated_movement = 0
					break

	..()

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hisses and spits!","mrowls fiercely!","eyes [snack] hungrily."))
		break

	if(!stat && !resting && !buckled) //SEE A MICRO AND ARE A PREDATOR, EAT IT!
		for(var/mob/living/carbon/human/food in oview(src, 5))

			if(food.size_multiplier <= RESIZE_A_SMALLTINY)
				if(prob(10))
					custom_emote(1, pick("eyes [food] hungrily!","lifts his paw and paws at the air towards [food], trying to gauge distance!","hisses fiercily as they plan a way to get [food] inside of them!"))
					break
				else
					if(prob(5))
						movement_target = food
						break

		for(var/mob/living/carbon/human/bellyfiller in oview(1, src))
			if(bellyfiller in src.prey_excludes)
				continue

			if(bellyfiller.size_multiplier <= RESIZE_A_SMALLTINY && isPredator)
				movement_target = null
				custom_emote(1, pick("traps [bellyfiller] and then bites him, slowly pulling him into their mouth!.","looms over [bellyfiller] and then quickly lowers their head towards their prey!.","devours [bellyfiller] with speed!."))
				sleep(10)
				custom_emote(1, "starts nomming on [bellyfiller]!")
				if(bellyfiller in oview(1, src))
					animal_nom(bellyfiller)
				else
					bellyfiller << "You just manage to slip away from [src]'s maw before you can be sent to a fleshy prison!"
				break

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if (turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0

	//If the packleader is around a mob who is not part of his pack, he may choose him as a target to kill
	if(!client)
		if((src.loc) && isturf(src.loc))
			if(!stat && !resting && !buckled)
				for(var/mob/possible_target in oview(src, 5))
					if(possible_target in packwolves) //If the mob is part of the pack this breaks
						break
					else
						if(prob(1))
							custom_emote(1, "Howls and marks [possible_target] as the prey of the pack!")
							for(var/mob/living/simple_animal/packwolf/packwolfGO in packwolves)
								packwolfGO.SetHostileTarget(possible_target)

/mob/living/simple_animal/packleader/proc/Call_Howl()
	//We have to improve this so when it's used and there already is a pack, the pack follows you.
	custom_emote(1, "Howls and calls out for his pack!")
	for(var/i=0,i<=max_wolves,i++)
		var/mob/living/simple_animal/packwolf/SpawnedWolf = new /mob/living/simple_animal/packwolf(src.loc)
		SpawnedWolf.name = pick("Hunter", "Assailant", "Attacker", "Aggressor", "Demon", "Moon moon", "Growler", "Snarler", "Toothy")
		SpawnedWolf.master = src
		SpawnedWolf.friends += src
		src.packwolves += SpawnedWolf

/mob/living/simple_animal/packleader/verb/CallHowl()
	set category = "Abilities"
	set name = "Call the Pack"
	set desc = "Bring your wolves to you!"
	Call_Howl()


/mob/living/simple_animal/packwolf
	name = "Pack Wolf"
	desc = "A powerful cryo wolf, looks like he belongs in a pack."
	health = 100
	maxHealth = 100
	speed = -2
	icon_state = "packwolf"
	item_state = "packwolf"
	icon_living = "packwolf"
	icon_dead = "packwolf_dead"
	speak = list("Aroooo!","Grrrrr...","Grrrrr.","Rrrr.", "Arf", "Wrarrr")
	speak_emote = list("pants", "growls", "snarls")
	emote_hear = list("pants", "growls")
	emote_see = list("shakes their head", "looks around", "scans the area for prey", "yawns")
	speak_chance = 1
	turns_per_move = 1
	see_in_dark = 14
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "strikes"
	var/turns_since_scan = 0
	var/mob/living/simple_animal/mouse/movement_target
	var/mob/hostile_target
	var/mob/living/simple_animal/packleader/master
	min_oxy = 0 		//Doesn't need oxygen
	minbodytemp = 0		//Can survive freezing
	maxbodytemp = 323	//Above 50 Degrees Celcius
	mob_size = MOB_MEDIUM

/mob/living/simple_animal/packwolf/Life()
	Handle_Vore_Actions()
	..()
	if(master)
		if(master in oview(8))
			if(master.health < master.maxHealth)
				NurseMaster()
			else
				..()
		else
			custom_emote(1, "Catches the scent of his master and runs towards them as quickly as they can")
			src.speed -= 3
			movement_target = master
			MoveToTarget()

	if(hostile_target && (master in view()))
		target_mob = hostile_target //A bit reiterative, but I'm testing -Sansaur
		MoveToTarget()
		AttackTarget()


/mob/living/simple_animal/packwolf/proc/NurseMaster()
	movement_target = master
	MoveToTarget()
	if(master in oview(1, src))
		if(master.stat != DEAD)
			custom_emote(1, "Licks their master's wounds with care")
			if(prob(25))
				master << "You feel a bit better as your wolves take care of you"
				master.health += 1
		if(master.stat == DEAD)
			if(prob(5))
				custom_emote(1, "Licks their master's mortal wounds and mourns their death")

/mob/living/simple_animal/packwolf/proc/SetHostileTarget(var/mob/M)
	src.hostile_target = M

/mob/living/simple_animal/packwolf/proc/Handle_Vore_Actions()
	if((src.loc) && isturf(src.loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(isPredator) //If the snake is a predator,
					movement_target = null
					custom_emote(1, "greedily stuffs [M] into their kitty mouth!")
					if(M in oview(1, src))
						animal_nom(M)
					else
						M << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
					break
				if(!M.stat)
					M.splat()
					visible_emote(pick("bites \the [M]!","toys with \the [M].","chomps on \the [M]!"))
					movement_target = null
					stop_automated_movement = 0
					break

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("hisses and spits!","mrowls fiercely!","eyes [snack] hungrily."))
		break

	if(!stat && !resting && !buckled) //SEE A MICRO AND ARE A PREDATOR, EAT IT!
		for(var/mob/living/carbon/human/food in oview(src, 5))

			if(food.size_multiplier <= RESIZE_A_SMALLTINY)
				if(prob(10))
					custom_emote(1, pick("eyes [food] hungrily!","lifts his paw and paws at the air towards [food], trying to gauge distance!","hisses fiercily as they plan a way to get [food] inside of them!"))
					break
				else
					if(prob(5))
						movement_target = food
						break

		for(var/mob/living/carbon/human/bellyfiller in oview(1, src))
			if(bellyfiller in src.prey_excludes)
				continue

			if(bellyfiller.size_multiplier <= RESIZE_A_SMALLTINY && isPredator)
				movement_target = null
				custom_emote(1, pick("traps [bellyfiller] and then bites him, slowly pulling him into their mouth!.","looms over [bellyfiller] and then quickly lowers their head towards their prey!.","devours [bellyfiller] with speed!."))
				sleep(10)
				custom_emote(1, "starts nomming on [bellyfiller]!")
				if(bellyfiller in oview(1, src))
					animal_nom(bellyfiller)
				else
					bellyfiller << "You just manage to slip away from [src]'s maw before you can be sent to a fleshy prison!"
				break

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if (turns_since_scan > 5)
			walk_to(src,0)
			turns_since_scan = 0
