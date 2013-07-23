mob
	chatter
		verb
			browseSystem()
				set hidden = 1

				setDisplay("system")

			setDefaultSystem()
				set hidden = 1

				setShowTitle(1)
				setShowWelcome(1)
				setShowMotD(1)
				setShowQotD(1)
				setHighlightCode(1)
				set24HourTime()
				setTimeOffset()
				setAutoAFK()
				setAwayMsg()

			setShowTitle(t as text|null)
				set hidden = 1

				if(t)
					winset(src, "system.show_title", "is-checked=true")
					show_title = TRUE

				else
					if(winget(src, "system.show_title", "is-checked")=="true") show_title = TRUE
					else show_title = FALSE

			setShowWelcome(t as text|null)
				set hidden = 1

				if(t)
					winset(src, "system.show_welcome", "is-checked=true")
					show_welcome = TRUE

				else
					if(winget(src, "system.show_welcome", "is-checked")=="true") show_welcome = TRUE
					else show_welcome = FALSE

			setShowMotD(t as text|null)
				set hidden = 1

				if(t)
					winset(src, "system.show_motd", "is-checked=true")
					show_motd = TRUE

				else
					if(winget(src, "system.show_motd", "is-checked")=="true") show_motd = TRUE
					else show_motd = FALSE

			setShowQotD(t as text|null)
				set hidden = 1

				if(t)
					winset(src, "system.show_qotd", "is-checked=true")
					show_qotd = TRUE

				else
					if(winget(src, "system.show_qotd", "is-checked")=="true") show_qotd = TRUE
					else show_qotd = FALSE

			setHighlightCode(t as text|null)
				set hidden = 1

				if(t)
					winset(src, "system.show_highlight", "is-checked=true")
					show_highlight = TRUE

				else
					if(winget(src, "system.show_highlight", "is-checked")=="true") show_highlight = TRUE
					else show_highlight = FALSE

			set24HourTime(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "24"

				if(t == "24")
					time_24hr = TRUE
					winset(src, "system.12Hour", "is-checked=false")
					winset(src, "system.24Hour", "is-checked=true")
				else
					time_24hr = FALSE
					winset(src, "system.12Hour", "is-checked=true")
					winset(src, "system.24Hour", "is-checked=false")

				src << output(text_manager.stripHTML(parseTime()), "system.time")

			setTimeOffset(t as num|null)
				set hidden = 1

				if(isnull(t) || !isnum(t)) t = 0

				time_offset = t
				src << output(text_manager.stripHTML(parseTime()), "system.time")
				winset(src, "system.offset", "text=[time_offset]")

			setAutoAFK(t as num|null)
				set hidden = 1

				if(isnull(t)) t = 15

				auto_away = t
				winset(src, "system.auto_afk", "text='[t]'")

			setAwayMsg(t as text|null)
				set hidden = 1
				if(isnull(t)) t = "I have gone auto-AFK."

				auto_reason = t
				winset(src, "system.away_msg", "text='[t]'")
