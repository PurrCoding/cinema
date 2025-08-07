--[[
    Base Media Service for Cinema Gamemode

    This file serves as the foundation for all media services in the Cinema theater system.
    All video platform services (YouTube, Dailymotion, TikTok, etc.) inherit from this base.

    Key Concepts:
    - SERVICE table: Defines service properties and methods
    - URL Matching: Each service checks if it can handle a given URL
    - Metadata Fetching: Services retrieve video information from platform APIs
    - Client Integration: Services embed video players and control playback

    Examples of services that extend this base:
    - YouTube: Complex ad-blocking and live stream detection
    - Dailymotion: Dual service pattern for regular/live content
    - DLive: Live streaming with mature content handling
    - Bilibili: Multi-part video support with mobile player
--]]

local SERVICE = {
    -- Display name shown to users (e.g., "YouTube", "Dailymotion")
    Name = "Base",

    -- Whether the service supports timed playback (seeking to specific timestamps)
    -- Examples: YouTube = true, Twitch streams = false
    IsTimed = true,

    -- === Service Configuration Properties ===

    -- Whether videos can be stored in cinema_history database for performance
    -- Set to false for services with privacy concerns or temporary content
    IsCacheable = true,

    -- Whether service requires GModPatchTool/GModCEFCodecFix for video playback
    -- Examples: Most embedded players = true, direct HTML5 = false
    NeedsCodecFix = false,

    -- Whether GetVideoInfo receives complete video data instead of just the ID
    -- Used by services like SoundCloud and Internet Archive for rich metadata
    ExtentedVideoInfo = false,

    -- Theater access restriction level
    -- THEATER_NONE = Available in all theaters
    -- THEATER_PRIVATE = Only available in private theaters
    TheaterType = THEATER_NONE
}

--[[
    Service Identification Methods
    These methods help the theater system identify and manage services
--]]

function SERVICE:GetName()
    return self.Name
end

function SERVICE:GetClass()
    return self.ClassName
end

--[[
    URL Processing Methods
    These are the core methods that every service MUST implement
--]]

function SERVICE:Match(url)
    --[[
        Determines if this service can handle the given URL

        Args:
            url (table): Parsed URL object with host, path, query properties

        Returns:
            boolean: true if service can handle this URL

        Examples from real services:
        - YouTube: return url.host and (url.host:match("youtu.be") or url.host:match("youtube.com"))
        - Dailymotion: return url.host and url.host:match("dailymotion.com")
        - TikTok: return url.host and url.host:match("tiktok.com")
    --]]
    return false
end

function SERVICE:GetURLInfo(url)
    --[[
        Extracts video data and metadata from URL structure

        Args:
            url (table): Parsed URL object

        Returns:
            table|false: Video info object with Data field, or false if invalid

        Example implementations:

        -- Simple video ID extraction (Dailymotion pattern):
        if url.path then
            local videoId = url.path:match("^/video/([%a%d-_]+)")
            if videoId then
                local info = { Data = videoId }
                -- Handle start time parameter
                if url.query and url.query.start then
                    info.StartTime = tonumber(url.query.start)
                end
                return info
            end
        end

        -- Multi-part video support (Bilibili pattern):
        local info = {}
        local videoId = url.path:match("BV[%w*]+")
        local part = (url.query and url.query.p) or 1
        if videoId then
            info.Data = videoId .. " " .. part
            return info
        end

        -- File-based services (Internet Archive pattern):
        local identifier, filename = url.path:match("/details/([^/]+)/?([^/]*)")
        if identifier then
            return { Data = identifier .. "," .. (filename or "") }
        end
    --]]
    return false
end

--[[
    HTTP Request Infrastructure
    The base service provides standardized HTTP fetching with proper headers
--]]

local HttpHeaders = {
    ["Cache-Control"] = "no-cache",
    -- ["Connection"] = "keep-alive", -- Commented out to avoid connection issues
}

function SERVICE:Fetch(url, onReceive, onFailure, headers)
    --[[
        Standardized HTTP request method used by all services

        Args:
            url (string): Target URL for the request
            onReceive (function): Callback for successful response (body, length, headers, code)
            onFailure (function): Callback for failed request (error)
            headers (table): Optional additional headers

        This method handles:
        - User-Agent spoofing for server requests
        - Header merging and management
        - Response code validation
        - Error handling and callbacks
    --]]

    if SERVER then
        -- Spoof a modern browser user agent to avoid API blocking
        HttpHeaders["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.7.8254.20 Safari/537.36"
    end

    local request = {
        url = url,
        method = "GET",
        headers = table.Merge(table.Copy(HttpHeaders), (headers and table.Copy(headers)) or {}),

        success = function(code, body, headers)
            code = tonumber(code) or 0

            if code == 200 or code == 0 then
                onReceive(body, body:len(), headers, code)
            else
                print("FAILURE: " .. code)
                pcall(onFailure, code)
            end
        end,

        failed = function(err)
            if isfunction(onFailure) then
                pcall(onFailure, err)
            end
        end
    }

    HTTP(request)
end

function SERVICE:GetVideoInfo(data, onSuccess, onFailure)
    --[[
        Fetches video metadata from the platform's API or webpage

        Args:
            data: Video identifier (from GetURLInfo)
            onSuccess (function): Callback for successful metadata retrieval
            onFailure (function): Callback for failed request

        This method should be implemented by each service. Examples:

        -- API-based metadata (Dailymotion pattern):
        local apiUrl = "https://api.dailymotion.com/video/" .. data
        self:Fetch(apiUrl, function(body, length, headers, code)
            local response = util.JSONToTable(body)
            if response and response.title then
                local info = {
                    title = response.title,
                    duration = response.duration,
                    thumbnail = response.thumbnail_url
                }
                -- Handle live streams
                if response.mode == "live" and response.duration == 0 then
                    info.type = "dailymotionlive"
                    info.duration = 0
                end
                onSuccess(info)
            else
                onFailure("Theater_RequestFailed")
            end
        end, onFailure)

        -- HTML parsing metadata (YouTube pattern):
        self:Fetch("https://www.youtube.com/watch?v=" .. data, function(body)
            local status, metadata = pcall(ParseMetaDataFromHTML, body)
            if status then
                onSuccess(metadata)
            else
                onFailure("Failed to parse metadata")
            end
        end, onFailure)
    --]]
    onFailure("GetVideoInfo: No implementation found for Video API.")
end

--[[
    Client-Side Video Integration
    These methods handle video player embedding and control
--]]

if CLIENT then
    -- Standard theater interface injected into all video players
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

    function SERVICE:SearchFunctions(browser)
        --[[
            Optional method for services that support search functionality
            Used to inject search-related JavaScript into browser panels

            Example (YouTube):
            browser:RunJavascript(ADBLOCK_JS) -- Inject ad-blocking code
        --]]
        -- Use in Service
    end

    function SERVICE:CreateWebCrawler(callback)
        --[[
            Creates an invisible DHTML panel for client-side metadata extraction
            Used by services that require JavaScript execution to get video info

            Args:
                callback (function): Called with metadata or error

            Returns:
                panel: DHTML panel object

            Usage pattern:
            function SERVICE:GetMetadata(data, callback)
                local panel = self:CreateWebCrawler(callback)
                panel:OpenURL(videoUrl)
                panel.OnDocumentReady = function()
                    panel:QueueJavascript(METADATA_EXTRACTION_JS)
                end
            end
        --]]

        local panel = vgui.Create("DHTML")
        panel:SetSize(100, 100)
        panel:SetAlpha(0)
        panel:SetMouseInputEnabled(false)

        local serviceName = self:GetName()
        function panel:ConsoleMessage(msg)

            if GetConVar("cinema_html_filter"):GetBool() then
                print(("[%s - Debug]: %s"):format(serviceName, msg))
            end

            -- Handle error messages from JavaScript
            if msg:StartWith("ERROR:") then
                local errmsg = string.sub(msg, 7)
                local code = tonumber(errmsg)

                -- If it's just a number, translate using MediaError codes
                if code then
                    errmsg = util.MEDIA_ERR[code] or util.MEDIA_ERR[5]
                end

                callback({ err = errmsg })
                panel:Remove()
                return
            end

            -- Handle successful metadata extraction
            if msg:StartWith("METADATA:") then
                local metadata = util.JSONToTable(string.sub(msg, 10))

                callback(metadata)
                panel:Remove()
            end
        end

        -- Auto-cleanup after 10 seconds to prevent memory leaks
        timer.Simple(10, function()
            if IsValid(panel) then
                panel:Remove()
            end
        end)

        return panel
    end

    function SERVICE:LoadExFunctions(panel)
        --[[
            Injects the standard theater interface into video player panels
            This ensures consistent volume and seeking controls across all services
        --]]
        panel:QueueJavascript(THEATER_INTERFACE)

        panel:AddFunction("exTheater", "controllerReady", function(data)
            -- Set initial volume when player is ready
            panel:QueueJavascript(
                ("if (window.theater) theater.setVolume(%s)"):format(theater.GetVolume())
            )
        end)
    end

    function SERVICE:LoadVideo(Video, panel)
        --[[
            Main method for loading videos in the theater panel
            This method coordinates the video loading process:
            1. Clears any existing content
            2. Stops animations and intervals
            3. Calls service-specific LoadProvider if available

            Services should implement LoadProvider like this:

            function SERVICE:LoadProvider(Video, panel)
                -- Calculate start time for seeking
                local startTime = math.Round(CurTime() - Video:StartTime())
                if startTime > 0 then startTime = startTime else startTime = 0 end

                -- Open the video URL with timing
                local embedUrl = EMBED_URL:format(Video:Data())
                if self.IsTimed and startTime > 0 then
                    embedUrl = embedUrl .. "&start=" .. startTime
                end
                panel:OpenURL(embedUrl)

                -- Set up player detection and control
                panel.OnDocumentReady = function(pnl)
                    self:LoadExFunctions(pnl)
                    pnl:QueueJavascript(THEATER_JS)
                end
            end
        --]]
        panel.OnDocumentReady = function() end -- Clear any possible remainings of Service code
        panel:Stop() -- Stops all panel animations by clearing its animation list

        -- Stop any remaining JavaScript intervals from previous videos
        panel:RunJavascript("if(typeof checkerInterval !== \"undefined\") { clearInterval(checkerInterval); }")

        if self.LoadProvider then
            self:LoadProvider(Video, panel)
        end
    end

end

--[[
    Service Registration
    Register this base service with the theater system
    All other services inherit from this base through metatable inheritance
--]]
theater.RegisterService("base", SERVICE)

/*
    Common JavaScript Patterns for Services

    Most services implement player detection using this pattern:

    local THEATER_JS = [[
        var checkerInterval = setInterval(function() {
            // Handle platform-specific UI elements
            var consentButton = document.querySelector(".consent-accept");
            if (consentButton) {
                consentButton.click();
            }

            // Find the video player element
            var player = document.querySelector("video") ||
                        document.querySelector(".video-player") ||
                        document.getElementById("player");

            if (player && player.readyState >= 3) {
                clearInterval(checkerInterval);

                // Set up cinema controller
                window.cinema_controller = player;
                exTheater.controllerReady();

                // Optional: Configure player properties
                player.autoplay = true;
                player.style.width = "100%";
                player.style.height = "100%";
            }
        }, 50);
    ]]

    Live Stream Detection Pattern:
    Many services register dual services for live content:

    theater.RegisterService("servicename", SERVICE)
    theater.RegisterService("servicenameLive", {
        Name = "Service Live",
        IsTimed = false,
        NeedsCodecFix = true,
        Hidden = true, -- Prevents direct user selection
        LoadProvider = CLIENT and SERVICE.LoadProvider or function() end
    })
*/