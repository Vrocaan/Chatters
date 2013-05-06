
Player
	proc
		CheckRoll(dice)
			if(!dice) return
			var/D, N, M, S, O, P
			D = findtext(dice, "d")
			if(!D || (D == length(dice))) return
			N = round(max(min(text2num(copytext(dice, 1, D)),10),1))
			M = findtext(dice, "+")
			P = "+"
			if(!M)
				M = findtext(dice, "-")
				P = ""
			S = round(max(min(text2num(copytext(dice, D+1, M)),100),1))
			if(M)
				O = max(min(text2num(copytext(dice, M)),99),-99)
				dice = "[N]d[S][P][O]"
			else dice = "[N]d[S]"
			return list(dice, N, S, O)

		Roll(dice as text|null)
			var/mob/chatter/M = usr
			if(!M || !M.Chan) return
			if(M.afk) M.ReturnAFK()
			var/N, S, O, list/outcomes, results = "", outcome = 0, offset, addon
			if(dice)
				var/list/L = src.CheckRoll(dice)
				if(L) dice = L[1]; N = L[2]; S = L[3]; O = L[4]
			if(!dice)
				N = round(max(min(input("How many dice shall you roll? (1 to 10)","Dice",1) as num | null,10),0))
				if(!N) return
				S = round(max(min(input("How many sides shall each die have? (1 to 100)","Sides",6) as num | null,100),0))
				if(!S) return
				O = round(max(min(input("What is the offset to add to the total roll? (-99 to 99)","Offset",0) as num | null,99),-99))
				if(O == null) return
				if(O)
					if(O > 0) dice = "[N]d[S]+[O]"
					else dice = "[N]d[S][O]"
				else
					dice = "[N]d[S]"
					O = null
			outcomes = new()
			for(var/i = 1 to N)
				var/n = roll("1d[S]")
				outcomes += n
				if(outcomes.len == N) results += "\[b][n]\[/b]"
				else results += "\[b][n]\[/b] + \..."
			for(var/o in outcomes) outcome += o
			if(O)
				outcome += O
				if(O>0) offset = "+"
				addon =  "[offset] \[b][O]\[/b]"
			M.Chan.chanbot.GameSay("\[b][M.name]\[/b] rolled \[b]\[#00c][dice]\[/b]\[/#] for \[b]\[#c00][outcome]\[/#]\[/b]. ([results])[addon]", "roll_play")
			call(M,"Games")("roll_play")

		RollSay(msg as text|null)
			set hidden = 1
			var/mob/chatter/M = usr
			if(M.afk) M.ReturnAFK()
			M.Chan.Say(M, msg, , "roll_play.output")

		RollMe(msg as text|null)
			set hidden = 1
			var/mob/chatter/M = usr
			if(M.afk) M.ReturnAFK()
			M.Chan.Me(M, msg, , "roll_play.output")

		RollMy(msg as text|null)
			set hidden = 1
			var/mob/chatter/M = usr
			if(M.afk) M.ReturnAFK()
			M.Chan.My(M, msg, , "roll_play.output")

		RollLook()
			set hidden = 1
			var/mob/chatter/M = usr
			if(!M.Chan) return
			if(!M.Chan.room_desc)
				src << output("Looking around, you see....\n\tAn average looking room.", "roll_play.output")
				return
			if(M.Chan.room_desc_size >= 500)
				switch(alert("This room description exceeds the recomended room description size. (500 characters) Would you like to view it anyways?","Room Description Size Alert! [M.Chan.room_desc_size] characters!","Yes","No"))
					if("No") return
			src << output("Looking around, you see....\n\t[M.Chan.room_desc]", "roll_play.output")