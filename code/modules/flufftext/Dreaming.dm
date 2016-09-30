
var/list/dreams = list(
	"a sloppy ID card","a bottle","a familiar neko","a micro","getting hit by a toolbox","a security predator","bondage gear",
	"voices from all around","deep space","a doctor and his open maw","the engine exploding","a traitorous prey","a belly","darkness",
	"light","a flirty scientist","a monkey with a knife","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","the... OMG WHAT IS THAT","a ruined station","a planet","a maw closing","cherries","the medical bay","wet sounds","blinking lights",
	"a blue light","bees","a massive butt","mercenaries","blood","healing","power","magic",
	"riches","space bellies","a crash","some taurs","pride","FALLING AARGH","water","flames","ice","furred breasts","flying","the eggs","lots of money",
	"the head of personnel being a cuck","getting fired","a chief engineer","a research director exploding","a violet dragon",
	"the detective losing at strip poker","the warden looking straight at you","a member of the internal affairs","a station engineer getting spaced","the janitor","atmospheric technician",
	"the quartermaster getting all flirty","a cargo technician dying against an alien","the botanist","a shaft miner humping the air","the psychologist","the chemist reducing your size","the geneticist",
	"the virologist making everyone cough","the roboticist building a VOREmech","the chef","the bartender serving drinks naked","a dragoness offering herself as dinner","the librarian","a macro mouse","an ert member",
	"a beach","the holodeck","a smokey room","a voice","the cold","a mouse","a... a...","the bar","the rain","a skrell",
	"an unathi's throat","a tajaran's butt","the ai core","the mining station full of deathclaws","the research station","a beaker of strange liquid",
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
