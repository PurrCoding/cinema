include("sh_init.lua")

-- Cache global functions for performance
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize

ENT.RenderGroup = RENDERGROUP_OPAQUE

surface.CreateFont( "TheaterInfoLarge", {
	font      = "Open Sans Condensed",
	size      = 130,
	weight    = 700,
	antialias = true
})

surface.CreateFont( "TheaterInfoMedium", {
	font      = "Open Sans Condensed",
	size      = 72,
	weight    = 700,
	antialias = true
})

local DefaultThumbnail = Material( "theater/static.vmt" )
local ThumbWidth = 480
local ThumbHeight = 360
local RenderScale = 0.197

local AngleOffset = Angle(0,90,90)

function ENT:Initialize()
	local bound = Vector(1,1,1) * 1024
	self:SetRenderBounds( -bound, bound )

	self.ScreenScale = RenderScale * self:GetModelScale()

	-- Cache tables for text dimensions
	self.NameCache = {}
	self.TitleCache = {}
end

function ENT:Draw()
	self:DrawModel()
	self:FixOffsets()

	if not self.Attach then return end

	cam_Start3D2D( self.Attach.Pos, self.Attach.Ang, self.ScreenScale )
		pcall( self.DrawThumbnail, self )
	cam_End3D2D()

	pcall( self.DrawText, self )
end

function ENT:FixOffsets()
	local pos, ang = LocalToWorld( Vector(0.6, self.ScreenScale * ThumbWidth * -0.5, self.ScreenScale * ThumbHeight * 0.5), AngleOffset, self:GetPos(), self:GetAngles() )
	self.Attach = {
		Pos = pos,
		Ang = ang,
	}
end

local hangs = { "p", "g", "y", "q", "j" }

-- Modified to accept pre-calculated cache
function ENT:DrawSubtitle( cache )
	cam_Start3D2D( self.Attach.Pos, self.Attach.Ang, ( 1 / cache.scale ) * self.ScreenScale )
		surface_SetDrawColor( 0, 0, 0, 200 )
		surface_DrawRect( 0, cache.by, cache.bw, cache.bh )
		draw.TheaterText( cache.str, "TheaterInfoMedium", (ThumbWidth * cache.scale) / 2, cache.ty, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam_End3D2D()
end

-- Helper function to calculate subtitle layout
function ENT:CalculateSubtitleCache( str, height )
	local cache = {}
	cache.str = str

	surface_SetFont( "TheaterInfoMedium" )

	-- Get text dimensions
	local tw, th = surface_GetTextSize( str )
	tw = tw + tw * 0.05 -- add additional padding

	-- Calculate hangs
	if string.findFromTable( str, hangs ) then
		th = th + ( th / 6 )
	end

	-- Calculate scale for fitting text
	cache.scale = tw / ThumbWidth
	cache.scale = math.max( cache.scale, 0.88 )

	-- Calculate subtitle bar dimensions
	cache.bw = (ThumbWidth * cache.scale)
	cache.bh = (ThumbHeight * cache.scale) * 0.16
	cache.bh = math.max( cache.bh, th )

	-- Calculate height offset for bar
	cache.by = height * cache.scale
	cache.by = math.min( cache.by, (ThumbHeight * cache.scale) - cache.bh )

	-- Calculate height offset for text
	cache.ty = (height * cache.scale) + (cache.bh / 2)
	cache.ty = math.min( cache.ty, (ThumbHeight * cache.scale) - cache.bh / 2 )

	return cache
end

local name, title
local CurrentName, CurrentTitle
local TranslatedName, TranslatedTitle

function ENT:DrawText()
	name = self:GetTheaterName()
	title = self:GetTitle()

	-- Name has changed - recalculate cache
	if name ~= CurrentName then
		CurrentName = name
		TranslatedName = name
		if name == "Invalid" then
			TranslatedName = translations:Format("Invalid")
		end
		-- Rebuild name cache
		self.NameCache = self:CalculateSubtitleCache( TranslatedName, 0 )
	end

	-- Title has changed - recalculate cache
	if title ~= CurrentTitle then
		CurrentTitle = title
		TranslatedTitle = title
		if title == "NoVideoPlaying" then
			TranslatedTitle = translations:Format("NoVideoPlaying")
		end
		-- Rebuild title cache
		self.TitleCache = self:CalculateSubtitleCache( TranslatedTitle, 303 )
	end

	-- Draw name
	if self.NameCache.str then
		self:DrawSubtitle( self.NameCache )
	end

	-- Only draw title if it's not "NoVideoPlaying"
	if title ~= "NoVideoPlaying" and self.TitleCache.str then
		self:DrawSubtitle( self.TitleCache )
	end
end

function ENT:OnRemoveHTML()
	-- Empty
end

function ENT:DrawThumbnail()
	-- Early return: No thumbnail set yet
	if self:GetThumbnail() == "" then
		surface_SetDrawColor( 80, 80, 80 )
		surface_SetMaterial( DefaultThumbnail )
		surface_DrawTexturedRect( 0, 0, ThumbWidth - 1, ThumbHeight - 1 )
		return
	end

	-- State 1: URL has changed - reset everything
	if not self.LastURL or self.LastURL ~= self:GetThumbnail() then
		if IsValid( self.HTML ) then
			self:OnRemoveHTML()
			self.HTML:Remove()
		end

		self.LastURL = self:GetThumbnail()
		self.ThumbMat = nil
		self.JSDelay = nil
		return
	end

	-- State 2: URL is set but material not loaded yet
	if self.LastURL and not self.ThumbMat then

		-- Create HTML panel if needed
		if not IsValid( self.HTML ) then
			self.HTML = vgui.Create( "HTML" )
			self.HTML:SetSize( ThumbWidth, ThumbHeight )
			self.HTML:SetPaintedManually(true)
			self.HTML:SetKeyboardInputEnabled(false)
			self.HTML:SetMouseInputEnabled(false)

			-- Setup console message listener
			self.HTML.ConsoleMessage = function(pnl, msg)
				if msg == "THUMBNAIL_READY" then
					if not IsValid(self) or not IsValid(self.HTML) then return end

					-- Grab HTML material
					self.HTML:UpdateHTMLTexture()
					self.ThumbMat = self.HTML:GetHTMLMaterial()

					-- Calculate dimensions
					local pw, ph = self.HTML:GetSize()
					self.w = ThumbWidth / pw
					self.h = ThumbHeight / ph

					-- Fix for non-power-of-two html panel size
					pw = pw * (math.power2(pw) / pw)
					ph = ph * (math.power2(ph) / ph)

					self.w = self.w * pw
					self.h = self.h * ph

					-- Cleanup
					self:OnRemoveHTML()
					self.HTML:Remove()
					self.JSDelay = nil
				end
			end

			self.HTML:OpenURL( self:GetThumbnail() )
			return
		end

		-- Wait for page to load
		if self.HTML:IsLoading() then
			return
		end

		-- Setup MutationObserver once page is loaded
		if not self.JSDelay then
			self.JSDelay = true

			-- Inject MutationObserver script
			self.HTML:RunJavascript([[
				(function() {
					const scaleAllImages = () => {
						const images = document.getElementsByTagName('img');
						let allReady = images.length > 0;

						for (let i = 0; i < images.length; i++) {
							const img = images[i];
							if (img.complete && img.naturalWidth > 0) {
								img.style.width = '100%';
								img.style.height = '100%';
								img.style.objectFit = 'fill';
								img.style.position = 'absolute';
								img.style.top = '0';
								img.style.left = '0';
							} else {
								allReady = false;
							}
						}

						return allReady;
					};

					const signalReady = () => {
						// Wait for next frame to ensure styles are applied
						requestAnimationFrame(() => {
							requestAnimationFrame(() => {
								console.log('THUMBNAIL_READY');
							});
						});
					};

					const observer = new MutationObserver(() => {
						if (scaleAllImages()) {
							signalReady();
							observer.disconnect();
						}
					});

					observer.observe(document.body, {
						childList: true,
						subtree: true,
						attributes: true,
						attributeFilter: ['src', 'complete']
					});

					// Check immediately in case images already loaded
					if (scaleAllImages()) {
						signalReady();
					}
				})();
			]])
		end

		return
	end

	-- State 3: Material is ready - draw it
	if self.ThumbMat then
		surface_SetDrawColor( 255, 255, 255, 255 )
		surface_SetMaterial( self.ThumbMat )
		surface_DrawTexturedRect( 0, 0, self.w, self.h )
	end
end