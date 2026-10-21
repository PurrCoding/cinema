local SERVICE = include "cl_init.lua"
if not SERVICE then return end

local PlaybackApi = "https://web.kick.com/api/v1/stream/%s/playback"

local function FinishVodInfo(info, onSuccess)
	if info.duration and info.duration > 0 then
		info.type = "kickvod"
	end
	if onSuccess then
		pcall(onSuccess, info)
	end
end

local KickHeaders = {
	["Accept"] = "application/json",
	["Referer"] = "https://kick.com/",
}

local ChannelVideosApi = "https://kick.com/api/v2/channels/%s/videos"
local VideoApi = "https://kick.com/api/v1/video/%s"

local function MsToSeconds(ms)
	ms = tonumber(ms) or 0
	if ms <= 0 then return 0 end
	if ms > 100000 then
		return math.floor(ms / 1000)
	end
	return math.floor(ms)
end

local function ResolveVodFromChannelList(self, channel, vodId, onSuccess, onFailure)
	self:Fetch(ChannelVideosApi:format(channel),
		function(body, length, headers, code)
			if code ~= 200 then
				return onFailure("Theater_RequestFailed")
			end

			local list = util.JSONToTable(body)
			if not istable(list) then
				return onFailure("Theater_RequestFailed")
			end

			local index = 1

			local function tryNext()
				if index > #list then
					return onFailure("Kick VOD not found on channel.")
				end

				local item = list[index]
				index = index + 1

				local vuuid = istable(item.video) and item.video.uuid
				if not vuuid then
					return tryNext()
				end

				self:Fetch(VideoApi:format(vuuid),
					function(body2, length2, headers2, code2)
						if code2 == 200 then
							local video = util.JSONToTable(body2)
							local live = istable(video) and video.livestream
							if istable(live) and live.vod_id == vodId then
								local info = {}
								info.title = live.session_title or item.session_title or ("Kick VOD: %s"):format(vodId)
								info.duration = MsToSeconds(live.duration or item.duration)

								if isstring(live.thumbnail) then
									info.thumbnail = live.thumbnail
								elseif istable(item.thumbnail) and isstring(item.thumbnail.src) then
									info.thumbnail = item.thumbnail.src
								end

								return FinishVodInfo(info, onSuccess)
							end
						end
						tryNext()
					end,
					function()
						tryNext()
					end,
					KickHeaders
				)
			end

			tryNext()
		end,
		function()
			onFailure("Theater_RequestFailed")
		end,
		KickHeaders
	)
end

local ChannelApi = "https://kick.com/api/v2/channels/%s"

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
	local uuid = isstring(data) and data:match("/videos/([%w%-]+)")
	if uuid then
		local channel = data:match("^([%a%d-_]+)/videos/")

		self:Fetch(PlaybackApi:format(uuid),
			function(body, length, headers, code)
				if code == 200 then
					local response = util.JSONToTable(body)
					local session = istable(response) and response.video_session
					if istable(session) and session.video_title and tonumber(session.video_duration) then
						local info = {}
						info.title = session.video_title
						info.duration = tonumber(session.video_duration) or 0

						local playback = response.playback_url or {}
						if isstring(playback.thumbnail) and playback.thumbnail ~= "" then
							info.thumbnail = playback.thumbnail:gsub("%{index%}", "0")
						end

						return FinishVodInfo(info, onSuccess)
					end
				end

				ResolveVodFromChannelList(self, channel, uuid, onSuccess, onFailure)
			end,
			function()
				ResolveVodFromChannelList(self, channel, uuid, onSuccess, onFailure)
			end,
			KickHeaders
		)
		return
	end

	-- Live channel
	self:Fetch(ChannelApi:format(data),
		function(body, length, headers, code)
			if code ~= 200 then
				return onFailure("Theater_RequestFailed")
			end

			local response = util.JSONToTable(body)
			if not response then
				return onFailure("Theater_RequestFailed")
			end

			local live = response.livestream
			if not istable(live) or live.is_live ~= true then
				return onFailure("Kick channel is not live.")
			end

			local info = {}
			info.title = live.session_title or ("Kick: %s"):format(data)
			info.duration = 0

			if istable(live.thumbnail) and isstring(live.thumbnail.url) then
				info.thumbnail = live.thumbnail.url
			end

			if onSuccess then
				pcall(onSuccess, info)
			end
		end,
		function()
			onFailure("Theater_RequestFailed")
		end,
		KickHeaders
	)
end

theater.RegisterService("kick", SERVICE)

theater.RegisterService("kickvod", {
	Name = "Kick VOD",
	IsTimed = true,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end,
})
