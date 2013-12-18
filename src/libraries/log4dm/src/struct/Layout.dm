Layout
	proc
		formatLog(log, level, name)
		startLog()
		endLog()

	PlaintextLayout
		startLog() return "Logging started at [time2text(world.timeofday)]"

		formatLog(log, level, name = "root")
			if(log)
				log = "\[[name]\] {[num2text(world.time, 32)] ([time2text(world.timeofday, "hh:mm:ss")])} {[level2text(level)] ([level])}: [log]\n"

				return log

		endLog() return "Logging ended at [time2text(world.timeofday)]"

	HTMLLayout
		startLog() return {"<table cellspacing=1 style='padding: 0px; margin: 0px; width: 100%; border: 0px'><tr style='text-align: center; background-color: #C8C8C8; color: #000000; font-size: 13px;'><td><b>Time</b></td><td><b>Level</b></td><td><b>Logger</b></td><td width="75%"><b>Message</b></td></tr>"}

		formatLog(log, level, name = "root")
			var
				time_format = "[time2text(world.timeofday, "hh:mm:ss")]"
				level_format = "[level2text(level)]"
				name_format = "[name]"
				log_format = "[log]"

			if(level == LOG_FATAL)
				time_format = "<b><font color=#FF0000>[time_format]</font><b>"
				level_format = "<b><font color=#FF0000>[level_format]</font><b>"
				name_format = "<b><font color=#FF0000>[name_format]</font><b>"
				log_format = "<b><font color=#FF0000>[log_format]</font><b>"

			if(level == LOG_ERROR)
				time_format = "<font color=#FF0000>[time_format]</font>"
				level_format = "<font color=#FF0000>[level_format]</font>"
				name_format = "<font color=#FF0000>[name_format]</font>"
				log_format = "<font color=#FF0000>[log_format]</font>"

			if(level == LOG_WARN)
				time_format = "<b>[time_format]</b>"
				level_format = "<b>[level_format]</b>"
				name_format = "<b>[name_format]</b>"
				log_format = "<b>[log_format]</b>"

			log = "<tr style='text-align: center; background-color: #E9E9E9; font-size: 13px;'><td>[time_format]</td><td>[level_format]</td><td>[name_format]</td><td style='text-align: left;'>[log_format]</td></tr>"

			return log

		endLog()