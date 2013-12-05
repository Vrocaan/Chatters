ChatterManager
	New()
		server_manager.logger.info("Created ChatterManager.")

	Del()
		server_manager.logger.info("Deleted ChatterManager.")

	Topic(href, href_list)
		..()

		var/mob/chatter/trg
		if(href_list["target"]) trg = locate(href_list["target"])

		switch(href_list["action"])
			if("showcontent")
				var/Snippet/snippet = server_manager.home.snippets[text2num(href_list["index"])]

				if(snippet.target && snippet.target != usr.ckey && usr.ckey != trg.ckey)
					// This is a private message they are not allowed to view.
					return

				else usr << browse(snippet.getContent(trg, 1), "window=showcontent_[snippet.id];display=1;size=800x500;border=1;can_close=1;can_resize=1;titlebar=1")

			if("tracker_viewckey")
				if(trg && trg.ckey in server_manager.home.operators)
					var/ckey = href_list["ckey"]
					if(ckey)
						var/TrackerEntry/entry = tracker_manager.findByCkey(ckey)
						if(entry)
							trg.viewing_entry = entry
							trg.updateViewingEntry()

			if("logs_viewlog")
				if(trg && trg.ckey in server_manager.home.operators)
					var/log = href_list["log"]
					if(log && fexists("./data/logs/[log]"))
						trg.viewing_log = "./data/logs/[log]"
						trg.updateViewingLog()

	proc
		usher(mob/chatter/C)
			if(!C.client)
				del(src)
				return

			// Do not call client.Import on telnet users
			if(!chatter_manager.isTelnet(C.key))
				var/client_file
				client_file = C.client.Import()

				if(client_file == "-1.sav")
					client_file = null

				if(client_file)
					if(!load(C, client_file))
						// Out of date or bad savefile, discard.
						C.client.Export()

		// Tests if the key is a telnet key eg: Telnet @127.000.000.001
		isTelnet(key)
			if(findtext(key, "Telnet @") == 1)
				return 1

		getByKey(chatter)
			if(server_manager && server_manager.home)
				for(var/mob/M in server_manager.home.chatters)
					if(M.ckey == ckey(chatter)) return M

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