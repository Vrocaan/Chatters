mob/chatter
	verb
		toggleSettings()
			set hidden = 1

			if(winget(src, "settings", "is-visible") == "false")
				setDisplay("colors")
				winshow(src, "settings")

			else winshow(src, "settings", 0)

		saveAllSettings()
			set hidden = 1

			winset(src, "settings.saving", "is-visible=true")

			var
				NameColor = winget(src, "style_colors.name_color", "text")
				TextColor = winget(src, "style_colors.text_color", "text")
				InterfaceColor = winget(src, "style_colors.interface_color", "text")

			setNameColor(NameColor)
			setTextColor(TextColor)
			setInterfaceColor(InterfaceColor)

			Chan.updateWho()

			if(winget(src, "misc.show_smileys", "is-checked")=="true") setShowSmileys(1)
			else setShowSmileys()

			setShowTitle()
			setShowWelcome()
			setShowMotD()
			setShowQotD()
			setHighlightCode()

			var
				TimeOffset = winget(src, "system.offset", "text")
				AutoAFK = text2num(winget(src, "system.auto_afk", "text"))
				AwayMsg = winget(src, "system.away_msg", "text")

			setTimeOffset(text2num(TimeOffset))
			setAutoAFK(AutoAFK)
			setAwayMsg(AwayMsg)

			var
				ChatFormat = winget(src, "style_formats.chat_format", "text")
				EmoteFormat = winget(src, "style_formats.emote_format", "text")
				InlineEmoteFormat = winget(src, "style_formats.inline_emote_format", "text")
				TimeFormat = winget(src, "style_formats.time_format", "text")
				DateFormat = winget(src, "style_formats.date_format", "text")
				LongDateFormat = winget(src, "style_formats.long_date_format", "text")
				OutputStyle = winget(src, "style_formats.output_style", "text")

			setDateFormat(DateFormat)
			setTimeFormat(TimeFormat)
			setInlineEmoteFormat(InlineEmoteFormat)
			setEmoteFormat(EmoteFormat)
			setChatFormat(ChatFormat)
			setLongDateFormat(LongDateFormat)
			setOutputStyle(OutputStyle)

			chat_manager.save(src)

			winset(src, "settings.saving", "is-visible=false")

		refreshAllSettings()
			set hidden = 1

			winset(src, "settings.saving", "is-visible=false")

			if(flip_panes) winset(src, "misc.flip_panes", "is-checked=true")
			else winset(src, "misc.flip_panes", "is-checked=false")

			winset(src, "style_colors.name_color", "text='[name_color]'")
			winset(src, "style_colors.name_color_button", "background-color='[name_color]'")
			winset(src, "style_colors.text_color", "text='[text_color]'")
			winset(src, "style_colors.text_color_button", "background-color='[text_color]'")
			winset(src, "style_colors.interface_color", "text='[interface_color]'")
			winset(src, "style_colors.interface_button", "background-color='[interface_color]'")

			src << output(null, "style_colors.output")

			if(fade_name) src << output("[fade_name]", "style_colors.output")
			else src << output("<font color=[name_color]>[name]</font>", "style_colors.output")

			if(show_colors)
				winset(src, "style_colors.show_colors", "is-checked=true")
				winset(src, "style_colors.no_colors", "is-checked=false")

			else
				winset(src, "style_colors.show_colors", "is-checked=false")
				winset(src, "style_colors.no_colors", "is-checked=true")

			winset(src, "style_formats.chat_format", "text='[textutil.list2text(say_format, "")]'")
			winset(src, "style_formats.emote_format", "text='[textutil.list2text(me_format, "")]'")
			winset(src, "style_formats.inline_emote_format", "text='[textutil.list2text(rpsay_format, "")]'")
			winset(src, "style_formats.time_format", "text='[textutil.list2text(time_format, "")]'")
			winset(src, "style_formats.date_format", "text='[textutil.list2text(date_format, "")]'")
			winset(src, "style_formats.long_date_format", "text='[textutil.list2text(long_date_format, "")]'")
			winset(src, "style_formats.output_style", "text='[default_output_style]'")

			if(show_title) winset(src, "system.show_title", "is-checked=true")
			else winset(src, "system.show_title", "is-checked=false")

			if(show_welcome) winset(src, "system.show_welcome", "is-checked=true")
			else winset(src, "system.show_welcome", "is-checked=false")

			if(show_motd) winset(src, "system.show_motd", "is-checked=true")
			else winset(src, "system.show_motd", "is-checked=false")

			if(show_qotd) winset(src, "system.show_qotd", "is-checked=true")
			else winset(src, "system.show_qotd", "is-checked=false")

			if(show_highlight) winset(src, "system.show_highlight", "is-checked=true")
			else winset(src, "system.show_highlight", "is-checked=false")

			if(!time_24hr)
				winset(src, "system.24Hour", "is-checked=false")
				winset(src, "system.12Hour", "is-checked=true")

			winset(src, "system.offset", "text='[time_offset]'")

			var/time = text_manager.stripHTML(parseTime())
			src << output(time, "system.time")

			winset(src, "system.auto_afk", "text='[auto_away]'")
			winset(src, "system.away_msg", "text='[auto_reason]'")

		setDisplay(page as text)
			set hidden = 1
			refreshAllSettings()

			switch(page)
				if("colors") winset(src, "settings.settings_child", "left=style_colors")
				if("formats") winset(src, "settings.settings_child", "left=style_formats")
				if("misc") winset(src, "settings.settings_child", "left=misc")
				if("system") winset(src, "settings.settings_child", "left=system")
