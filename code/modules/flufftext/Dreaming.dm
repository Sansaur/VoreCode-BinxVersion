
var/list/dreams = list(
	"a sloppy ID card","a bottle rolling on the ground","a familiar neko","a micro","getting hit by a toolbox","a security predator","bondage gear",
	"a growl behind your back","deep space","a doctor and his open maw","the engine exploding","a traitorous prey shouting SHITCURITY as he gets devoured","a belly","darkness",
	"light","a flirty scientist","a monkey with a knife","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","the... OMG WHAT IS THAT","a ruined station","a planet","a maw closing","cherries","the medical bay","wet sounds","blinking lights",
	"a blue light","bees","a massive butt","mercenaries","a bloody chaplain","healing","power","magic",
	"a lost wallet with a string attached to it","space bellies","a crash","some taurs","pride","FALLING AARGH","water","getting cooked","ice","furred breasts","flying","the eggs","lots of money",
	"the head of personnel being a cuck","getting fired","a chief engineer touching the supermatter","a research director exploding","a violet dragon",
	"the detective losing at strip poker","the warden looking straight at you","a member of the internal affairs crying","a station engineer getting spaced","the janitor having to clean some pred's work","an atmospheric technician farting",
	"the quartermaster getting all flirty","a cargo technician getting torn to pieces","the botanist growing carnivorous plants","a shaft miner humping the air","the psychologist pointing a gun to his head","the chemist reducing your size","the geneticist laughing like a maniac",
	"the virologist making everyone cough","the roboticist building a VOREmech","the chef cooking somebody","the bartender serving drinks naked","a dragoness offering herself as dinner","the librarian spreading their legs","a macro mouse","an ert member",
	"a beach","the holodeck","a smokey room","a voice","a sergal","a mouse","a... a...","the bar","the rain","a skrell",
	"an unathi's throat","a tajaran's butt","the ai core","the mining outpost full of deathclaws","the research station","a beaker of strange liquid",
	)

mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			src << "\blue <i>... [pick(dreams)] ...</i>"
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		dreaming = 0
		return 1

mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()

mob/living/carbon/var/dreaming = 0
