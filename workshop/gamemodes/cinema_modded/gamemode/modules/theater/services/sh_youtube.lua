local SERVICE = {}

SERVICE.Name = "YouTube"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_COMPLETE
SERVICE.ExtentedVideoInfo = true

local hostname = ""

function SERVICE:Match( url )
	return url.host and url.host:match("youtu.?be[.com]?")
end

if (CLIENT) then
	local THEATER_JS = [[
		var checkerInterval = setInterval(function() {
			var player = document.getElementsByTagName("VIDEO")[0]
			if (!!player) {
				if (player.paused) {player.play();}
				if (player.paused === false && player.readyState === 4) {
					clearInterval(checkerInterval);

					window.cinema_controller = player;
					player.style = "width:100%; height: 100%;";
					player.style.zIndex = 999

					exTheater.controllerReady();
				}
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( ("https://%s/embed/%s"):format(hostname, Video:Data()) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end

	function SERVICE:GetMetadata( data, callback )

		local url = ("https://%s/api/player/?id=%s"):format(hostname, data)

		http.Fetch(url, function(body, length, headers, code)
			local response = util.JSONToTable(body)

			if not response then callback({ err = "Failed to parse/receive Metadata from YouTube" }) return end
			if response.error or response.status ~= "OK" then callback({ err = ("%s (%s, %s)"):format(response.error.message, response.error.code, response.status) }) return end

			local details = response.data.details

			callback({
				title = details.title,
				isLive = details.isLive,
				length = util.ConvertTimeToSeconds(details.length),
			})

		end, function(error)
			callback({ err = ("YouTube Error: %s, Try diffrent Instance"):format(error) })
		end, {})
	end
end

function SERVICE:GetURLInfo( url )

	local info = {}

	-- http://www.youtube.com/watch?v=(videoId)
	if url.query and url.query.v and #url.query.v > 0 then
		info.Data = url.query.v

	-- http://www.youtube.com/v/(videoId)
	elseif url.path and url.path:match("^/v/([%a%d-_]+)") then
		info.Data = url.path:match("^/v/([%a%d-_]+)")

		-- http://www.youtube.com/shorts/(videoId)
	elseif url.path and url.path:match("^/shorts/([%a%d-_]+)") then
		info.Data = url.path:match("^/shorts/([%a%d-_]+)")

	-- http://youtu.be/(videoId)
	elseif url.host:match("youtu.be") and
		url.path and url.path:match("^/([%a%d-_]+)$") and
		( not info.query or #info.query == 0 ) then -- short url
		info.Data = url.path:match("^/([%a%d-_]+)$")
	end

	-- Start time, ?t=123s
	if (url.query and url.query.t and url.query.t ~= "") then
		local time = util.ISO_8601ToSeconds(url.query.t)
		if time and time ~= 0 then
			info.StartTime = time
		end
	end

	return info.Data and info or false
end

function SERVICE:GetVideoInfo( data, onSuccess, onFailure )

	theater.FetchVideoMedata( data:GetOwner(), data, function(metadata)

		if metadata.err then
			return onFailure(metadata.err)
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = ("https://img.youtube.com/vi/(%s)/hqdefault.jpg"):format(data)

		if (metadata.isLive and metadata.length == 0) then
			info.type = "youtubelive"
			info.duration = 0
		else
			info.duration = metadata.length
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "youtube", SERVICE )

-- Implementation is found in 'youtube' service.
-- GetVideoInfo switches to 'youtubelive'

theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	Dependency = DEPENDENCY_COMPLETE,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )

do
	if not CLIENT then return end

	local instances, description = {}, "LightTube is a privacy-respecting lightweight, ad-free YouTube frontend. It allows you to watch videos without ads and restrictions, it reduces the data sent to Google when watching videos."
	local cInstance = CreateClientConVar("cinema_youtube_instance", "lighttube.kuylar.dev", true, false)

	hostname = cInstance:GetString()

	cvars.AddChangeCallback(cInstance:GetName(), function(convar, oldValue, newValue)
		hostname = newValue
	end, cInstance:GetName())

	do -- LightTube Switcher menu
		local function switcher()
			local Frame = vgui.Create( "DFrame" )
			Frame:SetTitle("(YouTube) LightTube Instance Switcher")
			Frame:SetSize( 500, 300 )
			Frame:Center()
			Frame:MakePopup()

			do -- Top Box
				local SettingsBox = vgui.Create( "DPanel", Frame )
				SettingsBox:Dock(TOP)
				SettingsBox:SetHeight(50)
				SettingsBox:SetBackgroundColor(Color(255,255,255, 0))

				local Description = vgui.Create( "RichText", SettingsBox )
				Description:Dock(FILL)
				Description:SetText( description )
			end

			do -- Instance list
				local InstanceList = vgui.Create( "DListView", Frame )
				InstanceList:Dock( FILL )
				InstanceList:SetMultiSelect( false )
				InstanceList:SetSortable( true )

				InstanceList:AddColumn( "Hostname" )
				InstanceList:AddColumn( "Country" )
				InstanceList:AddColumn( "Proxies" )

				function InstanceList:DoDoubleClick(lineID, line)
					cInstance:SetString( line:GetColumnText(1) )

					if theater.ActivePanel() then
						theater.RefreshPanel(true)
					end
				end

				local lines = {}
				for host,tbl in pairs(instances) do
					lines[host] = InstanceList:AddLine(host, tbl["country"], tbl["proxyEnabled"])
				end

				InstanceList:SortByColumn( 2, true ) -- Sort by Users count

				if IsValid(lines[hostname]) then
					InstanceList:SelectItem( lines[hostname] )
				end

			end

		end
		concommand.Add("cinema_youtube_switch", switcher, nil, "Switch the LightTube instance")
	end

	do -- Instance fetcher & updater
		local function fetchInstances()
			local function onSuccess(body, length, headers, code)
				if not body or code ~= 200 then return end

				local response = util.JSONToTable(body)
				if not response then return end

				instances = {} -- Clear instance list

				for _,tbl in pairs(response) do

					if tbl.scheme ~= "https" then continue end
					if not tbl.apiEnabled or not tbl.isCloudflare then continue end

					instances[tbl.host] = {
						country = util.getCountryName(tbl.country),
						proxyEnabled = tbl.proxyEnabled,
					}

				end
			end

			local function onFailure(message)
				print("[LightTube API]: " .. message)
			end

			http.Fetch("https://lighttube.kuylar.dev/instances", onSuccess, onFailure, {})
		end
		fetchInstances()

		if timer.Exists("LightTube.Update") then timer.Remove("LightTube.Update") end
		timer.Create("LightTube.Update", 300, 0, fetchInstances)
	end
end