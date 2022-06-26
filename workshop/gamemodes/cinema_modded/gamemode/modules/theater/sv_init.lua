util.AddNetworkString( "PlayerEnterTheater" )
util.AddNetworkString( "PlayerLeaveTheater" )
util.AddNetworkString( "PlayerVideoQueued" )
util.AddNetworkString( "TheaterVideo" )
util.AddNetworkString( "TheaterMetadata" )
util.AddNetworkString( "TheaterInfo" )
util.AddNetworkString( "TheaterQueue" )
util.AddNetworkString( "TheaterSeek" )
util.AddNetworkString( "TheaterVoteSkips" )
util.AddNetworkString( "TheaterAnnouncement" )

local developer_cvar = GetConVar("developer")

module( "theater", package.seeall )

function Initialize()

	if game.SinglePlayer() or developer_cvar:GetInt() > 0 then
		game.CleanUpMap()
	end

	-- Make sure we can depends on the Location module
	if not Location then
		return Error("Location module not found! Theaters can't be initialized.\n")
	end

	-- Get the map locations
	local locations = Location.GetLocations()
	if not locations then return end

	for name, loc in pairs(locations) do
		GetByLocation( loc.Index, true )
	end

end
hook.Add( "InitPostEntity", "InitTheaters", Initialize )
hook.Add( "OnReloaded", "ReInitTheaters", Initialize )

function PlayerJoin( ply, locId )

	local Theater = GetByLocation(locId, true)
	if not Theater then return end

	Theater:AddPlayer(ply)

end

function PlayerLeave( ply, locId )

	if not locId then
		locId = ply:GetLocation()
	end

	local Theater = GetByLocation(locId)
	if not Theater then return end

	Theater:RemovePlayer(ply)

end
hook.Add( "PlayerDisconnected", "TheaterDisconnected", PlayerLeave )

local metadata_callback = {}
function FetchVideoMedata( ply, service, callback )

	if not IsValid(ply) then return end

	local type = service:Type()
	local data = service:Data()
	local hash = util.CRC( math.random(1, 9999999) .. data ) -- Random hash

	metadata_callback[hash] = callback

	net.Start("TheaterMetadata")
		net.WriteString(type) -- Service Type
		net.WriteString(data) -- Unique Video ID 
		net.WriteString(hash) -- Hash for callback
	net.Send(ply)

end
net.Receive("TheaterMetadata", function(len, ply)

	if not IsValid(ply) then return end

	local hash = net.ReadString()
	local data = net.ReadTable()

	if metadata_callback[hash] then
		metadata_callback[hash](data)
		metadata_callback[hash] = nil
	end
end)

function RequestTheaterInfo( ply, force )

	if not IsValid(ply) then return end

	-- Prevent spamming requests
	if not force and ply.LastTheaterRequest and ply.LastTheaterRequest + 1 > CurTime() then
		return
	end

	-- Grab theater information
	local info = {}
	local th = nil
	for _, Theater in pairs( GetTheaters() ) do

		-- Theater is set to not broadcast
		if not Theater:IsReplicated() and Theater ~= ply:GetTheater() then
			continue
		end

		th = {
			Location = Theater:GetLocation(),
			Name = Theater:Name(),
			Pos = Theater:GetPos(),
			Ang = Theater:GetAngles(),
			Flags = Theater:GetFlags(),
			Type = Theater:VideoType(),
			Data = Theater:VideoData(),
			Title = Theater:VideoTitle(),
			Duration = Theater:VideoDuration(),
			StartTime = Theater:VideoStartTime()
		}

		th.Width, th.Height = Theater:GetSize()

		if Theater:IsPrivate() then
			th.Owner = Theater:GetOwner()
		end

		table.insert(info, th)

	end

	if #info > 0 then
		net.Start("TheaterInfo")
			net.WriteTable(info)
		net.Send(ply)
	end

	-- If the player is currently in a theater, also
	-- send the queue information
	local queue = {}
	local Theater = ply:GetTheater()
	if Theater then
		for _, vid in pairs( Theater:GetQueue() ) do
			-- Queued video information
			local item = {
				Id = vid.id,
				Title = vid:Title(),
				Duration = vid:Duration(),
				Votes = vid:GetNumVotes()
			}

			-- Send the player's vote value if they have voted
			local vote = vid:GetVoteByPlayer(ply)
			if vote then
				item.Value = vote.value
			end

			-- Send whether they're the owner of the video
			if vid:GetOwner() == ply then
				item.Owner = true
			end

			table.insert(queue, item)
		end
	end

	if Theater then
		net.Start("TheaterQueue")
			net.WriteTable(queue)
		net.Send(ply)
	end

	ply.LastTheaterRequest = CurTime()

end
net.Receive("TheaterInfo", function(len, ply)
	theater.RequestTheaterInfo(ply)
end)

function GetVideoInfo( Video, onSuccess, onFailure )

	if not Video then return end

	local service = Services[ Video:Type() ]
	if service then
		service:GetVideoInfo( service.ExtentedVideoInfo and Video or Video:Data(), onSuccess, onFailure )
	else
		return pcall(onFailure, 404)
	end

end