ChannelManager
	New()
		..()

		spawn()
			loadServerCfg()
			loadHome()

	Del()
		if(home_channel) saveHome()

		..()

	proc
		join(mob/chatter/C, Channel/Chan) Chan.join(C)
		quit(mob/chatter/C, Channel/Chan) Chan.quit(C)
		say(mob/chatter/C, msg) C.Chan.say(C, msg)
		saveHome(Channel/Chan)
			var/savefile/S = new("./data/saves/home_channel.sav")

			S["mute"]		<< home_channel.mute
			S["banned"]		<< home_channel.banned
			S["operators"]  << home_channel.operators

		loadHome(chan)
			if(fexists("./data/saves/home_channel.sav"))
				var
					savefile/S = new("./data/saves/home_channel.sav")
					list/temp = null

				S["mute"] >> temp
				if(length(temp)) home_channel.mute |= temp

				S["banned"]	>> temp
				if(length(temp)) home_channel.banned |= temp

				S["operators"] >> temp
				if(length(temp)) home_channel.operators |= temp

		loadServerCfg()
			var/list/config = loadCFG("./data/saves/server.cfg")
			if(!config || !length(config)) return

			var/list/main = params2list(config["main"])
			if(!main || !length(main)) return

			host_ckey = ckey(main["host"])

			var
				list/mute_list = params2list(config["mute"])
				list/ban_list = params2list(config["bans"])
				list/op_list = params2list(config["ops"])
				list/server = params2list(config["server"])

			if(server && length(server))
				var
					chan_name  = server["name"]
					founder    = server["founder"]
					chan_desc  = server["desc"]
					chan_topic = server["topic"]

					bot_name         = server["bot_name"]
					bot_name_color   = server["bot_name_color"]
					bot_text_color   = server["bot_text_color"]

				home_channel = new(list("founder" = founder, "name" = chan_name, "desc" = chan_desc, "topic" = chan_topic))

				home_channel.chanbot.setName(bot_name)
				home_channel.chanbot.setNameColor("#" + bot_name_color)
				home_channel.chanbot.setTextColor("#" + bot_text_color)

				if(mute_list && length(mute_list))
					home_channel.mute = new
					for(var/i in mute_list)
						home_channel.mute += ckey(i)

				if(ban_list && length(ban_list))
					home_channel.banned = new
					for(var/i in ban_list)
						home_channel.banned += ckey(i)

				if(op_list && length(op_list))
					home_channel.operators = list()
					for(var/name in op_list)
						var/op_key = ckey(op_list[name])
						home_channel.operators += op_key


