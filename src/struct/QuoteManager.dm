QuoteManager
	New()
		loadQuotes()

		quote_changer_event = new(server_manager.global_scheduler)
		server_manager.global_scheduler.schedule(quote_changer_event, 864000)

		server_manager.logger.info("Created QuoteManager.")

	Del()
		server_manager.global_scheduler.cancel(quote_changer_event)
		server_manager.logger.info("Deleted QuoteManager.")

	var
		list/quotes = null
		tmp/Event/Timer/QuoteChanger/quote_changer_event

	proc
		loadQuotes()
			if(fexists("./data/quotes.txt"))
				quotes = list()

				var
					f = textutil.replaceText(file2text("./data/quotes.txt"), "\n", "")
					list/split = textutil.text2list(f, ";;")

				for(var/q in split)
					if(q)
						var/list/qsplit = textutil.text2list(q, "##")

						if(length(qsplit) >= 2)
							var/Quote/quote = new
							quote.author = qsplit[1]
							quote.text = qsplit[2]
							if(length(qsplit) >= 3) quote.link = qsplit[3]

							quotes += quote

				server_manager.logger.info("Loaded [length(quotes)] quote(s) from quotes.txt.")

			else
				server_manager.logger.warn("quotes.txt does not exist to be loaded.")

		getQOTD()
			if(!quotes || !length(quotes)) return

			var
				qloc = server_manager.qotd_current
				Quote/q
				qlen = length(quotes)

			if(qloc && (qloc <= qlen)) q = quotes[qloc]
			else
				qloc = round(qloc % qlen)
				if(qloc < 1) qloc = 1
				if(qloc > qlen) qloc = qlen
				q = quotes[qloc]

			if(q)
				var/qtxt = "\"[q.text]\"<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - [q.author]"
				if(q.link) qtxt += " ([q.link])"

				return qtxt

Quote
	var
		text = ""
		link = ""
		author = ""


Event/Timer/QuoteChanger
	New(var/EventScheduler/scheduler)
		..(scheduler, 864000)

	fire()
		..()

		server_manager.qotd_current ++
		server_manager.logger.trace("Quote scheduler increased current quote number to [server_manager.qotd_current].")