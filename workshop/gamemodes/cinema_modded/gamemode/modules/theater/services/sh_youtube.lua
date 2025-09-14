--[[
	Workaround with a Metadata parser made by veitikka (https://github.com/veitikka)
	Src: https://github.com/samuelmaddock/gm-mediaplayer/pull/34
--]]

local SERVICE = {
	Name = "YouTube",
	IsTimed = true,

	NeedsCodecFix = false,
	ExtentedVideoInfo = true,
}

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["duration"] = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"] = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"] = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">",
	["age_restriction"] = "<meta%sproperty=\"og:restrictions:age\"%s-content=%b\"\">"
}

-- Function to parse video metadata straight from the html instead of using the API
local function ParseMetaDataFromHTML( html )
	--MetaData table to return when we're done
	local metadata, html = {}, html

	-- Fetch title, with fallbacks if needed
	metadata.title = util.ParseElementAttribute(html:match(patterns["title"]), "content")
		or util.ParseElementContent(html:match(patterns["title_fallback"]))

	-- Parse HTML entities in the title into symbols
	metadata.title = url.htmlentities_decode(metadata.title)

	metadata.familyfriendly = util.ParseElementAttribute(html:match(patterns["age_restriction"]), "content") or ""

	-- See if the video is an ongoing live broadcast
	-- Set duration to 0 if it is, otherwise use the actual duration
	local isLiveBroadcast = tobool(util.ParseElementAttribute(html:match(patterns["live"]), "content"))
	local broadcastEndDate = html:match(patterns["live_enddate"])
	if isLiveBroadcast and not broadcastEndDate then
		-- Mark as live video
		metadata.duration = 0
	else
		local durationISO8601 = util.ParseElementAttribute(html:match(patterns["duration"]), "content")
		if isstring(durationISO8601) then
			metadata.duration = math.max(1, util.ISO_8601ToSeconds(durationISO8601))
		end
	end

	return metadata
end

function SERVICE:Match( url )
	return url.host and url.host:match("youtu.?be[.com]?")
end

if (CLIENT) then

	local BROWSER_JS = [[
		// YouTube Adblock (https://github.com/Vendicated/Vencord/blob/main/src/plugins/youtubeAdblock.desktop/adguard.js - #d199603)
		const hiddenCSS=["#__ffYoutube1","#__ffYoutube2","#__ffYoutube3","#__ffYoutube4","#feed-pyv-container","#feedmodule-PRO","#homepage-chrome-side-promo","#merch-shelf","#offer-module",'#pla-shelf > ytd-pla-shelf-renderer[class="style-scope ytd-watch"]',"#pla-shelf","#premium-yva","#promo-info","#promo-list","#promotion-shelf","#related > ytd-watch-next-secondary-results-renderer > #items > ytd-compact-promoted-video-renderer.ytd-watch-next-secondary-results-renderer","#search-pva","#shelf-pyv-container","#video-masthead","#watch-branded-actions","#watch-buy-urls","#watch-channel-brand-div","#watch7-branded-banner","#YtKevlarVisibilityIdentifier","#YtSparklesVisibilityIdentifier",".carousel-offer-url-container",".companion-ad-container",".GoogleActiveViewElement",'.list-view[style="margin: 7px 0pt;"]',".promoted-sparkles-text-search-root-container",".promoted-videos",".searchView.list-view",".sparkles-light-cta",".watch-extra-info-column",".watch-extra-info-right",".ytd-carousel-ad-renderer",".ytd-compact-promoted-video-renderer",".ytd-companion-slot-renderer",".ytd-merch-shelf-renderer",".ytd-player-legacy-desktop-watch-ads-renderer",".ytd-promoted-sparkles-text-search-renderer",".ytd-promoted-video-renderer",".ytd-search-pyv-renderer",".ytd-video-masthead-ad-v3-renderer",".ytp-ad-action-interstitial-background-container",".ytp-ad-action-interstitial-slot",".ytp-ad-image-overlay",".ytp-ad-overlay-container",".ytp-ad-progress",".ytp-ad-progress-list",'[class*="ytd-display-ad-"]','[layout*="display-ad-"]','a[href^="http://www.youtube.com/cthru?"]','a[href^="https://www.youtube.com/cthru?"]',"ytd-action-companion-ad-renderer","ytd-banner-promo-renderer","ytd-compact-promoted-video-renderer","ytd-companion-slot-renderer","ytd-display-ad-renderer","ytd-promoted-sparkles-text-search-renderer","ytd-promoted-sparkles-web-renderer","ytd-search-pyv-renderer","ytd-single-option-survey-renderer","ytd-video-masthead-ad-advertiser-info-renderer","ytd-video-masthead-ad-v3-renderer","YTM-PROMOTED-VIDEO-RENDERER"],hideElements=()=>{if(!hiddenCSS)return;const e=hiddenCSS.join(", ")+" { display: none!important; }",r=document.createElement("style");r.textContent=e,document.head.appendChild(r)},observeDomChanges=e=>{new MutationObserver((r=>{e(r)})).observe(document.documentElement,{childList:!0,subtree:!0})},hideDynamicAds=()=>{const e=document.querySelectorAll("#contents > ytd-rich-item-renderer ytd-display-ad-renderer");0!==e.length&&e.forEach((e=>{if(e.parentNode&&e.parentNode.parentNode){const r=e.parentNode.parentNode;"ytd-rich-item-renderer"===r.localName&&(r.style.display="none")}}))},autoSkipAds=()=>{if(document.querySelector(".ad-showing")){const e=document.querySelector("video");e&&e.duration&&(e.currentTime=e.duration,setTimeout((()=>{const e=document.querySelector("button.ytp-ad-skip-button");e&&e.click()}),100))}},overrideObject=(e,r,t)=>{if(!e)return!1;let o=!1;for(const d in e)e.hasOwnProperty(d)&&d===r?(e[d]=t,o=!0):e.hasOwnProperty(d)&&"object"==typeof e[d]&&overrideObject(e[d],r,t)&&(o=!0);return o},jsonOverride=(e,r)=>{const t=JSON.parse;JSON.parse=(...o)=>{const d=t.apply(this,o);return overrideObject(d,e,r),d},Response.prototype.json=new Proxy(Response.prototype.json,{async apply(...t){const o=await Reflect.apply(...t);return overrideObject(o,e,r),o}})};jsonOverride("adPlacements",[]),jsonOverride("playerAds",[]),hideElements(),hideDynamicAds(),autoSkipAds(),observeDomChanges((()=>{hideDynamicAds(),autoSkipAds()}));
	]]

	function SERVICE:LoadProvider( Video, panel )

		panel:OpenURL(("https://purrcoding-cinema.pages.dev/youtube.html?v=%s"):format(Video:Data()))

		panel.OnDocumentReady = function(pnl)
			self:LoadExFunctions( pnl )
		end
	end

	function SERVICE:GetMetadata( data, callback )

		http.Fetch(("https://www.youtube.com/watch?v=%s"):format(data), function(body, length, headers, code)
			if not body or code ~= 200 then
				callback({ err = ("Not expected response received from YouTube (Code: %d)"):format(code) })
				return
			end

			local status, metadata = pcall(ParseMetaDataFromHTML, body)
			if not status  then
				callback({ err = "Failed to parse MetaData from YouTube" })
				return
			end

			callback(metadata)
		end, function(error)
			callback({ err = ("YouTube Error: %s"):format(error) })
		end, {})

	end

	function SERVICE:SearchFunctions( browser )
		if not IsValid( browser ) then return end

		browser:RunJavascript(BROWSER_JS)
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

		if metadata.duration == 0 then
			info.type = "youtubelive"
			info.duration = 0
		else
			if metadata.familyfriendly == "18+" then
				-- info.type = "youtubensfw"
				return onFailure( "YouTube age-restricted content is currently not supported." )
			end

			info.duration = metadata.duration
		end

		if onSuccess then
			pcall(onSuccess, info)
		end
	end)

end

theater.RegisterService( "youtube", SERVICE )

-- Implementation is found in "youtube" service.
-- GetVideoInfo switches to "youtubelive"
theater.RegisterService( "youtubelive", {
	Name = "YouTube Live",
	IsTimed = false,
	NeedsCodecFix = true,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )

-- theater.RegisterService( "youtubensfw", {
-- 	Name = "YouTube NSFW",
-- 	IsTimed = true,
-- 	NeedsCodecFix = false,
-- 	Hidden = true,
-- 	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
-- } )