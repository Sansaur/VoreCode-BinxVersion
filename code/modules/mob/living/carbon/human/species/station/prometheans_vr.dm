/datum/species/shapeshifter/promethean
	max_age = 80
	valid_transform_species = list("Human", "Unathi", "Tajara", "Skrell", "Diona", "Teshari", "Monkey","Sergal","Akula","Nevrean","Highlander Zorren","Flatland Zorren", "Vulpkanin", "Neaera", "Stok", "Farwa")
	heal_rate = 0.4 //They heal .4, along with the natural .2 heal per tick when below the  organ natural heal damage threshhold so now they regen like normal slimes as long as the goy biomass (not hungry).
	siemens_coefficient = 1 //Prevents them from being immune to tasers and stun weapons.
	death_message = "goes limp, their body becoming softer..."

/datum/species/shapeshifter/promethean/handle_death(var/mob/living/carbon/human/H)
	return //This nullifies them gibbing.
