local SERVICE = {
	Name = "Base",
	IsTimed = true,

	-- Defaut Variables
	IsCacheable = true, -- Return false to prevent from storing into cinema_history on server
	Dependency = DEPENDENCY_NONE, -- DEPENDENCY_NONE = Normal | DEPENDENCY_PARTIAL = x86-64 Beta | DEPENDENCY_COMPLETE = x86-64 Beta + CEF Codec Fix
	ExtentedVideoInfo = false, -- Passes the complete video data instead of just the Data ID in GetVideoInfo
	TheaterType = THEATER_NONE  -- THEATER_NONE = Normal | THEATER_PRIVATE = Private only
}

function SERVICE:GetName()
	return self.Name
end

function SERVICE:GetClass()
	return self.ClassName
end

function SERVICE:Match( url )
	return false
end

function SERVICE:GetURLInfo( url )
	return false
end

local HttpHeaders = {
	["Cache-Control"] = "no-cache",
	-- ["Connection"] = "keep-alive",
}

function SERVICE:Fetch( url, onReceive, onFailure, headers )

	if SERVER then
		HttpHeaders["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.7.8254.20 Safari/537.36"
	end

	local request = {
		url			= url,
		method		= "GET",
		headers     = table.Merge(table.Copy(HttpHeaders), (headers and table.Copy(headers)) or {}),

		success = function( code, body, headers )
			code = tonumber( code ) or 0

			if code == 200 or code == 0 then
				onReceive( body, body:len(), headers, code )
			else
				print( "FAILURE: " .. code )
				pcall( onFailure, code )
			end
		end,

		failed = function( err )
			if isfunction( onFailure ) then
				pcall( onFailure, err )
			end
		end
	}

	HTTP( request )

end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )
	onFailure( "GetVideoInfo: No implementation found for Video API." )
end

if CLIENT then
	local THEATER_INTERFACE = [[
		if (!window.theater) {
			class CinemaPlayer {

				get player() {
					return window.cinema_controller;
				}

				setVolume(volume) {
					if (!!this.player) {
						this.player.volume = volume / 100;
					}
				}

				seek(second) {
					if (!!this.player && !!this.player.currentTime) {
						this.player.currentTime = second;
					}
				}

				sync(time) {
					if (!!this.player && !!this.player.currentTime && !!time) {

						var current = this.player.currentTime;
						if ((current !== null) &&
							(Math.abs(time - current) > 3)) {
							this.player.currentTime = time;
						}
					}
				}

			};
			window.theater = new CinemaPlayer();
		}
	]]

	function SERVICE:SearchFunctions( browser )
		-- Use in Service
	end

	function SERVICE:CreateWebCrawler(callback)

		local panel = vgui.Create("DHTML")
		panel:SetSize(100,100)
		panel:SetAlpha(0)
		panel:SetMouseInputEnabled(false)

		local serviceName = self:GetName()
		function panel:ConsoleMessage(msg)

			if GetConVar("cinema_html_filter"):GetBool() then
				print(("[%s - Debug]: %s"):format(serviceName, msg))
			end

			if msg:StartWith("METADATA:") then
				local metadata = util.JSONToTable(string.sub(msg, 10))

				callback(metadata)
				panel:Remove()
			end

			if msg:StartWith("ERROR:") then
				local errmsg = string.sub(msg, 7)

				callback({ err = errmsg })
				panel:Remove()
			end
		end

		timer.Simple(10, function()
			if IsValid(panel) then
				panel:Remove()
			end
		end )

		return panel
	end

	function SERVICE:LoadExFunctions(panel)
		panel:QueueJavascript(THEATER_INTERFACE)

		panel:AddFunction( "exTheater", "controllerReady", function(data)

			panel:QueueJavascript(
				("if (window.theater) theater.setVolume(%s)"):format( theater.GetVolume() )
			)

		end )
	end

	function SERVICE:LoadVideo( Video, panel )
		panel.OnDocumentReady = function() end -- Clear any possible remainings of Service code
		panel:Stop() -- Stops all panel animations by clearing its animation list. This also clears all delayed animations.

		panel:RunJavascript("if(typeof checkerInterval !== \"undefined\") { clearInterval(checkerInterval); }") -- Stop any remaining Intervals

		if self.LoadProvider then
			self:LoadProvider(Video, panel)
		end

	end

end

theater.RegisterService( "base", SERVICE )