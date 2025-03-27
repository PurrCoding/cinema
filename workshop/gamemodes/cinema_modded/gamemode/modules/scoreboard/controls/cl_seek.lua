surface.CreateFont( "ScoreboardSeekDuration", { font = "Open Sans Condensed", size = 18, weight = 200 } )
surface.CreateFont( "ScoreboardSeekDurationSmall", { font = "Open Sans Condensed", size = 16, weight = 200 } )

local ceil = math.ceil
local clamp = math.Clamp

local surface = surface
local color_white = color_white
local FormatSeconds = string.FormatSeconds

local BarHeight = 2
local ProgressColor = Color( 28, 100, 157 )

local SEEKBOX = {}

SEEKBOX.KnobSize = 8

function SEEKBOX:Init()

	self.NextUpdate = 0.0

	self.SeekBar = vgui.Create("DSlider", self)
	self.SeekBar.Paint = self.PaintBar
	self.SeekBar:Dock(TOP)
	self.SeekBar:SetMouseInputEnabled( true )

	self.SeekBar.Knob:SetSize( self.KnobSize, self.KnobSize )
	self.SeekBar.Knob.Paint = self.PaintKnob

	self.SeekBar.OnValueChanged = function(panel, x, y)
		if panel:IsEditing() then
			local seekTime = ceil(panel.m_fSlideX * self.Media.duration)
			self.TimeLbl:SetText( FormatSeconds( seekTime ) )
		end
	end

	self.SeekBar.Knob.OnMousePressed = function( panel, mousecode )
		DButton.OnMousePressed( panel, mousecode )
	end

	self.SeekBar.Knob.OnMouseReleased = function( panel, mousecode )
		DButton.OnMouseReleased( panel, mousecode )

		local seekTime = ceil(self.SeekBar.m_fSlideX * self.Media.duration)
		self.SeekBar:SetSlideX( self.SeekBar.m_fSlideX )

		RunConsoleCommand( "cinema_seek", seekTime )
	end
	
	-- Handling mouse clicks on the slider because some silly people not knows you need to hold the knob like me
	self.SeekBar.OnMousePressed = function(panel, mousecode)
		local x, y = panel:CursorPos()
		local newSlideX = x / panel:GetWide()
		panel:SetSlideX(newSlideX)
	
		local seekTime = ceil(newSlideX * self.Media.duration)
		self.TimeLbl:SetText(FormatSeconds(seekTime))
	
		RunConsoleCommand("cinema_seek", seekTime)
        end
	
	for _, child in pairs( self.SeekBar:GetChildren() ) do
		if child ~= self.SeekBar.Knob then
			child:Remove()
		end
	end

	self.TimeLbl = vgui.Create( "DLabel", self )
	self.TimeLbl:SetFont( "ScoreboardSeekDuration" )
	self.TimeLbl:SetText( "" )
	self.TimeLbl:SetTextColor( color_white )

	self.DividerLbl = vgui.Create( "DLabel", self )
	self.DividerLbl:SetText( "/" )
	self.DividerLbl:SetFont( "ScoreboardSeekDurationSmall" )
	-- self.DividerLbl:SetTextColor( color_white )

	self.DurationLbl = vgui.Create( "DLabel", self )
	self.DurationLbl:SetText( "" )
	self.DurationLbl:SetFont( "ScoreboardSeekDurationSmall" )
	-- self.DurationLbl:SetTextColor( color_white )

end


function SEEKBOX:Update()

	local Theater = LocalPlayer():GetTheater() -- get player's theater from their location
	if Theater and Theater._Video then

		local media = Theater._Video
		local current = math.Round(CurTime() - media._VideoStart)
		local duration = math.Round(media._VideoDuration)

		self.Media = {
			current = current,
			duration = duration
		}

		if not self.SeekBar:IsEditing() then
			self.TimeLbl:SetText( FormatSeconds( current ) )
			self.DurationLbl:SetText( FormatSeconds( duration ) )
		end
	else
		self.Media = nil
	end

end

function SEEKBOX:Think()

	if self.Media and not self.SeekBar:IsEditing() then
		local progress = clamp(self.Media.current / self.Media.duration, 0, 1)

		self.SeekBar:SetSlideX( progress )
		self:InvalidateLayout()
	end

	if RealTime() > self.NextUpdate then
		self:Update()
		self:InvalidateLayout()
		self.NextUpdate = RealTime() + 1
	end

end

function SEEKBOX:Paint( w, h )

	-- Background
	surface.SetDrawColor( 38, 41, 49)
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

end


function SEEKBOX:PerformLayout()

	self.TimeLbl:SizeToContents()
	self.DividerLbl:SizeToContents()
	self.DurationLbl:SizeToContents()
	self.SeekBar:SizeToContents()

	self.DurationLbl:CenterVertical()
	self.DurationLbl:AlignRight( 10 )

	self.DividerLbl:CenterVertical()
	self.DividerLbl:MoveLeftOf( self.DurationLbl )

	self.TimeLbl:CenterVertical()
	self.TimeLbl:MoveLeftOf( self.DividerLbl )

	local totalwidth = self.TimeLbl:GetWide() + self.DividerLbl:GetWide() + self.DurationLbl:GetWide()
	self.SeekBar:CenterVertical()
	self.SeekBar:DockMargin(10, 0, totalwidth + 20, 0)

end

function SEEKBOX:PaintKnob( w, h )

	draw.RoundedBoxEx( ceil(w / 2), 0, 0, w, h, color_white, true, true, true, true )

end

function SEEKBOX:PaintBar( w, h )

	local midy = ceil( h / 2 )
	local bary = ceil(midy - (BarHeight / 2))

	local progress = self:GetSlideX()

	surface.SetDrawColor( ProgressColor )
	surface.DrawRect( 0, bary, ceil(w * progress), BarHeight )

end

derma.DefineControl( "TheaterSeekBox", "", SEEKBOX, "Panel" )


local SEEKBUTTONS = {}

function SEEKBUTTONS:Init()

	local function createSeekButton(time)
		local panel = vgui.Create("TheaterButton", self)
		panel:SetText( ("%ss"):format(time) )
		panel:Dock(LEFT)
		panel.DoClick = function(self)
			RunConsoleCommand( "cinema_seek", time )
		end
	end

	createSeekButton("-30")
	createSeekButton("-10")
	createSeekButton("+10")
	createSeekButton("+30")

end

function SEEKBUTTONS:Paint( w, h )

	-- Background
	surface.SetDrawColor( 38, 41, 49)
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

end

derma.DefineControl( "TheaterSeekButtons", "", SEEKBUTTONS, "Panel" )
