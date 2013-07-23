showcode_snippet
	var
		id
		owner = ""
		target = ""

		code
		timestamp

	New()
		..()
		// Generates a unique ID for the code snippet based off the global array showcodes.
		if(!home_channel.showcodes)
			home_channel.showcodes = list()

		id = length(home_channel.showcodes) + 1
		home_channel.showcodes += src

	proc
		returnHTML(mob/chatter/C, code = 0)
			if(!C) return

			var/html

			if(C.show_highlight && code)
				html = {"
					<html>
					<head>
					<link rel="stylesheet" href="http://yandex.st/highlightjs/6.2/styles/default.min.css">
					<script src="http://yandex.st/highlightjs/6.2/highlight.min.js"></script>
					<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
					<script>hljs.initHighlightingOnLoad();</script>
					<title>[owner]'s Highlighted Showcode</title>
					</head>
					<body><pre><code>[html_encode(src.code)]</code></pre></body>
					</html>"}

			else if(code)
				html = {"
					<html>
					<head>
					<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
					<title>[owner]'s Showcode</title>
					</head>
					<body><pre><code>[src.code]</code></pre></body>
					</html> "}

			else
				html = {"
					<html>
					<head>
					<style>body {margin: 4px; overflow: auto; background-color: #ffffff}</style>
					<title>[owner]'s Showtext</title>
					</head>
					<body>[src.code]</body>
					</html>"}

			return html

		send(code = 0)
			if(!target)
				// This is shown to the channel.
				home_channel.chanbot.rawSay("Click <a href='byond://?src=\ref[chat_manager]&target=\ref[chat_manager.getByKey(owner)]&action=show[code ? "code" : "text"]&index=[id]'>here</a> to view [owner]'s [code ? "code" : "text"] snippet.")

			else
				var/messenger/im = new(chat_manager.getByKey(owner), target)
				im.display(chat_manager.getByKey(owner))

				routeMsg(chat_manager.getByKey(owner), chat_manager.getByKey(target), "[owner] has sent a private [code ? "code" : "text"] snippet.  <a href='byond://?src=\ref[chat_manager]&target=\ref[chat_manager.getByKey(owner)]&action=show[code ? "code" : "text"]&index=[id]'>Show [code ? "Code" : "Text"]</a>", 1)
