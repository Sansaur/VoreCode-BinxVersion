//////Ensyme_Reclaimer


/obj/structure/Ensyme_Reclaimer
	name = "Ensyme reclaimer"
	icon = 'icons/obj/Ensyme_Reclaimer.dmi'
	icon_state = "h_lathe"
	desc = "In goes dead bodies, out comes meat for the cloner. Simple as that. Try not to think about it too much."
	density = 1
	anchored = 1
	var/meat = 0
	var/occupied
	var/meat_type
	var/victim_name = "corpse"


/obj/structure/Ensyme_Reclaimer/attackby(obj/item/weapon/grab/G as obj, mob/user as mob)
	if(!istype(G, /obj/item/weapon/grab) || !ismob(G.affecting))
		return
	if(occupied)
		user << "<span class = 'danger'>The Ensyme Reclaimer already has something in it, finish collecting its meat first!</span>"
	else
		if(Insert(G.affecting))
			visible_message("<span class = 'danger'>[user] has forced [G.affecting] into the grinder, killing them brutaly!</span>")
			var/mob/M = G.affecting
			M.forceMove(src)
			qdel(G)
			qdel(M)
		else
			user << "<span class='danger'>They are too big for the grinder, try something smaller!</span>"

/obj/structure/Ensyme_Reclaimer/proc/Insert(var/mob/living/victim, mob/user as mob)
	if(!istype(victim))
		return

	if(istype(victim, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = victim
		if(H.size_multiplier <= RESIZE_NORMAL) //This still needs new sprites and the such.
			meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
		else
			return 0	//Big ass people cannot be spiked.
	else
		if(istype(victim, /mob/living/carbon/alien))
			meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/syntiflesh
		else
			return 0

	victim_name = victim.name
	occupied = 1
	meat = 10
	return 1


/obj/structure/Ensyme_Reclaimer/attack_hand(mob/user as mob)
	if(..() || !occupied)
		return
	meat--
	new meat_type(get_turf(src))
	if(meat > 1)
		user << "You remove some meat from \the [victim_name]."
	else if(meat == 1)
		user << "You remove the last piece of meat from \the [victim_name]!"
		icon_state = "h_lathe"
		occupied = 0

//this should work .(sorry if it dont Sansaur)
