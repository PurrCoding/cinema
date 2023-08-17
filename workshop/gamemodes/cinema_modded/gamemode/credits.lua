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