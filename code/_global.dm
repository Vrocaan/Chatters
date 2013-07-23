
/* Chatters Channel Server

* Copyright (c) 2008, Andrew "Xooxer" Arnold
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*     * Redistributions of source code must retain the above copyright
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright
*       notice, this list of conditions and the following disclaimer in the
*       documentation and/or other materials provided with the distribution.
*     * Neither the name of the Chatters Network nor the
*       names of its contributors may be used to endorse or promote products
*       derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY Andrew "Xooxer" Arnold ``AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Andrew "Xooxer" Arnold BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

// Preprocessor Definitions

// Ignore Scopes
#define NO_IGNORE     0
#define IM_IGNORE     1
#define CHAT_IGNORE   2
#define FADE_IGNORE   4
#define COLOR_IGNORE  8
#define SMILEY_IGNORE 16
#define IMAGES_IGNORE 32
#define FILES_IGNORE  64
#define FULL_IGNORE   128

// Global variables and procedures
var/global
	host_ckey		// Current Host of the Channel Server
	Channel/home_channel			// Main server channel

	textutil/textutil = new
	// Global Managers

	BotManager/bot_manager = new
	ChannelManager/channel_manager = new
	ChatterManager/chat_manager = new
	TextManager/text_manager = new
	QuoteManager/quote_manager = new

proc
	delManagers()
		del(bot_manager)
		del(channel_manager)
		del(chat_manager)
		del(text_manager)
		del(quote_manager)

	loadCFG(cfg)
		if(!cfg || !fexists(cfg)) return

		var
			list/config = new()
			list/lines = new()
			head
			txt
			l
			line
			fchar
			cbracket
			phead
			sep
			comm
			param
			value

		txt = file2text(cfg)
		if(!txt || !length(txt)) return

		lines = textutil.text2list(txt, "\n")
		if(!lines || !length(lines)) return

		config += "main"

		for(l in lines)
			line = textutil.trimWhitespace(l)
			if(!line) continue

			fchar = copytext(line, 1, 2)

			switch(fchar)
				if(";") continue
				if("#") continue
				if("\[")
					cbracket = findtext(line, "]")
					if(!cbracket) continue

					if(head)
						phead = config[length(config)]
						config[phead] = head
						config += lowertext(copytext(line, 2, cbracket))
						head = null

						continue

					else if(length(config) == 1)
						config = new()
						config += lowertext(copytext(line, 2, cbracket))

						continue

					else
						phead = config[length(config)]
						config -= phead
						config += lowertext(copytext(line, 2, cbracket))

				else
					sep = findtext(line, "=")

					if(!sep) sep = findtext(line, ":")
					if(!sep) continue

					comm = findtext(line, ";")
					if(!comm) comm = findtext(line, "#")
					if(comm && (comm < sep)) continue
					if(sep == length(line)) continue

					param = lowertext(textutil.trimWhitespace(copytext(line, 1, sep)))
					value = textutil.trimWhitespace(copytext(line, sep + 1, comm))

					if(head) head += "&" + param
					else head = param

					head += "=" + value

		if(head)
			phead = config[length(config)]
			config[phead] = head

		return config