
world
	version = 0
	name = "Chatters"
	hub = "Xooxer.Chatters"
	hub_password = "rbl9FQ0hzWtOEKtg"	// my eyes only 0_0

	view = "13x11"

	cache_lifespan = 1

	mob = /mob/Temp		 // default temporary mob
	visibility = 1		// Set to 0 in LoadServerCfg if we're not public, leave otherwise.

	New()
		..()
		Console = new()	// spawn the Console <-- This starts everything else

	Del()
		del(Console) // last ditch effort to save before the world dies
		..()


	Topic(Text,Addr)
		..()
		Text+="&addr=[Addr]"
		Console.Topic(Text)

