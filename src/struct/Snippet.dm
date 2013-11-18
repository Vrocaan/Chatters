Snippet
	var
		content_type = 1
		id
		owner = ""
		target = ""

		data = ""
		timestamp

	New()
		..()
		// Generates a unique ID for the code snippet based off the global array showcodes.
		if(!server_manager.home.snippets)
			server_manager.home.snippets = list()

		id = length(server_manager.home.snippets) + 1
		server_manager.home.snippets += src

	proc
		getContent(mob/chatter/C)
			if(!C) return

			var/content

			if(content_type == 1) // showcode
				if(C.show_highlight && data)
					content = {"
						<html>
						<head>
						<link rel="stylesheet" href="http://yandex.st/highlightjs/6.2/styles/default.min.css">
						<script src="http://yandex.st/highlightjs/6.2/highlight.min.js"></script>
						<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
						<script>hljs.initHighlightingOnLoad();</script>
						<title>[owner]'s Highlighted Showcode</title>
						</head>
						<body><pre><code>[html_encode(data)]</code></pre></body>
						</html>"}

				else if(data)
					content = {"
						<html>
						<head>
						<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
						<title>[owner]'s Showcode</title>
						</head>
						<body><pre><code>[data]</code></pre></body>
						</html> "}

			else if(content_type == 2) // showtext
				content = {"
					<html>
					<head>
					<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
					<title>[owner]'s Showtext</title>
					</head>
					<body>[data]</body>
					</html>"}

			return content

		send()
			if(!target)
				// This is shown to the channel.
				var/ct

				switch(content_type)
					if(1) ct = "code"
					if(2) ct = "text"

				server_manager.bot.rawSay("Click <a href='byond://?src=\ref[chatter_manager]&target=\ref[chatter_manager.getByKey(owner)]&action=showcontent&index=[id]'>here</a> to view [owner]'s [ct].")