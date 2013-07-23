mob
	chatter
		verb
			selectColor(scope as text|null)
				set hidden = 1

				if(!scope) return
				colorDisplay(scope)

			sayAlias(msg as text|null)
				set name = ">"
				set hidden = 1

				say(msg)
