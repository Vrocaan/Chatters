mob
	chatter
		verb
			browseStyle()
				set hidden = 1

				setDisplay("style")

			setDefaultFormatStyle()
				set hidden = 1

				setChatFormat()
				setEmoteFormat()
				setInlineEmoteFormat()
				setTimeFormat()
				setDateFormat()
				setLongDateFormat()
				setOutputStyle()

			setChatFormat(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "$ts <b>$name:</b> $msg"

				var
					list/variables = list("$ts","$name","$msg","says","said")
					list/required = list("$name","$msg")

				say_format = chat_manager.parseFormat(t, variables, required)
				winset(src, "style_formats.chat_format", "text='[t]'")

			setEmoteFormat(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "$ts $name $msg"

				var
					list/variables = list("$ts","$name","$msg")
					list/required = list("$name","$msg")

				me_format = chat_manager.parseFormat(t, variables, required)
				winset(src, "style_formats.emote_format", "text='[t]'")

			setInlineEmoteFormat(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "$ts $name $rp: $msg"

				var
					list/variables = list("$ts","$name","$rp","$msg","says","said")
					list/required = list("$name","$rp","$msg")

				rpsay_format = chat_manager.parseFormat(t, variables, required)
				winset(src, "style_formats.inline_emote_format", "text='[t]'")

			setTimeFormat(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "<font size=1>\[hh:mm:ss]</font>"

				var/list/variables = list("hh","mm","ss")
				time_format = chat_manager.parseFormat(t, variables)
				winset(src, "style_formats.time_format", "text='[t]'")

			setDateFormat(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "MMM MM, `YY"

				var/list/variables = list("YYYY","YY","Month","MMM","MM","Day","DDD","DD")
				date_format = chat_manager.parseFormat(t, variables)
				winset(src, "style_formats.date_format", "text='[t]'")

			setLongDateFormat(t as text|null)
				set hidden = 1

				if(isnull(t)) t = "Day, Month DD, YYYY"

				var/list/variables = list("YYYY","YY","Month","MMM","MM","Day","DDD","DD")
				long_date_format = chat_manager.parseFormat(t, variables)
				winset(src, "style_formats.long_date_format", "text='[t]'")

			setOutputStyle(t as text|null)
				set hidden = 1
				if(isnull(t)) t = "body { background-color: #ffffff; }"

				default_output_style = t
				winset(src, "[ckey(home_channel.name)].chat.default_output", "style='[t]';")
				winset(src, "style_formats.output_style", "text='[default_output_style]';")

			setDefaultColorStyle()
				set hidden = 1

				fade_colors.len = 1
				fade_colors[1] = "#000000"
				fade_name = null

				setNameColor("#000000")
				setTextColor("#000000")
				fadeName()
				fadeColors(1)
				fadeNameDone()
				setInterfaceColor()
				setShowColors()

				Chan.updateWho()

			fadeName()
				set hidden = 1

				winset(src, "style_colors.fade_help", "is-visible=true")
				winset(src, "style_colors.fadecolors", "is-visible=true")
				winset(src, "style_colors.colors", "is-visible=true;text=[length(fade_colors)]")
				winset(src, "style_colors.set_colors", "is-visible=true")
				winset(src, "style_colors.done", "is-visible=true")

				for(var/i = 1, i <= length(fade_colors), i ++)
					winset(src, "style_colors.color[i]", "is-visible=true;background-color=[fade_colors[i]]")

			fadeColors(n as num|null)
				set hidden = 1

				if(!isnum(n)) n = text2num(winget(src, "style_colors.colors", "text"))
				if(n > length(name)) n = length(name)

				fade_colors.len = n
				winset(src, "style_colors.colors", "is-visible=true;text=[n]")

				for(var/i = 0, (i + 1) <= n, i ++)
					if(!fade_colors[i + 1]) fade_colors[i + 1] = "#000000"
					winset(src, "style_colors.color[i+1]", "is-visible=true;background-color=[fade_colors[i + 1]]")

				for(var/i = 12, i > n, i --) winset(src, "style_colors.color[i]", "is-visible=false")

			fadeNameDone()
				set hidden = 1

				var/list/colors = new()
				for(var/c in fade_colors)
					var/red = text_manager.hex2dec(copytext(c, 2, 4))

					if(red < 100)
						if(red > 10) red = "0[red]"
						else red = "00[red]"

					else red = "[red]"

					var/grn = text_manager.hex2dec(copytext(c, 4, 6))

					if(grn < 100)
						if(grn > 10) grn = "0[grn]"
						else grn = "00[grn]"

					else grn = "[grn]"

					var/blu = text_manager.hex2dec(copytext(c, 6))
					if(blu < 100)
						if(blu > 10) blu = "0[blu]"
						else blu = "00[blu]"

					else blu = "[blu]"

					colors += red + grn + blu

				var/invalid = FALSE

				if(length(colors))
					var
						i = colors[1]
						same = 1

					for(var/c in colors)
						if(c != i)
							same = 0

							break

					if(same) invalid = TRUE

				if(!colors || !length(colors) || invalid || (fade_name == name)) fade_name = null
				else fade_name = text_manager.fadeText(name, colors)

				winset(src, "style_colors.fade_help", "is-visible=false")
				winset(src, "style_colors.fadecolors", "is-visible=false")
				winset(src, "style_colors.colors", "is-visible=false")
				winset(src, "style_colors.set_colors", "is-visible=false")
				winset(src, "style_colors.done", "is-visible=false")

				for(var/i = 1, i <= length(fade_colors), i ++)
					winset(src, "style_colors.color[i]", "is-visible=false")

				src << output(null, "style_colors.output")

				if(fade_name) src << output("[fade_name]", "style_colors.output")
				else src << output("<font color=[name_color]>[name]</font>", "style_colors.output")

			setNameColor(t as text|null)
				set hidden = 1

				if(!t) t = "#000000"
				if(copytext(t, 1, 2) != "#") t = "#" + t

				if(t && length(t) == 7)
					name_color = uppertext(t)

					winset(src, "style_colors.name_color_button", "background-color='[t]'")
					winset(src, "style_colors.name_color", "text='[t]'")

					src << output(null, "style_colors.output")

					if(fade_name) src << output("[fade_name]", "style_colors.output")
					else src << output("<font color=[name_color]>[name]</font>", "style_colors.output")

					Chan.updateWho()

			setTextColor(t as text|null)
				set hidden = 1

				if(!t) t = "#000000"
				if(copytext(t, 1, 2) != "#") t = "#" + t

				if(t && length(t) == 7)
					text_color = uppertext(t)

					winset(src, "style_colors.text_color_button", "background-color='[t]'")
					winset(src, "style_colors.text_color", "text='[t]'")

			setInterfaceColor(t as text|null)
				set hidden = 1

				if(!t) t = "#555555"
				if(copytext(t, 1, 2) != "#") t = "#" + t

				if(t && length(t) == 7)
					interface_color = uppertext(t)

					winset(src, "style_colors.interface_button", "background-color='[t]'")
					winset(src, "style_colors.interface_color", "text='[interface_color]'")

					if(Chan)
						winset(src, "[ckey(Chan.name)].interfacebar_1", "background-color='[interface_color]';")
						winset(src, "[ckey(Chan.name)].interfacebar_2", "background-color='[interface_color]';")
						winset(src, "cim.interfacebar_3", "background-color='[interface_color]';")
						winset(src, "cim.interfacebar_4", "background-color='[interface_color]';")
						winset(src, "settings.interfacebar_5", "background-color='[interface_color]';")
						winset(src, "showcontent.interfacebar_6", "background-color='[interface_color]';")
						winset(src, "[ckey(Chan.name)].who.interfacebar_7", "background-color='[interface_color]';")

						for(var/ck in msg_handlers)
							winset(src, "cim_[ckey(ck)].interfacebar_3", "background-color='[interface_color]';")
							winset(src, "cim_[ckey(ck)].interfacebar_4", "background-color='[interface_color]';")

			setShowColors(t as text|null)
				set hidden = 1
				if(isnull(t)) t = "true"

				if(t == "false") show_colors = FALSE
				else show_colors = TRUE