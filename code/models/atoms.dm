obj
	default

	selection
		var/obj/source

		New(Source)
			source = Source
			name = source.name
			..()

		Click(location, ctl)
			source.Click(usr, location, ctl)

		DblClick(location, ctl)
			source.DblClick(usr, location, ctl)