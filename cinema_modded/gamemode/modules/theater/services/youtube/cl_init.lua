-- Client-side YouTube player and metadata crawler.
local SERVICE = theater.GetServiceByClass( "youtube" )
if not SERVICE then return end


function SERVICE:LoadProvider( Video, panel )
	local baseUrl = theater.GetCinemaURL("youtube.html")
	local videoId = Video:Data()
	local hash = ("v=%s"):format(videoId)

	if self.IsTimed then
		local startTime
		if Video._Paused and Video._PausedOffset then
			-- Frozen pause position, not the advancing clock
			startTime = math.max(0, math.Round(Video._PausedOffset))
		else
			startTime = math.max(0, math.Round(CurTime() - Video:StartTime()))
		end

		if startTime > 0 then
			hash = hash .. ("&t=%d"):format(startTime)
		end
	end

	-- Start the player paused (disables autoplay in youtube.html)
	if Video._Paused then
		hash = hash .. "&paused=1"
	end

	local url = baseUrl .. "#" .. hash
	panel:OpenURL(url)

	panel.OnDocumentReady = function(pnl)
		self:LoadExFunctions( pnl )
	end
end

-- PRIMARY metadata extractor. Runs client-side, driven by the server via
-- theater.FetchVideoMedata. Loads the invisible youtube_meta.html crawler,
-- which uses the YouTube IFrame API to emit
-- "METADATA:{title,isLive,duration}" or "ERROR:<code|msg>" to console.
function SERVICE:GetMetadata( data, callback )
	local videoId = data
	if istable(data) then
		videoId = data.id or data.Data
	end

	local panel = self:CreateWebCrawler(callback)

	local baseUrl = theater.GetCinemaURL("youtube_meta.html")
	panel:OpenURL(baseUrl .. ("#v=%s"):format(videoId))
end

