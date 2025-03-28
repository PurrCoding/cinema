local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetTexture = surface.SetTexture
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local draw_RoundedBox = draw.RoundedBox
local draw_SimpleText = draw.SimpleText
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local math_Clamp = math.Clamp
local math_Round = math.Round

local color_white = color_white

surface.CreateFont( "VideoInfoLarge", {
	font      = "Open Sans Condensed",
	size      = 148,
	weight    = 700,
	antialias = true
})

surface.CreateFont( "VideoInfoMedium", {
	font      = "Open Sans Condensed",
	size      = 72,
	weight    = 700,
	antialias = true
})

surface.CreateFont( "VideoInfoSmall", {
	font      = "Open Sans Condensed",
	size      = 32,
	weight    = 700,
	antialias = true
})

local gradientDown = surface.GetTextureID("VGUI/gradient_down")
local refreshTexture = surface.GetTextureID("gui/html/refresh")

module( "theater", package.seeall )

LastInfoDraw = 0
local InfoDrawDelay = 3

local LastTheater = nil
local Pos = Vector(0,0,0)
local Ang = Angle(0,0,0)
local InfoScale = 1
local w, h = 0, 0

local LoadingStr = translations:Format("Loading")

local LastTitle, Title = "", ""
local WasFullscreen = false
local panel


function setLastTheater(th)
	LastTheater = th
end

local function DrawVideoInfo( w, h, scale )

	panel = ActivePanel()
	if not IsValid(panel) then return end

	local Theater = LocalPlayer():GetTheater()
	if not Theater then return end

	scale = scale and (1 / scale) * 0.1 or 1 -- scale for screen size fix

	w = w and w * scale or panel:GetWide()
	h = h and h * scale or panel:GetTall()

	-- TODO: Animate things
	-- local fade = math_Clamp((lastInfoView - CurTime()) / 2, 0, 1) * 255

	/* Top Info Background */
	surface_SetDrawColor(0,0,0,255)
	surface_SetTexture(gradientDown)
	surface_DrawTexturedRect(0, 0, w, h)

	-- Attempt to fix white line rendering artifact
	surface_DrawRect(0, -2, w, 4)

	-- Title
	if LastTitle ~= translations:Format( Theater:VideoTitle() ) or WasFullscreen ~= theater.Fullscreen then
		LastTitle = translations:Format( Theater:VideoTitle() )
		WasFullscreen = theater.Fullscreen
		Title = string.reduce( LastTitle, "VideoInfoMedium", w )
	end
	draw.TheaterText( Title, "VideoInfoMedium", 10, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	-- Volume
	draw.TheaterText( translations:Format("Volume"):upper(), "VideoInfoSmall", w - 72, 120, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	draw.TheaterText( GetVolume() .. "%", "VideoInfoMedium", w - 72, 136, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )

	-- Vote Skips
	if NumVoteSkips > 0 then
		draw.TheaterText( translations:Format("Voteskips"):upper(), "VideoInfoSmall", w - 72, 230, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
		draw.TheaterText( NumVoteSkips .. "/" .. ReqVoteSkips, "VideoInfoMedium", w - 72, 246, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	end

	-- Timed video info
	if theater.IsVideoTimed(Theater:VideoType()) then
		local current, duration = Theater:VideoCurrentTime(), Theater:VideoDuration()
		local percent = math_Clamp( (current / duration ) * 100, 0, 100 )

		-- Bar
		local bh = h * 1 / 32
		draw_RoundedBox( 0, 0, h - bh, w, bh, Color(0,0,0,200) )
		draw_RoundedBox( 0, 0, h - bh, w * (percent / 100), bh, color_white )

		-- Current Time
		local strSeconds = string.FormatSeconds(math_Clamp(math_Round(current), 0, duration))
		draw.TheaterText( strSeconds, "VideoInfoMedium", 16, h - bh, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

		-- Duration
		local strDuration = string.FormatSeconds(duration)
		draw.TheaterText( strDuration, "VideoInfoMedium", w - 16, h - bh, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
	end

	-- Loading indicater
	if panel:IsLoading() then
		surface_SetDrawColor(color_white)
		surface_SetTexture(refreshTexture)
		surface_DrawTexturedRectRotated( 32, 128, 64, 64, RealTime() * -256 )
	end

end

local function DrawActiveTheater( bDrawingDepth, bDrawingSkybox )

	if input.IsKeyDown(KEY_Q) then
		LastInfoDraw = CurTime()
	end

	if theater.Fullscreen then return end -- Don't render twice

	if not LastTheater then

		local Theater = LocalPlayer().GetTheater and LocalPlayer():GetTheater() or nil
		if not Theater then
			LastTheater = nil
			return
		end

		local ang = Theater:GetAngles()
		Ang = Angle( ang.p, ang.y, ang.r ) -- don't modify actual theater angle
		Ang:RotateAroundAxis( Ang:Forward(), 90 )

		Pos = Theater:GetPos() + Ang:Right() * 0.01

		w, h = Theater:GetSize()
		InfoScale = w / 10300 -- 10300 seems to produce a good scale

		LastTheater = Theater

	end

	cam_Start3D2D( Pos, Ang, 0.1 )

		-- Draw 'Loading...' incase page takes too long to load
		surface_SetDrawColor( 0, 0, 0, 255 )
		surface_DrawRect( 0, 0, w, h )
		draw_SimpleText( LoadingStr, "VideoInfoLarge", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

		draw.HTMLTexture( theater.ActivePanel(), w, h )

	cam_End3D2D()

	if LastInfoDraw + InfoDrawDelay > CurTime() then
		cam_Start3D2D( Pos, Ang, InfoScale )
			DrawVideoInfo(w, h, InfoScale)
				-- pcall( theater.DrawVideoInfo, w, h, InfoScale )
		cam_End3D2D()
	end

end
hook.Add( "PostDrawOpaqueRenderables", "DrawTheaterScreen", DrawActiveTheater )


local function DrawFullscreen()

	if Fullscreen then

		draw.HTMLTexture( ActivePanel(), ScrW(), ScrH() )

		if LastInfoDraw + InfoDrawDelay > CurTime() then
			DrawVideoInfo( ScrW(), ScrH(), 0.1 )
		end

	end

end
hook.Add( "HUDPaint", "DrawFullscreenInfo", DrawFullscreen )