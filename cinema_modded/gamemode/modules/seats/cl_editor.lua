local math_Round = math.Round
local pairs = pairs
local ipairs = ipairs
local LocalPlayer = LocalPlayer
local Color = Color
local Vector = Vector
local Angle = Angle

-- ConVars and state variables
local DebugEnabled = CreateClientConVar("cinema_seat_debug", "0", false, false)
local EditorEnabled = CreateClientConVar("cinema_seat_editor", "0", false, false)
local ShowSeatNumbers = CreateClientConVar("cinema_seat_debug_numbers", "1", true, false)
local ShowPropNames = CreateClientConVar("cinema_seat_debug_names", "1", true, false)

local CurrentProp = nil
local SeatPositions = {}
local EditingMode = false
local SelectedSeat = nil
local EditorFrame = nil
local PreviewSeats = {} -- Client-side preview entities
local DebugSeatModels = {} -- Store clientside models for cleanup
local PropSeatStorage = {} -- Store seats by prop entity index

-- Visual settings
local PropColor = Color(100, 100, 255, 80)
local EditingPropColor = Color(255, 100, 255, 100)
local TextColor = Color(255, 255, 255, 255)

-- Create 3D preview seat model
function CreatePreviewSeat(pos, ang, selected)
	local seat = ClientsideModel("models/nova/airboat_seat.mdl")
	if not IsValid(seat) then return nil end

	seat:SetPos(pos)
	seat:SetAngles(ang)
	seat:SetNoDraw(false)
	seat:SetRenderMode(RENDERMODE_TRANSALPHA)

	-- Color coding: yellow for normal, orange for selected
	local color = selected and Color(255, 128, 0, 200) or Color(255, 255, 0, 150)
	seat:SetColor(color)

	return seat
end

-- Update all 3D preview seats
function UpdatePreviewSeats()
	-- Clean up existing previews
	for _, seat in pairs(PreviewSeats) do
		if IsValid(seat) then seat:Remove() end
	end
	PreviewSeats = {}

	if not IsValid(CurrentProp) then return end

	-- Create new previews with proper orientation
	for i, seatData in ipairs(SeatPositions) do
		local worldPos = CurrentProp:LocalToWorld(seatData.Pos)
		-- Convert local angle to world angle relative to prop's orientation
		local worldAng = CurrentProp:LocalToWorldAngles(seatData.Ang)

		local preview = CreatePreviewSeat(worldPos, worldAng, i == SelectedSeat)
		if IsValid(preview) then
			PreviewSeats[i] = preview
		end
	end
end

-- ConVar callbacks for debug/editor modes
cvars.AddChangeCallback("cinema_seat_debug", function(cmd, old, new)
	local enabled = tobool(new)

	if enabled then
		hook.Add("PostDrawTranslucentRenderables", "CinemaSeatDebugEditor", DrawSeatDebugEditor)
		chat.AddText(Color(100, 255, 100), "[Seat Debug] Enabled - showing seatable props in current location")
	else
		if not EditorEnabled:GetBool() then
			hook.Remove("PostDrawTranslucentRenderables", "CinemaSeatDebugEditor")
		end

		CleanupDebugSeatModels()

		chat.AddText(Color(255, 200, 100), "[Seat Debug] Disabled")
	end
end)

cvars.AddChangeCallback("cinema_seat_editor", function(cmd, old, new)
	local enabled = tobool(new)

	if enabled then
		hook.Add("PostDrawTranslucentRenderables", "CinemaSeatDebugEditor", DrawSeatDebugEditor)
		chat.AddText(Color(100, 255, 100), "[Seat Editor] Editor mode enabled")
	else
		if EditingMode then
			-- Clean up when disabling editor
			for _, seat in pairs(PreviewSeats) do
				if IsValid(seat) then seat:Remove() end
			end
			PreviewSeats = {}

			if IsValid(EditorFrame) then EditorFrame:Close() end

			EditingMode = false
			CurrentProp = nil
			SeatPositions = {}
			SelectedSeat = nil
			chat.AddText(Color(255, 200, 100), "[Seat Editor] Editor disabled")
		end
		if not DebugEnabled:GetBool() then
			hook.Remove("PostDrawTranslucentRenderables", "CinemaSeatDebugEditor")
		end
	end
end)

-- Combined drawing function with location optimization
function DrawSeatDebugEditor()
	local debugMode = DebugEnabled:GetBool()
	local editorMode = EditorEnabled:GetBool()

	if not debugMode and not editorMode then return end

	-- Draw existing seatable props (debug mode)
	if debugMode then
		DrawExistingSeats()
	end

	-- Draw editor interface (editor mode)
	if editorMode and EditingMode then
		DrawSeatEditor()
	end

	-- Draw combined legend
	DrawLegend(debugMode, editorMode)
end

-- Draw existing seats with-in location
function DrawExistingSeats()
	local playerLocation = LocalPlayer():GetLocation()
	if not playerLocation or playerLocation == 0 then
		-- Clean up models when not in a location
		CleanupDebugSeatModels()
		return
	end

	local locationData = Location.GetLocationByIndex(playerLocation)
	if not locationData then
		CleanupDebugSeatModels()
		return
	end

	-- Clean up existing models first
	CleanupDebugSeatModels()

	-- Only check entities within the current location bounds
	for _, ent in pairs(ents.FindInBox(locationData.Min, locationData.Max)) do
		if not IsValid(ent) or not ent:GetModel() then continue end

		local model = ent:GetModel()
		local offsets = ChairOffsets[model]

		if not offsets then continue end

		-- Skip the prop being edited to avoid visual confusion
		if EditingMode and ent == CurrentProp then continue end

		-- Check if this prop has stored edits
		local hasStoredEdits = PropSeatStorage[ent:EntIndex()] ~= nil

		-- Draw prop outline (keep this as Debug3D for prop bounds)
		local propMin, propMax = ent:GetModelBounds()
		propMin = ent:LocalToWorld(propMin)
		propMax = ent:LocalToWorld(propMax)
		local propColor = hasStoredEdits and Color(255, 200, 100, 80) or PropColor
		Debug3D.DrawBox(propMin, propMax, propColor)

		-- Draw prop name if enabled
		if ShowPropNames:GetBool() then
			local propCenter = (propMin + propMax) / 2
			local statusText = hasStoredEdits and " (EDITED)" or ""
			Debug3D.DrawText(propCenter + Vector(0, 0, 30),
				string.GetFileFromFilename(model) .. " (" .. #offsets .. " seats)" .. statusText,
				"VideoInfoSmall", TextColor, 0.4)
		end

		-- Create seat models instead of Debug3D boxes
		for i, offset in ipairs(offsets) do
			local worldPos = ent:LocalToWorld(offset.Pos)

			-- Create clientside seat model
			local seatModel = ClientsideModel("models/nova/airboat_seat.mdl")
			if IsValid(seatModel) then
				seatModel:SetPos(worldPos)

				-- Handle seat angle
				local seatAngle
				if offset.Ang then
					seatAngle = ent:LocalToWorldAngles(offset.Ang)
				else
					-- Match the actual seat system's -90 degree default rotation
					seatAngle = ent:LocalToWorldAngles(Angle(0, -90, 0))
				end
				seatModel:SetAngles(seatAngle)

				-- Set visual properties
				seatModel:SetNoDraw(false)
				seatModel:SetRenderMode(RENDERMODE_TRANSALPHA)

				-- Color coding for different states
				local useTable = ent.UseTable or {}
				if useTable[i] then
					-- Red for occupied seats
					seatModel:SetColor(Color(255, 100, 100, 200))
				else
					-- Green for available seats
					seatModel:SetColor(Color(100, 255, 100, 150))
				end

				-- Store for cleanup
				table.insert(DebugSeatModels, seatModel)

				-- Draw seat number if enabled
				if ShowSeatNumbers:GetBool() then
					Debug3D.DrawText(worldPos + Vector(0, 0, 25),
						"Seat " .. i,
						"VideoInfoSmall", TextColor, 0.3)
				end
			end
		end
	end
end

-- Cleanup function for debug seat models
function CleanupDebugSeatModels()
	for _, model in pairs(DebugSeatModels) do
		if IsValid(model) then
			model:Remove()
		end
	end
	DebugSeatModels = {}
end

-- Draw seat editor interface
function DrawSeatEditor()
	if not IsValid(CurrentProp) then return end

	-- Draw prop being edited with different color
	local propMin, propMax = CurrentProp:GetModelBounds()
	propMin = CurrentProp:LocalToWorld(propMin)
	propMax = CurrentProp:LocalToWorld(propMax)
	Debug3D.DrawBox(propMin, propMax, EditingPropColor)

	-- Draw prop info
	local propCenter = (propMin + propMax) / 2
	Debug3D.DrawText(propCenter + Vector(0, 0, 50),
		"EDITING: " .. string.GetFileFromFilename(CurrentProp:GetModel()),
		"VideoInfoSmall", Color(255, 255, 0, 255), 0.5)
end

-- Draw combined legend
function DrawLegend(debugMode, editorMode)
	local eyePos = LocalPlayer():EyePos()
	local legendText = ""

	if debugMode and editorMode then
		legendText = "Debug: Green=Existing Seats, Editor: Yellow Models=Editing Seats"
	elseif debugMode then
		legendText = "Seat Debug: Green=Available, Red Arrow=Facing Direction"
	elseif editorMode then
		legendText = "Seat Editor: Yellow Models=Preview Seats"
	end

	if legendText ~= "" then
		Debug3D.DrawText(eyePos + Vector(0, 0, 150),
			legendText,
			"VideoInfoSmall", Color(200, 200, 200, 255), 0.5)
	end

	-- Show editor instructions when in editor mode
	if editorMode and EditingMode then
		Debug3D.DrawText(eyePos + Vector(0, 0, 120),
			"Use menu controls to position seats - see 3D preview models",
			"VideoInfoSmall", Color(200, 200, 200, 255), 0.4)
	end
end

-- Menu Panel Definition
local SEAT_EDITOR = {}

function SEAT_EDITOR:Init()
	self:SetSize(380, 550)
	self:SetTitle("Cinema Seat Editor - 3D Preview")
	self:SetDeleteOnClose(true)
	self:SetPos(50, 50) -- Position on left side to see 3D world
	self:MakePopup()

	-- Prop info panel
	self.PropInfo = vgui.Create("DPanel", self)
	self.PropInfo:Dock(TOP)
	self.PropInfo:SetHeight(50)
	self.PropInfo.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(40, 40, 40, 240))
		if IsValid(CurrentProp) then
			draw.SimpleText("Editing: " .. string.GetFileFromFilename(CurrentProp:GetModel()),
				"DermaDefault", 10, 10, Color(255, 255, 255))
			draw.SimpleText("Seats: " .. #SeatPositions,
				"DermaDefault", 10, 25, Color(200, 200, 200))
		end
	end

	-- Seat list with selection
	self.SeatList = vgui.Create("DListView", self)
	self.SeatList:Dock(TOP)
	self.SeatList:SetHeight(120)
	self.SeatList:AddColumn("Seat"):SetFixedWidth(40)
	self.SeatList:AddColumn("X"):SetFixedWidth(50)
	self.SeatList:AddColumn("Y"):SetFixedWidth(50)
	self.SeatList:AddColumn("Z"):SetFixedWidth(50)
	self.SeatList:AddColumn("Yaw"):SetFixedWidth(50)

	self.SeatList.OnRowSelected = function(lst, index, pnl)
		SelectedSeat = index
		self:UpdateControls()
		UpdatePreviewSeats() -- Update 3D visualization
	end

	-- Position controls panel
	self.ControlPanel = vgui.Create("DPanel", self)
	self.ControlPanel:Dock(TOP)
	self.ControlPanel:SetHeight(200)
	self.ControlPanel.Paint = function(s, w, h)
		draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50, 100))
	end

	-- X Position Slider
	self.XSlider = vgui.Create("DNumSlider", self.ControlPanel)
	self.XSlider:SetPos(10, 10)
	self.XSlider:SetSize(350, 25)
	self.XSlider:SetText("X Position")
	self.XSlider:SetMin(-200)
	self.XSlider:SetMax(200)
	self.XSlider:SetDecimals(1)
	self.XSlider.OnValueChanged = function(s, val)
		self:UpdateSeatPosition("x", val)
	end

	-- Y Position Slider
	self.YSlider = vgui.Create("DNumSlider", self.ControlPanel)
	self.YSlider:SetPos(10, 45)
	self.YSlider:SetSize(350, 25)
	self.YSlider:SetText("Y Position")
	self.YSlider:SetMin(-200)
	self.YSlider:SetMax(200)
	self.YSlider:SetDecimals(1)
	self.YSlider.OnValueChanged = function(s, val)
		self:UpdateSeatPosition("y", val)
	end

	-- Z Position Slider
	self.ZSlider = vgui.Create("DNumSlider", self.ControlPanel)
	self.ZSlider:SetPos(10, 80)
	self.ZSlider:SetSize(350, 25)
	self.ZSlider:SetText("Z Position")
	self.ZSlider:SetMin(-50)
	self.ZSlider:SetMax(100)
	self.ZSlider:SetDecimals(1)
	self.ZSlider.OnValueChanged = function(s, val)
		self:UpdateSeatPosition("z", val)
	end

-- Rotation Slider
self.RotSlider = vgui.Create("DNumSlider", self.ControlPanel)
self.RotSlider:SetPos(10, 115)
self.RotSlider:SetSize(350, 25)
self.RotSlider:SetText("Rotation")
self.RotSlider:SetMin(-180)
self.RotSlider:SetMax(180)
self.RotSlider:SetDecimals(0)
self.RotSlider.OnValueChanged = function(s, val)
	self:UpdateSeatRotation(val)
end

-- Quick positioning buttons
local quickPanel = vgui.Create("DPanel", self.ControlPanel)
quickPanel:SetPos(10, 150)
quickPanel:SetSize(350, 40)
quickPanel.Paint = function() end

local centerBtn = vgui.Create("DButton", quickPanel)
centerBtn:SetPos(0, 0)
centerBtn:SetSize(60, 20)
centerBtn:SetText("Center")
centerBtn.DoClick = function()
	self:CenterSelectedSeat()
end

local copyBtn = vgui.Create("DButton", quickPanel)
copyBtn:SetPos(70, 0)
copyBtn:SetSize(60, 20)
copyBtn:SetText("Copy")
copyBtn.DoClick = function()
	self:CopySelectedSeat()
end

local mirrorXBtn = vgui.Create("DButton", quickPanel)
mirrorXBtn:SetPos(140, 0)
mirrorXBtn:SetSize(60, 20)
mirrorXBtn:SetText("Mirror X")
mirrorXBtn.DoClick = function()
	self:MirrorSeats("x")
end

local mirrorYBtn = vgui.Create("DButton", quickPanel)
mirrorYBtn:SetPos(210, 0)
mirrorYBtn:SetSize(60, 20)
mirrorYBtn:SetText("Mirror Y")
mirrorYBtn.DoClick = function()
	self:MirrorSeats("y")
end

-- Action buttons panel
self.ActionPanel = vgui.Create("DPanel", self)
self.ActionPanel:Dock(FILL)

local addBtn = vgui.Create("DButton", self.ActionPanel)
addBtn:SetPos(10, 10)
addBtn:SetSize(80, 30)
addBtn:SetText("Add Seat")
addBtn.DoClick = function()
	self:AddSeat()
end

local removeBtn = vgui.Create("DButton", self.ActionPanel)
removeBtn:SetPos(100, 10)
removeBtn:SetSize(80, 30)
removeBtn:SetText("Remove")
removeBtn.DoClick = function()
	self:RemoveSeat()
end

local arrayBtn = vgui.Create("DButton", self.ActionPanel)
arrayBtn:SetPos(190, 10)
arrayBtn:SetSize(80, 30)
arrayBtn:SetText("Array Y")
arrayBtn.DoClick = function()
	local value = self.ArrayCount and self.ArrayCount:GetValue() or 3
	self:ArraySeats("y", value)
end

-- Array count input
self.ArrayCount = vgui.Create("DTextEntry", self.ActionPanel)
self.ArrayCount:SetPos(280, 10)
self.ArrayCount:SetSize(40, 30)
self.ArrayCount:SetValue("3")

-- Export and close buttons
local exportBtn = vgui.Create("DButton", self.ActionPanel)
exportBtn:SetPos(10, 50)
exportBtn:SetSize(100, 30)
exportBtn:SetText("Export")
exportBtn.DoClick = function()
	self:ExportSeats()
end

local closeBtn = vgui.Create("DButton", self.ActionPanel)
closeBtn:SetPos(270, 50)
closeBtn:SetSize(80, 30)
closeBtn:SetText("Close")
closeBtn.DoClick = function()
	self:Close()
end
end

-- Menu panel methods
function SEAT_EDITOR:UpdateSeatPosition(axis, value)
	if not SelectedSeat or not SeatPositions[SelectedSeat] then return end

	if axis == "x" then
		SeatPositions[SelectedSeat].Pos.x = value
	elseif axis == "y" then
		SeatPositions[SelectedSeat].Pos.y = value
	elseif axis == "z" then
		SeatPositions[SelectedSeat].Pos.z = value
	end

	self:UpdateSeatList()
	UpdatePreviewSeats() -- Real-time 3D update
end

function SEAT_EDITOR:UpdateSeatRotation(yaw)
	if not SelectedSeat or not SeatPositions[SelectedSeat] then return end

	SeatPositions[SelectedSeat].Ang.y = yaw
	UpdatePreviewSeats() -- Real-time 3D update
end

function SEAT_EDITOR:AddSeat()
	if not IsValid(CurrentProp) then return end

	table.insert(SeatPositions, {
		Pos = Vector(0, 0, 20),
		Ang = Angle(0, 0, 0)
	})

	self:UpdateSeatList()
	UpdatePreviewSeats()

	-- Auto-select new seat - get the actual line object
	SelectedSeat = #SeatPositions
	local lines = self.SeatList:GetLines()
	if lines[SelectedSeat] then
		self.SeatList:SelectItem(lines[SelectedSeat])
	end
	self:UpdateControls()
end

function SEAT_EDITOR:RemoveSeat()
	if not SelectedSeat or SelectedSeat > #SeatPositions then return end

	table.remove(SeatPositions, SelectedSeat)
	SelectedSeat = math.min(SelectedSeat, #SeatPositions)
	if SelectedSeat == 0 then SelectedSeat = nil end

	self:UpdateSeatList()
	UpdatePreviewSeats()
end

function SEAT_EDITOR:CenterSelectedSeat()
	if not SelectedSeat or not SeatPositions[SelectedSeat] then return end

	SeatPositions[SelectedSeat].Pos = Vector(0, 0, 20)
	self:UpdateControls()
	self:UpdateSeatList()
	UpdatePreviewSeats()
end

function SEAT_EDITOR:CopySelectedSeat()
	if not SelectedSeat or not SeatPositions[SelectedSeat] then return end

	local seat = SeatPositions[SelectedSeat]
	table.insert(SeatPositions, {
		Pos = Vector(seat.Pos.x, seat.Pos.y, seat.Pos.z),
		Ang = Angle(seat.Ang.p, seat.Ang.y, seat.Ang.r)
	})

	self:UpdateSeatList()
	UpdatePreviewSeats()
end

function SEAT_EDITOR:MirrorSeats(axis)
	if #SeatPositions == 0 then return end

	local originalCount = #SeatPositions
	for i = 1, originalCount do
		local seat = SeatPositions[i]
		local mirroredSeat = {
			Pos = Vector(seat.Pos.x, seat.Pos.y, seat.Pos.z),
			Ang = Angle(seat.Ang.p, seat.Ang.y, seat.Ang.r)
		}

		if axis == "x" then
			mirroredSeat.Pos.x = -mirroredSeat.Pos.x
			mirroredSeat.Ang.y = -mirroredSeat.Ang.y
		elseif axis == "y" then
			mirroredSeat.Pos.y = -mirroredSeat.Pos.y
			mirroredSeat.Ang.y = 180 - mirroredSeat.Ang.y
		end

		table.insert(SeatPositions, mirroredSeat)
	end

	self:UpdateSeatList()
	UpdatePreviewSeats()
end

function SEAT_EDITOR:ArraySeats(axis, count)
	if not SelectedSeat or not SeatPositions[SelectedSeat] then return end

	local baseSeat = SeatPositions[SelectedSeat]
	local spacing = 40

	for i = 1, count - 1 do
		local newSeat = {
			Pos = Vector(baseSeat.Pos.x, baseSeat.Pos.y, baseSeat.Pos.z),
			Ang = Angle(baseSeat.Ang.p, baseSeat.Ang.y, baseSeat.Ang.r)
		}

		if axis == "x" then
			newSeat.Pos.x = newSeat.Pos.x + (spacing * i)
		elseif axis == "y" then
			newSeat.Pos.y = newSeat.Pos.y + (spacing * i)
		end

		table.insert(SeatPositions, newSeat)
	end

	self:UpdateSeatList()
	UpdatePreviewSeats()
end

function SEAT_EDITOR:UpdateSeatList()
	self.SeatList:Clear()
	for i, seat in ipairs(SeatPositions) do
		self.SeatList:AddLine(i,
			math_Round(seat.Pos.x, 1),
			math_Round(seat.Pos.y, 1),
			math_Round(seat.Pos.z, 1),
			math_Round(seat.Ang.y, 0))
	end
end

function SEAT_EDITOR:UpdateControls()
	if not SelectedSeat or not SeatPositions[SelectedSeat] then return end

	local seat = SeatPositions[SelectedSeat]
	self.XSlider:SetValue(seat.Pos.x)
	self.YSlider:SetValue(seat.Pos.y)
	self.ZSlider:SetValue(seat.Pos.z)
	self.RotSlider:SetValue(seat.Ang.y)
end

function SEAT_EDITOR:ExportSeats()
	if #SeatPositions == 0 then
		chat.AddText(Color(255, 100, 100), "[Seat Editor] No seats to export!")
		return
	end

	local modelPath = CurrentProp:GetModel()
	local existingOffsets = ChairOffsets[modelPath]

	-- Show what we're replacing
	if existingOffsets then
		chat.AddText(Color(255, 200, 100), "[Seat Editor] Replacing " .. #existingOffsets .. " existing seats with " .. #SeatPositions .. " new seats")
	end

	local exportStr = '["' .. modelPath .. '"] = {\n'

	for i, seat in ipairs(SeatPositions) do
		exportStr = exportStr .. '\t{ Pos = Vector(' ..
			math.Round(seat.Pos.x, 1) .. ', ' ..
			math.Round(seat.Pos.y, 1) .. ', ' ..
			math.Round(seat.Pos.z, 1) .. '), Ang = Angle(' ..
			math.Round(seat.Ang.p, 1) .. ', ' ..
			math.Round(seat.Ang.y, 1) .. ', ' ..
			math.Round(seat.Ang.r, 1) .. ') }'

		if i < #SeatPositions then
			exportStr = exportStr .. ','
		end
		exportStr = exportStr .. '\n'
	end

	exportStr = exportStr .. '},'

	SetClipboardText(exportStr)
	chat.AddText(Color(100, 255, 100), "[Seat Editor] Exported " .. #SeatPositions .. " seats to clipboard!")
	print("=== SEAT EDITOR EXPORT ===")
	print("-- Replace the existing entry in ChairOffsets or add to map-specific file")
	print(exportStr)
	print("=== END EXPORT ===")
end

function SEAT_EDITOR:Close()
	-- Clean up preview seats
	for _, seat in pairs(PreviewSeats) do
		if IsValid(seat) then seat:Remove() end
	end
	PreviewSeats = {}

	-- Store current seat data before closing if we have a valid prop
	if IsValid(CurrentProp) and #SeatPositions > 0 then
		PropSeatStorage[CurrentProp:EntIndex()] = {
			model = CurrentProp:GetModel(),
			seats = table.Copy(SeatPositions) -- Deep copy the seat positions
		}
		chat.AddText(Color(100, 200, 255), "[Seat Editor] Saved " .. #SeatPositions .. " seats for this prop")
	end

	EditingMode = false
	CurrentProp = nil
	SeatPositions = {}
	SelectedSeat = nil

	self:Remove()
end

vgui.Register("SeatEditor", SEAT_EDITOR, "DFrame")

-- Command to select a prop
concommand.Add("cinema_seat_select", function(ply, cmd, args)
	if not ply:IsAdmin() then return end

	local trace = util.TraceLine({
		start = LocalPlayer():EyePos(),
		endpos = LocalPlayer():EyePos() + LocalPlayer():GetAimVector() * 1000,
		filter = LocalPlayer()
	})

	if not IsValid(trace.Entity) then
		chat.AddText(Color(255, 100, 100), "[Seat Editor] No prop found!")
		return
	end

	CurrentProp = trace.Entity
	EditingMode = true
	SelectedSeat = nil

	local propModel = CurrentProp:GetModel()
	local propIndex = CurrentProp:EntIndex()

	-- Priority order: 1. Stored edits, 2. ChairOffsets, 3. Empty
	local storedData = PropSeatStorage[propIndex]
	local chairOffsets = ChairOffsets[propModel]

	if storedData and storedData.model == propModel then
		-- Restore previously saved edits
		SeatPositions = table.Copy(storedData.seats)
		chat.AddText(Color(100, 255, 100), "[Seat Editor] Restored " .. #SeatPositions .. " edited seats for: " .. propModel)
	elseif chairOffsets then
		-- Load existing ChairOffsets data with proper angle defaults
		SeatPositions = {}
		for i, offset in ipairs(chairOffsets) do
			local seatAngle
			if offset.Ang then
				-- Use existing angle if defined
				seatAngle = Angle(offset.Ang.p, offset.Ang.y, offset.Ang.r)
			else
				-- Match the actual seat system's -90 degree default rotation
				seatAngle = Angle(0, -90, 0)
			end

			table.insert(SeatPositions, {
				Pos = Vector(offset.Pos.x, offset.Pos.y, offset.Pos.z),
				Ang = seatAngle
			})
		end
		chat.AddText(Color(100, 255, 100), "[Seat Editor] Loaded " .. #SeatPositions .. " existing seats from ChairOffsets for: " .. propModel)
	else
		-- Start fresh
		SeatPositions = {}
		chat.AddText(Color(100, 255, 100), "[Seat Editor] Started new seat configuration for: " .. propModel)
	end

	-- Open the editor
	if IsValid(EditorFrame) then EditorFrame:Close() end
	EditorFrame = vgui.Create("SeatEditor")

	-- Update the interface with loaded data
	if IsValid(EditorFrame) then
		EditorFrame:UpdateSeatList()
		UpdatePreviewSeats()
	end
end)