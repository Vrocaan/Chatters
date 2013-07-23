mob
	temp
		Login()
			..()

			var/timer = world.timeofday
			while(!client)
				if(world.timeofday > timer + 180) del(src)
				sleep(-1)

			chat_manager.usher(src)