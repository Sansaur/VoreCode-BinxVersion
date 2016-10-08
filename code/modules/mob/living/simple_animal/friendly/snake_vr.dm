/mob/living/simple_animal/snake
	name = "Snake"
	desc = "A big thick snake."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"
	speak_emote = list("hisses")
	health = 20
	maxHealth = 20
	attacktext = "bites"
	melee_damage_lower = 3
	melee_damage_upper = 5
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "kicks"
	turns_per_move = 8 // SLOW-ASS MUTHAFUCKA
	var/turns_since_scan = 0
	var/obj/movement_target_object
	var/mob/living/simple_animal/mouse/movement_target

/mob/living/simple_animal/snake/New()
	if(!vore_organs.len)
		var/datum/belly/B = new /datum/belly(src)
		B.immutable = 1
		B.name = "Stomach"
		B.inside_flavor = "You are now inside a snake! Digestion will take a looooooong while, have fun!"
		B.human_prey_swallow_time = swallowTime
		B.nonhuman_prey_swallow_time = swallowTime
		B.digest_mode = DM_DIGEST
		vore_organs[B.name] = B
		vore_selected = B.name

		B.emote_lists[DM_HOLD] = list(
			"The extremely tight passage that surrounds you shifts just gently, the snake is repositioning",
			"With a loud glorp, the muscles knead your form from head to feet",
			"Thick bellyslime surrounds you.",
			"The snake moves a bit and hisses, making you shift positions",
			"During a moment of relative silence... you realize how long this is taking",
			"The belly around you shifts a bit, the snake slithers and turns, making you face the opposite direction now")

		B.emote_lists[DM_DIGEST] = list(
			"The guts knead at you, trying to work you into thick soup.",
			"You're ground on by the slimey walls, treated like a mouse.",
			"The acrid air is hard to breathe, and stings at your lungs.",
			"You can feel the acids coating you, ground in by the slick walls.",
			"The snake's stomach churns hungrily over your form, trying to take you.",
			"With a loud glorp, the stomach spills more acids onto you.")
	..()
//NOODLE IS HERE! SQUEEEEEEEE~
/mob/living/simple_animal/snake/Noodle
	name = "Noodle"
	desc = "This snake is particularly chubby and demands nothing but the finest of treats."
	isPredator = 1

/mob/living/simple_animal/snake/Life()
	//MICE!
	if((loc) && isturf(loc))
		if(!stat && !resting && !buckled)
			for(var/mob/living/simple_animal/mouse/M in loc)
				if(isPredator) //If the snake is a predator,
					movement_target = null
					custom_emote(1, "greedily stuffs [M] into their gaping maw!")
					if(M in oview(1, src))
						animal_nom(M)
					else
						M << "You just manage to slip away from [src]'s jaws before you can be sent to a fleshy prison!"
					break
				else
					if(!M.stat)
						M.splat()
						visible_emote(pick("flicks her tongue at \the [M]!","coils a bit around \the [M].","hisses at \the [M]!"))
						movement_target = null
						stop_automated_movement = 0
						break
	..()

	for(var/mob/living/simple_animal/mouse/snack in oview(src,5))
		if(snack.stat < DEAD && prob(15))
			audible_emote(pick("slithers stealthily!","stares as they flick their tongue!","eyes [snack] hungrily.","slowly lifts itself from the ground!"))
		break

	if(!stat && !resting && !buckled) //SEE A MICRO AND ARE A PREDATOR, EAT IT!
		for(var/mob/living/carbon/human/food in oview(src, 5))

			if(food.size_multiplier <= RESIZE_A_SMALLTINY)
				if(prob(10))
					custom_emote(1, pick("eyes [food] hungrily!","flicks their tongue and turns towards [food] a little!","starts dancing a bit as they imagine [food] being in their belly."))
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
				custom_emote(1, pick("tries to trap [bellyfiller] with their stretchy maw.","looms over [bellyfiller] with their maw agape, smiling deviously.","pokes [bellyfiller] with their nose, their tail rattling."))
				sleep(10)
				custom_emote(1, "starts devouring [bellyfiller] without chewing!")
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
			handle_movement_target()

/mob/living/simple_animal/snake/proc/handle_movement_target()
	//if our target is neither inside a turf or inside a human(???), stop
	if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
		movement_target = null
		stop_automated_movement = 0
	//if we have no target or our current one is out of sight/too far away
	if( !movement_target || !(movement_target.loc in oview(src, 4)) )
		movement_target = null
		stop_automated_movement = 0
		for(var/mob/living/simple_animal/mouse/snack in oview(src)) //search for a new target
			if(isturf(snack.loc) && !snack.stat)
				movement_target = snack
				break

	if(movement_target)
		stop_automated_movement = 1
		walk_to(src,movement_target,0,10)

//Special snek-snax for Noodle!
obj/item/weapon/reagent_containers/food/snacks/snakesnack
	name = "Sugar mouse"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these!"
	var/snack_colour
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snack_yellow"

obj/item/weapon/reagent_containers/food/snacks/snakesnack/New()
	..()
	if(!snack_colour)
		snack_colour = pick( list("yellow","green","pink","blue") )
	icon_state = "snack_[snack_colour]"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these! This one is [snack_colour]."

obj/item/weapon/storage/box/fluff/snakesnackbox
	name = "Box of Snake Snax"
	desc = "A box containing Noodle's special sugermouse treats."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "sneksnakbox"
	storage_slots = 7
	New()
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		..()
		return