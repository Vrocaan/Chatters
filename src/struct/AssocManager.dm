AssocManager
	var
		list/entries = list()
		list/all_ips = list()
		list/all_cids = list()
		list/all_ckeys = list()

	New()
		loadDB()

	Del()
		saveDB()

	proc
		saveDB()
			var/savefile/f = new("./data/assoc_db.sav")
			Write(f)


		loadDB()
			if(fexists("./data/assoc_db.sav"))
				var/savefile/f = new("./data/assoc_db.sav")
				Read(f)

			if(!entries) entries = list()
			if(!all_ips) all_ips = list()
			if(!all_cids) all_cids = list()
			if(!all_ckeys) all_ckeys = list()

		purge(data)
			. = 0

			all_ips -= data
			all_ckeys -= ckey(data)
			all_cids -= data

			for(var/AssocEntry/entry in entries)
				if(data in entry.ips)
					entry.ips -= data
					. ++

				if(ckey(data) in entry.ckeys)
					entry.ckeys -= ckey(data)
					. ++

				if(data in entry.cids)
					entry.cids -= data
					. ++

				if(!length(entry.ips) && !length(entry.ckeys) && !length(entry.cids))
					entries -= entry

		combineEntries(list/sentries)
			if(!length(sentries)) return

			var/AssocEntry/entry = new

			for(var/AssocEntry/e in sentries)
				for(var/ip in e.ips)
					if(!(ip in all_ips)) all_ips += ip
					all_ips[ip] = entry
					if(!(ip in entry.ips)) entry.ips += ip

				for(var/cid in e.cids)
					if(!(cid in all_cids)) all_cids += cid
					all_cids[cid] = entry
					if(!(cid in entry.cids)) entry.cids += cid

				for(var/ckey in e.ckeys)
					if(!(ckey in all_ckeys)) all_ckeys += ckey
					all_ckeys[ckey] = entry
					if(!(ckey in entry.ckeys)) entry.ckeys += ckey

				entries -= e
				del(e)

			entries += entry

			return entry

		findByIP(ip)
			if(!ip) return

			var/list/sentries = list()
			for(var/AssocEntry/entry in entries)
				if(ip in entry.ips)
					sentries += entry

			if(length(sentries))
				if(length(sentries) > 1) return combineEntries(sentries)
				else return sentries[1]

		findByCkey(ckey)
			ckey = ckey(ckey)
			if(!ckey) return

			var/list/sentries = list()
			for(var/AssocEntry/entry in entries)
				if(ckey in entry.ckeys)
					sentries += entry

			if(length(sentries))
				if(length(sentries) > 1) return combineEntries(sentries)
				else return sentries[1]

		findByCID(cid)
			if(!cid) return

			var/list/sentries = list()
			for(var/AssocEntry/entry in entries)
				if(cid in entry.cids)
					sentries += entry

			if(length(sentries))
				if(length(sentries) > 1) return combineEntries(sentries)
				else return sentries[1]

		findByClient(client/c)
			if(!c || !istype(c, /client)) return

			addClient(c)

			var/list/sentries = list()

			if(c.address && c.address in all_ips) sentries += all_ips[c.address]
			if(c.computer_id && c.computer_id in all_cids) sentries += all_cids[c.computer_id]
			if(c.ckey in all_ckeys) sentries += all_ckeys[c.ckey]

			if(length(sentries))
				if(length(sentries) > 1) return combineEntries(sentries)
				else return sentries[1]

		addClient(client/c)
			if(!c || !istype(c, /client)) return

			if((c.ckey in all_ckeys) || (c.computer_id && (c.computer_id in all_cids)) || (c.address && (c.address in all_ips)))
				var/list/sentries = list()

				if(c.ckey in all_ckeys)
					var/AssocEntry/entry = all_ckeys[c.ckey]
					sentries += entry

				if(c.computer_id && (c.computer_id in all_cids))
					var/AssocEntry/entry = all_cids[c.computer_id]
					if(!(entry in sentries)) sentries += entry

				if(c.address && (c.address in all_ips))
					var/AssocEntry/entry = all_ips[c.address]
					if(!(entry in sentries)) sentries += entry

				for(var/AssocEntry/entry in sentries)
					if(!(c.ckey in entry.ckeys)) entry.ckeys += c.ckey
					if(c.computer_id && !(c.computer_id in entry.cids)) entry.cids += c.computer_id
					if(c.address && !(c.address in entry.ips)) entry.ips += c.address

				if(length(sentries) > 1) return combineEntries(sentries)
				else return sentries[1]

			else
				var/AssocEntry/entry = new

				if(c.address)
					entry.ips += c.address
					all_ips += c.address
					all_ips[c.address] = entry

				if(c.computer_id)
					entry.cids += c.computer_id
					all_cids += c.computer_id
					all_cids[c.computer_id] = entry

				entry.ckeys += c.ckey
				all_ckeys += c.ckey
				all_ckeys[c.ckey] = entry

				entries += entry

AssocEntry
	var
		list/ips = list()
		list/cids = list()
		list/ckeys = list()