include("sh_init.lua")

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

end

function ENT:Draw()

	self:DrawModel()
	self:FixOffsets() -- Begone Monitor Grid

	if not self.Attach then return end

	cam.Start3D2D( self.Attach.Pos, self.Attach.Ang, self.ScreenScale )
		pcall( self.DrawThumbnail, self )
	cam.End3D2D()

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

local tw, th, ty, scale, bw, bh, by = nil
function ENT:DrawSubtitle( str, height )

	surface.SetFont( "TheaterInfoMedium" )

	-- Get text dimensions
	tw, th = surface.GetTextSize( str )
	tw = tw + tw * 0.05 -- add additional padding

	-- Calculate hangs
	if string.findFromTable( str, hangs ) then th = th + ( th / 6 ) end

	-- Calculate scale for fitting text
	scale = tw / ThumbWidth
	scale = math.max( scale, 0.88 )

	-- Calculate subtitle bar dimensions
	bw, bh = (ThumbWidth * scale), (ThumbHeight * scale) * 0.16
	bh = math.max( bh, th )

	-- Calculate height offset for bar
	by = height * scale
	by = math.min( by, (ThumbHeight * scale) - bh )

	-- Calculate height offset for text
	ty = (height * scale) + (bh / 2)
	ty = math.min( ty, (ThumbHeight * scale) - bh / 2 )

	cam.Start3D2D( self.Attach.Pos, self.Attach.Ang, ( 1 / scale ) * self.ScreenScale )
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawRect( 0, by, bw, bh )
		draw.TheaterText( str, "TheaterInfoMedium", (ThumbWidth * scale) / 2, ty, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()

end

local name, title
local CurrentName, CurrentTitle
local TranslatedName, TranslatedTitle

function ENT:DrawText()

	name = self:GetTheaterName()
	title = self:GetTitle()

	-- Name has changed
	if name ~= CurrentName then
		CurrentName = name
		TranslatedName = name
		if name == "Invalid" then
			TranslatedName = translations:Format("Invalid")
		end
	end

	-- Title has changed
	if title ~= CurrentTitle then
		CurrentTitle = title
		TranslatedTitle = title
		if title == "NoVideoPlaying" then
			TranslatedTitle = translations:Format("NoVideoPlaying")
		end
	end

	-- Draw name
	self:DrawSubtitle( TranslatedName, 0 )

	-- Draw title
	self:DrawSubtitle( TranslatedTitle, 303 )

end

function ENT:OnRemoveHTML()
	-- Empty
end

function ENT:DrawThumbnail()

	-- Thumbnail isn't set yet
	if self:GetThumbnail() == "" then

		surface.SetDrawColor( 80, 80, 80 )
		surface.SetMaterial( DefaultThumbnail )
		surface.DrawTexturedRect( 0, 0, ThumbWidth - 1, ThumbHeight - 1 )

		return

	else -- Thumbnail is valid

		-- URL has changed
		if (not self.LastURL or self.LastURL ~= self:GetThumbnail()) then

			if IsValid( self.HTML ) then
				self:OnRemoveHTML()
				self.HTML:Remove()
			end

			self.LastURL = self:GetThumbnail()
			self.ThumbMat = nil

		elseif self.LastURL and not self.ThumbMat then

			if not IsValid( self.HTML ) then

				-- Create HTML panel to load thumbnail
				self.HTML = vgui.Create( "Awesomium" )
				self.HTML:SetSize( ThumbWidth, ThumbHeight )
				self.HTML:SetPaintedManually(true)
				self.HTML:SetKeyboardInputEnabled(false)
				self.HTML:SetMouseInputEnabled(false)
				self.HTML:OpenURL( self:GetThumbnail() )

			elseif not self.HTML:IsLoading() and not self.JSDelay then

				-- Force thumbnail sizes
				self.HTML:RunJavascript( [[
					var nodes = document.getElementsByTagName('img');
					for (var i = 0; i < nodes.length; i++) {
						nodes[i].style.width = '100%';
						nodes[i].style.height = '100%';
					}
				]] )

				self.JSDelay = true

				-- Add delay to wait for JS to run
				timer.Simple(0.1, function()

					if not IsValid(self) then return end
					if not IsValid(self.HTML) then return end

					-- Grab HTML material
					self.HTML:UpdateHTMLTexture()
					self.ThumbMat = self.HTML:GetHTMLMaterial()

					-- Do some math to get the correct size
					local pw, ph = self.HTML:GetSize()

					-- Convert to scalar
					self.w = ThumbWidth / pw
					self.h = ThumbHeight / ph

					-- Fix for non-power-of-two html panel size
					pw = pw * (math.power2(pw) / pw)
					ph = ph * (math.power2(ph) / ph)

					self.w = self.w * pw
					self.h = self.h * ph

					-- Free resources after grabbing material
					self:OnRemoveHTML()
					self.HTML:Remove()
					self.JSDelay = nil

				end)

			else
				return -- Waiting for download to finish
			end

		end

	end

	-- Draw the HTML material
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( self.ThumbMat )
	surface.DrawTexturedRect( 0, 0, self.w - 1, self.h - 1 )

end