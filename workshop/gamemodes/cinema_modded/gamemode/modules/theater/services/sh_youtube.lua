local SERVICE = {}

SERVICE.Name = "YouTube"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_PARTIAL
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

					exTheater.controllerReady();
				}
			}
		}, 50);
	]]

	local embedUrlParser = {
		["youtube"] = function( Video )
			return ("https://" .. hostname .. "/embed/%s?autoplay=0&thin_mode=1&controls=0&quality=auto&volume=1&t=%s"):format(
					Video:Data(),
					math.Round(CurTime() - Video:StartTime()
				)
			)
		end,
		["youtubelive"] = function( Video )
			return ("https://" .. hostname .. "/embed/%s?autoplay=0&thin_mode=1&controls=0&quality=auto&volume=1"):format(
				Video:Data()
			)
		end
	}

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL( embedUrlParser[Video:Type()](Video) )
		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
			pnl:QueueJavascript(THEATER_JS)
		end

	end

	function SERVICE:GetMetadata( data, callback )

		local url = ("https://%s/api/v1/videos/%s"):format(hostname, data)

		http.Fetch(url, function(body, length, headers, code)
			if not body or code ~= 200 then
				callback({ err = ("Not expected response received from API (Code: %d, Try diffrent Instance)"):format(code) })
				return
			end

			local response = util.JSONToTable(body)
			if not response then
				callback({ err = "Failed to parse MetaData from YouTube" })
				return
			end

			callback({
				title = response.title,
				premium = response.premium,
				lengthSeconds = response.lengthSeconds,
				isListed = response.isListed,
				liveNow = response.liveNow,
				isUpcoming = response.isUpcoming,
				isFamilyFriendly = response.isFamilyFriendly,
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

		if not metadata.isListed then
			return onFailure( "Service_EmbedDisabled" )
		end

		if metadata.premium then
			return onFailure( "Service_PurchasableContent" )
		end

		if metadata.prisUpcomingemium then
			return onFailure( "Service_StreamOffline" )
		end

		local info = {}
		info.title = metadata.title
		info.thumbnail = ("https://img.youtube.com/vi/(%s)/hqdefault.jpg"):format(data)

		if (metadata.liveNow and metadata.lengthSeconds == 0) then
			info.type = "youtubelive"
			info.duration = 0
		else
			if not metadata.isFamilyFriendly then
				info.type = "youtubensfw"
			end

			info.duration = metadata.lengthSeconds
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
	if not (CLIENT) then return end

	local instances, description = {}, "Invidious is a de-googled alternative to YouTube, it allows you to watch videos without ads and restrictions. It reduces the data sent to Google when watching videos."
	local cInstance = CreateClientConVar("cinema_invidious_instance", "invidious.fdn.fr", true, false)

	hostname = cInstance:GetString()

	cvars.AddChangeCallback(cInstance:GetName(), function(convar, oldValue, newValue)
		hostname = newValue
	end, cInstance:GetName())

	do -- Invidious Switcher menu
		local function createButton(parent, pos, size, text, callback )
			local button = vgui.Create( "DButton", parent )
			button:SetPos( pos[1], pos[2] )
			button:SetSize( size[1], size[2] )
			button:SetText(text)
			button:SizeToContents()
			button.DoClick = callback

			return button
		end

		local function switcher()
			local Frame = vgui.Create( "DFrame" )
			Frame:SetTitle("(YouTube) Invidious Instance Switcher")
			Frame:SetSize( 500, 500 )
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

				InstanceList:AddColumn( "Instance" )
				InstanceList:AddColumn( "Users" )
				InstanceList:AddColumn( "Location" )
				InstanceList:AddColumn( "Health" )

				function InstanceList:DoDoubleClick(lineID, line)
					cInstance:SetString( line:GetColumnText(1) )

					if theater.ActivePanel() then
						theater.RefreshPanel(true)
					end
				end

				local lines = {}
				for host,tbl in pairs(instances) do
					if tbl["api"] then
						lines[host] = InstanceList:AddLine(host, tbl["users"], tbl["region"], tbl["uptime"])
					end
				end

				InstanceList:SortByColumn( 2, true ) -- Sort by Users count

				if IsValid(lines[hostname]) then
					InstanceList:SelectItem( lines[hostname] )
				end

			end

		end
		concommand.Add("cinema_invidious_switch", switcher, nil, "Switch the Invidious instance")
	end

	do -- Instance fetcher & updater
		local function fetchInstances()
			local function onSuccess(body, length, headers, code)
				if not body or code ~= 200 then return end

				local response = util.JSONToTable(body)
				if not response then return end

				instances = {} -- Clear instance list

				for k,v in pairs(response) do
					local name, tbl = v[1], v[2]

					if tbl.type ~= "https" then
						continue
					end

					local api = tbl["api"]
					local region = tbl["region"]
					local users = (tbl["stats"] and tbl["stats"]["usage"] and tbl["stats"]["usage"]["users"] and tbl["stats"]["usage"]["users"]["total"] or "-")
					local uptime = (tbl["monitor"] and tbl["monitor"]["uptime"] and tbl["monitor"]["uptime"] or "-")

					instances[name] = {
						api = api,
						region = util.getCountryName(region),
						users = users,
						uptime = uptime,
					}

				end
			end

			local function onFailure(message)
				print("[Invidious API]: " .. message)
			end

			http.Fetch("https://api.invidious.io/instances.json?sort_by=type,users", onSuccess, onFailure, {
				["Accept-Encoding"] = "gzip, deflate",
				["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36",
			})
		end
		fetchInstances()

		if timer.Exists("Invidious.Update") then timer.Remove("Invidious.Update") end
		timer.Create("Invidious.Update", 300, 0, fetchInstances)
	end
end