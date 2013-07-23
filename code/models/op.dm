mob/chatter
	verb
		promote(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(ckey(home_channel.founder) != ckey)
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			if(!home_channel.operators) home_channel.operators = list()

			if(ckey(home_channel.founder) == ckey(target)) return
			if(ckey(target) in home_channel.operators) home_channel.chanbot.say("[target] is already an operator.", src)
			else
				home_channel.chanbot.say("[target] was promoted to operator by [name].")
				home_channel.operators += ckey(target)

			home_channel.updateWho()
			channel_manager.saveHome()

		demote(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(ckey(home_channel.founder) != ckey)
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			if(ckey(home_channel.founder) == ckey(target)) return
			if(!(ckey(target) in home_channel.operators)) home_channel.chanbot.say("[target] is not an operator.", src)
			else
				home_channel.chanbot.say("[target] was demoted by [name].")
				home_channel.operators -= ckey(target)

			home_channel.updateWho()
			channel_manager.saveHome()

		setTopic(ntopic as text)
			set hidden = 1

			if(!ntopic) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.setTopic(ntopic, 1)

		setDesc(ndesc as text)
			set hidden = 1

			if(!ndesc) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.setDesc(ndesc, 1)

		botsetTextColor(n as text)
			set hidden = 1

			if(!n) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.setTextColor(n, 1)

		botsetNameColor(n as text)
			set hidden = 1

			if(!n) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.setNameColor(n, 1)

		botSetName(n as text)
			set hidden = 1

			if(!n) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.setName(n, 1)

		botSay(n as text)
			set hidden = 1

			if(!n) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.say(n)

		botme(n as text)
			set hidden = 1

			if(!n) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.me(n)

		botmy(n as text)
			set hidden = 1

			if(!n) return
			if(!home_channel.chanbot) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			home_channel.chanbot.my(n)

		checkIP(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			var/mob/chatter/C
			if(ismob(target)) C = target
			else C = chat_manager.getByKey(target)

			if(!C)
				home_channel.chanbot.say("[target] is not currently in the channel.", src)
				return

			if(C.client.address) home_channel.chanbot.say("[C.name]'s IP: [C.client.address]", src)
			else home_channel.chanbot.say("[C.name]'s IP is unknown.", src)

		mute(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			if(!home_channel.mute) home_channel.mute = list()

			if(!(ckey(target) in home_channel.operators))
				if(!(ckey(target) in home_channel.mute))
					home_channel.chanbot.say("[target] has been muted by \[b][name]\[/b].")
					home_channel.mute += ckey(target)
					home_channel.updateWho()

				else home_channel.chanbot.say("[target] is already mute.", src)

			else home_channel.chanbot.say("You cannot mute an operator.", src)

			channel_manager.saveHome()

		unmute(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			if(!home_channel.mute) home_channel.mute = new
			if(!(ckey(target) in home_channel.operators))
				if(ckey(target) in home_channel.mute)
					home_channel.chanbot.say("[target] has been unmuted by \[b][name]\[/b].")
					home_channel.mute -= ckey(target)
					home_channel.updateWho()

				else home_channel.chanbot.say("[target] is not muted.", src)

			channel_manager.saveHome()

		kick(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			var/mob/chatter/C
			if(ismob(target)) C = target
			else C = chat_manager.getByKey(target)

			if(!C)
				home_channel.chanbot.say("[target] is not currently in the channel.", src)
				return

			if(ckey(target) in home_channel.operators)
				home_channel.chanbot.say("You cannot kick an operator.", src)
				return

			home_channel.chanbot.say("[C.name] has been kicked by \[b][name]\[/b].")

			C << output("You have been kicked from [home_channel.name] by [name].", "[ckey(home_channel.name)].chat.default_output")
			C << output("<font color=red>Connection closed.", "[ckey(home_channel.name)].chat.default_output")

			home_channel.chatters -= C
			home_channel.updateWho()

			C.Logout()

		ban(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			var/mob/chatter/C = chat_manager.getByKey(target)

			if(ckey(target) in home_channel.operators)
				home_channel.chanbot.say("You cannot ban an operator.", src)
				return

			if(!home_channel.banned) home_channel.banned = list()

			home_channel.chanbot.say("[target] has been banned by \[b][name]\[/b].")
			home_channel.banned += ckey(target)

			if(C)
				C << output("You have been banned from [home_channel.name] by [name]", "[ckey(home_channel.name)].chat.default_output")
				C << output("<font color=red>Connection closed.", "[ckey(home_channel.name)].chat.default_output")

				home_channel.chatters -= C
				home_channel.updateWho()

				C.Logout()

			channel_manager.saveHome()

		unban(target as text)
			set hidden = 1

			if(!target) return
			if(!Chan) return
			if(!(ckey in home_channel.operators))
				home_channel.chanbot.say("You do not have access to this command.", src)
				return

			if(ckey(target) in home_channel.banned)
				home_channel.chanbot.say("[target] has been unbanned by \[b][name]\[/b].")
				home_channel.banned -= ckey(target)

			channel_manager.saveHome()

		listBanned()
			if(length(home_channel.banned))
				for(var/o in home_channel.banned)
					home_channel.chanbot.say("[o]", src)

		listMuted()
			if(length(home_channel.mute))
				for(var/o in home_channel.mute)
					home_channel.chanbot.say("[o]", src)