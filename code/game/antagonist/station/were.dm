var/datum/antagonist/were/weres

/datum/antagonist/were
	id = MODE_WERE
	role_type = BE_WERE
	role_text = "Were"
	role_text_plural = "Were"
	bantype = "were"
	landmark_id = "were"
	welcome_text = "Have fun as a were!" //We have to change this later
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_VOTABLE
	antaghud_indicator = "were" //mob.dmi

	hard_cap = 1
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 1


/datum/antagonist/wizard/New()
	..()
	weres = src

/datum/antagonist/were/create_objectives(var/datum/mind/were)

	if(!..())
		return

	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = were
	kill_objective.find_target()
	were.objectives |= kill_objective
	return

/datum/antagonist/were/update_antag_mob(var/datum/mind/were)
	..()

/datum/antagonist/were/equip(var/mob/living/carbon/human/wizard_mob)

	if(!..())
		return 0

/datum/antagonist/were/check_victory()
	..()

