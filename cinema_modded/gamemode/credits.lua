--[[
  Cinema (Fixed Edition)
  Copyright (C) 2013–2026 Cinema authors

  Originally created by PixelTail Games
  (https://github.com/pixeltailgames/cinema)

  This file is part of Cinema (Fixed Edition)
  (https://github.com/PurrCoding/cinema)

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  See LICENSE.md in the project root for the full license text.
]]

local credit = [[
	 ██████ ██ ███    ██ ███████ ███    ███  █████
	██      ██ ████   ██ ██      ████  ████ ██   ██
	██      ██ ██ ██  ██ █████   ██ ████ ██ ███████
	██      ██ ██  ██ ██ ██      ██  ██  ██ ██   ██
	 ██████ ██ ██   ████ ███████ ██      ██ ██   ██


		███████ ██ ██   ██ ███████ ██████      ███████ ██████  ██ ████████ ██  ██████  ███    ██
		██      ██  ██ ██  ██      ██   ██     ██      ██   ██ ██    ██    ██ ██    ██ ████   ██
		█████   ██   ███   █████   ██   ██     █████   ██   ██ ██    ██    ██ ██    ██ ██ ██  ██
		██      ██  ██ ██  ██      ██   ██     ██      ██   ██ ██    ██    ██ ██    ██ ██  ██ ██
		██      ██ ██   ██ ███████ ██████      ███████ ██████  ██    ██    ██  ██████  ██   ████


	This AddOn is released under the GNU GPLv3 license (https://choosealicense.com/licenses/gpl-3.0/) and
	its Source Code available on GitHub (https://github.com/PurrCoding/cinema/)

	Credits:
	- Originally developed by PixelTail Games
	- PurrCoding (https://github.com/PurrCoding/) for maintaining the addon
	- YouTube Workaround by Veitikka (https://github.com/veitikka)
	- Ket'Ta-Lani (STEAM_0:0:63267722) & Artar0s (STEAM_0:0:85997797) for Sandbox in Cinema
	- Akiko Kumagara (https://www.youtube.com/@AkikoKumagara) &
		Solstice Game Studios (https://github.com/solsticegamestudios) for the x86-64 / GModCEFCodecFix Guide
	{@TransInsert} 
]]

hook.Add("PostGamemodeLoaded", "Cinema.Credits", function()

	if CLIENT and (translations and translations.LanguageSupported
		and translations:LanguageSupported()) then

		credit = credit:Replace("{@TransInsert}",
			("- %s translation by %s"):format(
				translations:Format("Name"),
				translations:Format("Author")
			))
	else
		credit = credit:Replace("{@TransInsert}", "")
	end

	print(credit)
end)