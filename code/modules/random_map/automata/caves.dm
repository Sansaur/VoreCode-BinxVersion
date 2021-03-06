/datum/random_map/automata/cave_system
	iterations = 5
	descriptor = "moon caves"
	var/list/ore_turfs = list()

/datum/random_map/automata/cave_system/get_appropriate_path(var/value)
	return

/datum/random_map/automata/cave_system/get_map_char(var/value)
	switch(value)
		if(DOOR_CHAR)
			return "x"
		if(EMPTY_CHAR)
			return "X"
	return ..(value)

/datum/random_map/automata/cave_system/revive_cell(var/target_cell, var/list/use_next_map, var/final_iter)
	..()
	if(final_iter)
		ore_turfs |= target_cell

/datum/random_map/automata/cave_system/kill_cell(var/target_cell, var/list/use_next_map, var/final_iter)
	..()
	if(final_iter)
		ore_turfs -= target_cell

// Create ore turfs.
// Trying to rebalance the goddamn Ore spawn because the map is too big for so few mineral spots and this
// is based off how big the map is -Sansaur
/datum/random_map/automata/cave_system/cleanup()
	var/ore_count = round(map.len/8) //This was /20 before -Sansaur
	while((ore_count>0) && (ore_turfs.len>0))
		if(!priority_process) sleep(-1)
		var/check_cell = pick(ore_turfs)
		ore_turfs -= check_cell
		if(prob(75))
			map[check_cell] = DOOR_CHAR  // Mineral block
		else
			map[check_cell] = EMPTY_CHAR // Rare mineral block.
		ore_count--
	return 1

/datum/random_map/automata/cave_system/apply_to_turf(var/x,var/y)
	var/current_cell = get_map_cell(x,y)
	if(!current_cell)
		return 0
	var/turf/simulated/mineral/T = locate((origin_x-1)+x,(origin_y-1)+y,origin_z)
	if(istype(T) && !T.ignore_mapgen)
		if(map[current_cell] == FLOOR_CHAR)
			T.make_floor()
		else
			T.make_wall()
			if(map[current_cell] == DOOR_CHAR)
				T.make_ore()
			else if(map[current_cell] == EMPTY_CHAR)
				T.make_ore(1)
		get_additional_spawns(map[current_cell],T,get_spawn_dir(x, y))
	return T