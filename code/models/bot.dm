Bot
	var
		name = "@chanBot"
		name_color = "#f00"
		text_color = "#000"
		fade_name = ""
		Channel/Chan

	New(Channel/chan)
		..()

		if(chan)
			Chan = chan

	proc
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

				C << output(C.parseMsg(src, msg, C.say_format), "[ckey(Chan.name)].chat.default_output")

			else
				for(var/mob/chatter/c in Chan.chatters)
					var/message = msg
					if(c.show_smileys) message = text_manager.parseSmileys(raw_msg)

					message = text_manager.parseLinks(message)
					message = text_manager.parseTags(message, c.show_colors, c.show_highlight, 0)

					c << output(c.parseMsg(src, message, c.say_format), "[ckey(Chan.name)].chat.default_output")

		rawSay(msg, mob/chatter/receiver, echoed)
			if(receiver)
				// message for a specific chatter.
				receiver << output(receiver.parseMsg(src, msg, receiver.say_format),"[ckey(Chan.name)].chat.default_output")

			else
				// message for all chatters.
				for(var/mob/chatter/a in Chan.chatters)
					a << output(a.parseMsg(src, msg, a.say_format),"[ckey(Chan.name)].chat.default_output")

		me(msg, echoed)
			msg = copytext(msg, 1, 1024)
			msg = text_manager.sanitize(msg)

			var
				raw_msg = msg
				smsg = text_manager.parseSmileys(msg)

			smsg = text_manager.parseLinks(smsg)
			msg = text_manager.parseLinks(msg)

			if(echoed) name = ">[copytext(name, 2)]"

			for(var/mob/chatter/c in Chan.chatters)
				var/message
				if(c.show_smileys) message = text_manager.parseSmileys(raw_msg)

				message = text_manager.parseLinks(message)
				message = text_manager.parseTags(message, c.show_colors, c.show_highlight, 0)

				c << output(c.parseMsg(src, message, c.me_format, 1), "[ckey(Chan.name)].chat.default_output")

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

			for(var/mob/chatter/c in Chan.chatters)
				var/message
				if(c.show_smileys) message = text_manager.parseSmileys(raw_msg)

				message = text_manager.parseLinks(message)
				message = text_manager.parseTags(message, c.show_colors, c.show_highlight, 0)

				c << output(c.parseMsg(src, message, c.me_format, 2), "[ckey(Chan.name)].chat.default_output")

			if(echoed) name = "@[copytext(name, 2)]"

		setName(new_name, save = 1)
			if(!new_name) new_name = "chanBot"
			name = "@" + new_name
			if(save) bot_manager.saveBot(src)

		setNameColor(new_color, save = 1)
			if(!new_color) new_color = "#f00"
			name_color = new_color
			if(save) bot_manager.saveBot(src)

		setTextColor(new_color, save = 1)
			if(!new_color) new_color = "#000"
			text_color = new_color
			if(save) bot_manager.saveBot(src)

		setDesc(new_value, save = 1)
			Chan.desc = new_value
			if(save) channel_manager.saveHome()

		setTopic(new_value, save)
			Chan.topic = new_value

			for(var/mob/chatter/C in Chan.chatters)
				if(chat_manager.isTelnet(C.key)) continue
				if(!C.client) continue
				winset(C, "[ckey(Chan.name)].topic_label", "text='[new_value]';")

			if(save) channel_manager.saveHome()