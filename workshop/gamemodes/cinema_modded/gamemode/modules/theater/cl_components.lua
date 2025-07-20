local WarningSet, HasCodecFix
local InstructionSite = "https://www.solsticegamestudios.com/fixmedia/"

local HTML_Code = [[
<html><body>
<script>
	var support = "SUPPORT:";
	video = document.createElement('video');
	support += video.canPlayType('video/mp4; codecs="avc1.42E01E"') === "probably"?1:0,
	console.log(support);
</script>
</body></html>
]]

local function CheckServiceDependency()
	local panel = vgui.Create("HTML")
	panel:SetSize(100,100)
	panel:SetAlpha(0)
	panel:SetMouseInputEnabled(false)

	function panel:ConsoleMessage(msg)
		if msg:StartWith("SUPPORT:") then
			HasCodecFix = msg[9] == "1"
			self:Remove()
		end
	end

	panel:SetHTML(HTML_Code)
end
hook.Add("InitPostEntity", "CheckServiceDependency", CheckServiceDependency)
hook.Add("OnReloaded", "CheckServiceDependency", CheckServiceDependency)

hook.Add("PreVideoLoad", "ShowDependencyWarning", function(Video)

	local service = theater.Services[Video:Type()]
	if not service or not service.NeedsCodecFix or
		service.NeedsCodecFix == false then return end

	local reason = nil
	local panel = theater.ActivePanel()
	if IsValid(panel) then

		if service.NeedsCodecFix == true and not HasCodecFix then
			reason = "GModPatchTool / GModCEFCodecFix"
		end

		if reason then
			if WarningSet then return true end

			panel:OpenURL( GetGlobal2String( "cinema_url", "" ) ) -- Fallback to idle screen

			warning.Set(
				translations:Format("Dependency_Missing_Line1"),
				reason,
				translations:Format("Dependency_Missing_Line2")
			)

			control.Add( KEY_F4, function( enabled, held )
				if enabled and not held then
					gui.OpenURL(InstructionSite)
				end
			end )

			surface.PlaySound("hl1/fvox/warning.wav")
			WarningSet = true
			return true
		end
	end

end)

hook.Add("OnTheaterLeft", "HideDependencyWarning", function()
	warning.Clear()
	control.Remove(KEY_F4)

	WarningSet = false
end)