BotManager
	Del()
		if(home_channel && home_channel.chanbot) saveBot(home_channel.chanbot)
		..()

	proc
		saveBot(Bot/chanBot)
			var/savefile/S = new("./data/saves/channels/[ckey(chanBot.Chan.name)].sav")

			S["bot.name"]		<< chanBot.name
			S["bot.name_color"]	<< chanBot.name_color
			S["bot.text_color"]	<< chanBot.text_color

		loadBot(Channel/Chan)
			var
				savefile/S = new("./data/saves/channels/[ckey(Chan.name)].sav")
				Bot/chanBot = new(Chan)

			S["bot.name"]		>> chanBot.name
			S["bot.name_color"]	>> chanBot.name_color
			S["bot.text_color"]	>> chanBot.text_color

			return chanBot
