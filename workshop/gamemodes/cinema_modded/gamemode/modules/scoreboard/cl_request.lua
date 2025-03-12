local table_sort = table.sort
local math_Clamp = math.Clamp
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial

local mouseCodeFunc = {
	[MOUSE_5] = "history.forward();",
	[MOUSE_4] = "history.back();",
}

-- Additional information when hovering the mouse over the video history
local videoInfo = [[
%s

Last Request: %s
Service: %s
Supported: %s]]

function RequestVideoURL( url )

	if IsValid( RequestPanel ) then
		RequestPanel:OnClose()
		RequestPanel:Remove()
	end

	RunConsoleCommand( "cinema_video_request", url )

end

local PANEL = {}
PANEL.HistoryWidth = 300

local CloseTexture = Material( "theater/close.png" )

function PANEL:Init()

	RequestPanel = self

	self:SetFocusTopLevel( true )

	local w = math_Clamp( ScrW() - 100, 800, 1152 + self.HistoryWidth )
	local h = ScrH()
	if h > 800 then
		h = h * 3 / 4
	elseif h > 600 then
		h = h * 7 / 8
	end
	self:SetSize( w, h )

	self.CloseButton = vgui.Create( "DButton", self )
	self.CloseButton:SetZPos( 5 )
	self.CloseButton:NoClipping( true )
	self.CloseButton:SetText( "" )
	self.CloseButton.DoClick = function ( button )
		self:OnClose()
		self:Remove()
	end
	self.CloseButton.Paint = function( panel, w, h )
		DisableClipping( true )
		surface_SetDrawColor( 48, 55, 71 )
		surface_DrawRect( 2, 2, w - 4, h - 4 )

		surface_SetDrawColor( 26, 30, 38 )
		surface_SetMaterial( CloseTexture )
		surface_DrawTexturedRect( 0, 0, w, h )

		DisableClipping( false )
	end

	self.BrowserContainer = vgui.Create( "DPanel", self )

	self.Browser = vgui.Create( "TheaterHTML", self.BrowserContainer )
	self.Browser.isContainer = true

	local searchURL = GetGlobal2String( "cinema_url_search", "" )
	function self.Browser:OnDocumentReady( url )
		if (not self.searchUrl) then self.searchUrl = searchURL end
		if (url == searchURL) then return end

		if IsValid(self) then
			local service = theater.GetServiceByURL(url)

			if (service and istable(service)) then
				service:SearchFunctions(self)
			end
		end
	end

	self.Browser:OpenURL( searchURL )

	self.Controls = vgui.Create( "TheaterHTMLControls", self.BrowserContainer )
	self.Controls:SetHTML( self.Browser )
	self.Controls.BorderSize = 0

	self.History = vgui.Create( "RequestHistory", self )
	self.History:SetPaintBackgroundEnabled(false)

	hook.Add("VGUIMousePressed", "Cinema.RequestInputs", function(pnl, mouseCode)
		if (IsValid(pnl) and pnl.isContainer and mouseCodeFunc[mouseCode]) then
			pnl:RunJavascript(mouseCodeFunc[mouseCode])
		end
	end)
end

function PANEL:OnClose()
	if IsValid(self.Browser) then
		self.Browser:Remove()
	end

	hook.Remove("VGUIMousePressed", "Cinema.RequestInputs")
end

function PANEL:CheckClose()

	local x, y = self:CursorPos()

	-- Remove panel if mouse is clicked outside of itself
	if not (gui.IsGameUIVisible() or gui.IsConsoleVisible()) and
		( x < 0 or x > self:GetWide() or y < 0 or y > self:GetTall() ) then
		self:OnClose()
		self:Remove()
	end

end

function PANEL:PerformLayout()

	local w, h = self:GetSize()

	self.CloseButton:SetSize( 32, 32 )
	self.CloseButton:SetPos( w - 34, 2 )

	self.BrowserContainer:Dock( FILL )

	self.Browser:Dock( FILL )

	self.History:Dock( RIGHT )
	-- self.History:DockMargin( 8, 0, 0, 0 )
	self.History:SetWide( self.HistoryWidth )

	self.Controls:Dock( TOP )

end

vgui.Register( "VideoRequestFrame", PANEL, "EditablePanel" )


-- Custom search and page function made by Shadowsun™ (STEAM_0:1:75888605).
-- Additional filters and tweaks added by Chev (STEAM_0:0:71541002).
local HISTORY = {}
HISTORY.TitleHeight = 64
HISTORY.VidHeight = 32 -- 48

local arrowLeft = Material("icon16/arrow_left.png")
local arrowRight = Material("icon16/arrow_right.png")
local binempty = Material("icon16/bin_empty.png")
local rowLimit = 50

function HISTORY:Init()

	self.Videos = {}
	self.HistoryPageCount = 0
	self.CurrentPageCount = 1

	self:SetSize( 256, 512 )
	self:SetPos( 8, ScrH() / 2 - ( self:GetTall() / 2 ) )

	self.Title = Label( translations:Format("Request_History"), self )
	self.Title:SetFont( "ScoreboardTitle" )
	self.Title:SetColor( Color( 255, 255, 255 ) )
	self.Title:SetContentAlignment(5)
	self.Title:SetTall(self.TitleHeight)
	self.Title:Dock(TOP)

	self.SearchFrame = vgui.Create( "DPanel", self )
	self.SearchFrame:DockMargin(4, 4, 4, 4)
	self.SearchFrame:SetPaintBackground(false)
	self.SearchFrame:SetTall(20)
	self.SearchFrame:Dock(TOP)

	self.SearchField = vgui.Create( "DTextEntry", self.SearchFrame )
	self.SearchField:DockMargin(0, 0, 0, 0)
	self.SearchField:Dock(FILL)
	self.SearchField:SetPlaceholderText( "Search.." )
	self.SearchField:SetUpdateOnType(true)
	self.SearchField.OnChange = function(pnl)
		self:NewSearch()
	end

	-- Clear Button
	self.ClearButton = vgui.Create( "DButton", self.SearchFrame )
	self.ClearButton:SetText( "" )
	self.ClearButton:SetTooltip( "Clear History" )
	self.ClearButton:SetMaterial(binempty)
	self.ClearButton:SetPaintBackground(false)
	self.ClearButton:SetSize( 20, 16 )
	self.ClearButton:DockMargin(0, 0, 0, 0)
	self.ClearButton:Dock(RIGHT)
	self.ClearButton.DoClick = function()
		local queryPnl = Derma_Query("Woah, hold on!\nYou are about to delete all your history, do you really want to do that?", "Info",
			"Yes", function()
				theater.ClearRequestHistory()
				self.VideoList:Clear(true)
			end,
			"No", function() end
		)

		function queryPnl:Paint( w, h )
			draw.RoundedBox( 8, 0, 0, w, h, Color( 146, 146, 146, 230) )
		end
	end

	self.FilterFrame = vgui.Create("DPanel", self)
	self.FilterFrame:DockMargin(4, 4, 4, 4)
	self.FilterFrame:Dock(TOP)
	self.FilterFrame:SetTall(20)
	self.FilterFrame.Paint = nil

	self.VideoTypeLabel = vgui.Create("DLabel", self.FilterFrame)
	self.VideoTypeLabel:SetText("Service:")
	self.VideoTypeLabel:SizeToContents()
	self.VideoTypeLabel:SetContentAlignment(4)
	self.VideoTypeLabel:DockMargin(2, 0, 4, 0)
	self.VideoTypeLabel:Dock(LEFT)

	self.VideoType = vgui.Create("DComboBox", self.FilterFrame)
	self.VideoType:SetWide(128)
	self.VideoType:Dock(LEFT)

	self.VideoType:AddChoice(translations:Format("Request_Filter_AllServices"), nil, true, "icon16/film.png")

	for _, serviceClass in ipairs(theater.GetServiceClasses()) do
		local serviceTb = theater.GetServiceByClass(serviceClass)

		-- Hide hidden services as well as the 'base' service - the player doesn't need to see these
		if serviceTb.Hidden or serviceClass == "base" then continue end

		self.VideoType:AddChoice(serviceTb.Name or serviceClass, serviceClass, false, "icon16/film.png")
	end

	self.VideoType.OnSelect = function(panel, index, value, data)
		self:NewSearch()
	end

	self.SortByLabel = vgui.Create("DLabel", self.FilterFrame)
	self.SortByLabel:SetText("Sort by:")
	self.SortByLabel:SizeToContents()
	self.SortByLabel:SetContentAlignment(5)
	self.SortByLabel:DockMargin(4, 0, 4, 0)
	self.SortByLabel:Dock(LEFT)

	self.SortByBox = vgui.Create("DComboBox", self.FilterFrame)
	self.SortByBox:Dock(FILL)

	self.SortByBox:SetSortItems(false)

	self.SortByBox:AddChoice(translations:Format("Request_Filter_SortBy_LastRequest"), "lastRequest", true, "icon16/database_table.png")
	self.SortByBox:AddChoice(translations:Format("Request_Filter_SortBy_Alphabet"), "title", false, "icon16/database_table.png")
	self.SortByBox:AddChoice(translations:Format("Request_Filter_SortBy_Duration"), "duration", false, "icon16/database_table.png")
	self.SortByBox:AddChoice(translations:Format("Request_Filter_SortBy_RequestCount"), "count", false, "icon16/database_table.png")

	self.SortByBox.OnSelect = function(panel, index, value, data)
		self:NewSearch()
	end

	self.BottomFrame = vgui.Create("DPanel", self)
	self.BottomFrame:DockMargin(4, 4, 4, 4)
	self.BottomFrame.Paint = nil
	self.BottomFrame:SetTall(20)
	self.BottomFrame:Dock(BOTTOM)

	-- Page Forward
	self.PagerRight = vgui.Create( "DButton", self.BottomFrame )
	self.PagerRight:SetText( "" )
	self.PagerRight:SetTooltip( "Next Page" )
	self.PagerRight:SetMaterial(arrowRight)
	self.PagerRight:SetPaintBackground(false)
	self.PagerRight:SetSize( 20, 16 )
	self.PagerRight:Dock(RIGHT)
	self.PagerRight.DoClick = function()
		if self.History[self.CurrentPageCount] then
			self.CurrentPageCount = self.CurrentPageCount + 1
		end

		self:Search()
	end

	-- Page Backward
	self.PagerLeft = vgui.Create( "DButton", self.BottomFrame )
	self.PagerLeft:SetText( "" )
	self.PagerLeft:SetTooltip( "Previous Page" )
	self.PagerLeft:SetMaterial(arrowLeft)
	self.PagerLeft:SetPaintBackground(false)
	self.PagerLeft:SetSize( 20, 16 )
	self.PagerLeft:Dock(LEFT)
	self.PagerLeft.DoClick = function()
		if self.History[self.CurrentPageCount] then
			local page = self.CurrentPageCount - 1

			self.CurrentPageCount = (page == 0 and #self.History or page)
		end

		self:Search()
	end

	-- Page Info
	self.PagerInfo = Label( translations:Format("Request_Paginator_PageOf", 1, 1), self.BottomFrame )
	self.PagerInfo:SetContentAlignment(5)
	self.PagerInfo:SetColor( Color( 255, 255, 255 ) )
	self.PagerInfo:Dock(FILL)
	self.PagerInfo.UpdateText = function(child, curPage, totalPage)
		-- Prevents showing "Page 1 of 0" results, corrects it to "Page 1 of 1"
		totalPage = math.max(totalPage, 1)

		child:SetText(translations:Format("Request_Paginator_PageOf", curPage, totalPage))
	end

	self.ResultsLabel = vgui.Create("DLabel", self)
	self.ResultsLabel:SetContentAlignment(5)
	self.ResultsLabel:SetText(translations:Format("Request_Paginator_ResultCount", 0))
	self.ResultsLabel:DockMargin(4, 8, 4, 8)
	self.ResultsLabel:Dock(BOTTOM)

	self.VideoList = vgui.Create( "TheaterList", self )
	self.VideoList:DockMargin(0, 2, 0, 0)
	self.VideoList:Dock(FILL)

	self:NewSearch()
end

-- Clears the history cache and begins a new search with the user's selected settings
function HISTORY:NewSearch()
	-- Clear History table on Change
	self.History = nil

	local searchQuery = self.SearchField:GetText()
	local _, serviceType = self.VideoType:GetSelected()
	local _, sortBy = self.SortByBox:GetSelected()

	self:Search(searchQuery, serviceType, sortBy)
end

function HISTORY:Search(filter, serviceType, sortBy)

	self.Videos = {}
	self.VideoList:Clear(true)

	-- Default to last request sort
	sortBy = sortBy or "lastRequest"

	-- Check if not History table exists and cache it!
	if not self.History then
		local memArray = {}
		local memArrayCount, memCount = 1,1

		-- Get History from SQL and Sort by Request time
		local raw_history = theater.GetRequestHistory(filter)
		table_sort( raw_history, function( a, b )

			if not a then return false end
			if not b then return true end

			-- Title sorts ascending while other sort methods are descending
			if sortBy == "title" then
				return a[sortBy] < b[sortBy]
			else
				return a[sortBy] > b[sortBy]
			end

		end )

		local service_filtered_history = {}

		if serviceType then
			for _, videoData in pairs(raw_history) do
				if videoData.type == serviceType then
					service_filtered_history[#service_filtered_history + 1] = videoData
				end
			end
		else
			service_filtered_history = raw_history
		end

		local resultsCount = #service_filtered_history
		local resultsText = translations:Format("Request_Paginator_ResultCount", string.Comma(resultsCount))
		self.ResultsLabel:SetText(resultsText)
		self.ResultsLabel:SizeToContents()

		-- Split table into multidimensional tables
		-- Each Keynumber represents a "Page" 
		for i = 1, resultsCount do
			if not memArray[memArrayCount] then
				memArray[memArrayCount] = {}
			end

			memArray[memArrayCount][memCount] = service_filtered_history[i]

			if memCount == rowLimit then
				memArrayCount = memArrayCount + 1
				memCount = 1
			else
				memCount = memCount + 1
			end
		end

		self.History = memArray -- Cache it!
	end

	local history = self.History[self.CurrentPageCount]
	if not history then -- Check if the Page exists
		self.CurrentPageCount = 1 -- Fallback to Page no. 1

		history = self.History[self.CurrentPageCount]
	end

	-- Create and Add video items
	if history then
		for i = 1, #history do
			self:AddVideo( history[i] )
		end
	end

	-- Update Page info
	self.PagerInfo:UpdateText(self.CurrentPageCount, #self.History)
end

function HISTORY:AddVideo( vid )

	if self.Videos[ vid.id ] then
		self.Videos[ vid.id ]:SetVideo( vid )
	else
		local panel = vgui.Create( "RequestVideo", self )
		panel:SetVideo( vid )
		panel:SetVisible( true )
		self.Videos[ vid.id ] = panel
		self.VideoList:AddItem( panel )
	end

end

function HISTORY:RemoveVideo( vid )

	if IsValid( self.Videos[ vid.id ] ) then
		self.VideoList:RemoveItem( self.Videos[ vid.Id ] )
		self.Videos[ vid.id ]:Remove()
		self.Videos[ vid.id ] = nil
	end

end

local Background = Material( "theater/banner.png" )
function HISTORY:Paint( w, h )

	-- Background
	surface_SetDrawColor( 26, 30, 38, 255 )
	surface_DrawRect( 0, 0, self:GetWide(), self:GetTall() )

	-- Title
	surface_SetDrawColor( 141, 38, 33, 255 )
	surface_DrawRect( 0, 0, self:GetWide(), self.Title:GetTall() )

	-- Title Background
	surface_SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( Background )
	surface_DrawTexturedRect( 0, -1, 512, self.Title:GetTall() + 1 )


end

function HISTORY:PerformLayout()
end

vgui.Register( "RequestHistory", HISTORY )


local VIDEO = {}
VIDEO.Padding = 8

function VIDEO:Init()

	self:SetTall( HISTORY.VidHeight )

	self.Title = Label( "Unknown", self )
	self.Title:SetFont( "ScoreboardVidTitle" )
	self.Title:SetColor( Color( 255, 255, 255 ) )

	self.Duration = Label( "0:00", self )
	self.Duration:SetFont( "ScoreboardVidDuration" )
	self.Duration:SetColor( Color( 255, 255, 255 ) )

	self.Requests = Label( "1 request(s)", self )
	self.Requests:SetFont( "ScoreboardVidDuration" )
	self.Requests:SetColor( Color( 255, 255, 255 ) )

	self.RequestVideo = vgui.Create( "DImageButton", self )
	self.RequestVideo:SetSize( 16, 16 )
	self.RequestVideo:SetImage( "theater/play.png" )
	self.RequestVideo:SetTooltip( translations:Format("Request_Video") )
	self.RequestVideo.DoClick = function()
		RequestVideoURL( self.Video.url )
	end
	self.RequestVideo.Think = function()
		if IsMouseOver( self.RequestVideo ) then
			self.RequestVideo:SetAlpha( 255 )
		else
			self.RequestVideo:SetAlpha( 25 )
		end
	end

	self.DeleteVideo = vgui.Create( "DImageButton", self )
	self.DeleteVideo:SetSize( 16, 16 )
	self.DeleteVideo:SetImage( "theater/trashbin.png" )
	self.DeleteVideo:SetTooltip( translations:Format("Request_DeleteTooltip") )
	self.DeleteVideo.DoClick = function()
		theater.RemoveRequestById( self.Video.id )

		-- Lovely DPanelList
		pcall( function(v)
			self:GetParent():GetParent():GetParent():RemoveVideo( v )
		end, self.Video )

	end
	self.DeleteVideo.Think = function()
		if IsMouseOver( self.DeleteVideo ) then
			self.DeleteVideo:SetAlpha( 255 )
		else
			self.DeleteVideo:SetAlpha( 25 )
		end
	end

end

function VIDEO:SetVideo( vid )

	self.Video = vid

	local service = theater.GetServiceByClass(self.Video.type)
	local duration = tonumber(self.Video.duration) > 0 and
		string.FormatSeconds(self.Video.duration) or ""

	self.Title:SetText( self.Video.title )
	self.Duration:SetText( duration )
	self:SetTooltip( videoInfo:format(
		self.Video.title,
		os.date( "%H:%M:%S - %d/%m/%Y" , self.Video.lastRequest ),
		service and service.Name or self.Video.type,
		service and "Yes" or "No"
	) )

	self.Requests:SetText( translations:Format("Request_PlayCount", self.Video.count) )

end

function VIDEO:PerformLayout()

	self.Title:SizeToContents()
	local w = math_Clamp(self.Title:GetWide(), 0, 224)
	self.Title:SetSize(w, self.Title:GetTall())

	self.Title:AlignTop( -2 )
	self.Title:AlignLeft( self.Padding )

	self.Duration:SizeToContents()
	self.Duration:AlignTop( self.Title:GetTall() - 4 )
	self.Duration:AlignLeft( self.Padding )

	self.Requests:SizeToContents()
	self.Requests:SetContentAlignment( 6 )
	self.Requests:AlignTop( self.Title:GetTall() - 4 )
	self.Requests:AlignRight( 64 )

	self.RequestVideo:Center()
	self.RequestVideo:AlignRight( 36 )

	self.DeleteVideo:Center()
	self.DeleteVideo:AlignRight( 10 )

end

function VIDEO:Paint( w, h )

	surface_SetDrawColor( 38, 41, 49, 255 )
	surface_DrawRect( 0, 0, self:GetSize() )

end

vgui.Register( "RequestVideo", VIDEO )
