Bot
	var
		name = "@ChanBot"
		name_color = "#f00"
		text_color = "#000"
		fade_name = ""

		tmp
			Event/Timer/BotFacts/bot_facts
			fact_current = 1
			list/facts

	New()
		loadFacts()
		bot_facts = new(server_manager.global_scheduler)
		server_manager.global_scheduler.schedule(bot_facts, 108000)
		server_manager.logger.info("Created Bot.")

	Del()
		server_manager.global_scheduler.cancel(bot_facts)
		server_manager.logger.info("Deleted Bot.")

	proc
		sayFact()
			var/flen = length(facts)

			if(flen)
				var/n = round(fact_current % flen)
				if(n < 1) n = 1
				if(n > flen) n = flen

				var/fact = facts[n]
				say(fact)

		loadFacts()
			if(fexists("./data/facts.txt"))
				facts = list()

				var/f = textutil.replaceText(file2text("./data/facts.txt"), "\n", "")
				facts = textutil.text2list(f, ";;")

				server_manager.logger.info("Loaded [length(facts)] fact(s) from facts.txt.")

			else
				server_manager.logger.warn("facts.txt does not exist to be loaded.")

		say(msg, mob/chatter/C, echoed)
			msg = copytext(msg, 1, 1024)
			msg = text_manager.sanitize(msg)

			var
				raw_msg = msg
				smsg = text_manager.parseSmileys(msg)

			smsg = text_manager.parseLinks(smsg)
			msg = text_manager.parseLinks(msg)

			if(C)
				var/message = msg
				if(C.show_smileys) message = text_manager.parseSmileys(raw_msg)

				message = text_manager.parseLinks(message)
				message = text_manager.parseTags(message, C.show_colors, C.show_highlight, 0)

				C << output(C.parseMsg(src, msg, C.say_format), "default_output")

			else
				for(var/mob/chatter/c in server_manager.home.chatters)
					var/message = msg
					if(c.show_smileys) message = text_manager.parseSmileys(raw_msg)

					message = text_manager.parseLinks(message)
					message = text_manager.parseTags(message, c.show_colors, c.show_highlight, 0)

					c << output(c.parseMsg(src, message, c.say_format), "default_output")

		rawSay(msg, mob/chatter/receiver, echoed)
			if(receiver)
				// message for a specific chatter.
				receiver << output(receiver.parseMsg(src, msg, receiver.say_format),"default_output")

			else
				// message for all chatters.
				for(var/mob/chatter/a in server_manager.home.chatters)
					a << output(a.parseMsg(src, msg, a.say_format),"default_output")

		me(msg, echoed)
			msg = copytext(msg, 1, 1024)
			msg = text_manager.sanitize(msg)

			var
				raw_msg = msg
				smsg = text_manager.parseSmileys(msg)

			smsg = text_manager.parseLinks(smsg)
			msg = text_manager.parseLinks(msg)

			if(echoed) name = ">[copytext(name, 2)]"

			for(var/mob/chatter/c in server_manager.home.chatters)
				var/message
				if(c.show_smileys) message = text_manager.parseSmileys(raw_msg)

				message = text_manager.parseLinks(message)
				message = text_manager.parseTags(message, c.show_colors, c.show_highlight, 0)

				c << output(c.parseMsg(src, message, c.me_format, 1), "default_output")

			if(echoed) name = "@[copytext(name, 2)]"

		my(msg, echoed)
			msg = copytext(msg, 1, 1024)
			msg = text_manager.sanitize(msg)

			var
				raw_msg = msg
				smsg = text_manager.parseSmileys(msg)

			smsg = text_manager.parseLinks(smsg)
			msg = text_manager.parseLinks(msg)

			if(echoed) name = ">[copytext(name, 2)]"

			for(var/mob/chatter/c in server_manager.home.chatters)
				var/message
				if(c.show_smileys) message = text_manager.parseSmileys(raw_msg)

				message = text_manager.parseLinks(message)
				message = text_manager.parseTags(message, c.show_colors, c.show_highlight, 0)

				c << output(c.parseMsg(src, message, c.me_format, 2), "default_output")

			if(echoed) name = "@[copytext(name, 2)]"

		setName(new_name, save = 1)
			if(!new_name) new_name = "chanBot"
			name = "@" + html_encode(new_name)

		setNameColor(new_color, save = 1)
			if(!new_color) new_color = "#f00"
			name_color = copytext(html_encode(new_color), 1, 8)

		setTextColor(new_color, save = 1)
			if(!new_color) new_color = "#000"
			text_color = copytext(html_encode(new_color), 1, 8)

		setTopic(new_value, save)
			server_manager.home.topic = new_value

			for(var/mob/chatter/C in server_manager.home.chatters)
				if(chatter_manager.isTelnet(C.key)) continue
				if(!C.client) continue
				winset(C, "channel.topic_label", "text=\"[text_manager.escapeQuotes(new_value)]\";")

Event/Timer/BotFacts
	New(var/EventScheduler/scheduler)
		..(scheduler, 108000)

	fire()
		..()

		server_manager.bot.fact_current ++
		server_manager.bot.sayFact()
		server_manager.logger.trace("Bot fact scheduler increased current fact number to [server_manager.bot.fact_current].")