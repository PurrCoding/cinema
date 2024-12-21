local SERVICE = {}

SERVICE.Name = "YouTube"
SERVICE.IsTimed = true

SERVICE.Dependency = DEPENDENCY_PARTIAL
SERVICE.ExtentedVideoInfo = true

local EMBED_URL = "https://www.youtube.com/watch?v=%s"
local EMBED_PARAMETER = "&unlock_confirmed=1%s"

local AGEBYPASS_JS = "" -- See end of file (https://github.com/zerodytrash/Simple-YouTube-Age-Restriction-Bypass/blob/main/dist/Simple-YouTube-Age-Restriction-Bypass.user.js - #47c5508 - v2.5.11)
local ADBLOCK_JS = "" -- see end of file (https://github.com/Vendicated/Vencord/blob/main/src/plugins/youtubeAdblock.desktop/adguard.js - #d199603)

--[[
	Credits to veitikka (https://github.com/veitikka) for fixing YouTube service and writing the
	Workaround with a Metadata parser.
--]]

-- Lua search patterns to find metadata from the html
local patterns = {
	["title"] = "<meta%sproperty=\"og:title\"%s-content=%b\"\">",
	["title_fallback"] = "<title>.-</title>",
	["duration"] = "<meta%sitemprop%s-=%s-\"duration\"%s-content%s-=%s-%b\"\">",
	["live"] = "<meta%sitemprop%s-=%s-\"isLiveBroadcast\"%s-content%s-=%s-%b\"\">",
	["live_enddate"] = "<meta%sitemprop%s-=%s-\"endDate\"%s-content%s-=%s-%b\"\">",
	["age_restriction"] = "<meta%sproperty=\"og:restrictions:age\"%s-content=%b\"\">"
}

---
-- Function to parse video metadata straight from the html instead of using the API
--
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

	local THEATER_JS = [[
		const isNSFW = window.location.search.includes('nsfw');
		const startTime = window.location.search.includes('t');

		var checkerInterval = setInterval(function() {
			var player = document.getElementById("movie_player") || document.getElementsByClassName("html5-video-player")[0];

			if (!!player) {
				clearInterval(checkerInterval);

				{ // NSFW fix
					var nsfwInterval = setInterval(function() {
						if (isNSFW && player.getPlayerState() == 0) {

							if (startTime) {
								player.seekTo(startTime, true)
							}
							clearInterval(nsfwInterval);
						}
					}, 50);
				}

				{ // Native video controll
					player.volume = 0;
					player.currentTime = 0;
					player.duration = player.getDuration();

					Object.defineProperty(player, "volume", {
						get() {
							return player.getVolume();
						},
						set(volume) {
							if (player.isMuted()) {
								player.unMute();
							}
							player.setVolume(volume * 100);
						},
					});

					Object.defineProperty(player, "currentTime", {
						get() {
							return Number(player.getCurrentTime());
						},
						set(time) {
							player.seekTo(time, true);
						},
					});
				}

				{ // Player resizer
					document.body.appendChild(player);

					player.style.backgroundColor = "#000";
					player.style.height = "100vh";
					player.style.left = '0px';
					player.style.width = '100%';

					let countAmt = 0
					let resizeTimer = setInterval(function() {

						for (const elem of document.getElementsByClassName("watch-skeleton")) { elem.remove(); }
						for (const elem of document.getElementsByTagName("ytd-app")) { elem.remove(); }
						for (const elem of document.getElementsByClassName("skeleton")) { elem.remove(); }

						player.setInternalSize("100vw", "100vh");
						document.body.style.overflow = "hidden";

						countAmt++;

						if (countAmt > 100) {
							clearInterval(resizeTimer);
						}
        			}, 10);
				}

				window.cinema_controller = player;
				exTheater.controllerReady();
			}
		}, 50);
	]]

	function SERVICE:LoadProvider( Video, panel )

		local isNSFW = self:GetClass() == "youtubensfw"

		panel:OpenURL(EMBED_URL:format(Video:Data()) ..
			EMBED_PARAMETER:format(self.IsTimed and ("&t=%s"):format(
				math.Round(CurTime() - Video:StartTime()
			) .. (isNSFW and "&nsfw=1" or ""))
		) or "")

		if timer.Exists("YouTube.AgeBypass") then
			timer.Remove("YouTube.AgeBypass")
		end

		if isNSFW then
			timer.Create("YouTube.AgeBypass", .01, 30, function()
				if not IsValid(panel) then return end
				panel:RunJavascript(AGEBYPASS_JS)
			end)
		end

		panel.OnDocumentReady = function(pnl)
			pnl:RunJavascript(ADBLOCK_JS)

			self:LoadExFunctions(pnl)
			pnl:QueueJavascript(THEATER_JS)
		end
	end

	function SERVICE:GetMetadata( data, callback )

		http.Fetch(EMBED_URL:format(data), function(body, length, headers, code)
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
				info.type = "youtubensfw"
			end

			info.duration = metadata.duration
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

theater.RegisterService( "youtubensfw", {
	Name = "YouTube NSFW",
	IsTimed = true,
	Dependency = DEPENDENCY_PARTIAL,
	Hidden = true,
	LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
} )

if not CLIENT then return end

AGEBYPASS_JS = [[
const UNLOCKABLE_PLAYABILITY_STATUSES=["AGE_VERIFICATION_REQUIRED","AGE_CHECK_REQUIRED","CONTENT_CHECK_REQUIRED","LOGIN_REQUIRED"],VALID_PLAYABILITY_STATUSES=["OK","LIVE_STREAM_OFFLINE"],ACCOUNT_PROXY_SERVER_HOST="https://youtube-proxy.zerody.one",VIDEO_PROXY_SERVER_HOST="https://ny.4everproxy.com";let ENABLE_UNLOCK_CONFIRMATION_EMBED=!0,ENABLE_UNLOCK_NOTIFICATION=!0,SKIP_CONTENT_WARNINGS=!0;const GOOGLE_AUTH_HEADER_NAMES=["Authorization","X-Goog-AuthUser","X-Origin"],BLURRED_THUMBNAIL_SQP_LENGTHS=[32,48,56,68,72,84,88];var Config=window[Symbol()]={UNLOCKABLE_PLAYABILITY_STATUSES:UNLOCKABLE_PLAYABILITY_STATUSES,VALID_PLAYABILITY_STATUSES:VALID_PLAYABILITY_STATUSES,ACCOUNT_PROXY_SERVER_HOST:ACCOUNT_PROXY_SERVER_HOST,VIDEO_PROXY_SERVER_HOST:VIDEO_PROXY_SERVER_HOST,ENABLE_UNLOCK_CONFIRMATION_EMBED:ENABLE_UNLOCK_CONFIRMATION_EMBED,ENABLE_UNLOCK_NOTIFICATION:ENABLE_UNLOCK_NOTIFICATION,SKIP_CONTENT_WARNINGS:SKIP_CONTENT_WARNINGS,GOOGLE_AUTH_HEADER_NAMES:GOOGLE_AUTH_HEADER_NAMES,BLURRED_THUMBNAIL_SQP_LENGTHS:BLURRED_THUMBNAIL_SQP_LENGTHS};function isGoogleVideoUrl(e){return e.host.includes(".googlevideo.com")}function isGoogleVideoUnlockRequired(e,t){const n=new URLSearchParams(e.search),o=n.get("gcr"),i=n.get("id")===t;return o&&i}const nativeJSONParse=window.JSON.parse,nativeXMLHttpRequestOpen=window.XMLHttpRequest.prototype.open,isDesktop="m.youtube.com"!==window.location.host,isMusic="music.youtube.com"===window.location.host,isEmbed=0===window.location.pathname.indexOf("/embed/"),isConfirmed=window.location.search.includes("unlock_confirmed");class Deferred{constructor(){return Object.assign(new Promise(((e,t)=>{this.resolve=e,this.reject=t})),this)}}if(window.trustedTypes&&trustedTypes.createPolicy&&!trustedTypes.defaultPolicy){const e=e=>e;trustedTypes.createPolicy("default",{createHTML:e,createScriptURL:e,createScript:e})}function createElement(e,t){const n=document.createElement(e);return t&&Object.assign(n,t),n}function isObject(e){return null!==e&&"object"==typeof e}function findNestedObjectsByAttributeNames(e,t){var n=[];return t.every((t=>void 0!==e[t]))&&n.push(e),Object.keys(e).forEach((o=>{e[o]&&"object"==typeof e[o]&&n.push(...findNestedObjectsByAttributeNames(e[o],t))})),n}function pageLoaded(){if("complete"===document.readyState)return Promise.resolve();const e=new Deferred;return window.addEventListener("load",e.resolve,{once:!0}),e}function createDeepCopy(e){return nativeJSONParse(JSON.stringify(e))}function getYtcfgValue(e){var t;return null===(t=window.ytcfg)||void 0===t?void 0:t.get(e)}function getSignatureTimestamp(){return getYtcfgValue("STS")||(e=>{const t=null===(e=document.querySelector('script[src*="/base.js"]'))||void 0===e?void 0:e.src;if(!t)return;const n=new XMLHttpRequest;return n.open("GET",t,!1),n.send(null),parseInt(n.responseText.match(/signatureTimestamp:([0-9]*)/)[1])})()}function isUserLoggedIn(){return"boolean"==typeof getYtcfgValue("LOGGED_IN")?getYtcfgValue("LOGGED_IN"):"string"==typeof getYtcfgValue("DELEGATED_SESSION_ID")||parseInt(getYtcfgValue("SESSION_INDEX"))>=0}function getCurrentVideoStartTime(e){if(window.location.href.includes(e)){var t;const e=new URLSearchParams(window.location.search),n=null===(t=e.get("t")||e.get("start")||e.get("time_continue"))||void 0===t?void 0:t.replace("s","");if(n&&!isNaN(n))return parseInt(n)}return 0}function setUrlParams(e){const t=new URLSearchParams(window.location.search);for(const n in e)t.set(n,e[n]);window.location.search=t}function waitForElement(e,t){const n=new Deferred,o=setInterval((()=>{const t=document.querySelector(e);t&&(clearInterval(o),n.resolve(t))}),100);return setTimeout((()=>{clearInterval(o),n.reject()}),t),n}function isWatchNextObject(e){var t;return!(null==e||!e.contents||null==e||null===(t=e.currentVideoEndpoint)||void 0===t||null===(t=t.watchEndpoint)||void 0===t||!t.videoId)&&(!!e.contents.twoColumnWatchNextResults||!!e.contents.singleColumnWatchNextResults)}function isWatchNextSidebarEmpty(e){var t,n;if(isDesktop){var o;return!(null===(o=e.contents)||void 0===o||null===(o=o.twoColumnWatchNextResults)||void 0===o||null===(o=o.secondaryResults)||void 0===o||null===(o=o.secondaryResults)||void 0===o?void 0:o.results)}const i=null===(t=e.contents)||void 0===t||null===(t=t.singleColumnWatchNextResults)||void 0===t||null===(t=t.results)||void 0===t||null===(t=t.results)||void 0===t?void 0:t.contents;return"object"!=typeof(null==i||null===(n=i.find((e=>{var t;return"watch-next-feed"===(null===(t=e.itemSectionRenderer)||void 0===t?void 0:t.targetId)})))||void 0===n?void 0:n.itemSectionRenderer)}function isPlayerObject(e){return(null==e?void 0:e.videoDetails)&&(null==e?void 0:e.playabilityStatus)}function isEmbeddedPlayerObject(e){return"object"==typeof(null==e?void 0:e.previewPlayabilityStatus)}function isAgeRestricted(e){var t;return!(null==e||!e.status)&&(!!e.desktopLegacyAgeGateReason||(!!Config.UNLOCKABLE_PLAYABILITY_STATUSES.includes(e.status)||isEmbed&&(null===(t=e.errorScreen)||void 0===t||null===(t=t.playerErrorMessageRenderer)||void 0===t||null===(t=t.reason)||void 0===t||null===(t=t.runs)||void 0===t||null===(t=t.find((e=>e.navigationEndpoint)))||void 0===t||null===(t=t.navigationEndpoint)||void 0===t||null===(t=t.urlEndpoint)||void 0===t||null===(t=t.url)||void 0===t?void 0:t.includes("/2802167"))))}function isSearchResult(e){var t,n,o;return"object"==typeof(null==e||null===(t=e.contents)||void 0===t?void 0:t.twoColumnSearchResultsRenderer)||"search-feed"===(null==e||null===(n=e.contents)||void 0===n||null===(n=n.sectionListRenderer)||void 0===n?void 0:n.targetId)||"search-feed"===(null==e||null===(o=e.onResponseReceivedCommands)||void 0===o||null===(o=o.find((e=>e.appendContinuationItemsAction)))||void 0===o||null===(o=o.appendContinuationItemsAction)||void 0===o?void 0:o.targetId)}function attach$4(e,t,n){if(!e||"function"!=typeof e[t])return;let o=e[t];e[t]=function(){try{n(arguments)}catch{}o.apply(this,arguments)}}const logPrefix="%cSimple-YouTube-Age-Restriction-Bypass:",logPrefixStyle="background-color: #1e5c85; color: #fff; font-size: 1.2em;",logSuffix="🐞 You can report bugs at: https://github.com/zerodytrash/Simple-YouTube-Age-Restriction-Bypass/issues";function error(e,t){window.SYARB_CONFIG&&window.dispatchEvent(new CustomEvent("SYARB_LOG_ERROR",{detail:{message:(t?t+"; ":"")+(e&&e.message?e.message:""),stack:e&&e.stack?e.stack:null}}))}function info(e){window.SYARB_CONFIG&&window.dispatchEvent(new CustomEvent("SYARB_LOG_INFO",{detail:{message:e}}))}function getYtcfgDebugString(){try{return`InnertubeConfig: innertubeApiKey: ${getYtcfgValue("INNERTUBE_API_KEY")} innertubeClientName: ${getYtcfgValue("INNERTUBE_CLIENT_NAME")} innertubeClientVersion: ${getYtcfgValue("INNERTUBE_CLIENT_VERSION")} loggedIn: ${getYtcfgValue("LOGGED_IN")} `}catch(e){return`Failed to access config: ${e}`}}function attach$3(e){interceptObjectProperty("playerResponse",((t,n)=>(info(`playerResponse property set, contains sidebar: ${!!t.response}`),isObject(t.response)&&e(t.response),n.unlocked=!1,e(n),n.unlocked?createDeepCopy(n):n))),window.addEventListener("DOMContentLoaded",(()=>{isObject(window.ytInitialData)&&e(window.ytInitialData)}))}function interceptObjectProperty(e,t){var n;const o="__SYARB_"+e,{get:i,set:r}=null!==(n=Object.getOwnPropertyDescriptor(Object.prototype,e))&&void 0!==n?n:{set(e){this[o]=e},get(){return this[o]}};Object.defineProperty(Object.prototype,e,{set(e){r.call(this,isObject(e)?t(this,e):e)},get(){return i.call(this)},configurable:!0})}function attach$2(e){window.JSON.parse=function(){const t=nativeJSONParse.apply(this,arguments);return isObject(t)?e(t):t}}function attach$1(e){"function"==typeof window.Request&&(window.Request=new Proxy(window.Request,{construct(t,n){let[o,i]=n;try{if("string"==typeof o&&(0===o.indexOf("/")&&(o=window.location.origin+o),-1!==o.indexOf("https://"))){const t=e(o,i);t&&(n[0]=t)}}catch(e){error(e,"Failed to intercept Request()")}return Reflect.construct(t,n)}}))}function attach(e){XMLHttpRequest.prototype.open=function(...t){let[n,o]=t;try{if("string"==typeof o&&(0===o.indexOf("/")&&(o=window.location.origin+o),-1!==o.indexOf("https://"))){const i=e(n,o,this);i&&(t[1]=i)}}catch(e){error(e,"Failed to intercept XMLHttpRequest.open()")}nativeXMLHttpRequestOpen.apply(this,t)}}const localStoragePrefix="SYARB_";function set(e,t){localStorage.setItem("SYARB_"+e,JSON.stringify(t))}function get(e){try{return JSON.parse(localStorage.getItem("SYARB_"+e))}catch{return null}}function getPlayer$1(e,t){return sendInnertubeRequest("v1/player",e,t)}function getNext$1(e,t){return sendInnertubeRequest("v1/next",e,t)}function sendInnertubeRequest(e,t,n){const o=new XMLHttpRequest;return o.open("POST",`/youtubei/${e}?key=${getYtcfgValue("INNERTUBE_API_KEY")}&prettyPrint=false`,!1),n&&isUserLoggedIn()&&(o.withCredentials=!0,Config.GOOGLE_AUTH_HEADER_NAMES.forEach((e=>{o.setRequestHeader(e,get(e))}))),o.send(JSON.stringify(t)),nativeJSONParse(o.responseText)}var innertube={getPlayer:getPlayer$1,getNext:getNext$1};let nextResponseCache={};function getGoogleVideoUrl(e){return Config.VIDEO_PROXY_SERVER_HOST+"/direct/"+btoa(e.toString())}function getPlayer(e){return nextResponseCache[e.videoId]||isMusic||isEmbed||(e.includeNext=1),sendRequest("getPlayer",e)}function getNext(e){return nextResponseCache[e.videoId]?nextResponseCache[e.videoId]:sendRequest("getNext",e)}function sendRequest(e,t){const n=new URLSearchParams(t),o=`${Config.ACCOUNT_PROXY_SERVER_HOST}/${e}?${n}&client=js`;try{const e=new XMLHttpRequest;e.open("GET",o,!1),e.send(null);const n=nativeJSONParse(e.responseText);return n.proxied=!0,n.nextResponse&&(nextResponseCache[t.videoId]=n.nextResponse,delete n.nextResponse),n}catch(e){return error(e,"Proxy API Error"),{errorMessage:"Proxy Connection failed"}}}var proxy={getPlayer:getPlayer,getNext:getNext,getGoogleVideoUrl:getGoogleVideoUrl};function getUnlockStrategies$1(e,t){var n;const o=getYtcfgValue("INNERTUBE_CLIENT_NAME")||"WEB",i=getYtcfgValue("INNERTUBE_CLIENT_VERSION")||"2.20220203.04.00",r=getYtcfgValue("HL"),s=null!==(n=getYtcfgValue("INNERTUBE_CONTEXT").client.userInterfaceTheme)&&void 0!==n?n:document.documentElement.hasAttribute("dark")?"USER_INTERFACE_THEME_DARK":"USER_INTERFACE_THEME_LIGHT";return[{name:"Content Warning Bypass",skip:!t||!t.includes("CHECK_REQUIRED"),optionalAuth:!0,payload:{context:{client:{clientName:o,clientVersion:i,hl:r,userInterfaceTheme:s}},videoId:e,racyCheckOk:!0,contentCheckOk:!0},endpoint:innertube},{name:"Account Proxy",payload:{videoId:e,clientName:o,clientVersion:i,hl:r,userInterfaceTheme:s,isEmbed:+isEmbed,isConfirmed:+isConfirmed},endpoint:proxy}]}function getUnlockStrategies(e,t){const n=getYtcfgValue("INNERTUBE_CLIENT_NAME")||"WEB",o=getYtcfgValue("INNERTUBE_CLIENT_VERSION")||"2.20220203.04.00",i=getSignatureTimestamp(),r=getCurrentVideoStartTime(e),s=getYtcfgValue("HL");return[{name:"Content Warning Bypass",skip:!t||!t.includes("CHECK_REQUIRED"),optionalAuth:!0,payload:{context:{client:{clientName:n,clientVersion:o,hl:s}},playbackContext:{contentPlaybackContext:{signatureTimestamp:i}},videoId:e,startTimeSecs:r,racyCheckOk:!0,contentCheckOk:!0},endpoint:innertube},{name:"TV Embedded Player",requiresAuth:!1,payload:{context:{client:{clientName:"TVHTML5_SIMPLY_EMBEDDED_PLAYER",clientVersion:"2.0",clientScreen:"WATCH",hl:s},thirdParty:{embedUrl:"https://www.youtube.com/"}},playbackContext:{contentPlaybackContext:{signatureTimestamp:i}},videoId:e,startTimeSecs:r,racyCheckOk:!0,contentCheckOk:!0},endpoint:innertube},{name:"Creator + Auth",requiresAuth:!0,payload:{context:{client:{clientName:"WEB_CREATOR",clientVersion:"1.20210909.07.00",hl:s}},playbackContext:{contentPlaybackContext:{signatureTimestamp:i}},videoId:e,startTimeSecs:r,racyCheckOk:!0,contentCheckOk:!0},endpoint:innertube},{name:"Account Proxy",payload:{videoId:e,reason:t,clientName:n,clientVersion:o,signatureTimestamp:i,startTimeSecs:r,hl:s,isEmbed:+isEmbed,isConfirmed:+isConfirmed},endpoint:proxy}]}var buttonTemplate='<div style="margin-top: 15px !important; padding: 3px 10px 3px 10px; margin: 0px auto; background-color: #4d4d4d; width: fit-content; font-size: 1.2em; text-transform: uppercase; border-radius: 3px; cursor: pointer;">\n    <div class="button-text"></div>\n</div>';let buttons={};async function addButton(e,t,n,o){const i=await waitForElement(".ytp-error",2e3),r=createElement("div",{class:"button-container",innerHTML:buttonTemplate});r.getElementsByClassName("button-text")[0].innerText=t,"function"==typeof o&&r.addEventListener("click",o),buttons[e]&&buttons[e].isConnected||(buttons[e]=r,i.append(r))}function removeButton(e){buttons[e]&&buttons[e].isConnected&&buttons[e].remove()}const confirmationButtonId="confirmButton",confirmationButtonText="Click to unlock";function isConfirmationRequired(){return!isConfirmed&&isEmbed&&Config.ENABLE_UNLOCK_CONFIRMATION_EMBED}function requestConfirmation(){addButton("confirmButton","Click to unlock",null,(()=>{removeButton("confirmButton"),confirm()}))}function confirm(){setUrlParams({unlock_confirmed:1,autoplay:1})}var tDesktop="<tp-yt-paper-toast></tp-yt-paper-toast>\n",tMobile='<c3-toast>\n    <ytm-notification-action-renderer>\n        <div class="notification-action-response-text"></div>\n    </ytm-notification-action-renderer>\n</c3-toast>\n';const template=isDesktop?tDesktop:tMobile,nToastContainer=createElement("div",{id:"toast-container",innerHTML:template}),nToast=nToastContainer.querySelector(":scope > *");async function show(e,t=5){Config.ENABLE_UNLOCK_NOTIFICATION&&(isEmbed||(await pageLoaded(),"hidden"!==document.visibilityState&&(nToastContainer.isConnected||document.documentElement.append(nToastContainer),nToast.duration=1e3*t,nToast.show(e))))}isMusic&&(nToast.style["margin-bottom"]="85px"),isDesktop||(nToast.nMessage=nToast.querySelector(".notification-action-response-text"),nToast.show=e=>{nToast.nMessage.innerText=e,nToast.setAttribute("dir","in"),setTimeout((()=>{nToast.setAttribute("dir","out")}),nToast.duration+225)});var Toast={show:show};const messagesMap={success:"Age-restricted video successfully unlocked!",fail:"Unable to unlock this video 🙁 - More information in the developer console"};let lastProxiedGoogleVideoUrlParams,lastPlayerUnlockVideoId=null,lastPlayerUnlockReason=null,cachedPlayerResponse={};function getLastProxiedGoogleVideoId(){var e;return null===(e=lastProxiedGoogleVideoUrlParams)||void 0===e?void 0:e.get("id")}function unlockResponse$1(e){var t,n,o,i,r;if(isConfirmationRequired())return info("Unlock confirmation required."),void requestConfirmation();const s=(null===(t=e.videoDetails)||void 0===t?void 0:t.videoId)||getYtcfgValue("PLAYER_VARS").video_id,a=(null===(n=e.playabilityStatus)||void 0===n?void 0:n.status)||(null===(o=e.previewPlayabilityStatus)||void 0===o?void 0:o.status);if(!Config.SKIP_CONTENT_WARNINGS&&a.includes("CHECK_REQUIRED"))return void info(`SKIP_CONTENT_WARNINGS disabled and ${a} status detected.`);lastPlayerUnlockVideoId=s,lastPlayerUnlockReason=a;const c=getUnlockedPlayerResponse(s,a);if(c.errorMessage)throw Toast.show(`${messagesMap.fail} (ProxyError)`,10),new Error(`Player Unlock Failed, Proxy Error Message: ${c.errorMessage}`);var l;if(!Config.VALID_PLAYABILITY_STATUSES.includes(null===(i=c.playabilityStatus)||void 0===i?void 0:i.status))throw Toast.show(`${messagesMap.fail} (PlayabilityError)`,10),new Error(`Player Unlock Failed, playabilityStatus: ${null===(l=c.playabilityStatus)||void 0===l?void 0:l.status}`);if(c.proxied&&null!==(r=c.streamingData)&&void 0!==r&&r.adaptiveFormats){var d,u;const e=null===(d=c.streamingData.adaptiveFormats.find((e=>e.signatureCipher)))||void 0===d?void 0:d.signatureCipher,t=e?new URLSearchParams(e).get("url"):null===(u=c.streamingData.adaptiveFormats.find((e=>e.url)))||void 0===u?void 0:u.url;lastProxiedGoogleVideoUrlParams=t?new URLSearchParams(new window.URL(t).search):null}e.previewPlayabilityStatus&&(e.previewPlayabilityStatus=c.playabilityStatus),Object.assign(e,c),e.unlocked=!0,Toast.show(messagesMap.success)}function getUnlockedPlayerResponse(e,t){if(cachedPlayerResponse.videoId===e)return createDeepCopy(cachedPlayerResponse);const n=getUnlockStrategies(e,t);let o={};return n.every(((e,t)=>{var n;if(e.skip||e.requiresAuth&&!isUserLoggedIn())return!0;info(`Trying Player Unlock Method #${t+1} (${e.name})`);try{o=e.endpoint.getPlayer(e.payload,e.requiresAuth||e.optionalAuth)}catch(e){error(e,`Player Unlock Method ${t+1} failed with exception`)}const i=Config.VALID_PLAYABILITY_STATUSES.includes(null===(n=o)||void 0===n||null===(n=n.playabilityStatus)||void 0===n?void 0:n.status);var r;i&&(o.trackingParams&&null!==(r=o.responseContext)&&void 0!==r&&null!==(r=r.mainAppWebResponseContext)&&void 0!==r&&r.trackingParam||(o.trackingParams="CAAQu2kiEwjor8uHyOL_AhWOvd4KHavXCKw=",o.responseContext={mainAppWebResponseContext:{trackingParam:"kx_fmPxhoPZRzgL8kzOwANUdQh8ZwHTREkw2UqmBAwpBYrzRgkuMsNLBwOcCE59TDtslLKPQ-SS"}}),e.payload.startTimeSecs&&"Account Proxy"===e.name&&(o.playerConfig={playbackStartConfig:{startSeconds:e.payload.startTimeSecs}}));return!i})),cachedPlayerResponse={videoId:e,...createDeepCopy(o)},o}let cachedNextResponse={};function unlockResponse(e){const t=e.currentVideoEndpoint.watchEndpoint.videoId;if(!t)throw new Error("Missing videoId in nextResponse");if(t!==lastPlayerUnlockVideoId)return;const n=getUnlockedNextResponse(t);if(isWatchNextSidebarEmpty(n))throw new Error("Sidebar Unlock Failed");mergeNextResponse(e,n)}function getUnlockedNextResponse(e){if(cachedNextResponse.videoId===e)return createDeepCopy(cachedNextResponse);const t=getUnlockStrategies$1(e,lastPlayerUnlockReason);let n={};return t.every(((e,t)=>{if(e.skip)return!0;info(`Trying Next Unlock Method #${t+1} (${e.name})`);try{n=e.endpoint.getNext(e.payload,e.optionalAuth)}catch(e){error(e,`Next Unlock Method ${t+1} failed with exception`)}return isWatchNextSidebarEmpty(n)})),cachedNextResponse={videoId:e,...createDeepCopy(n)},n}function mergeNextResponse(e,t){var n;if(isDesktop){e.contents.twoColumnWatchNextResults.secondaryResults=t.contents.twoColumnWatchNextResults.secondaryResults;const n=e.contents.twoColumnWatchNextResults.results.results.contents.find((e=>e.videoSecondaryInfoRenderer)).videoSecondaryInfoRenderer,o=t.contents.twoColumnWatchNextResults.results.results.contents.find((e=>e.videoSecondaryInfoRenderer)).videoSecondaryInfoRenderer;return void(o.description?n.description=o.description:o.attributedDescription&&(n.attributedDescription=o.attributedDescription))}const o=null===(n=t.contents)||void 0===n||null===(n=n.singleColumnWatchNextResults)||void 0===n||null===(n=n.results)||void 0===n||null===(n=n.results)||void 0===n||null===(n=n.contents)||void 0===n?void 0:n.find((e=>{var t;return"watch-next-feed"===(null===(t=e.itemSectionRenderer)||void 0===t?void 0:t.targetId)}));o&&e.contents.singleColumnWatchNextResults.results.results.contents.push(o);const i=e.engagementPanels.find((e=>e.engagementPanelSectionListRenderer)).engagementPanelSectionListRenderer.content.structuredDescriptionContentRenderer.items.find((e=>e.expandableVideoDescriptionBodyRenderer)),r=t.engagementPanels.find((e=>e.engagementPanelSectionListRenderer)).engagementPanelSectionListRenderer.content.structuredDescriptionContentRenderer.items.find((e=>e.expandableVideoDescriptionBodyRenderer));r.expandableVideoDescriptionBodyRenderer&&(i.expandableVideoDescriptionBodyRenderer=r.expandableVideoDescriptionBodyRenderer)}function handleXhrOpen(e,t,n){const o=new URL(t);let i=unlockGoogleVideo(o);if(i)return Object.defineProperty(n,"withCredentials",{set:()=>{},get:()=>!1}),i.toString();0===o.pathname.indexOf("/youtubei/")&&attach$4(n,"setRequestHeader",(([e,t])=>{Config.GOOGLE_AUTH_HEADER_NAMES.includes(e)&&set(e,t)})),Config.SKIP_CONTENT_WARNINGS&&"POST"===e&&["/youtubei/v1/player","/youtubei/v1/next"].includes(o.pathname)&&attach$4(n,"send",(e=>{"string"==typeof e[0]&&(e[0]=setContentCheckOk(e[0]))}))}function handleFetchRequest(e,t){const n=new URL(e),o=unlockGoogleVideo(n);if(o)return t.credentials&&(t.credentials="omit"),o.toString();if(0===n.pathname.indexOf("/youtubei/")&&isObject(t.headers))for(let e in t.headers)Config.GOOGLE_AUTH_HEADER_NAMES.includes(e)&&set(e,t.headers[e]);Config.SKIP_CONTENT_WARNINGS&&["/youtubei/v1/player","/youtubei/v1/next"].includes(n.pathname)&&(t.body=setContentCheckOk(t.body))}function unlockGoogleVideo(e){if(Config.VIDEO_PROXY_SERVER_HOST&&isGoogleVideoUrl(e)&&isGoogleVideoUnlockRequired(e,getLastProxiedGoogleVideoId()))return proxy.getGoogleVideoUrl(e)}function setContentCheckOk(e){try{let t=JSON.parse(e);if(t.videoId)return t.contentCheckOk=!0,t.racyCheckOk=!0,JSON.stringify(t)}catch{}return e}function processThumbnails(e){const t=findNestedObjectsByAttributeNames(e,["url","height"]);let n=0;for(const e of t)isThumbnailBlurred(e)&&(n++,e.url=e.url.split("?")[0]);info(n+"/"+t.length+" thumbnails detected as blurred.")}function isThumbnailBlurred(e){if(!(-1!==e.url.indexOf("?sqp=")))return!1;const t=new URL(e.url).searchParams.get("sqp").length;return Config.BLURRED_THUMBNAIL_SQP_LENGTHS.includes(t)}try{attach$3(processYtData),attach$2(processYtData),attach(handleXhrOpen),attach$1(handleFetchRequest)}catch(e){error(e,"Error while attaching data interceptors")}function processYtData(e){try{(isPlayerObject(e)&&isAgeRestricted(e.playabilityStatus)||isEmbeddedPlayerObject(e)&&isAgeRestricted(e.previewPlayabilityStatus))&&unlockResponse$1(e)}catch(e){error(e,"Video unlock failed")}try{isWatchNextObject(e)&&isWatchNextSidebarEmpty(e)&&unlockResponse(e),isWatchNextObject(e.response)&&isWatchNextSidebarEmpty(e.response)&&unlockResponse(e.response)}catch(e){error(e,"Sidebar unlock failed")}try{isSearchResult(e)&&processThumbnails(e)}catch(e){error(e,"Thumbnail unlock failed")}return e}
]]

ADBLOCK_JS = [[
const hiddenCSS=["#__ffYoutube1","#__ffYoutube2","#__ffYoutube3","#__ffYoutube4","#feed-pyv-container","#feedmodule-PRO","#homepage-chrome-side-promo","#merch-shelf","#offer-module",'#pla-shelf > ytd-pla-shelf-renderer[class="style-scope ytd-watch"]',"#pla-shelf","#premium-yva","#promo-info","#promo-list","#promotion-shelf","#related > ytd-watch-next-secondary-results-renderer > #items > ytd-compact-promoted-video-renderer.ytd-watch-next-secondary-results-renderer","#search-pva","#shelf-pyv-container","#video-masthead","#watch-branded-actions","#watch-buy-urls","#watch-channel-brand-div","#watch7-branded-banner","#YtKevlarVisibilityIdentifier","#YtSparklesVisibilityIdentifier",".carousel-offer-url-container",".companion-ad-container",".GoogleActiveViewElement",'.list-view[style="margin: 7px 0pt;"]',".promoted-sparkles-text-search-root-container",".promoted-videos",".searchView.list-view",".sparkles-light-cta",".watch-extra-info-column",".watch-extra-info-right",".ytd-carousel-ad-renderer",".ytd-compact-promoted-video-renderer",".ytd-companion-slot-renderer",".ytd-merch-shelf-renderer",".ytd-player-legacy-desktop-watch-ads-renderer",".ytd-promoted-sparkles-text-search-renderer",".ytd-promoted-video-renderer",".ytd-search-pyv-renderer",".ytd-video-masthead-ad-v3-renderer",".ytp-ad-action-interstitial-background-container",".ytp-ad-action-interstitial-slot",".ytp-ad-image-overlay",".ytp-ad-overlay-container",".ytp-ad-progress",".ytp-ad-progress-list",'[class*="ytd-display-ad-"]','[layout*="display-ad-"]','a[href^="http://www.youtube.com/cthru?"]','a[href^="https://www.youtube.com/cthru?"]',"ytd-action-companion-ad-renderer","ytd-banner-promo-renderer","ytd-compact-promoted-video-renderer","ytd-companion-slot-renderer","ytd-display-ad-renderer","ytd-promoted-sparkles-text-search-renderer","ytd-promoted-sparkles-web-renderer","ytd-search-pyv-renderer","ytd-single-option-survey-renderer","ytd-video-masthead-ad-advertiser-info-renderer","ytd-video-masthead-ad-v3-renderer","YTM-PROMOTED-VIDEO-RENDERER"],hideElements=()=>{if(!hiddenCSS)return;const e=hiddenCSS.join(", ")+" { display: none!important; }",r=document.createElement("style");r.textContent=e,document.head.appendChild(r)},observeDomChanges=e=>{new MutationObserver((r=>{e(r)})).observe(document.documentElement,{childList:!0,subtree:!0})},hideDynamicAds=()=>{const e=document.querySelectorAll("#contents > ytd-rich-item-renderer ytd-display-ad-renderer");0!==e.length&&e.forEach((e=>{if(e.parentNode&&e.parentNode.parentNode){const r=e.parentNode.parentNode;"ytd-rich-item-renderer"===r.localName&&(r.style.display="none")}}))},autoSkipAds=()=>{if(document.querySelector(".ad-showing")){const e=document.querySelector("video");e&&e.duration&&(e.currentTime=e.duration,setTimeout((()=>{const e=document.querySelector("button.ytp-ad-skip-button");e&&e.click()}),100))}},overrideObject=(e,r,t)=>{if(!e)return!1;let o=!1;for(const d in e)e.hasOwnProperty(d)&&d===r?(e[d]=t,o=!0):e.hasOwnProperty(d)&&"object"==typeof e[d]&&overrideObject(e[d],r,t)&&(o=!0);return o},jsonOverride=(e,r)=>{const t=JSON.parse;JSON.parse=(...o)=>{const d=t.apply(this,o);return overrideObject(d,e,r),d},Response.prototype.json=new Proxy(Response.prototype.json,{async apply(...t){const o=await Reflect.apply(...t);return overrideObject(o,e,r),o}})};jsonOverride("adPlacements",[]),jsonOverride("playerAds",[]),hideElements(),hideDynamicAds(),autoSkipAds(),observeDomChanges((()=>{hideDynamicAds(),autoSkipAds()}));
]]