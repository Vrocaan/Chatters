mob
	chatter
		icon = 'resources/icons/who.dmi'
		icon_state = "active"

		var
			name_color = "#000000"
			text_color = "#000000"
			interface_color = "#555555"
			fade_name
			show_colors = TRUE

			time_24hr  = TRUE
			time_offset = 0
			auto_away = 15
			auto_reason = "I have gone auto-AFK."

			default_output_style = "body { background-color: #ffffff; }"

			show_smileys = TRUE
			show_title = TRUE
			show_welcome = FALSE
			show_motd = TRUE
			show_qotd = TRUE
			show_highlight = TRUE
			flip_panes = FALSE

			tmp/afk = FALSE
			tmp/telnet = FALSE
			tmp/away_at = 0
			tmp/away_reason
			tmp/list/msgs
			tmp/Channel/Chan
			tmp/ColorView/colorview
			tmp/messageHandler/msg_hand

			list
				ignoring
				fade_colors = list("#000000")

				time_format = list("<font size=1>\[","hh",":","mm",":","ss","]</font>")
				date_format = list("MMM"," ","MM",", `","YY")
				long_date_format = list("Day",", ","Month"," ","DD",", ","YYYY")
				say_format = list("$ts", " <b>","$name",":</b> ","$msg")
				rpsay_format = list("$ts", " ","$name"," ","$rp",":   ","$msg")
				me_format = list("$ts", " ", "$name", " ", "$msg")

				tmp/msg_handlers

		New()
			..()
			msg_hand = new(src)

		Login()
			..()

			if(!chat_manager.isTelnet(key))
				channel_manager.join(src, home_channel)

				winshow(src, "showcontent", 0)
				winshow(src, "settings", 0)

				refreshAllSettings()

			// Telnet users login differently
			else
				//Set options suited for telnet.
				telnet = TRUE
				show_colors = FALSE
				show_smileys = FALSE
				show_highlight = FALSE
				channel_manager.join(src, home_channel)

		Stat()
			..()

			if(telnet) return
			if(auto_away && (auto_away < client.inactivity/600) && !afk) afk(auto_reason)
			if(msg_handlers && length(msg_handlers))
				for(var/msg_handler in msg_handlers)
					var/open = winget(src, "cim_[msg_handler]", "is-visible")
					if(open == "false")
						src << output(null, "cim_[msg_handler].output")
						winset(src, "cim_[msg_handler].input", "text=")
						var/messenger/M = msg_handlers[msg_handler]

						msg_handlers -= msg_handler
						del(M)

		Click()
			var/messenger/im = new(usr, key)
			im.display(usr)

		Logout()
			if(Chan) channel_manager.quit(src, Chan)

			..()

			sleep(50)

			if(!client) del(src)
