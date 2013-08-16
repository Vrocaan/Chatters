world
	name = "Chatters"
	hub = "Xooxer.Chatters"
	hub_password = "rbl9FQ0hzWtOEKtg"	// my eyes only 0_0
	cache_lifespan = 1
	mob = /mob/chatter
	visibility = 1		// Set to 0 in LoadServerCfg if we're not public, leave otherwise.

	Reboot()
		if(server_manager && server_manager.home)
			server_manager.bot.say("The server is now rebooting! Reconnect at byond://[world.address]:[world.port]")

		..()

	New()
		..()

		createManagers()

	Del()
		deleteManagers()

		..()