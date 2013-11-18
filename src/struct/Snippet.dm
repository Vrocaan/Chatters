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

			if(content_type == SNIPPET_CODE) // showcode
				if(C.show_highlight && data)
					content = {"
						<html>
						<head>
						<link rel="stylesheet" href="http://yandex.st/highlightjs/6.2/styles/default.min.css">
						<script src="http://yandex.st/highlightjs/6.2/highlight.min.js"></script>
						<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
						<script>hljs.initHighlightingOnLoad();</script>
						<title>[owner]'s Highlighted Code</title>
						</head>
						<body><pre><code>[html_encode(data)]</code></pre></body>
						</html>"}

				else if(data)
					content = {"
						<html>
						<head>
						<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
						<title>[owner]'s Code</title>
						</head>
						<body><pre><code>[data]</code></pre></body>
						</html> "}

			else if(content_type == SNIPPET_TEXT) // showtext
				content = {"
					<html>
					<head>
					<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
					<title>[owner]'s Text</title>
					</head>
					<body>[html_encode(data)]</body>
					</html>"}

			else if(content_type == SNIPPET_HTML)
				content = {"[data]"}

			return content

		send()
			if(!target)
				// This is shown to the channel.
				var/ct

				switch(content_type)
					if(SNIPPET_CODE) ct = "code"
					if(SNIPPET_TEXT) ct = "text"
					if(SNIPPET_HTML) ct = "HTML"

				server_manager.bot.rawSay("Click <a href='byond://?src=\ref[chatter_manager]&target=\ref[chatter_manager.getByKey(owner)]&action=showcontent&index=[id]'>here</a> to view [owner]'s [ct].")