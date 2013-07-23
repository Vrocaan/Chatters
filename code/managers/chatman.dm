ChatterManager
	Topic(href, href_list)
		..()

		switch(href_list["action"])
			if("showcode")
				var
					mob/chatter/trg = locate(href_list["target"])
					showcode_snippet/snippet = home_channel.showcodes[text2num(href_list["index"])]

				if(snippet.target && snippet.target != usr.ckey && usr.ckey != trg.ckey)
					// This is a private message they are not allowed to view.
					return

				else usr << browse(snippet.returnHTML(trg, 1), "window=showcode_[snippet.id];display=1;size=800x500;border=1;can_close=1;can_resize=1;titlebar=1")

			if("showtext")
				var
					mob/chatter/trg = locate(href_list["target"])
					showcode_snippet/snippet = home_channel.showcodes[text2num(href_list["index"])]

				if (snippet.target && snippet.target != usr.ckey && usr.ckey != trg.ckey)
					// This is a private message they are not allowed to view.
					return

				else usr << browse(snippet.returnHTML(trg), "window=showtext_[snippet.id];display=1;size=800x500;border=1;can_close=1;can_resize=1;titlebar=1")

	proc
		usher(mob/temp/T)
			if(!T || !T.client)
				del(T)

				return

			var/mob/chatter/C = new()

			// Do not call client.Import on telnet users
			if(!isTelnet(T.key))
				var/client_file
				client_file = T.client.Import()

				if(client_file == "-1.sav")
					client_file = null

				if(client_file)
					if(!load(C, client_file))
						// Out of date or bad savefile, discard.
						T.client.Export()
						C.name = T.name
						C.key = T.key

				else
					C.name = T.name
					C.key = T.key

			else
				C.name = T.name
				C.key = T.key

			del(T)

		// Tests if the key is a telnet key eg: Telnet @127.000.000.001
		isTelnet(key)
			if(findtext(key, "Telnet @") == 1)
				return 1

		getByKey(chatter, local)
			if(!length(chatter))
				return

			if(home_channel && home_channel.chatters)
				var/first_char = text2ascii(copytext(chatter, 1, 2))
				// If search starts with a number, search IPs.
				if(first_char > 47 && first_char < 58)
					// Exact IP first
					for(var/mob/chatter/C in home_channel.chatters)
						if(C.client.address == chatter)
							return C

					// Partial IP second
					for(var/mob/chatter/C in home_channel.chatters)
						if(text_manager.match(C.client.address, chatter))
							return C

				else
					// Exact key search.
					for(var/mob/chatter/C in home_channel.chatters)
						if(ckey(C.name) == ckey(chatter))
							return C

					// Partial case-sensitive key search
					for(var/mob/chatter/C in home_channel.chatters)
						if(text_manager.match(C.key, chatter))
							return C

					// Partial non-case-sensitive key search
					for(var/mob/chatter/C in home_channel.chatters)
						if(text_manager.match(C.ckey, chatter))
							return C

		parseFormat(format, variables[], required[])
			if(!format || !variables || !length(variables))
				return FALSE

			if(required)
				for(var/r in required)
					if(!findtext(format, r))
						return FALSE

			var
				list/L = new()
				temp = format

			for(var/v in variables)
				var/pos = findtext(format, v)
				if(pos) variables[v] = pos
				else variables -= v

			for(var/v = length(variables), v >= 1, v--)
				for(var/i = 1, i < v, i ++)
					if(variables[variables[i]] > variables[variables[i + 1]])
						variables.Swap( i, i + 1)

					else if(variables[variables[i]] == variables[variables[i + 1]])
						variables -= variables[i + 1]

					if(v > length(variables))
						break

			for(var/v in variables)
				var/pos = findtext(temp, v)
				if(pos > 1)
					L += copytext(temp, 1, pos)

				L += v
				temp = copytext(temp, pos + length(v))

			if(length(temp))
				L += temp

			return L

		load(mob/chatter/C, client_file)
			var/savefile/F = new(client_file)
			C.Read(F)

			return TRUE

		save(mob/chatter/C)
			var/savefile/S = new()
			C.Write(S)

			sleep(10)

			C.client.Export(S)