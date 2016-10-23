/obj/item/clothing/gloves/lazarus_glove
	name = "Lazarus Glove"
	desc = "A glove loaded with Tricordrazine and electricity, a shame it doesn't help against brain damage"
	icon_state = "lazarus_glove"
	item_state = "lazarus_glove"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
		)
	gender = PLURAL //Carn: for grammarically correct text-parsing
	w_class = 2.0
	icon = 'icons/obj/clothing/gloves.dmi'
	siemens_coefficient = 2.5
	var/acting = 0 //Is this acting as a defibrilator?
	var/loading = 0 //Is it ready to act again?
	var/obj/item/weapon/shock_hand/shockhand = new /obj/item/weapon/shock_hand

	var/chargecost = 200
	cell = new /obj/item/weapon/cell
	body_parts_covered = HANDS
	slot_flags = SLOT_GLOVES
	attack_verb = list("challenged")
	species_restricted = null
	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/gloves.dmi',
		)
/obj/item/clothing/gloves/lazarus_glove/New()
	//new /obj/item/weapon/shock_hand(src)
	shockhand.masterglove = src

/obj/item/clothing/gloves/lazarus_glove/verb/Prepare_Shock()
	set category = "Object"
	set name = "Prepare a Shock"
	set desc = "Shocking!"
	PrepareShock()
	spawn(200)
	EndShock()

/obj/item/clothing/gloves/lazarus_glove/proc/PrepareShock()
	if(cell)
		if(cell.charge >= chargecost)
			cell.use(chargecost)
			if(!usr.put_in_hands(shockhand))
				acting = 0
				usr << "<span class='warning'>You can't prepare a reviving shock with your hands full!</span>"
				update_icon()
				return
			else
				usr.visible_message("<span class='warning'>[usr] overloads the [src] and now has a shocking glove!</span>",
					"<span class='userdanger'>Power flows through your glove!</span>")
				acting = 1
				update_overlays()
				shockhand.loc = usr
				return
		else
			usr << "<span class='warning'>There's not enough load in the power cell!</span>"

/obj/item/clothing/gloves/lazarus_glove/proc/EndShock()
	if(acting == 1)
		acting = 0
		update_overlays()
		return
	else
		return

/obj/item/clothing/gloves/lazarus_glove/proc/update_overlays()
	overlays.Cut()
	if(acting)
		overlays.Add("[initial(icon_state)]-acting")

/obj/item/weapon/shock_hand
	name = "Shocking touch"
	desc = "ZAPPER!!"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "electric_hand"
	item_state = "electric_hand"
	var/timecreated
	var/obj/item/clothing/gloves/lazarus_glove/masterglove

/obj/item/weapon/shock_hand/New()
	timecreated = world.time

/obj/item/weapon/shock_hand/process()
	if(world.time >= timecreated + 20)
		//src.loc << "The glove ran out of it's overload"
		src.loc = masterglove
		return

/obj/item/weapon/shock_hand/dropped(mob/user)
	user.put_in_hands(src) //It returns to the hand after dropping.
	return

/obj/item/weapon/shock_hand/attack(mob/M as mob, mob/user as mob)
	if(user.a_intent == "harm")
		if(!M)
			return
		if(M && M.stat == DEAD)
			user << "<span class='warning'>[M] is dead.</span>"
			return
		var/mob/living/carbon/human/HU = M
		if(HU)
			HU.emote("scream")
			if(!HU.stat)
				HU.visible_message("<span class='warning'>[M] thrashes wildly, clutching at their chest!</span>",
					"<span class='userdanger'>You feel a horrible agony in your chest!</span>")
				HU.apply_damage(20, BURN, "chest")
				add_logs(user, M, "overloaded the heart of", src)
				HU.Weaken(3)

	if(user.a_intent == "disarm")
		if(!M)
			return
		if(M && M.stat == DEAD)
			user << "<span class='warning'>[M] is dead.</span>"
			return
		var/mob/living/carbon/human/HU = M
		if(HU)
			if(!HU.stat)
				HU.custom_emote(1, "Jitters and falls to the ground as they get shocked!")
				HU.Weaken(3)

	if(user.a_intent == "help")
		if(!M)
			return
		if(M && M.stat != DEAD)
			user << "<span class='warning'>[M] is alive and you are not trying to hurt them.</span>"
			return
		if(M && M.stat == DEAD)
			var/mob/living/carbon/human/HU = M
			if(HU)
				var/tplus = world.time - HU.timeofdeath
				var/tlimit = 6000 * 10
				HU.rejuvenate()
				HU.restore_blood()
				HU.fixblood()
				HU.update_canmove()
				HU.adjustOxyLoss(15, 0)
				HU.adjustToxLoss(15, 0)
				HU.adjustFireLoss(15, 0)
				HU.adjustBruteLoss(15, 0)
				HU.setBrainLoss( max(0, min(50, ((tlimit - tplus) / tlimit * 100))))
				HU.Weaken(20)

	src.loc = masterglove
	return