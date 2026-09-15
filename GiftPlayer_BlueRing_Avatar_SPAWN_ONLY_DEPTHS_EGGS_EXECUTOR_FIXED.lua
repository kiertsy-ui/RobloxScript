-- ==========================================
-- CONFIG & SETTINGS
-- ==========================================
local Settings = {
	Balance = 6579516,
	ItemName = "[Luminous] Limited Egg x50",
	ItemPrice = "3,499",
	FakeUsers = {
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},
	RealUsernames = {
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	}
}

local PurchasePrice = 3499

-- Requested badge / selected-recipient state
local SelectedGiftDisplayName = ""
local SelectedGiftUsername = ""
local BadgeEnabled = false
local BadgeTypeIndex = 1
local BadgeTypes = {
	"Developer",
	"Creator",
	"TikTok Creator"
}
local LocalBadgeBillboard = nil

-- ==========================================
-- FORMAT NUMBER
-- ==========================================
local function FormatNumber(n)
	local str = tostring(n)
	local formatted = str

	while true do
		local replaced, count = string.gsub(
			formatted,
			"^(-?%d+)(%d%d%d)",
			"%1,%2"
		)

		formatted = replaced

		if count == 0 then
			break
		end
	end

	return formatted
end

-- ==========================================
-- SERVICES
-- ==========================================
local Players = game:GetService("Players")
local UserService = game:GetService("UserService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ==========================================
-- GUI CONTAINER
-- ==========================================
local UIContainer

local success, coreGui = pcall(function()
	return game:GetService("CoreGui")
end)

if success and coreGui then
	UIContainer = coreGui
else
	UIContainer = PlayerGui
end

if UIContainer:FindFirstChild("RobloxFakeUI") then
	UIContainer.RobloxFakeUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RobloxFakeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.Parent = UIContainer

-- ==========================================
-- ROBUX ICON
-- ==========================================
local function CreateRobuxIcon(parent, size, position)
	local Icon = Instance.new("ImageLabel")
	Icon.Size = size
	Icon.Position = position
	Icon.BackgroundTransparency = 1
	Icon.Image = "rbxasset://textures/ui/common/robux_small.png"
	Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	Icon.ScaleType = Enum.ScaleType.Fit
	Icon.Parent = parent

	return Icon
end

-- ==========================================
-- CONTROL PANEL
-- ==========================================
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(0, 300, 0, 690)
ControlPanel.Position = UDim2.new(0, 20, 0.5, -345)
ControlPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ControlPanel.BorderSizePixel = 0
ControlPanel.Parent = ScreenGui

Instance.new(
	"UICorner",
	ControlPanel
).CornerRadius = UDim.new(0, 8)

local CPad =
	Instance.new(
		"UIPadding",
		ControlPanel
	)

CPad.PaddingTop =
	UDim.new(0, 15)

CPad.PaddingLeft =
	UDim.new(0, 15)

CPad.PaddingRight =
	UDim.new(0, 15)

local CLayout =
	Instance.new(
		"UIListLayout",
		ControlPanel
	)

CLayout.Padding =
	UDim.new(0, 8)

local CTitle =
	Instance.new(
		"TextLabel",
		ControlPanel
	)

CTitle.Size =
	UDim2.new(1, 0, 0, 20)

CTitle.BackgroundTransparency =
	1

CTitle.Text =
	"CONTROL PANEL"

CTitle.TextColor3 =
	Color3.fromRGB(255, 255, 255)

CTitle.Font =
	Enum.Font.GothamBold

CTitle.TextSize =
	14

local function CreateCPLabel(text)
	local lbl =
		Instance.new(
			"TextLabel",
			ControlPanel
		)

	lbl.Size =
		UDim2.new(1, 0, 0, 15)

	lbl.BackgroundTransparency =
		1

	lbl.Text =
		text

	lbl.TextColor3 =
		Color3.fromRGB(
			200,
			200,
			200
		)

	lbl.Font =
		Enum.Font.GothamMedium

	lbl.TextSize =
		12

	lbl.TextXAlignment =
		Enum.TextXAlignment.Left

	return lbl
end

local function CreateCPInput(text, defaultVal)
	local box =
		Instance.new(
			"TextBox",
			ControlPanel
		)

	box.Size =
		UDim2.new(
			1,
			0,
			0,
			25
		)

	box.BackgroundColor3 =
		Color3.fromRGB(
			40,
			40,
			45
		)

	box.BorderSizePixel =
		0

	box.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	box.Font =
		Enum.Font.GothamMedium

	box.TextSize =
		13

	box.Text =
		defaultVal

	box.ClearTextOnFocus =
		false

	Instance.new(
		"UICorner",
		box
	).CornerRadius =
		UDim.new(0, 4)

	return box
end

CreateCPLabel(
	"Balance"
)

local BalanceBox =
	CreateCPInput(
		"",
		FormatNumber(
			Settings.Balance
		)
	)

local UserBoxes = {}

for i = 1, 8 do
	CreateCPLabel(
		"Fake User " .. i
	)

	UserBoxes[i] =
		CreateCPInput(
			"",
			Settings.FakeUsers[i]
		)
end

local ForceTestBtn =
	Instance.new(
		"TextButton",
		ControlPanel
	)

ForceTestBtn.Size =
	UDim2.new(
		1,
		0,
		0,
		30
	)

local HideControlPanelBtn = Instance.new("TextButton", ControlPanel)
HideControlPanelBtn.Name = "HideControlPanel"
HideControlPanelBtn.Size = UDim2.new(1, 0, 0, 30)
HideControlPanelBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 78)
HideControlPanelBtn.BorderSizePixel = 0
HideControlPanelBtn.Text = "HIDE PANEL"
HideControlPanelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideControlPanelBtn.Font = Enum.Font.GothamBold
HideControlPanelBtn.TextSize = 12
HideControlPanelBtn.AutoButtonColor = true
Instance.new("UICorner", HideControlPanelBtn).CornerRadius = UDim.new(0, 4)

-- ==========================================
-- HIDE PANEL / FAKE USER COMPACT MODE
-- ==========================================
local ControlPanelHidden = false
local ControlPanelNormalPosition = ControlPanel.Position
local ControlPanelNormalSize = ControlPanel.Size

-- This button is only visible in hidden mode and sits directly above Fake User 1.
local OpenFullPanelBtn = Instance.new("TextButton", ControlPanel)
OpenFullPanelBtn.Name = "OpenFullPanel"
OpenFullPanelBtn.Size = UDim2.new(0, 100, 0, 28)
OpenFullPanelBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 63)
OpenFullPanelBtn.BorderSizePixel = 0
OpenFullPanelBtn.Text = "OPEN PANEL"
OpenFullPanelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenFullPanelBtn.Font = Enum.Font.GothamBold
OpenFullPanelBtn.TextSize = 10
OpenFullPanelBtn.AutoButtonColor = true
OpenFullPanelBtn.LayoutOrder = -100
OpenFullPanelBtn.Visible = false
Instance.new("UICorner", OpenFullPanelBtn).CornerRadius = UDim.new(0, 4)

local function SetControlPanelHidden(hidden)
	ControlPanelHidden = hidden

	if ControlPanelHidden then
		-- Hidden mode: ONLY the 8 Fake User input boxes + OPEN PANEL button remain.
		-- The input bars are exactly 1/3 of the normal 300px panel width.
		CPad.PaddingTop = UDim.new(0, 0)
		CPad.PaddingLeft = UDim.new(0, 0)
		CPad.PaddingRight = UDim.new(0, 0)
		ControlPanel.BackgroundTransparency = 1
		ControlPanel.Size = UDim2.new(0, 100, 0, 690)
		ControlPanel.Position = ControlPanelNormalPosition

		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") then
				child.Visible = false
			end
		end

		OpenFullPanelBtn.Visible = true
		for i = 1, 8 do
			if UserBoxes[i] then
				UserBoxes[i].Size = UDim2.new(0, 100, 0, 25)
				UserBoxes[i].Visible = true
			end
		end
	else
		-- Full mode: restore the original panel size, padding and all controls.
		ControlPanel.BackgroundTransparency = 0
		ControlPanel.Size = ControlPanelNormalSize
		ControlPanel.Position = ControlPanelNormalPosition
		CPad.PaddingTop = UDim.new(0, 15)
		CPad.PaddingLeft = UDim.new(0, 15)
		CPad.PaddingRight = UDim.new(0, 15)

		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") then
				child.Visible = true
			end
		end

		OpenFullPanelBtn.Visible = false
		for i = 1, 8 do
			if UserBoxes[i] then
				UserBoxes[i].Size = UDim2.new(1, 0, 0, 25)
			end
		end
	end

	HideControlPanelBtn.Text = ControlPanelHidden and "HIDE PANEL" or "HIDE PANEL"
end

HideControlPanelBtn.MouseButton1Click:Connect(function()
	SetControlPanelHidden(true)
end)

OpenFullPanelBtn.MouseButton1Click:Connect(function()
	SetControlPanelHidden(false)
end)



ForceTestBtn.BackgroundColor3 =
	Color3.fromRGB(
		150,
		40,
		200
	)

ForceTestBtn.Text =
	"OPEN: GIFT PLAYER"

ForceTestBtn.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

ForceTestBtn.Font =
	Enum.Font.GothamBold

ForceTestBtn.TextSize =
	12

ForceTestBtn.BorderSizePixel =
	0

Instance.new(
	"UICorner",
	ForceTestBtn
).CornerRadius =
	UDim.new(0, 4)

-- ==========================================
-- BADGE CONTROL
-- ==========================================
local BadgeToggle = Instance.new("TextButton", ControlPanel)
BadgeToggle.Name = "BadgeToggle"
BadgeToggle.Size = UDim2.new(1, 0, 0, 36)
BadgeToggle.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
BadgeToggle.BorderSizePixel = 0
BadgeToggle.Text = "BADGE • OFF"
BadgeToggle.TextColor3 = Color3.fromRGB(240, 240, 245)
BadgeToggle.Font = Enum.Font.GothamBold
BadgeToggle.TextSize = 13
BadgeToggle.AutoButtonColor = false
Instance.new("UICorner", BadgeToggle).CornerRadius = UDim.new(0, 7)
local BadgeToggleStroke = Instance.new("UIStroke", BadgeToggle)
BadgeToggleStroke.Color = Color3.fromRGB(84, 86, 95)
BadgeToggleStroke.Thickness = 1

local BadgeTypeButton = Instance.new("TextButton", ControlPanel)
BadgeTypeButton.Name = "BadgeTypeButton"
BadgeTypeButton.Size = UDim2.new(1, 0, 0, 42)
BadgeTypeButton.BackgroundColor3 = Color3.fromRGB(32, 34, 41)
BadgeTypeButton.BorderSizePixel = 0
BadgeTypeButton.Text = "Developer"
BadgeTypeButton.TextColor3 = Color3.fromRGB(245, 246, 249)
BadgeTypeButton.Font = Enum.Font.GothamBold
BadgeTypeButton.TextSize = 15
BadgeTypeButton.TextXAlignment = Enum.TextXAlignment.Center
BadgeTypeButton.TextYAlignment = Enum.TextYAlignment.Center
BadgeTypeButton.AutoButtonColor = false
Instance.new("UICorner", BadgeTypeButton).CornerRadius = UDim.new(0, 8)
local BadgeTypeStroke = Instance.new("UIStroke", BadgeTypeButton)
BadgeTypeStroke.Color = Color3.fromRGB(71, 73, 82)
BadgeTypeStroke.Thickness = 1

local BadgeHint = Instance.new("TextLabel", ControlPanel)
BadgeHint.Size = UDim2.new(1, 0, 0, 17)
BadgeHint.BackgroundTransparency = 1
BadgeHint.Text = "Badge: ON/OFF • bấm tên để đổi loại"
BadgeHint.TextColor3 = Color3.fromRGB(145, 147, 156)
BadgeHint.Font = Enum.Font.Gotham
BadgeHint.TextSize = 10
BadgeHint.TextXAlignment = Enum.TextXAlignment.Center

-- ==========================================
-- DRAG CONTROL PANEL
-- ==========================================
local dragging = false
local dragInput
local dragStart
local startPos

ControlPanel.InputBegan:Connect(function(input)
	if input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPos = ControlPanel.Position

		input.Changed:Connect(function()
			if input.UserInputState ==
				Enum.UserInputState.End then

				dragging = false
			end
		end)
	end
end)

ControlPanel.InputChanged:Connect(function(input)
	if input.UserInputType ==
		Enum.UserInputType.MouseMovement then

		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput
		and dragging then

		local delta =
			input.Position -
			dragStart

		ControlPanel.Position =
			UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset +
					delta.X,

				startPos.Y.Scale,
				startPos.Y.Offset +
					delta.Y
			)
	end
end)

-- ==========================================
-- DARK OVERLAY
-- ==========================================
local DarkOverlay =
	Instance.new(
		"Frame",
		ScreenGui
	)

DarkOverlay.Size =
	UDim2.new(1, 0, 1, 0)

DarkOverlay.BackgroundColor3 =
	Color3.fromRGB(0, 0, 0)

DarkOverlay.BackgroundTransparency =
	0.5

DarkOverlay.BorderSizePixel =
	0

DarkOverlay.ZIndex = 500

DarkOverlay.Visible =
	false

DarkOverlay.Parent =
	ScreenGui


-- ==========================================
-- SPAWN MODEL TAB
-- ==========================================
local SpawnModelPanel = Instance.new("Frame")
SpawnModelPanel.Name = "SpawnModelPanel"
SpawnModelPanel.Size = ControlPanelNormalSize
SpawnModelPanel.Position = ControlPanelNormalPosition
SpawnModelPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SpawnModelPanel.BorderSizePixel = 0
SpawnModelPanel.Visible = false
SpawnModelPanel.ZIndex = 1500
SpawnModelPanel.Parent = ScreenGui

Instance.new("UICorner", SpawnModelPanel).CornerRadius = UDim.new(0, 8)

local SpawnPanelStroke = Instance.new("UIStroke", SpawnModelPanel)
SpawnPanelStroke.Color = Color3.fromRGB(60, 60, 68)
SpawnPanelStroke.Thickness = 1

local SpawnTitle = Instance.new("TextLabel", SpawnModelPanel)
SpawnTitle.Size = UDim2.new(1, -30, 0, 28)
SpawnTitle.Position = UDim2.new(0, 15, 0, 12)
SpawnTitle.BackgroundTransparency = 1
SpawnTitle.Text = "SPAWN MODEL"
SpawnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnTitle.Font = Enum.Font.GothamBold
SpawnTitle.TextSize = 16
SpawnTitle.TextXAlignment = Enum.TextXAlignment.Left
SpawnTitle.ZIndex = 1502

local SpawnInfo = Instance.new("TextLabel", SpawnModelPanel)
SpawnInfo.Size = UDim2.new(1, -30, 0, 20)
SpawnInfo.Position = UDim2.new(0, 15, 0, 42)
SpawnInfo.BackgroundTransparency = 1
SpawnInfo.Text = "Scanning EGG / LUMINOUS models..."
SpawnInfo.TextColor3 = Color3.fromRGB(165, 165, 175)
SpawnInfo.Font = Enum.Font.Gotham
SpawnInfo.TextSize = 11
SpawnInfo.TextXAlignment = Enum.TextXAlignment.Left
SpawnInfo.ZIndex = 1502

local SpawnHeightLabel = Instance.new("TextLabel", SpawnModelPanel)
SpawnHeightLabel.Size = UDim2.fromOffset(75, 22)
SpawnHeightLabel.Position = UDim2.fromOffset(15, 70)
SpawnHeightLabel.BackgroundTransparency = 1
SpawnHeightLabel.Text = "Height"
SpawnHeightLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
SpawnHeightLabel.Font = Enum.Font.GothamMedium
SpawnHeightLabel.TextSize = 11
SpawnHeightLabel.TextXAlignment = Enum.TextXAlignment.Left
SpawnHeightLabel.ZIndex = 1502

local SpawnHeightBox = Instance.new("TextBox", SpawnModelPanel)
SpawnHeightBox.Size = UDim2.fromOffset(70, 24)
SpawnHeightBox.Position = UDim2.fromOffset(72, 68)
SpawnHeightBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpawnHeightBox.BorderSizePixel = 0
SpawnHeightBox.Text = "0.5"
SpawnHeightBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnHeightBox.Font = Enum.Font.GothamMedium
SpawnHeightBox.TextSize = 12
SpawnHeightBox.ClearTextOnFocus = false
SpawnHeightBox.ZIndex = 1503
Instance.new("UICorner", SpawnHeightBox).CornerRadius = UDim.new(0, 4)

local SpawnSizeLabel = Instance.new("TextLabel", SpawnModelPanel)
SpawnSizeLabel.Size = UDim2.fromOffset(55, 22)
SpawnSizeLabel.Position = UDim2.fromOffset(155, 70)
SpawnSizeLabel.BackgroundTransparency = 1
SpawnSizeLabel.Text = "Size"
SpawnSizeLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
SpawnSizeLabel.Font = Enum.Font.GothamMedium
SpawnSizeLabel.TextSize = 11
SpawnSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SpawnSizeLabel.ZIndex = 1502

local SpawnSizeBox = Instance.new("TextBox", SpawnModelPanel)
SpawnSizeBox.Size = UDim2.fromOffset(70, 24)
SpawnSizeBox.Position = UDim2.fromOffset(195, 68)
SpawnSizeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpawnSizeBox.BorderSizePixel = 0
SpawnSizeBox.Text = "1"
SpawnSizeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnSizeBox.Font = Enum.Font.GothamMedium
SpawnSizeBox.TextSize = 12
SpawnSizeBox.ClearTextOnFocus = false
SpawnSizeBox.ZIndex = 1503
Instance.new("UICorner", SpawnSizeBox).CornerRadius = UDim.new(0, 4)

local SpawnSearchBox = Instance.new("TextBox", SpawnModelPanel)
SpawnSearchBox.Name = "SpawnSearchBox"
SpawnSearchBox.Size = UDim2.new(1, -30, 0, 24)
SpawnSearchBox.Position = UDim2.fromOffset(15, 100)
SpawnSearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
SpawnSearchBox.BorderSizePixel = 0
SpawnSearchBox.PlaceholderText = "Search model name..."
SpawnSearchBox.PlaceholderColor3 = Color3.fromRGB(125, 125, 135)
SpawnSearchBox.Text = ""
SpawnSearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnSearchBox.Font = Enum.Font.GothamMedium
SpawnSearchBox.TextSize = 11
SpawnSearchBox.ClearTextOnFocus = false
SpawnSearchBox.ZIndex = 1503
Instance.new("UICorner", SpawnSearchBox).CornerRadius = UDim.new(0, 4)

local RefreshModelsBtn = Instance.new("TextButton", SpawnModelPanel)
RefreshModelsBtn.Size = UDim2.fromOffset(80, 24)
RefreshModelsBtn.Position = UDim2.new(1, -95, 0, 68)
RefreshModelsBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
RefreshModelsBtn.BorderSizePixel = 0
RefreshModelsBtn.Text = "CLEAR"
RefreshModelsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshModelsBtn.Font = Enum.Font.GothamBold
RefreshModelsBtn.TextSize = 10
RefreshModelsBtn.ZIndex = 1503
Instance.new("UICorner", RefreshModelsBtn).CornerRadius = UDim.new(0, 4)

local SpawnModelList = Instance.new("ScrollingFrame", SpawnModelPanel)
SpawnModelList.Name = "SpawnModelList"
SpawnModelList.Size = UDim2.new(1, -30, 1, -174)
SpawnModelList.Position = UDim2.fromOffset(15, 167)
SpawnModelList.BackgroundTransparency = 1
SpawnModelList.BorderSizePixel = 0
SpawnModelList.ScrollBarThickness = 7
SpawnModelList.ScrollBarImageColor3 = Color3.fromRGB(130, 130, 140)
SpawnModelList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SpawnModelList.CanvasSize = UDim2.new(0, 0, 0, 0)
SpawnModelList.ZIndex = 1502

local SpawnModelListLayout = Instance.new("UIListLayout", SpawnModelList)
SpawnModelListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpawnModelListLayout.Padding = UDim.new(0, 6)

local SpawnModelListPadding = Instance.new("UIPadding", SpawnModelList)
SpawnModelListPadding.PaddingBottom = UDim.new(0, 8)

local SpawnModelEntries = {}
local SpawnModelSources = {}
local function ApplySpawnModelSearch()
	local query = (SpawnSearchBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()

	for index, rowUI in ipairs(SpawnModelEntries) do
		local model = SpawnModelSources[index]
		local matches = true

		if query ~= "" then
			local modelName = model and model.Name or ""
			local fullName = model and model:GetFullName() or ""

			matches =
				modelName:lower():find(query, 1, true) ~= nil
				or fullName:lower():find(query, 1, true) ~= nil
		end

		if rowUI then
			rowUI.Row.Visible = matches
		end
	end
end

SpawnSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	ApplySpawnModelSearch()
end)

RefreshModelsBtn.MouseButton1Click:Connect(function()
	SpawnSearchBox.Text = ""
	ApplySpawnModelSearch()
end)


local SpawnModelSaved = {}
local SpawnModelFirstScanDone = false

local function GetSpawnNumber(box, fallback)
	local value = tonumber((box.Text or ""):gsub(",", "."))
	if not value then
		return fallback
	end
	return value
end

local function ClearSpawnModelList()
	for _, child in ipairs(SpawnModelList:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	table.clear(SpawnModelEntries)
	table.clear(SpawnModelSources)
	table.clear(SpawnModelSaved)
end

local function BuildHeldToolFromModel(sourceModel, modelName)
	if not sourceModel or not sourceModel.Parent or not sourceModel:IsA("Model") then
		return nil
	end

	local backpack = Player:FindFirstChildOfClass("Backpack")
	if not backpack then
		backpack = Player:WaitForChild("Backpack", 5)
	end
	if not backpack then
		return nil
	end

	local sizeScale = math.clamp(GetSpawnNumber(SpawnSizeBox, 1), 0.05, 10)
	local heightOffset = math.clamp(GetSpawnNumber(SpawnHeightBox, 0.5), -10, 10)

	-- Clone the selected model without running copied scripts.
	local oldArchivable = sourceModel.Archivable
	sourceModel.Archivable = true

	local okClone, modelClone = pcall(function()
		return sourceModel:Clone()
	end)

	sourceModel.Archivable = oldArchivable

	if not okClone or not modelClone then
		return nil
	end

	for _, obj in ipairs(modelClone:GetDescendants()) do
		if obj:IsA("Script")
			or obj:IsA("LocalScript")
			or obj:IsA("ModuleScript") then
			obj:Destroy()
		end
	end

	-- Make sure the clone can be physically welded to a Tool Handle.
	local baseParts = {}
	for _, obj in ipairs(modelClone:GetDescendants()) do
		if obj:IsA("BasePart") then
			table.insert(baseParts, obj)
			obj.Anchored = false
			obj.CanCollide = false
			obj.CanTouch = false
			obj.CanQuery = false
			obj.Massless = true
		end
	end

	if #baseParts == 0 then
		modelClone:Destroy()
		return nil
	end

	-- Scale first, then center the model around its bounding-box center.
	pcall(function()
		modelClone:ScaleTo(sizeScale)
	end)

	local bboxCFrame = modelClone:GetBoundingBox()
	local bboxCenter = bboxCFrame.Position
	local currentPivot = modelClone:GetPivot()
	local centeredPivot = CFrame.new(-bboxCenter) * currentPivot
	modelClone:PivotTo(centeredPivot)

	-- Create ONE normal Roblox Tool and put it directly into the real Backpack.
	-- No new Backpack/Inventory GUI is created.
	local tool = Instance.new("Tool")
	tool.Name = tostring(modelName)
	tool.ToolTip = tostring(modelName)
	tool.TextureId = "rbxassetid://128805749258612"
	tool.CanBeDropped = false
	tool.RequiresHandle = true
	tool.ManualActivationOnly = false
	tool.Enabled = true
	tool.Parent = backpack

	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(0.25, 0.25, 0.25)
	handle.Transparency = 1
	handle.CanCollide = false
	handle.CanTouch = false
	handle.CanQuery = false
	handle.Massless = true
	handle.Anchored = false
	handle.CFrame = CFrame.new(0, 0, 0)
	handle.Parent = tool

	modelClone.Name = "HeldModel"
	modelClone.Parent = tool

	-- Preserve every part's relative transform and weld it to the single Tool Handle.
	for _, obj in ipairs(baseParts) do
		if obj.Parent then
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = handle
			weld.Part1 = obj
			weld.Parent = handle
		end
	end

	-- Grip can be adjusted live by changing Height.
	-- The model itself stays centered so it does not fly away from the hand.
	tool.Grip = CFrame.new(0, heightOffset, 0) * CFrame.Angles(0, math.rad(180), 0)

	-- Re-apply size/height values if the TextBoxes are edited while the tool exists.
	local sizeConn
	local heightConn

	sizeConn = SpawnSizeBox.FocusLost:Connect(function()
		local newScale = math.clamp(GetSpawnNumber(SpawnSizeBox, sizeScale), 0.05, 10)
		pcall(function()
			modelClone:ScaleTo(newScale)
		end)
	end)

	heightConn = SpawnHeightBox.FocusLost:Connect(function()
		local newHeight = math.clamp(GetSpawnNumber(SpawnHeightBox, heightOffset), -10, 10)
		tool.Grip = CFrame.new(0, newHeight, 0)
	end)

	tool.AncestryChanged:Connect(function(_, parent)
		if not parent then
			if sizeConn then
				sizeConn:Disconnect()
				sizeConn = nil
			end
			if heightConn then
				heightConn:Disconnect()
				heightConn = nil
			end
		end
	end)

	-- Equip immediately into the player's normal character hand.
	task.defer(function()
		local character = Player.Character or Player.CharacterAdded:Wait()
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoid and character then
			humanoid = character:WaitForChild("Humanoid", 5)
		end

		if humanoid and tool.Parent == backpack then
			pcall(function()
				humanoid:EquipTool(tool)
			end)
		end
	end)

	return tool
end

local function SpawnSelectedModel(sourceModel, modelName)
	if not sourceModel or not sourceModel.Parent then
		return nil
	end

	local ok, toolOrError = pcall(function()
		return BuildHeldToolFromModel(sourceModel, modelName)
	end)

	if not ok then
		warn("[Spawn Model] Spawn failed:", toolOrError)
		return nil
	end

	if not toolOrError then
		warn("[Spawn Model] Could not create Tool:", tostring(modelName))
		return nil
	end

	return toolOrError
end

local function BuildModelViewport(parent, sourceModel)
	local viewport = Instance.new("ViewportFrame", parent)
	viewport.Name = "ModelPreview"
	viewport.Size = UDim2.fromOffset(216, 176)
	viewport.Position = UDim2.fromOffset(4, 4)
	viewport.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	viewport.BorderSizePixel = 0
	viewport.ZIndex = 1504
	viewport.Ambient = Color3.fromRGB(190, 190, 190)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-1, -1, -1)

	Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 5)

	local world = Instance.new("WorldModel")
	world.Parent = viewport

	local camera = Instance.new("Camera")
	camera.Parent = viewport
	viewport.CurrentCamera = camera

	local oldArchivable = sourceModel.Archivable
	sourceModel.Archivable = true

	local okClone, previewClone = pcall(function()
		return sourceModel:Clone()
	end)

	sourceModel.Archivable = oldArchivable

	if not okClone or not previewClone then
		return viewport
	end

	for _, obj in ipairs(previewClone:GetDescendants()) do
		if obj:IsA("Script")
			or obj:IsA("LocalScript")
			or obj:IsA("ModuleScript") then
			obj:Destroy()
		elseif obj:IsA("BasePart") then
			obj.Anchored = true
			obj.CanCollide = false
			obj.CanTouch = false
			obj.CanQuery = false
		end
	end

	previewClone.Parent = world

	local bboxCFrame, bboxSize = previewClone:GetBoundingBox()
	local center = bboxCFrame.Position
	previewClone:PivotTo(CFrame.new(-center) * previewClone:GetPivot())

	local maxDim = math.max(bboxSize.X, bboxSize.Y, bboxSize.Z, 0.1)
	local distance = maxDim * 2.25
	camera.CFrame = CFrame.new(
		Vector3.new(distance * 0.72, distance * 0.45, distance),
		Vector3.new(0, 0, 0)
	)

	return viewport
end

local function SetSavedRowVisual(rowUI, saved)
	if not rowUI then
		return
	end

	local saveButton = rowUI.SaveButton
	local spawnButton = rowUI.SpawnButton
	if saved then
		rowUI.Row.BackgroundColor3 = Color3.fromRGB(53, 43, 24)
		if saveButton then
			saveButton.Text = "SAVED"
			saveButton.BackgroundColor3 = Color3.fromRGB(255, 190, 60)
		end
	else
		rowUI.Row.BackgroundColor3 = Color3.fromRGB(40, 40, 47)
		if saveButton then
			saveButton.Text = "SAVE"
			saveButton.BackgroundColor3 = Color3.fromRGB(95, 95, 105)
		end
	end

	if spawnButton then
		spawnButton.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
	end
end

local SavedRowOrder = -100000

local function MoveRowToTop(row)
	if row and row.Parent == SpawnModelList then
		row.LayoutOrder = SavedRowOrder
		SavedRowOrder += 1
	end
end

local function AddSpawnModelEntry(sourceModel)
	local displayName = sourceModel:GetFullName()

	local row = Instance.new("Frame", SpawnModelList)
	row.Name = "SpawnModelRow"
	row.Size = UDim2.new(1, -8, 0, 190)
	row.BackgroundColor3 = Color3.fromRGB(40, 40, 47)
	row.BorderSizePixel = 0
	row.ZIndex = 1503
	row.LayoutOrder = #SpawnModelEntries + 1

	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

	BuildModelViewport(row, sourceModel)

	local nameLabel = Instance.new("TextLabel", row)
	nameLabel.Size = UDim2.new(1, -330, 0, 24)
	nameLabel.Position = UDim2.fromOffset(228, 8)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = sourceModel.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextSize = 11
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.ZIndex = 1505

	local pathLabel = Instance.new("TextLabel", row)
	pathLabel.Size = UDim2.new(1, -330, 0, 15)
	pathLabel.Position = UDim2.fromOffset(228, 40)
	pathLabel.BackgroundTransparency = 1
	pathLabel.Text = displayName
	pathLabel.TextColor3 = Color3.fromRGB(130, 130, 140)
	pathLabel.Font = Enum.Font.Gotham
	pathLabel.TextSize = 8
	pathLabel.TextXAlignment = Enum.TextXAlignment.Left
	pathLabel.TextTruncate = Enum.TextTruncate.AtEnd
	pathLabel.ZIndex = 1505

	local saveBtn = Instance.new("TextButton", row)
	saveBtn.Name = "SaveModel"
	saveBtn.Size = UDim2.fromOffset(58, 28)
	saveBtn.Position = UDim2.new(1, -164, 0, 78)
	saveBtn.BackgroundColor3 = Color3.fromRGB(95, 95, 105)
	saveBtn.BorderSizePixel = 0
	saveBtn.Text = "SAVE"
	saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	saveBtn.Font = Enum.Font.GothamBold
	saveBtn.TextSize = 9
	saveBtn.AutoButtonColor = true
	saveBtn.ZIndex = 1506
	Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 5)

	local spawnBtn = Instance.new("TextButton", row)
	spawnBtn.Name = "SpawnModel"
	spawnBtn.Size = UDim2.fromOffset(90, 32)
	spawnBtn.Position = UDim2.fromOffset(63, 140)
	spawnBtn.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
	spawnBtn.BorderSizePixel = 0
	spawnBtn.Text = "SPAWN"
	spawnBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
	spawnBtn.Font = Enum.Font.GothamBold
	spawnBtn.TextSize = 11
	spawnBtn.AutoButtonColor = true
	spawnBtn.ZIndex = 1510
	Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 5)

	local rowUI = {
		Row = row,
		SaveButton = saveBtn,
		SpawnButton = spawnBtn,
		Source = sourceModel,
	}

	SpawnModelSaved[sourceModel] = false
	SetSavedRowVisual(rowUI, false)

	saveBtn.Activated:Connect(function()
		if not sourceModel or not sourceModel.Parent then
			return
		end

		SpawnModelSaved[sourceModel] = true
		SetSavedRowVisual(rowUI, true)
		MoveRowToTop(row)
	end)

	spawnBtn.Activated:Connect(function()
		if sourceModel and sourceModel.Parent then
			SpawnSelectedModel(sourceModel, sourceModel.Name)
		end
	end)

	table.insert(SpawnModelEntries, rowUI)
	table.insert(SpawnModelSources, sourceModel)
	ApplySpawnModelSearch()
end

local function ScanAllModelsOnce()
	if SpawnModelFirstScanDone then
		return
	end
	SpawnModelFirstScanDone = true

	ClearSpawnModelList()
	
	local models = {}
	local wantedNames = {
		["depths reroll egg"] = true,
		["depths egg"] = true,
	}
	local foundNames = {}

	-- One full scan only. Only the two requested models are allowed.
	for _, obj in ipairs(game:GetDescendants()) do
		if obj:IsA("Model") then
			local normalizedName = obj.Name:gsub("^%s+", ""):gsub("%s+$", ""):lower()

			if wantedNames[normalizedName] and not foundNames[normalizedName] then
				-- Require at least one visible BasePart so the ViewportFrame
				-- is not empty.
				local hasVisiblePart = false
				for _, child in ipairs(obj:GetDescendants()) do
					if child:IsA("BasePart")
						and child.Transparency < 1
						and child.Size.X > 0
						and child.Size.Y > 0
						and child.Size.Z > 0
					then
						hasVisiblePart = true
						break
					end
				end

				if hasVisiblePart then
					foundNames[normalizedName] = true
					table.insert(models, obj)
				end
			end
		end
	end

	-- Keep the requested order: Depths Reroll Egg first, Depths Egg second.
	table.sort(models, function(a, b)
		local order = {
			["depths reroll egg"] = 1,
			["depths egg"] = 2,
		}
		local ao = order[a.Name:gsub("^%s+", ""):gsub("%s+$", ""):lower()] or 99
		local bo = order[b.Name:gsub("^%s+", ""):gsub("%s+$", ""):lower()] or 99

		if ao == bo then
			return a:GetFullName():lower() < b:GetFullName():lower()
		end
		return ao < bo
	end)

	for index, model in ipairs(models) do
		AddSpawnModelEntry(model)
		if index % 2 == 0 then
			task.wait()
		end
	end

	SpawnInfo.Text = ("Found %d / 2 requested models • scanned once"):format(#models)
end

RefreshModelsBtn.Visible = false

-- Scan every Model once when the script starts.
task.spawn(function()
	ScanAllModelsOnce()
end)

-- ==========================================
-- MAIN TABS
-- ==========================================
local MainTabBar = Instance.new("Frame", ControlPanel)
MainTabBar.Name = "MainTabBar"
MainTabBar.Size = UDim2.new(1, 0, 0, 30)
MainTabBar.BackgroundTransparency = 1
MainTabBar.BorderSizePixel = 0
MainTabBar.LayoutOrder = -200
MainTabBar.ZIndex = 1600

local GiftTabBtn = Instance.new("TextButton", MainTabBar)
GiftTabBtn.Size = UDim2.new(0.5, -4, 1, 0)
GiftTabBtn.Position = UDim2.fromOffset(0, 0)
GiftTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
GiftTabBtn.BorderSizePixel = 0
GiftTabBtn.Text = "GIFT PLAYER"
GiftTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GiftTabBtn.Font = Enum.Font.GothamBold
GiftTabBtn.TextSize = 10
GiftTabBtn.ZIndex = 1601
Instance.new("UICorner", GiftTabBtn).CornerRadius = UDim.new(0, 4)

local SpawnTabBtn = Instance.new("TextButton", MainTabBar)
SpawnTabBtn.Size = UDim2.new(0.5, -4, 1, 0)
SpawnTabBtn.Position = UDim2.new(0.5, 4, 0, 0)
SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
SpawnTabBtn.BorderSizePixel = 0
SpawnTabBtn.Text = "SPAWN MODEL"
SpawnTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnTabBtn.Font = Enum.Font.GothamBold
SpawnTabBtn.TextSize = 10
SpawnTabBtn.ZIndex = 1601
Instance.new("UICorner", SpawnTabBtn).CornerRadius = UDim.new(0, 4)

local CurrentMainTab = "Gift"

local function SetMainTab(tabName)
	if tabName == "Spawn" then
		CurrentMainTab = "Spawn"
		SpawnModelPanel.Position = ControlPanel.Position
		SpawnModelPanel.Size = ControlPanel.Size
		SpawnModelPanel.Visible = true
		ControlPanel.BackgroundTransparency = 1

		GiftTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
		SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)

		-- Keep only the tab bar visible while Spawn Model is open.
		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") and child ~= MainTabBar then
				child.Visible = false
			end
		end

		-- Restore the tab bar after the generic hide pass.
		MainTabBar.Visible = true
	else
		CurrentMainTab = "Gift"
		SpawnModelPanel.Visible = false
		ControlPanel.BackgroundTransparency = 0

		GiftTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
		SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)

		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") then
				child.Visible = true
			end
		end

		if ControlPanelHidden then
			-- Hidden mode is only for the compact Fake User input view.
			for _, child in ipairs(ControlPanel:GetChildren()) do
				if child:IsA("GuiObject") then
					child.Visible = false
				end
			end

			OpenFullPanelBtn.Visible = true
			for i = 1, 8 do
				if UserBoxes[i] then
					UserBoxes[i].Visible = true
				end
			end
		else
			OpenFullPanelBtn.Visible = false
		end
	end
end

GiftTabBtn.MouseButton1Click:Connect(function()
	SetMainTab("Gift")
end)

SpawnTabBtn.MouseButton1Click:Connect(function()
	if ControlPanelHidden then
		return
	end
	SetMainTab("Spawn")
end)

-- Put the Spawn Model window back in the same place when the Control Panel is moved.
ControlPanel:GetPropertyChangedSignal("Position"):Connect(function()
	if SpawnModelPanel.Visible then
		SpawnModelPanel.Position = ControlPanel.Position
	end
end)

ControlPanel:GetPropertyChangedSignal("Size"):Connect(function()
	if SpawnModelPanel.Visible then
		SpawnModelPanel.Size = ControlPanel.Size
	end
end)

-- ==========================================
-- GIFT PLAYER
-- ==========================================
local GiftPrompt =
	Instance.new(
		"Frame",
		DarkOverlay
	)

GiftPrompt.Size =
	UDim2.new(
		0,
		820,
		0,
		610
	)

GiftPrompt.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

GiftPrompt.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

GiftPrompt.BackgroundColor3 =
	Color3.fromRGB(
		44,
		20,
		77
	)

GiftPrompt.Visible =
	false

GiftPrompt.ClipsDescendants =
	true

-- Keep Gift Player above the fullscreen dimmer.
GiftPrompt.Parent = ScreenGui
GiftPrompt.ZIndex = 650

local GiftOuterStroke =
	Instance.new(
		"UIStroke",
		GiftPrompt
	)

GiftOuterStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

GiftOuterStroke.Thickness =
	2

local TiledBackground =
	Instance.new(
		"ImageLabel",
		GiftPrompt
	)

TiledBackground.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

TiledBackground.BackgroundTransparency =
	1

TiledBackground.ScaleType =
	Enum.ScaleType.Tile

TiledBackground.TileSize =
	UDim2.new(
		0,
		30,
		0,
		30
	)

TiledBackground.ImageTransparency =
	0.85

TiledBackground.ImageColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

task.spawn(function()
	for _, obj in pairs(
		PlayerGui:GetDescendants()
	) do
		if obj:IsA("ImageLabel")
			and obj.ScaleType ==
				Enum.ScaleType.Tile
			and obj.Image ~= "" then

			TiledBackground.Image =
				obj.Image

			TiledBackground.TileSize =
				obj.TileSize

			TiledBackground.ImageColor3 =
				obj.ImageColor3

			break
		end
	end
end)

-- ==========================================
-- GIFT HEADER
-- ==========================================
-- HEADER OUTER BORDER (white -> pink -> purple)
local HeaderBorder = Instance.new("Frame", GiftPrompt)
HeaderBorder.Name = "GiftHeaderBorder"
HeaderBorder.Size = UDim2.new(1, 0, 0, 90)
HeaderBorder.Position = UDim2.new(0, 0, 0, 0)
HeaderBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderBorder.BorderSizePixel = 0
HeaderBorder.ZIndex = 5

local HeaderBorderGradient = Instance.new("UIGradient", HeaderBorder)
HeaderBorderGradient.Color = ColorSequence.new({
	-- More pink/purple at the LEFT edge instead of starting from pure white.
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 214, 249)),
	ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 245, 255)),
	ColorSequenceKeypoint.new(0.22, Color3.fromRGB(246, 185, 255)),
	ColorSequenceKeypoint.new(0.38, Color3.fromRGB(181, 35, 255)),
	ColorSequenceKeypoint.new(0.56, Color3.fromRGB(255, 196, 247)),
	ColorSequenceKeypoint.new(0.72, Color3.fromRGB(236, 133, 248)),
	ColorSequenceKeypoint.new(0.86, Color3.fromRGB(219, 82, 255)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168, 42, 255))
})

local HeaderFrame = Instance.new("Frame", GiftPrompt)
HeaderFrame.Name = "GiftHeader"
-- 50% thinner header border: 1.5px inset on every side instead of 3px.
HeaderFrame.Size = UDim2.new(1, -4, 0, 86)
HeaderFrame.Position = UDim2.new(0, 2, 0, 2)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- SUPPLIED HEADER EFFECT
-- Asset 98981360538955 is rendered as a dedicated overlay inside the Gift Player bar.
-- It stays above the gradient/pattern but below the icon, title and close button.
local HeaderGlow =
	Instance.new(
		"ImageLabel",
		HeaderFrame
	)

HeaderGlow.Name =
	"Stroke_98981360538955"

HeaderGlow.Size =
	UDim2.new(
		0,
		542,
		1,
		0
	)

HeaderGlow.Position =
	UDim2.new(
		0,
		271,
		0,
		0
	)

HeaderGlow.AnchorPoint =
	Vector2.new(
		0,
		0
	)

HeaderGlow.BackgroundTransparency =
	1

HeaderGlow.BorderSizePixel =
	0

HeaderGlow.Image =
	"rbxassetid://98981360538955"

HeaderGlow.ImageColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

HeaderGlow.ImageTransparency =
	0

HeaderGlow.ScaleType =
	Enum.ScaleType.Stretch

HeaderGlow.ResampleMode =
	Enum.ResamplerMode.Default

-- Effect from the supplied asset: kept above all header background layers.
HeaderGlow.ZIndex =
	900

HeaderGlow.Visible =
	true

HeaderGlow.Active =
	false

-- Reference header: the supplied effect occupies the RIGHT 2/3 of the 826px bar.
-- Left 1/3 remains the neon base; the 98981360538955 diagonal effect starts around x=275.

-- Force Roblox to load the supplied image before displaying the header.
pcall(function()
	ContentProvider:PreloadAsync({HeaderGlow})
end)

HeaderFrame.BorderSizePixel =
	0

HeaderFrame.ZIndex =
	800

local HeaderGradient =
	Instance.new(
		"UIGradient",
		HeaderFrame
	)

HeaderGradient.Color =
ColorSequence.new({
	-- Reference image measured from left to right; purple regions are intentionally wider:
	-- hot pink -> deep purple -> magenta -> light pink -> magenta -> purple
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(232, 0, 254)),
	ColorSequenceKeypoint.new(0.16, Color3.fromRGB(139, 33, 253)),
	ColorSequenceKeypoint.new(0.34, Color3.fromRGB(166, 12, 254)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(240, 156, 250)),
	ColorSequenceKeypoint.new(0.63, Color3.fromRGB(246, 110, 246)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(196, 21, 254)),
	ColorSequenceKeypoint.new(0.90, Color3.fromRGB(165, 14, 252)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(108, 1, 252))
})

-- HeaderGradient provides the neon magenta/purple base;
-- the supplied image (98981360538955) is confined to the right 2/3
-- to reproduce the diagonal glow/highlight visible in the reference.
local HeaderBottomBorder =
	Instance.new(
		"Frame",
		HeaderFrame
	)

-- Bottom border is handled by the 2px outer header border.
-- Do not add a second black strip here, which causes the visible offset.
HeaderBottomBorder.Size = UDim2.new(1, 0, 0, 0)
HeaderBottomBorder.Position = UDim2.new(0, 0, 1, 0)

HeaderBottomBorder.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

HeaderBottomBorder.BorderSizePixel =
	0

HeaderBottomBorder.ZIndex =
	770

-- ==========================================
-- ==========================================
-- GIFT ICON
-- Exact supplied gift image.
-- ==========================================
local GiftIcon =
	Instance.new(
		"ImageLabel",
		HeaderFrame
	)

GiftIcon.Name =
	"GiftIcon"

GiftIcon.Size =
	UDim2.fromOffset(
		58,
		66
	)

GiftIcon.Position =
	UDim2.new(
		0,
		14,
		0.5,
		-33
	)

GiftIcon.BackgroundTransparency =
	1

GiftIcon.BorderSizePixel =
	0

GiftIcon.Image =
	"rbxassetid://91482729206521"

GiftIcon.ScaleType =
	Enum.ScaleType.Fit

GiftIcon.ImageTransparency =
	0

GiftIcon.ZIndex =
	910

-- GIFT TITLE
-- ==========================================
local TitleText =
	Instance.new(
		"TextLabel",
		HeaderFrame
	)

TitleText.Size =
	UDim2.new(
		0,
		440,
		1,
		0
	)

TitleText.Position =
	UDim2.new(
		0,
		86,
		0,
		0
	)

TitleText.BackgroundTransparency =
	1

TitleText.Text =
	"Gift Player"

TitleText.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

TitleText.Font =
	Enum.Font.FredokaOne

TitleText.TextSize =
	54

TitleText.TextXAlignment =
	Enum.TextXAlignment.Left

TitleText.TextYAlignment =
	Enum.TextYAlignment.Center

TitleText.TextScaled =
	false

TitleText.TextWrapped =
	false

TitleText.ZIndex =
	920

local TitleStroke =
	Instance.new(
		"UIStroke",
		TitleText
	)

TitleStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

TitleStroke.Thickness =
	4.5

-- Supplied square-pattern texture on the Gift Player header.
local HeaderPattern =
	Instance.new(
		"ImageLabel",
		HeaderFrame
	)

HeaderPattern.Name =
	"PatternTexture"

HeaderPattern.Size =
	UDim2.new(
		1,
		0,
		1,
		-4
	)

HeaderPattern.Position =
	UDim2.new(
		0,
		0,
		0,
		0
	)

HeaderPattern.BackgroundTransparency =
	1

HeaderPattern.BorderSizePixel =
	0

HeaderPattern.Image =
	"rbxassetid://90325592797235"

HeaderPattern.ScaleType =
	Enum.ScaleType.Tile

HeaderPattern.TileSize =
	UDim2.fromOffset(
		60,
		60
	)

HeaderPattern.ImageTransparency =
	0.72

HeaderPattern.Active =
	false

HeaderPattern.ZIndex =
	850

-- Keep the supplied effect explicitly visible above the header background/pattern.
-- 98981360538955 is the only header effect asset used here; it covers the right 2/3 only.
HeaderGlow.Visible = true
HeaderGlow.ImageTransparency = 0
HeaderGlow.ZIndex = 900

-- Foreground UI stays above the effect.
GiftIcon.ZIndex = 910


-- ==========================================
-- GIFT CLOSE BUTTON
-- ==========================================
local CloseBtnContainer =
	Instance.new(
		"Frame",
		HeaderFrame
	)

CloseBtnContainer.Size =
	UDim2.new(
		0,
		56,
		0,
		56
	)

CloseBtnContainer.Position =
	UDim2.new(
		1,
		-10,
		0.5,
		0
	)

CloseBtnContainer.AnchorPoint =
	Vector2.new(
		1,
		0.5
	)

CloseBtnContainer.BackgroundColor3 =
	Color3.fromRGB(
		255,
		0,
		0
	)

CloseBtnContainer.ZIndex =
	979

-- Intentionally square: no UICorner.

local CloseContainerStroke =
	Instance.new(
		"UIStroke",
		CloseBtnContainer
	)

CloseContainerStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

CloseContainerStroke.Thickness =
	3

local CloseGiftBtn =
	Instance.new(
		"ImageButton",
		CloseBtnContainer
	)

CloseGiftBtn.Size =
	UDim2.new(
		1,
		0,
		1,
		-6
	)

CloseGiftBtn.Position =
	UDim2.new(
		0,
		0,
		0,
		0
	)

CloseGiftBtn.BackgroundTransparency =
	1

CloseGiftBtn.BorderSizePixel =
	0

CloseGiftBtn.Image =
	""

CloseGiftBtn.ScaleType =
	Enum.ScaleType.Fit

CloseGiftBtn.ImageTransparency =
	0

CloseGiftBtn.AutoButtonColor =
	false

CloseGiftBtn.ZIndex =
	981

local CloseXText =
	Instance.new(
		"TextLabel",
		CloseBtnContainer
	)

CloseXText.Name =
	"CloseX"

CloseXText.Size =
	UDim2.new(
		1,
		0,
		1,
		-4
	)

CloseXText.Position =
	UDim2.new(
		0,
		0,
		0,
		0
	)

CloseXText.BackgroundTransparency =
	1

CloseXText.Text =
	"X"

CloseXText.TextColor3 =
	Color3.fromRGB(255, 255, 255)

CloseXText.Font =
	Enum.Font.FredokaOne

CloseXText.TextSize =
	36

CloseXText.TextXAlignment =
	Enum.TextXAlignment.Center

CloseXText.TextYAlignment =
	Enum.TextYAlignment.Center

CloseXText.ZIndex =
	982

local CloseXStroke =
	Instance.new(
		"UIStroke",
		CloseXText
	)

CloseXStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

CloseXStroke.Thickness =
	4

CloseXText.Active =
	false


CloseGiftBtn.InputBegan:Connect(function(input)
	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		CloseGiftBtn.Size =
			UDim2.new(
				1,
				0,
				1,
				0
			)
	end
end)

CloseGiftBtn.InputEnded:Connect(function(input)
	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		CloseGiftBtn.Size =
			UDim2.new(
				1,
				0,
				1,
				-6
			)
	end
end)

-- ==========================================
-- PLAYER LIST
-- ==========================================
local PlayerList =
	Instance.new(
		"ScrollingFrame",
		GiftPrompt
	)

PlayerList.Size =
	UDim2.new(
		1,
		-24,
		1,
		-115
	)

-- Add a clear gap below the Gift Player header so the first row does not touch it.
PlayerList.Position =
	UDim2.new(
		0,
		12,
		0,
		100
	)

PlayerList.BackgroundTransparency =
	1

PlayerList.BorderSizePixel =
	0

PlayerList.ZIndex =
	690

PlayerList.ScrollBarThickness =
	8

PlayerList.ScrollBarImageColor3 =
	Color3.fromRGB(
		150,
		150,
		150
	)

PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout =
	Instance.new(
		"UIListLayout",
		PlayerList
	)

ListLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

ListLayout.Padding =
	UDim.new(
		0,
		10
	)

local ListPadding =
	Instance.new(
		"UIPadding",
		PlayerList
	)

ListPadding.PaddingTop =
	UDim.new(
		0,
		5
	)

ListPadding.PaddingBottom =
	UDim.new(
		0,
		5
	)

local RowUIList = {}

-- ==========================================
-- LOADING / SELECT ANIMATION
-- ==========================================
local LoadingPrompt =
	Instance.new(
		"Frame",
		DarkOverlay
	)

LoadingPrompt.Size =
	UDim2.new(1, 0, 1, 0)

LoadingPrompt.BackgroundTransparency =
	1

LoadingPrompt.BorderSizePixel =
	0

LoadingPrompt.Visible =
	false

LoadingPrompt.Parent = ScreenGui
LoadingPrompt.ZIndex =
	700

-- ==========================================
-- REAL GIFT BOX + REAL BLUE RING
-- ==========================================
local LoadGiftIcon =
	Instance.new(
		"ImageLabel",
		LoadingPrompt
	)

LoadGiftIcon.Name =
	"LoadingGiftIcon"

LoadGiftIcon.Size =
	UDim2.fromOffset(
		230,
		230
	)

LoadGiftIcon.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

LoadGiftIcon.AnchorPoint =
	Vector2.new(0.5, 0.5)

LoadGiftIcon.BackgroundTransparency =
	1

LoadGiftIcon.BorderSizePixel =
	0

LoadGiftIcon.Image =
	"rbxassetid://99174903737611"

LoadGiftIcon.ImageColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

LoadGiftIcon.ImageTransparency =
	0

LoadGiftIcon.ScaleType =
	Enum.ScaleType.Fit

LoadGiftIcon.ZIndex =
	710

local LoadGiftScale =
	Instance.new(
		"UIScale",
		LoadGiftIcon
	)

LoadGiftScale.Scale =
	1

local LoadRing =
	Instance.new(
		"ImageLabel",
		LoadingPrompt
	)

LoadRing.Name =
	"BlueSelectionRing"

LoadRing.Size =
	UDim2.fromOffset(
		550, 550
	)

LoadRing.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

-- Center the 550x550 ring around the screen center.
-- Without this AnchorPoint, Position(0.5, 0.5) places the ring's TOP-LEFT
-- corner at the center, causing the visible ring to be offset down/right.
LoadRing.AnchorPoint = Vector2.new(0.5, 0.5)

LoadRing.BackgroundTransparency =
	1

LoadRing.BorderSizePixel =
	0

LoadRing.Image =
	"rbxassetid://2565668394"

LoadRing.ImageColor3 =
	Color3.fromRGB(
		0,
		170,
		255
	)

LoadRing.ImageTransparency =
	0

LoadRing.ScaleType =
	Enum.ScaleType.Fit

LoadRing.ZIndex =
	705

pcall(function()
	ContentProvider:PreloadAsync({
		LoadGiftIcon,
		LoadRing
	})
end)

-- ==========================================
-- BUY ITEM
-- TERMS TEXT ĐÃ ĐƯỢC XÓA
-- ==========================================
local BuyPrompt =
	Instance.new(
		"Frame",
		DarkOverlay
	)

BuyPrompt.Size =
	UDim2.new(
		0,
		420,
		0,
		230
	)

BuyPrompt.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

BuyPrompt.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

BuyPrompt.BackgroundColor3 =
	Color3.fromRGB(
		33,
		34,
		38
	)

BuyPrompt.BorderSizePixel =
	0

BuyPrompt.Visible =
	false

-- Keep Buy Item above the fullscreen dimmer.
BuyPrompt.Parent = ScreenGui
BuyPrompt.ZIndex = 800

Instance.new(
	"UICorner",
	BuyPrompt
).CornerRadius =
	UDim.new(
		0,
		8
	)

-- ==========================================
-- BUY TITLE
-- ==========================================
local BuyTitleBar =
	Instance.new(
		"TextLabel",
		BuyPrompt
	)

BuyTitleBar.Size =
	UDim2.new(
		0,
		250,
		0,
		40
	)

BuyTitleBar.Position =
	UDim2.new(
		0,
		20,
		0,
		10
	)

BuyTitleBar.BackgroundTransparency =
	1

BuyTitleBar.Text =
	"Buy item"

BuyTitleBar.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

BuyTitleBar.Font =
	Enum.Font.GothamBold

BuyTitleBar.TextSize =
	18

BuyTitleBar.TextXAlignment =
	Enum.TextXAlignment.Left

BuyTitleBar.TextYAlignment =
	Enum.TextYAlignment.Center

BuyTitleBar.TextScaled =
	false

BuyTitleBar.TextWrapped =
	false

BuyTitleBar.ZIndex =
	810

-- ==========================================
-- BUY BALANCE
-- ==========================================
local TopBalanceContainer =
	Instance.new(
		"Frame",
		BuyPrompt
	)

TopBalanceContainer.Size =
	UDim2.new(
		0,
		150,
		0,
		40
	)

TopBalanceContainer.Position =
	UDim2.new(
		1,
		-210,
		0,
		10
	)

TopBalanceContainer.BackgroundTransparency =
	1

TopBalanceContainer.ZIndex =
	811

local TopLayout =
	Instance.new(
		"UIListLayout",
		TopBalanceContainer
	)

TopLayout.FillDirection =
	Enum.FillDirection.Horizontal

TopLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Right

TopLayout.VerticalAlignment =
	Enum.VerticalAlignment.Center

TopLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

TopLayout.Padding =
	UDim.new(
		0,
		4
	)

local TopIcon =
	CreateRobuxIcon(
		TopBalanceContainer,
		UDim2.new(
			0,
			16,
			0,
			16
		),
		UDim2.new(
			0,
			0,
			0,
			0
		)
	)

TopIcon.LayoutOrder =
	1

TopIcon.ZIndex =
	812

local TopBalanceLbl =
	Instance.new(
		"TextLabel",
		TopBalanceContainer
	)

TopBalanceLbl.AutomaticSize =
	Enum.AutomaticSize.X

TopBalanceLbl.Size =
	UDim2.new(
		0,
		0,
		1,
		0
	)

TopBalanceLbl.BackgroundTransparency =
	1

TopBalanceLbl.Text =
	FormatNumber(
		Settings.Balance
	)

TopBalanceLbl.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

TopBalanceLbl.Font =
	Enum.Font.GothamMedium

TopBalanceLbl.TextSize =
	14

TopBalanceLbl.TextXAlignment =
	Enum.TextXAlignment.Right

TopBalanceLbl.TextYAlignment =
	Enum.TextYAlignment.Center

TopBalanceLbl.TextScaled =
	false

TopBalanceLbl.TextWrapped =
	false

TopBalanceLbl.LayoutOrder =
	2

TopBalanceLbl.ZIndex =
	813

-- ==========================================
-- BUY CLOSE
-- ==========================================
local CloseBtnX =
	Instance.new(
		"TextButton",
		BuyPrompt
	)

CloseBtnX.Size =
	UDim2.new(
		0,
		30,
		0,
		30
	)

CloseBtnX.Position =
	UDim2.new(
		1,
		-35,
		0,
		15
	)

CloseBtnX.BackgroundTransparency =
	1

CloseBtnX.Text =
	"X"

CloseBtnX.TextColor3 =
	Color3.fromRGB(
		200,
		200,
		200
	)

CloseBtnX.Font =
	Enum.Font.GothamMedium

CloseBtnX.TextSize =
	18

CloseBtnX.ZIndex =
	814

-- ==========================================
-- ITEM IMAGE
-- ==========================================
local ItemImage =
	Instance.new(
		"ImageLabel",
		BuyPrompt
	)

ItemImage.Name =
	"ItemImage"

ItemImage.Size =
	UDim2.new(
		0,
		75,
		0,
		75
	)

ItemImage.Position =
	UDim2.new(
		0,
		20,
		0,
		60
	)

ItemImage.BackgroundTransparency =
	1

ItemImage.BorderSizePixel =
	0

ItemImage.ScaleType =
	Enum.ScaleType.Fit

ItemImage.Image =
	"rbxassetid://128805749258712"

ItemImage.ImageColor3 =
	Color3.fromRGB(255, 255, 255)

ItemImage.ImageTransparency =
	0

ItemImage.ZIndex =
	815

-- ==========================================
-- ITEM NAME
-- ==========================================
local ItemName =
	Instance.new(
		"TextLabel",
		BuyPrompt
	)

ItemName.Size =
	UDim2.new(
		0,
		200,
		0,
		24
	)

ItemName.Position =
	UDim2.new(
		0,
		105,
		0,
		63
	)

ItemName.BackgroundTransparency =
	1

ItemName.Text =
	Settings.ItemName

ItemName.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

ItemName.Font =
	Enum.Font.GothamBold

ItemName.TextSize =
	15

ItemName.TextXAlignment =
	Enum.TextXAlignment.Left

ItemName.TextYAlignment =
	Enum.TextYAlignment.Center

ItemName.TextScaled =
	false

ItemName.TextWrapped =
	false

ItemName.ZIndex =
	816

-- ==========================================
-- PRICE
-- ==========================================
local PriceContainer =
	Instance.new(
		"Frame",
		BuyPrompt
	)

PriceContainer.Size =
	UDim2.new(
		0,
		150,
		0,
		22
	)

PriceContainer.Position =
	UDim2.new(
		0,
		105,
		0,
		89
	)

PriceContainer.BackgroundTransparency =
	1

PriceContainer.ZIndex =
	817

local PriceLayout =
	Instance.new(
		"UIListLayout",
		PriceContainer
	)

PriceLayout.FillDirection =
	Enum.FillDirection.Horizontal

PriceLayout.HorizontalAlignment =
	Enum.HorizontalAlignment.Left

PriceLayout.VerticalAlignment =
	Enum.VerticalAlignment.Center

PriceLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

PriceLayout.Padding =
	UDim.new(
		0,
		4
	)

local PriceIcon =
	CreateRobuxIcon(
		PriceContainer,
		UDim2.new(
			0,
			16,
			0,
			16
		),
		UDim2.new(
			0,
			0,
			0,
			0
		)
	)

PriceIcon.LayoutOrder =
	1

PriceIcon.ZIndex =
	818

local PriceLabel =
	Instance.new(
		"TextLabel",
		PriceContainer
	)

PriceLabel.AutomaticSize =
	Enum.AutomaticSize.X

PriceLabel.Size =
	UDim2.new(
		0,
		0,
		1,
		0
	)

PriceLabel.BackgroundTransparency =
	1

PriceLabel.Text =
	Settings.ItemPrice

PriceLabel.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

PriceLabel.Font =
	Enum.Font.GothamBold

PriceLabel.TextSize =
	15

PriceLabel.TextXAlignment =
	Enum.TextXAlignment.Left

PriceLabel.TextYAlignment =
	Enum.TextYAlignment.Center

PriceLabel.TextScaled =
	false

PriceLabel.TextWrapped =
	false

PriceLabel.LayoutOrder =
	2

PriceLabel.ZIndex =
	819

-- ==========================================
-- BUY BUTTON
-- ==========================================
local BuyBtn =
	Instance.new(
		"TextButton",
		BuyPrompt
	)

BuyBtn.Size =
	UDim2.new(
		1,
		-40,
		0,
		40
	)

BuyBtn.Position =
	UDim2.new(
		0,
		20,
		1,
		-70
	)

BuyBtn.BackgroundColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

BuyBtn.BorderSizePixel =
	0

BuyBtn.Text =
	""

BuyBtn.AutoButtonColor =
	false

BuyBtn.ZIndex =
	820

Instance.new(
	"UICorner",
	BuyBtn
).CornerRadius =
	UDim.new(
		0,
		6
	)

local BuyGradient =
	Instance.new(
		"UIGradient",
		BuyBtn
	)

BuyGradient.Color =
	ColorSequence.new({
		ColorSequenceKeypoint.new(
			0,
			Color3.fromRGB(
				45,
				95,
				255
			)
		),

		ColorSequenceKeypoint.new(
			0.5,
			Color3.fromRGB(
				45,
				95,
				255
			)
		),

		ColorSequenceKeypoint.new(
			0.501,
			Color3.fromRGB(
				30,
				50,
				140
			)
		),

		ColorSequenceKeypoint.new(
			1,
			Color3.fromRGB(
				30,
				50,
				140
			)
		)
	})

BuyGradient.Offset =
	Vector2.new(
		-0.5,
		0
	)

local BuyText =
	Instance.new(
		"TextLabel",
		BuyBtn
	)

BuyText.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

BuyText.BackgroundTransparency =
	1

BuyText.Text =
	"Buy"

BuyText.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

BuyText.Font =
	Enum.Font.GothamBold

BuyText.TextSize =
	16

BuyText.TextXAlignment =
	Enum.TextXAlignment.Center

BuyText.TextYAlignment =
	Enum.TextYAlignment.Center

BuyText.TextScaled =
	false

BuyText.TextWrapped =
	false

BuyText.ZIndex =
	822

local sweepTween
local buySweepFinished = false
local buyPressing = false

local BUY_NORMAL_COLOR = Color3.fromRGB(45, 95, 255)
local BUY_READY_COLOR = Color3.fromRGB(45, 95, 255)
local BUY_PRESSED_COLOR = Color3.fromRGB(20, 35, 105)

local function SetBuyReadyVisual()
	if buyPressing then
		return
	end
	BuyGradient.Enabled = false
	BuyBtn.BackgroundColor3 = BUY_READY_COLOR
end

BuyPrompt:GetPropertyChangedSignal(
	"Visible"
):Connect(function()

	buyPressing = false
	buySweepFinished = false

	if BuyPrompt.Visible then
		BuyGradient.Enabled = true
		BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BuyGradient.Offset =
			Vector2.new(
				-0.5,
				0
			)

		if sweepTween then
			sweepTween:Cancel()
		end

		sweepTween =
			TweenService:Create(
				BuyGradient,
				TweenInfo.new(
					3,
					Enum.EasingStyle.Linear
				),
				{
					Offset =
						Vector2.new(
							0.5,
							0
						)
				}
			)

		sweepTween.Completed:Connect(function()
			if BuyPrompt.Visible and sweepTween then
				buySweepFinished = true
				SetBuyReadyVisual()
			end
		end)

		sweepTween:Play()
	else
		if sweepTween then
			sweepTween:Cancel()
			sweepTween = nil
		end
		BuyGradient.Enabled = true
		BuyGradient.Offset =
			Vector2.new(
				-0.5,
				0
			)
		BuyBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
end)

BuyBtn.MouseEnter:Connect(function()
	if buySweepFinished and not buyPressing then
		BuyBtn.BackgroundColor3 = BUY_PRESSED_COLOR
	end
end)

BuyBtn.MouseLeave:Connect(function()
	if buySweepFinished and not buyPressing then
		SetBuyReadyVisual()
	end
end)

local SuccessPrompt
local PurchaseSuccessfulPrompt
local StartConfetti
local RefreshPurchaseSuccessfulTitle

-- ==========================================
-- BUY CLICK / 1 SECOND CONFIRM DELAY
-- FIXED RESULT FLOW:
-- Buy -> 1s delay -> Purchase Successful + Purchase Completed + Confetti
-- ==========================================

local function ShowPurchaseResult()
	-- Close the Buy Item panel.
	BuyPrompt.Visible =
		false

	-- Keep the fullscreen dimmer active.
	DarkOverlay.Visible =
		true

	DarkOverlay.BackgroundTransparency =
		0.5

	-- Refresh the selected recipient text first.
	if RefreshPurchaseSuccessfulTitle then
		RefreshPurchaseSuccessfulTitle()
	end

	-- Show the "You sent a gift to..." panel.
	PurchaseSuccessfulPrompt.Visible =
		true

	-- Show Purchase completed above everything else.
	SuccessPrompt.Visible =
		true

	-- The loading / Gift Player panels are no longer active.
	LoadingPrompt.Visible =
		false

	GiftPrompt.Visible =
		false

end

BuyBtn.MouseButton1Click:Connect(function()
	if buyPressing then
		return
	end

	if Settings.Balance <
		PurchasePrice then
		return
	end

	-- Buy is only valid after the 3-second color sweep.
	if not buySweepFinished then
		return
	end

	buyPressing = true

	-- Pressed state: dark blue immediately.
	BuyGradient.Enabled =
		false

	BuyBtn.BackgroundColor3 =
		BUY_PRESSED_COLOR

	-- Exactly 1 second delay before purchase result.
	task.wait(1.0)

	-- Deduct the local fake balance only after the delay.
	Settings.Balance =
		Settings.Balance -
		PurchasePrice

	local formattedBalance =
		FormatNumber(
			Settings.Balance
		)

	BalanceBox.Text =
		formattedBalance

	TopBalanceLbl.Text =
		formattedBalance

	ShowPurchaseResult()

	buyPressing =
		false
end)

-- ==========================================
-- PURCHASE COMPLETED
-- ==========================================
SuccessPrompt =
	Instance.new(
		"Frame",
		ScreenGui
	)

SuccessPrompt.Name =
	"PurchaseCompletedPrompt"

SuccessPrompt.Size =
	UDim2.new(
		0,
		458,
		0,
		223
	)

SuccessPrompt.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

SuccessPrompt.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

SuccessPrompt.BackgroundColor3 =
	Color3.fromRGB(
		27,
		28,
		33
	)

SuccessPrompt.BorderSizePixel =
	0

SuccessPrompt.Visible =
	false

SuccessPrompt.ZIndex =
	1000

Instance.new(
	"UICorner",
	SuccessPrompt
).CornerRadius =
	UDim.new(
		0,
		11
	)

local SuccessStroke =
	Instance.new(
		"UIStroke",
		SuccessPrompt
	)

SuccessStroke.Color =
	Color3.fromRGB(
		49,
		52,
		59
	)

SuccessStroke.Thickness =
	1

-- ==========================================
-- PURCHASE COMPLETED TITLE
-- ==========================================
local SuccessTitle =
	Instance.new(
		"TextLabel",
		SuccessPrompt
	)

SuccessTitle.Size =
	UDim2.new(
		1,
		-72,
		0,
		31
	)

SuccessTitle.Position =
	UDim2.new(
		0,
		21,
		0,
		11
	)

SuccessTitle.BackgroundTransparency =
	1

SuccessTitle.Text =
	"Purchase completed"

SuccessTitle.TextColor3 =
	Color3.fromRGB(
		229,
		230,
		234
	)

SuccessTitle.Font =
	Enum.Font.GothamBold

SuccessTitle.TextSize =
	20

SuccessTitle.TextXAlignment =
	Enum.TextXAlignment.Left

SuccessTitle.TextYAlignment =
	Enum.TextYAlignment.Center

SuccessTitle.TextScaled =
	false

SuccessTitle.TextWrapped =
	false

SuccessTitle.ZIndex =
	1001

-- ==========================================
-- CLOSE PURCHASE COMPLETED
-- ==========================================
local CloseBtnX2 =
	Instance.new(
		"TextButton",
		SuccessPrompt
	)

CloseBtnX2.Size =
	UDim2.new(
		0,
		32,
		0,
		32
	)

CloseBtnX2.Position =
	UDim2.new(
		1,
		-49,
		0,
		9
	)

CloseBtnX2.BackgroundTransparency =
	1

CloseBtnX2.BorderSizePixel =
	0

CloseBtnX2.Text =
	"×"

CloseBtnX2.TextColor3 =
	Color3.fromRGB(
		226,
		227,
		232
	)

CloseBtnX2.Font =
	Enum.Font.Gotham

CloseBtnX2.TextSize =
	29

CloseBtnX2.TextXAlignment =
	Enum.TextXAlignment.Center

CloseBtnX2.TextYAlignment =
	Enum.TextYAlignment.Center

CloseBtnX2.TextScaled =
	false

CloseBtnX2.AutoButtonColor =
	false

CloseBtnX2.ZIndex =
	1002

-- ==========================================
-- CHECK CIRCLE
-- ==========================================
local CheckCircle =
	Instance.new(
		"Frame",
		SuccessPrompt
	)

CheckCircle.Size =
	UDim2.new(
		0,
		43,
		0,
		43
	)

CheckCircle.Position =
	UDim2.new(
		0.5,
		-21.5,
		0,
		57
	)

CheckCircle.BackgroundTransparency =
	1

CheckCircle.BorderSizePixel =
	0

CheckCircle.ZIndex =
	1003

local CheckCircleCorner =
	Instance.new(
		"UICorner",
		CheckCircle
	)

CheckCircleCorner.CornerRadius =
	UDim.new(
		1,
		0
	)

local CheckStroke =
	Instance.new(
		"UIStroke",
		CheckCircle
	)

CheckStroke.Color =
	Color3.fromRGB(
		213,
		214,
		220
	)

CheckStroke.Thickness =
	4

local CheckIcon =
	Instance.new(
		"TextLabel",
		CheckCircle
	)

CheckIcon.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

CheckIcon.BackgroundTransparency =
	1

CheckIcon.Text =
	"✓"

CheckIcon.TextColor3 =
	Color3.fromRGB(
		216,
		217,
		223
	)

CheckIcon.Font =
	Enum.Font.GothamMedium

CheckIcon.TextSize =
	24

CheckIcon.TextXAlignment =
	Enum.TextXAlignment.Center

CheckIcon.TextYAlignment =
	Enum.TextYAlignment.Center

CheckIcon.ZIndex =
	1004

-- ==========================================
-- PURCHASE COMPLETED DESCRIPTION
-- ==========================================
local SuccessSub =
	Instance.new(
		"TextLabel",
		SuccessPrompt
	)

SuccessSub.Size =
	UDim2.new(
		1,
		-40,
		0,
		24
	)

SuccessSub.Position =
	UDim2.new(
		0,
		20,
		0,
		117
	)

SuccessSub.BackgroundTransparency =
	1

SuccessSub.Text =
	"You have successfully bought " ..
	Settings.ItemName ..
	"."

SuccessSub.TextColor3 =
	Color3.fromRGB(
		202,
		203,
		209
	)

SuccessSub.Font =
	Enum.Font.Gotham

SuccessSub.TextSize =
	14

SuccessSub.TextXAlignment =
	Enum.TextXAlignment.Center

SuccessSub.TextYAlignment =
	Enum.TextYAlignment.Center

SuccessSub.TextScaled =
	false

SuccessSub.TextWrapped =
	false

SuccessSub.ZIndex =
	1001

-- ==========================================
-- PURCHASE COMPLETED OK
-- ==========================================
local OkBtn =
	Instance.new(
		"TextButton",
		SuccessPrompt
	)

OkBtn.Size =
	UDim2.new(
		1,
		-40,
		0,
		41
	)

OkBtn.Position =
	UDim2.new(
		0,
		20,
		1,
		-58
	)

OkBtn.BackgroundColor3 =
	Color3.fromRGB(
		52,
		91,
		246
	)

OkBtn.BorderSizePixel =
	0

OkBtn.Text =
	"OK"

OkBtn.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

OkBtn.Font =
	Enum.Font.GothamBold

OkBtn.TextSize =
	14

OkBtn.TextXAlignment =
	Enum.TextXAlignment.Center

OkBtn.TextYAlignment =
	Enum.TextYAlignment.Center

OkBtn.TextScaled =
	false

OkBtn.TextWrapped =
	false

OkBtn.AutoButtonColor =
	false

OkBtn.ZIndex =
	1002

Instance.new(
	"UICorner",
	OkBtn
).CornerRadius =
	UDim.new(
		0,
		7
	)

OkBtn.MouseEnter:Connect(function()
	OkBtn.BackgroundColor3 =
		Color3.fromRGB(
			61,
			100,
			255
		)
end)

OkBtn.MouseLeave:Connect(function()
	OkBtn.BackgroundColor3 =
		Color3.fromRGB(
			52,
			91,
			246
		)
end)

-- ==========================================
-- PURCHASE SUCCESSFUL
-- ==========================================
PurchaseSuccessfulPrompt =
	Instance.new(
		"Frame",
		ScreenGui
	)

PurchaseSuccessfulPrompt.Name =
	"PurchaseSuccessfulPrompt"

PurchaseSuccessfulPrompt.Size =
	UDim2.new(
		0,
		540,
		0,
		390
	)

PurchaseSuccessfulPrompt.Position =
	UDim2.new(
		0.5,
		0,
		0.5,
		0
	)

PurchaseSuccessfulPrompt.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

PurchaseSuccessfulPrompt.BackgroundColor3 =
	Color3.fromRGB(0, 0, 0)

PurchaseSuccessfulPrompt.BackgroundTransparency =
	1

PurchaseSuccessfulPrompt.BorderSizePixel =
	0

PurchaseSuccessfulPrompt.Visible =
	false

PurchaseSuccessfulPrompt.ZIndex =
	900

PurchaseSuccessfulPrompt.ClipsDescendants =
	false

-- The panel background is the bottom-most layer inside this popup.
local PurchaseSuccessfulBackground =
	Instance.new(
		"Frame",
		PurchaseSuccessfulPrompt
	)

PurchaseSuccessfulBackground.Name =
	"PurchaseSuccessfulBackground"

PurchaseSuccessfulBackground.Size =
	UDim2.fromScale(
		1,
		1
	)

PurchaseSuccessfulBackground.Position =
	UDim2.fromScale(
		0,
		0
	)

PurchaseSuccessfulBackground.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

PurchaseSuccessfulBackground.BackgroundTransparency =
	0.05

PurchaseSuccessfulBackground.BorderSizePixel =
	0

PurchaseSuccessfulBackground.ZIndex =
	901

Instance.new(
	"UICorner",
	PurchaseSuccessfulBackground
).CornerRadius =
	UDim.new(
		0,
		4
	)

Instance.new(
	"UICorner",
	PurchaseSuccessfulPrompt
).CornerRadius =
	UDim.new(
		0,
		4
	)

local PurchaseSuccessfulStroke =
	Instance.new(
		"UIStroke",
		PurchaseSuccessfulPrompt
	)

PurchaseSuccessfulStroke.Color =
	Color3.fromRGB(115, 115, 122)

PurchaseSuccessfulStroke.Thickness =
	1.5

-- ==========================================
-- PURCHASE SUCCESSFUL CLOSE X
-- ==========================================
local PurchaseSuccessfulClose =
	Instance.new(
		"TextButton",
		PurchaseSuccessfulPrompt
	)

PurchaseSuccessfulClose.Name =
	"PurchaseSuccessfulClose"

PurchaseSuccessfulClose.Size =
	UDim2.fromOffset(60, 60)

PurchaseSuccessfulClose.Position =
	UDim2.new(1, 8, 0, -12)

PurchaseSuccessfulClose.AnchorPoint =
	Vector2.new(
		1,
		0
	)

PurchaseSuccessfulClose.BackgroundColor3 =
	Color3.fromRGB(
		255,
		0,
		0
	)

PurchaseSuccessfulClose.BorderSizePixel =
	0

PurchaseSuccessfulClose.Text =
	"X"

PurchaseSuccessfulClose.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

PurchaseSuccessfulClose.Font =
	Enum.Font.GothamBold

PurchaseSuccessfulClose.TextSize =
	40

PurchaseSuccessfulClose.TextXAlignment =
	Enum.TextXAlignment.Center

PurchaseSuccessfulClose.TextYAlignment =
	Enum.TextYAlignment.Center

PurchaseSuccessfulClose.AutoButtonColor =
	false

PurchaseSuccessfulClose.ZIndex =
	903

local PurchaseSuccessfulCloseStroke =
	Instance.new(
		"UIStroke",
		PurchaseSuccessfulClose
	)

PurchaseSuccessfulCloseStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

PurchaseSuccessfulCloseStroke.Thickness =
	4

PurchaseSuccessfulClose.MouseEnter:Connect(function()
	PurchaseSuccessfulClose.BackgroundColor3 =
		Color3.fromRGB(
			220,
			0,
			0
		)
end)

PurchaseSuccessfulClose.MouseLeave:Connect(function()
	PurchaseSuccessfulClose.BackgroundColor3 =
		Color3.fromRGB(
			255,
			0,
			0
		)
end)

PurchaseSuccessfulClose.MouseButton1Click:Connect(function()
	PurchaseSuccessfulPrompt.Visible =
		false

	ClosePopups()
end)

local PurchaseSuccessfulTitle =
	Instance.new(
		"TextLabel",
		PurchaseSuccessfulPrompt
	)

PurchaseSuccessfulTitle.Size =
	UDim2.new(
		1,
		-50,
		0,
		170
	)

PurchaseSuccessfulTitle.Position =
	UDim2.new(
		0,
		25,
		0,
		35
	)

PurchaseSuccessfulTitle.BackgroundTransparency =
	1

PurchaseSuccessfulTitle.Text =
	"You sent a gift to\n" ..
	(SelectedGiftDisplayName ~= "" and SelectedGiftDisplayName or "Player") ..
	"! 😁"

PurchaseSuccessfulTitle.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

PurchaseSuccessfulTitle.Font =
	Enum.Font.FredokaOne

PurchaseSuccessfulTitle.TextSize =
	38

PurchaseSuccessfulTitle.TextXAlignment =
	Enum.TextXAlignment.Center

PurchaseSuccessfulTitle.TextYAlignment =
	Enum.TextYAlignment.Center

PurchaseSuccessfulTitle.TextWrapped =
	true

PurchaseSuccessfulTitle.TextScaled =
	false

PurchaseSuccessfulTitle.ZIndex =
	902

local PurchaseSuccessfulTitleStroke =
	Instance.new(
		"UIStroke",
		PurchaseSuccessfulTitle
	)

PurchaseSuccessfulTitleStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

PurchaseSuccessfulTitleStroke.Thickness =
	3

RefreshPurchaseSuccessfulTitle = function()
	PurchaseSuccessfulTitle.Text =
		"You sent a gift to\n" ..
		(SelectedGiftDisplayName ~= "" and SelectedGiftDisplayName or "Player") ..
		"! 😁"
end

local SuccessfulOkBtn =
	Instance.new(
		"TextButton",
		PurchaseSuccessfulPrompt
	)

SuccessfulOkBtn.Size =
	UDim2.new(
		0,
		220,
		0,
		62
	)

SuccessfulOkBtn.Position =
	UDim2.new(
		0.5,
		-110,
		1,
		-84
	)

SuccessfulOkBtn.BackgroundColor3 =
	Color3.fromRGB(52, 195, 0)

SuccessfulOkBtn.BorderSizePixel =
	0

SuccessfulOkBtn.Text =
	"Ok!"

SuccessfulOkBtn.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

SuccessfulOkBtn.Font =
	Enum.Font.FredokaOne

SuccessfulOkBtn.TextSize =
	36

SuccessfulOkBtn.TextXAlignment =
	Enum.TextXAlignment.Center

SuccessfulOkBtn.TextYAlignment =
	Enum.TextYAlignment.Center

SuccessfulOkBtn.TextScaled =
	false

SuccessfulOkBtn.TextWrapped =
	false

SuccessfulOkBtn.AutoButtonColor =
	false

SuccessfulOkBtn.ZIndex =
	1002

Instance.new(
	"UICorner",
	SuccessfulOkBtn
).CornerRadius =
	UDim.new(
		0,
		2
	)

local SuccessfulOkStroke =
	Instance.new(
		"UIStroke",
		SuccessfulOkBtn
	)

SuccessfulOkStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

SuccessfulOkStroke.Thickness =
	3

local SuccessfulOkText =
	Instance.new(
		"TextLabel",
		SuccessfulOkBtn
	)

SuccessfulOkText.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

SuccessfulOkText.BackgroundTransparency =
	1

SuccessfulOkText.Text =
	"Ok!"

SuccessfulOkText.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

SuccessfulOkText.Font =
	Enum.Font.FredokaOne

SuccessfulOkText.TextSize =
	36

SuccessfulOkText.TextXAlignment =
	Enum.TextXAlignment.Center

SuccessfulOkText.TextYAlignment =
	Enum.TextYAlignment.Center

SuccessfulOkText.TextScaled =
	false

SuccessfulOkText.ZIndex =
	905

local SuccessfulOkTextStroke =
	Instance.new(
		"UIStroke",
		SuccessfulOkText
	)

SuccessfulOkTextStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

SuccessfulOkTextStroke.Thickness =
	3

SuccessfulOkBtn.MouseEnter:Connect(function()
	SuccessfulOkBtn.BackgroundColor3 =
		Color3.fromRGB(62, 210, 0)
end)

SuccessfulOkBtn.MouseLeave:Connect(function()
	SuccessfulOkBtn.BackgroundColor3 =
		Color3.fromRGB(52, 195, 0)
end)

-- ==========================================
-- RESOLVE REAL ROBLOX USER
-- ==========================================
local function ResolveRealUser(inputUsername)
	local cleanUsername =
		inputUsername:gsub("^%s+", ""):gsub("%s+$", "")

	if cleanUsername == "" then
		return nil
	end

	local ok, userId =
		pcall(function()
			return Players:GetUserIdFromNameAsync(cleanUsername)
		end)

	if not ok or not userId then
		return nil
	end

	local normalizedUsername = cleanUsername
	local nameOk, fetchedUsername =
		pcall(function()
			return Players:GetNameFromUserIdAsync(userId)
		end)

	if nameOk and fetchedUsername and fetchedUsername ~= "" then
		normalizedUsername = fetchedUsername
	end

	local displayName = normalizedUsername

	-- Fetch the real Roblox DisplayName even when the user is not
	-- currently inside this server.
	local infoOk, userInfos =
		pcall(function()
			return UserService:GetUserInfosByUserIdsAsync({ userId })
		end)

	if infoOk and userInfos then
		for _, info in ipairs(userInfos) do
			if info.Id == userId then
				if info.Username and info.Username ~= "" then
					normalizedUsername = info.Username
				end

				if info.DisplayName and info.DisplayName ~= "" then
					displayName = info.DisplayName
				else
					displayName = normalizedUsername
				end

				break
			end
		end
	end

	return {
		UserId = userId,
		Username = normalizedUsername,
		DisplayName = displayName
	}
end

local AvatarCache = {}          -- keyed by UserId, never by row/display name
local AvatarLoading = {}        -- keyed by UserId

-- ==========================================
-- ROBLOX RANDOM AVATAR FALLBACK FOR UNKNOWN USERNAMES
-- Uses Roblox's official public user search endpoint with the first
-- 3 characters of the entered username, then randomly selects a real
-- Roblox user from the returned results and uses that user's real avatar.
-- No generated initials / invented avatar data are used.
-- ==========================================
local HttpService = game:GetService("HttpService")
local RobloxRandomAvatarCache = {} -- [typedUsernameLower] = { UserId, Username, DisplayName, Image }

local function RobloxHttpGet(url)
	-- Executor/client environments may expose one of these HTTP functions.
	local gameHttpOk, gameHttpResult = pcall(function()
		if type(game.HttpGet) == "function" then
			return game:HttpGet(url)
		end
		return nil
	end)
	if gameHttpOk and type(gameHttpResult) == "string" and gameHttpResult ~= "" then
		return true, gameHttpResult
	end

	local requestFunction = nil
	pcall(function()
		if type(request) == "function" then
			requestFunction = request
		elseif type(http_request) == "function" then
			requestFunction = http_request
		elseif type(syn) == "table" and type(syn.request) == "function" then
			requestFunction = syn.request
		end
	end)

	if requestFunction then
		local ok, response = pcall(function()
			return requestFunction({
				Url = url,
				Method = "GET"
			})
		end)
		if ok and type(response) == "table" and tonumber(response.StatusCode or response.Status) == 200 and type(response.Body) == "string" then
			return true, response.Body
		end
	end

	return false, nil
end

local function GetRandomRobloxUserByPrefix(username)
	local clean = (username or ""):gsub("^%s+", ""):gsub("%s+$", "")
	local prefix = clean:sub(1, math.min(3, #clean))
	if prefix == "" then
		return nil
	end

	local cacheKey = clean:lower()
	local cached = RobloxRandomAvatarCache[cacheKey]
	if cached then
		return cached
	end

	local encodedPrefix = HttpService:UrlEncode(prefix)
	local cursor = nil
	local candidates = {}

	-- FAST MODE: one Roblox search request with a small result set.
	-- A random real user is selected from the returned Roblox data.
	local url = "https://users.roblox.com/v1/users/search?keyword=" .. encodedPrefix .. "&limit=10"
	local ok, body = RobloxHttpGet(url)
	if not ok or not body then
		return nil
	end

	local decodeOk, payload = pcall(function()
		return HttpService:JSONDecode(body)
	end)
	if not decodeOk or type(payload) ~= "table" then
		return nil
	end

	for _, user in ipairs(payload.data or {}) do
		local foundName = tostring(user.name or "")
		if foundName ~= ""
			and foundName:sub(1, #prefix):lower() == prefix:lower()
			and tonumber(user.id) then
			table.insert(candidates, {
				UserId = tonumber(user.id),
				Username = foundName,
				DisplayName = tostring(user.displayName or foundName)
			})
		end
	end

	if #candidates == 0 then
		return nil
	end

	local selected = candidates[math.random(1, #candidates)]

	local thumbOk, avatarImage = pcall(function()
		local image = Players:GetUserThumbnailAsync(
			selected.UserId,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size150x150
		)
		return image
	end)

	if not thumbOk
		or type(avatarImage) ~= "string"
		or avatarImage == ""
		or avatarImage == "rbxasset://textures/ui/GuiImagePlaceholder.png" then
		return nil
	end

	selected.Image = avatarImage
	RobloxRandomAvatarCache[cacheKey] = selected
	return selected
end

local function ShowRobloxRandomAvatar(rowUI, username, requestId)
	local clean = (username or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if clean == "" then
		return
	end

	task.spawn(function()
		local selected = GetRandomRobloxUserByPrefix(clean)
		if not selected then
			return
		end

		-- Never allow an async result for an old user to overwrite a reused row.
		if rowUI.AvatarRequestId ~= requestId
			or rowUI.AvatarRequestUsername ~= clean then
			return
		end

		rowUI.Avatar.Image = selected.Image
		rowUI.Avatar.Visible = true
		rowUI.FallbackAvatar.Visible = false
		rowUI.FallbackAvatarText.Text = ""
		rowUI.RandomRobloxUserId = selected.UserId
		rowUI.RandomRobloxUsername = selected.Username
		rowUI.RandomRobloxDisplayName = selected.DisplayName

		-- Show the randomly selected REAL Roblox username + display name.
		-- The typed Fake User value remains stored in Settings/UserBoxes.
		rowUI.NameLabel.Text = selected.DisplayName
		rowUI.UserLabel.Text = "@" .. selected.Username
	end)
end

-- ==========================================
-- UPDATE PLAYER ROW / REAL AVATAR
-- ==========================================
local function UpdatePlayerRow(
	displayName,
	realUserName,
	rowUI
)
	local cleanUserName =
		(realUserName or ""):gsub("^%s+", ""):gsub("%s+$", "")

	-- Every update gets its own request token.  Any older async thumbnail
	-- request is ignored as soon as this row is assigned to another user.
	rowUI.AvatarRequestId = (rowUI.AvatarRequestId or 0) + 1
	local requestId = rowUI.AvatarRequestId

	-- Always clear/hide the old avatar BEFORE resolving the new user.
	-- This prevents a previous player's image from being visible in a reused slot.
	rowUI.Avatar.Visible = false
	rowUI.Avatar.Image = ""
	rowUI.FallbackAvatar.Visible = false
	rowUI.Username = ""
	rowUI.UserId = nil

	-- Empty slot => completely hidden, and no thumbnail request.
	if cleanUserName == "" then
		rowUI.Row.Visible = false
		rowUI.NameLabel.Text = ""
		rowUI.UserLabel.Text = ""
		rowUI.FallbackAvatar.Visible = false
		return
	end

	rowUI.Row.Visible = true
	rowUI.NameLabel.Text = displayName ~= "" and displayName or cleanUserName
	rowUI.UserLabel.Text = "@" .. cleanUserName
	rowUI.Avatar.ZIndex = 711
	rowUI.Avatar.ImageTransparency = 0
	rowUI.AvatarRequestUsername = cleanUserName

	-- Resolve the real Roblox UserId from the configured username.
	local ok, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(cleanUserName)
	end)

	-- The slot may have been replaced while the async lookup was running.
	if rowUI.AvatarRequestId ~= requestId
		or rowUI.AvatarRequestUsername ~= cleanUserName then
		return
	end

	if not ok or not userId then
		-- Username does not exist: search Roblox by the first 3 characters
		-- and use a randomly selected REAL Roblox user's avatar.
		-- Nothing is generated locally and no old avatar is allowed to remain.
		if rowUI.AvatarRequestId == requestId
			and rowUI.AvatarRequestUsername == cleanUserName then
			rowUI.Username = cleanUserName
			rowUI.UserId = nil
			rowUI.FallbackAvatar.Visible = false
			rowUI.FallbackAvatarText.Text = ""
			ShowRobloxRandomAvatar(rowUI, cleanUserName, requestId)
		end
		return
	end

	rowUI.UserId = userId
	rowUI.Username = cleanUserName

	-- If the same user is already cached, restore the real avatar immediately.
	local cached = AvatarCache[userId]
	if cached and cached ~= "" then
		if rowUI.AvatarRequestId == requestId
			and rowUI.UserId == userId
			and rowUI.AvatarRequestUsername == cleanUserName then
			rowUI.FallbackAvatar.Visible = false
			rowUI.Avatar.Image = cached
			rowUI.Avatar.Visible = true
		end
		return
	end

	-- Only one thumbnail request per real UserId at a time.
	if AvatarLoading[userId] then
		-- The current row stays hidden until the real thumbnail is ready.
		return
	end

	AvatarLoading[userId] = true

	task.spawn(function()
		local finalImage = nil
		local finalReady = false

		for _ = 1, 10 do
			local thumbOk, avatarImage, isReady =
				pcall(function()
					local image, ready =
						Players:GetUserThumbnailAsync(
							userId,
							Enum.ThumbnailType.HeadShot,
							Enum.ThumbnailSize.Size150x150
						)
					return image, ready
				end)

			if thumbOk
				and avatarImage
				and avatarImage ~= ""
				and avatarImage ~= "rbxasset://textures/ui/GuiImagePlaceholder.png" then
				finalImage = avatarImage
				finalReady = isReady
				AvatarCache[userId] = avatarImage

				-- IMPORTANT: only write into this row if it is STILL the same user.
				if rowUI.AvatarRequestId == requestId
					and rowUI.UserId == userId
					and rowUI.AvatarRequestUsername == cleanUserName then
					rowUI.FallbackAvatar.Visible = false
					rowUI.Avatar.Image = avatarImage
					rowUI.Avatar.Visible = true
				end

				if isReady then
					break
				end
			end

			task.wait(0.35)
		end

		AvatarLoading[userId] = nil

		-- Final safety pass: if the request became ready after the loop,
		-- show it only when this row still belongs to the same real UserId.
		if finalImage
			and rowUI.AvatarRequestId == requestId
			and rowUI.UserId == userId
			and rowUI.AvatarRequestUsername == cleanUserName then
			rowUI.FallbackAvatar.Visible = false
			rowUI.Avatar.Image = finalImage
			rowUI.Avatar.Visible = true
		end
	end)
end


-- ==========================================
-- PLAYER ROWS
-- ==========================================
for i = 1, 8 do
	local Row =
		Instance.new(
			"Frame",
			PlayerList
		)

	Row.Size = UDim2.new(1, -10, 0, 112)

	-- EXACT PLAYER-ROW BACKGROUND MATCH TO THE SUPPLIED REFERENCE:
	-- Top half:  RGB(33, 9, 67)  #210943
	-- Bottom half: RGB(41, 11, 83) #290B53
	-- The split is horizontal at the midpoint; this is the ROW BACKGROUND,
	-- not the border.  The gradient is applied directly to Row so no child
	-- layer can fall behind the parent and accidentally reveal black.
	Row.BackgroundColor3 = Color3.fromRGB(33, 9, 67)
	Row.BorderSizePixel = 0
	Row.ClipsDescendants = true

	
	Row.Visible = false
-- FORCE the two-color player background in a dedicated layer so no other
	-- child/parent background can make the visible row area appear black.
	local RowColorBackground = Instance.new("Frame", Row)
	RowColorBackground.Name = "PlayerRowColorBackground"
	RowColorBackground.Size = UDim2.new(1, 0, 1, 0)
	RowColorBackground.Position = UDim2.new(0, 0, 0, 0)
	RowColorBackground.BackgroundColor3 = Color3.fromRGB(33, 9, 67)
	RowColorBackground.BackgroundTransparency = 0
	RowColorBackground.BorderSizePixel = 0
	RowColorBackground.ZIndex = 701
	RowColorBackground.Active = false
	local RowColorCorner = Instance.new("UICorner", RowColorBackground)
	RowColorCorner.CornerRadius = UDim.new(0, 12)

	local RowBackgroundGradient = Instance.new("UIGradient", RowColorBackground)
	RowBackgroundGradient.Name = "PlayerRowBackground2Color"
	RowBackgroundGradient.Rotation = 90
	RowBackgroundGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(33, 9, 67)),
		ColorSequenceKeypoint.new(0.49, Color3.fromRGB(33, 9, 67)),
		ColorSequenceKeypoint.new(0.51, Color3.fromRGB(41, 11, 83)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(41, 11, 83))
	})
	RowBackgroundGradient.Transparency = NumberSequence.new(0)

	-- Keep Row itself on the same base color as the fallback in case the
	-- dedicated background layer is temporarily unavailable.
	Row.BackgroundColor3 = Color3.fromRGB(33, 9, 67)

	Row.LayoutOrder =
		i

	Instance.new(
		"UICorner",
		Row
	).CornerRadius =
		UDim.new(
			0,
			12
		)

	-- Player frame border removed.

	local RowInner =
		Instance.new(
			"Frame",
			Row
		)

	RowInner.Size =
		UDim2.new(
			1,
			-4,
			1,
			-4
		)

	RowInner.Position =
		UDim2.new(
			0,
			2,
			0,
			2
		)

	RowInner.BackgroundTransparency =
		1

	Instance.new(
		"UICorner",
		RowInner
	).CornerRadius =
		UDim.new(
			0,
			10
		)

	-- Inner Player frame border removed.

	local AvatarFrame =
		Instance.new(
			"Frame",
			Row
		)

	AvatarFrame.Size =
		UDim2.new(
			0,
			80,
			0,
			80
		)

	AvatarFrame.Position =
		UDim2.new(
			0,
			15,
			0.5,
			-40
		)

	-- Transparent avatar holder: do not paint any black color behind the avatar.
	AvatarFrame.BackgroundTransparency =
		1

	-- Avatar container is ONLY the small square at the far-left of the row.
	-- It must never stretch to the full player row.
	AvatarFrame.BackgroundTransparency = 1
	AvatarFrame.BorderSizePixel = 0
	AvatarFrame.ZIndex = 710
	AvatarFrame.Visible = true
	AvatarFrame.ClipsDescendants = true

	local AvatarAspect = Instance.new("UIAspectRatioConstraint", AvatarFrame)
	AvatarAspect.AspectRatio = 1

	Instance.new(
		"UICorner",
		AvatarFrame
	).CornerRadius =
		UDim.new(
			0,
			12
		)

	local Avatar =
		Instance.new(
			"ImageLabel",
			AvatarFrame
		)

	-- Fixed 80x80 square, centered vertically, never inherited from row size.
	Avatar.Size = UDim2.fromOffset(80, 80)
	Avatar.Position = UDim2.fromOffset(0, 0)

	Avatar.BackgroundTransparency =
		1

	Avatar.BorderSizePixel =
		0

	Avatar.ScaleType = Enum.ScaleType.Crop
	Avatar.Visible = true
	Avatar.ClipsDescendants = true
	Avatar.ImageTransparency = 0
	Avatar.ZIndex = 711
	Avatar.Visible = true

	-- The avatar itself is the ONLY image shown in this 80x80 area.
	-- Nothing uses AvatarFrame as a full-row background.

	Instance.new(
		"UICorner",
		Avatar
	).CornerRadius =
		UDim.new(
			0,
			12
		)

	-- Generated initials avatar used only when the entered username does not exist.
	local FallbackAvatar = Instance.new("Frame", AvatarFrame)
	FallbackAvatar.Name = "FallbackAvatar"
	FallbackAvatar.Size = UDim2.fromOffset(80, 80)
	FallbackAvatar.Position = UDim2.fromOffset(0, 0)
	FallbackAvatar.BorderSizePixel = 0
	FallbackAvatar.Visible = false
	FallbackAvatar.ZIndex = 712

	Instance.new("UICorner", FallbackAvatar).CornerRadius = UDim.new(0, 12)

	local FallbackAvatarText = Instance.new("TextLabel", FallbackAvatar)
	FallbackAvatarText.Size = UDim2.fromScale(1, 1)
	FallbackAvatarText.BackgroundTransparency = 1
	FallbackAvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
	FallbackAvatarText.Font = Enum.Font.GothamBlack
	FallbackAvatarText.TextSize = 23
	FallbackAvatarText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	FallbackAvatarText.TextStrokeTransparency = 0.25
	FallbackAvatarText.TextXAlignment = Enum.TextXAlignment.Center
	FallbackAvatarText.TextYAlignment = Enum.TextYAlignment.Center
	FallbackAvatarText.ZIndex = 713

	local NameLabel =
		Instance.new(
			"TextLabel",
			Row
		)

	NameLabel.Size =
		UDim2.new(
			0,
			300,
			0,
			34
		)

	NameLabel.Position =
		UDim2.new(
			0,
			110,
			0,
			20
		)

	NameLabel.BackgroundTransparency =
		1
	NameLabel.ZIndex = 712

	NameLabel.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	NameLabel.Font =
		Enum.Font.FredokaOne

	NameLabel.TextSize =
		34

	NameLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	NameLabel.TextYAlignment =
		Enum.TextYAlignment.Center

	NameLabel.TextScaled =
		false

	NameLabel.TextWrapped =
		false

	local NameStroke =
		Instance.new(
			"UIStroke",
			NameLabel
		)

	NameStroke.Color =
		Color3.fromRGB(
			0,
			0,
			0
		)

	NameStroke.Thickness =
		2

	local UserLabel =
		Instance.new(
			"TextLabel",
			Row
		)

	UserLabel.Size =
		UDim2.new(
			0,
			330,
			0,
			28
		)

	UserLabel.Position =
		UDim2.new(
			0,
			110,
			0,
			57
		)

	UserLabel.BackgroundTransparency =
		1
	UserLabel.ZIndex = 713

	UserLabel.TextColor3 =
		Color3.fromRGB(
			211,
			211,
			211
		)

	UserLabel.Font =
		Enum.Font.FredokaOne

	UserLabel.TextSize =
		27

	UserLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	UserLabel.TextYAlignment =
		Enum.TextYAlignment.Center

	UserLabel.TextScaled =
		false

	UserLabel.TextWrapped =
		false

	local UserStroke =
		Instance.new(
			"UIStroke",
			UserLabel
		)

	UserStroke.Color =
		Color3.fromRGB(
			0,
			0,
			0
		)

	UserStroke.Thickness =
		2

	local SelectBtnContainer =
		Instance.new(
			"Frame",
			Row
		)

	SelectBtnContainer.Size = UDim2.new(0, 174, 0, 70)

	SelectBtnContainer.Position = UDim2.new(1, -190, 0.5, -35)

	SelectBtnContainer.BackgroundTransparency = 1
	SelectBtnContainer.BorderSizePixel = 0
	-- No 3D/shadow layer on Select.

	local SelectBtn =
		Instance.new(
			"TextButton",
			SelectBtnContainer
		)

	SelectBtn.Size =
		UDim2.new(
			1,
			0,
			1,
			0
		)

	SelectBtn.BackgroundColor3 =
		Color3.fromRGB(
			118,
			255,
			10
		)

	SelectBtn.Text =
		""

	SelectBtn.AutoButtonColor =
		false

	SelectBtn.ZIndex =
		715

	Instance.new(
		"UICorner",
		SelectBtn
	).CornerRadius =
		UDim.new(
			0,
			8
		)

	local SelectWhiteStroke = Instance.new("UIStroke", SelectBtn)
	SelectWhiteStroke.Color = Color3.fromRGB(255, 255, 255)
	SelectWhiteStroke.Thickness = 3

	-- Dedicated white outline overlay so the border remains clearly visible
	-- above the button fill/pattern and matches the reference image.
	local SelectWhiteBorderOverlay =
		Instance.new(
			"Frame",
			SelectBtn
		)

	SelectWhiteBorderOverlay.Name =
		"WhiteBorderOverlay"

	SelectWhiteBorderOverlay.Size =
		UDim2.new(
			1,
			0,
			1,
			0
		)

	SelectWhiteBorderOverlay.Position =
		UDim2.new(
			0,
			0,
			0,
			0
		)

	SelectWhiteBorderOverlay.BackgroundTransparency =
		1

	SelectWhiteBorderOverlay.BorderSizePixel =
		0

	SelectWhiteBorderOverlay.ZIndex =
		717

	Instance.new(
		"UICorner",
		SelectWhiteBorderOverlay
	).CornerRadius =
		UDim.new(0, 8)

	local SelectVisibleWhiteStroke =
		Instance.new(
			"UIStroke",
			SelectWhiteBorderOverlay
		)

	SelectVisibleWhiteStroke.Color =
		Color3.fromRGB(255, 255, 255)

	SelectVisibleWhiteStroke.Thickness =
		3

	SelectVisibleWhiteStroke.Transparency =
		0

-- ==========================================
-- SELECT PATTERN IMAGE
-- Supplied asset: rbxassetid://90325592797235
-- ==========================================
local SelectPattern =
	Instance.new(
		"ImageLabel"
	)

SelectPattern.Name =
	"SelectPattern"

SelectPattern.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

SelectPattern.Position =
	UDim2.new(
		0,
		0,
		0,
		0
	)

SelectPattern.BackgroundTransparency =
	1

SelectPattern.BorderSizePixel =
	0

SelectPattern.Image =
	"rbxassetid://90325592797235"

SelectPattern.ScaleType =
	Enum.ScaleType.Tile

SelectPattern.TileSize =
	UDim2.fromOffset(
		60,
		60
	)

SelectPattern.ImageTransparency =
	0.72

SelectPattern.ZIndex =
	716

SelectPattern.Active =
	false

SelectPattern.Parent =
	SelectBtn








	local SelectText =
		Instance.new(
			"TextLabel",
			SelectBtn
		)

	SelectText.Name =
		"SelectText"

	SelectText.Size =
		UDim2.new(
			1,
			0,
			1,
			0
		)

	SelectText.BackgroundTransparency =
		1

	SelectText.Text =
		"Select"

	SelectText.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	SelectText.Font =
		Enum.Font.FredokaOne

	SelectText.TextSize =
		52

	SelectText.TextXAlignment =
		Enum.TextXAlignment.Center

	SelectText.TextYAlignment =
		Enum.TextYAlignment.Center

	SelectText.TextScaled =
		false

	SelectText.TextWrapped =
		false

	SelectText.ZIndex =
		718

	local SelectTextStroke =
		Instance.new(
			"UIStroke",
			SelectText
		)

	SelectTextStroke.Color =
		Color3.fromRGB(
			0,
			0,
			0
		)

	SelectTextStroke.Thickness =
		2

	local SELECT_NORMAL = Color3.fromRGB(118, 255, 10)
	local SELECT_HOVER = Color3.fromRGB(128, 255, 20)
	local SELECT_PRESSED = Color3.fromRGB(92, 225, 0)

	SelectBtn.MouseEnter:Connect(function()
		SelectBtn.BackgroundColor3 = SELECT_HOVER
	end)

	SelectBtn.MouseLeave:Connect(function()
		SelectBtn.BackgroundColor3 = SELECT_NORMAL
	end)

	SelectBtn.InputBegan:Connect(function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			SelectBtn.BackgroundColor3 = SELECT_PRESSED
		end
	end)

	SelectBtn.InputEnded:Connect(function(input)
		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
				Enum.UserInputType.Touch then

			SelectBtn.BackgroundColor3 = SELECT_HOVER
		end
	end)

RowUIList[i] = {
		Row = Row,
		Avatar = Avatar,
		FallbackAvatar = FallbackAvatar,
		FallbackAvatarText = FallbackAvatarText,
		NameLabel = NameLabel,
		UserLabel = UserLabel,
		Username = Settings.RealUsernames[i] or ""
	}

	UpdatePlayerRow(
		Settings.FakeUsers[i],
		Settings.RealUsernames[i],
		RowUIList[i]
	)

	SelectBtn.MouseButton1Click:Connect(function()
		SelectedGiftDisplayName =
			RowUIList[i].NameLabel.Text

		SelectedGiftUsername =
			RowUIList[i].UserLabel.Text:gsub("^@", "")

		RefreshPurchaseSuccessfulTitle()

		GiftPrompt.Visible =
			false

		LoadingPrompt.Visible =
			true

		BuyPrompt.Visible =
			false

		DarkOverlay.Visible =
			true

		DarkOverlay.BackgroundTransparency =
			0.5

		LoadRing.Rotation =
			0

		LoadGiftScale.Scale =
			1

		local animationStart =
			os.clock()

		local rotateConnection =
			RunService.RenderStepped:Connect(
				function(dt)
					if not LoadingPrompt.Visible then
						return
					end

					LoadRing.Rotation =
						(LoadRing.Rotation + 180 * dt) % 360

					local elapsed =
						os.clock() - animationStart

					LoadGiftScale.Scale =
						1 + math.sin(
							elapsed * math.pi * 2.2
						) * 0.11
				end
			)

		task.wait(2)

		if rotateConnection then
			rotateConnection:Disconnect()
			rotateConnection = nil
		end

		LoadGiftScale.Scale =
			1

		LoadingPrompt.Visible =
			false

		BuyPrompt.Visible =
			true
	end)
end

-- ==========================================
-- BALANCE UPDATE
-- ==========================================
BalanceBox.FocusLost:Connect(function()
	local number =
		tonumber(
			BalanceBox.Text:gsub(
				"%D",
				""
			)
		)

	if number then
		Settings.Balance =
			number
	end

	local formatted =
		FormatNumber(
			Settings.Balance
		)

	BalanceBox.Text =
		formatted

	TopBalanceLbl.Text =
		formatted
end)

-- ==========================================
-- USER UPDATE / SERVER AUTO SYNC
-- ==========================================
local function SyncFakeUsersFromServer()
	local serverPlayers = {}

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= Player then
			table.insert(
				serverPlayers,
				p
			)
		end
	end

	for i = 1, 8 do
		local p =
			serverPlayers[i]

		if p then
			local username =
				p.Name

			local displayName =
				p.DisplayName

			Settings.RealUsernames[i] =
				username

			Settings.FakeUsers[i] =
				displayName

			if UserBoxes[i] then
				UserBoxes[i].Text =
					username
			end

			if RowUIList[i] then
				UpdatePlayerRow(
					displayName,
					username,
					RowUIList[i]
				)
			end
		else
			Settings.RealUsernames[i] =
				""

			Settings.FakeUsers[i] =
				""

			if UserBoxes[i] then
				UserBoxes[i].Text =
					""
			end

			if RowUIList[i] then
				UpdatePlayerRow(
					"",
					"",
					RowUIList[i]
				)
			end
		end
	end
end


for i = 1, 8 do
	UserBoxes[i].FocusLost:Connect(function()
		local inputUsername =
			UserBoxes[i].Text:gsub("^%s+", ""):gsub("%s+$", "")

		if inputUsername == "" then
			Settings.RealUsernames[i] = ""
			Settings.FakeUsers[i] = ""

			if RowUIList[i] then
				UpdatePlayerRow(
					"",
					"",
					RowUIList[i]
				)
			end

			return
		end

		local resolved = ResolveRealUser(inputUsername)
		if resolved then
			UserBoxes[i].Text = resolved.Username
			Settings.RealUsernames[i] = resolved.Username
			Settings.FakeUsers[i] = resolved.DisplayName

			if RowUIList[i] then
				RowUIList[i].Username = resolved.Username
				UpdatePlayerRow(resolved.DisplayName, resolved.Username, RowUIList[i])
			end

			if SelectedGiftUsername:lower() == inputUsername:lower() then
				SelectedGiftDisplayName = resolved.DisplayName
				SelectedGiftUsername = resolved.Username
			end
		else
			-- Non-existent username: keep it in the slot and use the generated
			-- 3-letter initials avatar instead of leaving the previous avatar.
			Settings.RealUsernames[i] = inputUsername
			Settings.FakeUsers[i] = inputUsername
			UserBoxes[i].Text = inputUsername

			if RowUIList[i] then
				RowUIList[i].Username = inputUsername
				UpdatePlayerRow(inputUsername, inputUsername, RowUIList[i])
			end
		end
	end)
end

-- Keep existing Fake User slots stable. New players only occupy the first empty slot.
local function AddPlayerToFirstEmptySlot(p)
	if not p or p == Player then
		return
	end

	local username = p.Name
	local displayName = p.DisplayName

	-- Do not duplicate a player that is already assigned to a slot.
	for i = 1, 8 do
		if (Settings.RealUsernames[i] or ""):lower() == username:lower() then
			return
		end
	end

	-- Add the new player to the first available slot only.
	for i = 1, 8 do
		if (Settings.RealUsernames[i] or "") == "" then
			Settings.RealUsernames[i] = username
			Settings.FakeUsers[i] = displayName

			if UserBoxes[i] then
				UserBoxes[i].Text = username
			end

			if RowUIList[i] then
				UpdatePlayerRow(displayName, username, RowUIList[i])
			end

			return
		end
	end
end

Players.PlayerAdded:Connect(function(p)
	task.wait(0.15)
	AddPlayerToFirstEmptySlot(p)
end)

Players.PlayerRemoving:Connect(function(p)
	if not p or p == Player then
		return
	end

	local leavingUsername = (p.Name or ""):lower()

	-- First check whether this player is actually present in the Fake User list.
	-- If the username is not found, do absolutely nothing.
	local matchedSlot = nil
	for i = 1, 8 do
		local slotUsername = (Settings.RealUsernames[i] or ""):lower()
		if slotUsername ~= "" and slotUsername == leavingUsername then
			matchedSlot = i
			break
		end
	end

	if not matchedSlot then
		return
	end

	-- Only clear the slot belonging to the player who left.
	-- Do NOT rebuild/reorder/reset all Fake User slots.
	local i = matchedSlot
	Settings.RealUsernames[i] = ""
	Settings.FakeUsers[i] = ""

	if UserBoxes[i] then
		UserBoxes[i].Text = ""
	end

	if RowUIList[i] then
		UpdatePlayerRow("", "", RowUIList[i])
	end

	-- If this player was selected, clear the selection as well.
	if SelectedGiftUsername:lower() == leavingUsername then
		SelectedGiftDisplayName = ""
		SelectedGiftUsername = ""
	end
end)

-- Initial population only; after this, slots are kept stable.
SyncFakeUsersFromServer()

-- ==========================================
-- LOCAL PLAYER BADGE
-- ==========================================
local function DestroyLocalBadge()
	if LocalBadgeBillboard then
		LocalBadgeBillboard:Destroy()
		LocalBadgeBillboard = nil
	end
end

local function DrawTikTokIcon(parent)
	-- Existing TikTok Creator icon: keep this design; only move it next to the title.
	local cyan = Instance.new("TextLabel", parent)
	cyan.Size = UDim2.fromScale(1, 1)
	cyan.Position = UDim2.fromOffset(-3, 0)
	cyan.BackgroundTransparency = 1
	cyan.Text = "♪"
	cyan.TextColor3 = Color3.fromRGB(37, 244, 238)
	cyan.Font = Enum.Font.GothamBlack
	cyan.TextSize = 33
	cyan.TextXAlignment = Enum.TextXAlignment.Center
	cyan.TextYAlignment = Enum.TextYAlignment.Center

	local magenta = cyan:Clone()
	magenta.Parent = parent
	magenta.Position = UDim2.fromOffset(3, 2)
	magenta.TextColor3 = Color3.fromRGB(254, 44, 85)

	local white = cyan:Clone()
	white.Parent = parent
	white.Position = UDim2.fromOffset(0, 0)
	white.TextColor3 = Color3.fromRGB(255, 255, 255)
	local outline = Instance.new("UIStroke", white)
	outline.Color = Color3.fromRGB(0, 0, 0)
	outline.Thickness = 0.8
end

local function ApplyLocalBadge()
	DestroyLocalBadge()

	if not BadgeEnabled then
		return
	end

	local character = Player.Character
	local head = character and character:FindFirstChild("Head")
	if not head then
		return
	end

	local badgeType = BadgeTypes[BadgeTypeIndex]
	local textSize = 32
	local textBounds = TextService:GetTextSize(
		badgeType,
		textSize,
		Enum.Font.GothamBlack,
		Vector2.new(1000, 70)
	)

	-- Measure the title first so the whole badge can be centered as one unit.
	local textWidth = math.max(150, textBounds.X + 8)
	local iconWidth = badgeType == "TikTok Creator" and 38 or 0
	local gap = badgeType == "TikTok Creator" and 3 or 0
	local totalWidth = textWidth + iconWidth + gap
	local billboardWidth = math.max(270, totalWidth + 24)
	local billboardHeight = 70
	-- Keep TikTok Creator at its current position (-20 px).
	-- Developer and Creator are moved +20 px to the right (back to 0).
	local BADGE_HORIZONTAL_SHIFT = badgeType == "TikTok Creator" and -20 or 0
	local left = (billboardWidth - totalWidth) / 2 + BADGE_HORIZONTAL_SHIFT

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "LocalPlayerBadge"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(billboardWidth, billboardHeight)
	-- Slightly lower than the previous placement.
	billboard.StudsOffset = Vector3.new(0, 3.0, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 120
	billboard.Parent = head
	LocalBadgeBillboard = billboard

	if badgeType == "TikTok Creator" then
		local iconFrame = Instance.new("Frame", billboard)
		iconFrame.Size = UDim2.fromOffset(iconWidth, 38)
		iconFrame.Position = UDim2.fromOffset(left, 16)
		iconFrame.BackgroundTransparency = 1
		iconFrame.BorderSizePixel = 0
		DrawTikTokIcon(iconFrame)

		left += iconWidth + gap
	end

	-- Title is centered relative to the screen. The TikTok icon is attached immediately to its left.
	local title = Instance.new("TextLabel", billboard)
	title.Name = "BadgeTitle"
	title.Size = UDim2.fromOffset(textWidth, billboardHeight)
	title.Position = UDim2.fromOffset(left, 0)
	title.BackgroundTransparency = 1
	title.BorderSizePixel = 0
	title.Text = badgeType
	title.Font = Enum.Font.GothamBlack
	title.TextSize = textSize
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.TextYAlignment = Enum.TextYAlignment.Center
	title.ZIndex = 2

	local shadow = Instance.new("TextLabel", billboard)
	shadow.Name = "BadgeShadow"
	shadow.Size = title.Size
	shadow.Position = UDim2.fromOffset(left, 2)
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Text = badgeType
	shadow.Font = Enum.Font.GothamBlack
	shadow.TextSize = textSize
	shadow.TextXAlignment = Enum.TextXAlignment.Center
	shadow.TextYAlignment = Enum.TextYAlignment.Center
	shadow.TextColor3 = Color3.fromRGB(0, 0, 0)
	shadow.TextTransparency = 0.08
	shadow.ZIndex = 1

	local stroke = Instance.new("UIStroke", title)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2.5

	if badgeType == "Developer" then
		-- No Developer icon. Only color the title.
		title.TextColor3 = Color3.fromRGB(110, 185, 255)

	elseif badgeType == "Creator" then
		-- No Creator icon. Requested red Creator text.
		title.TextColor3 = Color3.fromRGB(255, 70, 70)

	else
		-- TikTok icon stays unchanged; only keep the existing text treatment.
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		local gradient = Instance.new("UIGradient", title)
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(37, 244, 238)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(254, 44, 85))
		})
	end
end

local function RefreshBadgeControls()
	local badgeType = BadgeTypes[BadgeTypeIndex]
	BadgeTypeButton.Text = badgeType

	if BadgeEnabled then
		BadgeToggle.Text = "BADGE • ON"
		BadgeToggle.BackgroundColor3 = Color3.fromRGB(236, 70, 166)
		BadgeToggleStroke.Color = Color3.fromRGB(255, 153, 213)
	else
		BadgeToggle.Text = "BADGE • OFF"
		BadgeToggle.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
		BadgeToggleStroke.Color = Color3.fromRGB(84, 86, 95)
	end
end

BadgeToggle.MouseButton1Click:Connect(function()
	BadgeEnabled = not BadgeEnabled

	if BadgeEnabled then
		ApplyLocalBadge()
	else
		DestroyLocalBadge()
	end

	RefreshBadgeControls()
end)

BadgeTypeButton.MouseButton1Click:Connect(function()
	BadgeTypeIndex += 1
	if BadgeTypeIndex > #BadgeTypes then
		BadgeTypeIndex = 1
	end

	if BadgeEnabled then
		ApplyLocalBadge()
	end

	RefreshBadgeControls()
end)

RefreshBadgeControls()

Player.CharacterAdded:Connect(function()
	if BadgeEnabled then
		task.wait(0.35)
		ApplyLocalBadge()
	end
end)

-- ==========================================
-- SHOW GIFT PROMPT
-- ==========================================
local function ShowFakeGiftPrompt()
	SuccessPrompt.Visible =
		false

	PurchaseSuccessfulPrompt.Visible =
		false

	BuyPrompt.Visible =
		false

	LoadingPrompt.Visible =
		false

	GiftPrompt.Visible =
		true

	-- Gift Player is shown at normal brightness.
	-- The fullscreen black overlay is ONLY enabled when
	-- moving to Buy Item / Loading.
	DarkOverlay.Visible =
		false

	DarkOverlay.BackgroundTransparency =
		1
end

-- ==========================================
-- CLOSE ALL
-- ==========================================
local function ClosePopups()
	ConfettiRunId = ConfettiRunId + 1
	ConfettiHasStarted = false

	DarkOverlay.Visible =
		false

	GiftPrompt.Visible =
		false

	BuyPrompt.Visible =
		false

	SuccessPrompt.Visible =
		false

	PurchaseSuccessfulPrompt.Visible =
		false

	LoadingPrompt.Visible =
		false

	ConfettiLayer.Visible =
		false

	for _, piece in ipairs(
		ConfettiPieces
	) do
		if piece.Gui
			and piece.Gui.Parent then

			piece.Gui:Destroy()
		end
	end

	table.clear(
		ConfettiPieces
	)

	if ConfettiConnection then
		ConfettiConnection:Disconnect()
		ConfettiConnection = nil
	end
end

-- ==========================================
-- CONFETTI STATE
-- ==========================================
local ConfettiLayer =
	Instance.new(
		"Frame",
		ScreenGui
	)

ConfettiLayer.Name =
	"ConfettiLayer"

ConfettiLayer.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

ConfettiLayer.BackgroundTransparency =
	1

ConfettiLayer.BorderSizePixel =
	0

ConfettiLayer.Visible =
	false

ConfettiLayer.ZIndex =
	950

ConfettiLayer.ClipsDescendants =
	true

local ConfettiColors = {
	Color3.fromRGB(
		255,
		110,
		135
	),

	Color3.fromRGB(
		255,
		245,
		155
	),

	Color3.fromRGB(
		115,
		238,
		255
	),

	Color3.fromRGB(
		205,
		145,
		255
	),

	Color3.fromRGB(
		190,
		255,
		110
	),

	Color3.fromRGB(
		255,
		255,
		255
	)
}

local ConfettiPieces = {}
local ConfettiConnection
local ConfettiRunId = 0
local ConfettiHasStarted = false

local function ClearConfetti()
	ConfettiRunId +=
		1

	if ConfettiConnection then
		ConfettiConnection:Disconnect()
		ConfettiConnection = nil
	end

	for _, piece in ipairs(
		ConfettiPieces
	) do
		if piece.Gui
			and piece.Gui.Parent then

			piece.Gui:Destroy()
		end
	end

	table.clear(
		ConfettiPieces
	)

	ConfettiLayer.Visible =
		false
end

StartConfetti = function()
	if ConfettiHasStarted then
		return
	end
	ConfettiHasStarted = true
	ClearConfetti()

	local localRunId =
		ConfettiRunId

	ConfettiLayer.Visible =
		true

	local viewport =
		ConfettiLayer.AbsoluteSize

	local width =
		viewport.X > 0
		and viewport.X
		or 1920

	local height =
		viewport.Y > 0
		and viewport.Y
		or 1080

	local random =
		Random.new()

	-- Gradual rain: each ribbon is spawned after its own delay.
	local ribbonCount =
		108

	local spawnWindow =
		3.0

	local spawnedCount =
		0

	local activeCount =
		0

	local finished =
		false

	local elapsed =
		0

	local function StopRain()
		if finished then
			return
		end

		finished =
			true

		if ConfettiConnection then
			ConfettiConnection:Disconnect()
			ConfettiConnection = nil
		end

		table.clear(
			ConfettiPieces
		)

		ConfettiLayer.Visible =
			false
	end

	for i = 1, ribbonCount do
		local spawnDelay =
			random:NextNumber(
				0,
				spawnWindow
			)

		task.delay(
			spawnDelay,
			function()
				if localRunId ~=
					ConfettiRunId
					or not ConfettiLayer.Parent
					then
					return
				end

				local ribbon =
					Instance.new(
						"Frame"
					)

				ribbon.Name =
					"FallingRibbon_" ..
					i

				local ribbonWidth =
					random:NextInteger(
						10,
						24
					)

				local ribbonHeight =
					random:NextInteger(
						24,
						56
					)

				ribbon.Size =
					UDim2.fromOffset(
						ribbonWidth,
						ribbonHeight
					)

				ribbon.AnchorPoint =
					Vector2.new(
						0.5,
						0.5
					)

				ribbon.Position =
					UDim2.fromOffset(
						random:NextNumber(
							-width * 0.05,
							width * 1.05
						),
						random:NextNumber(
							-180,
							-30
						)
					)

				ribbon.BackgroundColor3 =
					ConfettiColors[
						random:NextInteger(
							1,
							#ConfettiColors
						)
					]

				ribbon.BorderSizePixel =
					0

				ribbon.Rotation =
					random:NextInteger(
						-65,
						65
					)

				ribbon.ZIndex =
					951

				ribbon.Parent =
					ConfettiLayer

				activeCount +=
					1

				spawnedCount +=
					1

				table.insert(
					ConfettiPieces,
					{
						Gui = ribbon,

						x =
							ribbon.Position.X.Offset,

						y =
							ribbon.Position.Y.Offset,

						vx =
							random:NextNumber(
								-260,
								260
							),

						vy =
							random:NextNumber(
								260,
								520
							),

						gravity =
							random:NextNumber(
								650,
								1000
							),

						rotation =
							random:NextNumber(
								-180,
								180
							),

						spin =
							random:NextNumber(
								-780,
								780
							),

						wobble =
							random:NextNumber(
								10,
								34
							),

						wobbleSpeed =
							random:NextNumber(
								2.5,
								6.5
							),

						phase =
							random:NextNumber(
								0,
								math.pi * 2
							),

						counted =
							true
					}
				)
			end
		)
	end

	ConfettiConnection =
		RunService.RenderStepped:Connect(
			function(dt)
				if localRunId ~=
					ConfettiRunId
					or finished then
					return
				end

				elapsed +=
					dt

				for index = #ConfettiPieces, 1, -1 do
					local piece =
						ConfettiPieces[index]

					if piece.Gui
						and piece.Gui.Parent then

						piece.vy +=
							piece.gravity *
							dt

						piece.x +=
							piece.vx *
							dt

						piece.y +=
							piece.vy *
							dt

						piece.x +=
							math.sin(
								elapsed *
									piece.wobbleSpeed +
									piece.phase
							) *
							piece.wobble *
							dt

						piece.rotation +=
							piece.spin *
							dt

						piece.Gui.Position =
							UDim2.fromOffset(
								piece.x,
								piece.y
							)

						piece.Gui.Rotation =
							piece.rotation

						if piece.y >
							height + 100 then

							piece.Gui:Destroy()

							if piece.counted then
								piece.counted =
									false

								activeCount -=
									1
							end

							table.remove(
								ConfettiPieces,
								index
							)
						end
					else
						if piece.counted then
							piece.counted =
								false

							activeCount -=
								1
						end

						table.remove(
							ConfettiPieces,
							index
						)
					end
				end

				-- Only finish after all ribbons have spawned and
				-- every last ribbon has fallen completely below the screen.
				if spawnedCount >= ribbonCount
					and activeCount <= 0 then
					StopRain()
				end
			end
		)
end

-- ==========================================
-- PURCHASE COMPLETED -> RIBBON
-- Every time Purchase completed is shown, start the existing
-- ribbon effect at the same time.
-- ==========================================
SuccessPrompt:GetPropertyChangedSignal(
	"Visible"
):Connect(function()
	if SuccessPrompt.Visible then
		-- Restart the existing ribbon effect every time Purchase Completed opens.
		ConfettiHasStarted =
			false

		if StartConfetti then
			StartConfetti()
		end
	end
end)

-- ==========================================
-- PURCHASE COMPLETED
-- CHỈ ĐÓNG BẢNG TRÊN
-- ==========================================
OkBtn.MouseButton1Click:Connect(function()
	SuccessPrompt.Visible = false
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 0.5
	PurchaseSuccessfulPrompt.Visible = true
end)

CloseBtnX2.MouseButton1Click:Connect(function()
	SuccessPrompt.Visible =
		false

	PurchaseSuccessfulPrompt.Visible =
		false

	ClosePopups()
end)

-- ==========================================
-- PURCHASE SUCCESSFUL
-- CHỈ ĐÓNG BẢNG DƯỚI
-- ==========================================
SuccessfulOkBtn.MouseButton1Click:Connect(function()
	PurchaseSuccessfulPrompt.Visible = false
	SuccessPrompt.Visible = false
	ClosePopups()
end)

-- ==========================================
-- CLOSE GIFT / BUY
-- ==========================================
CloseGiftBtn.MouseButton1Click:Connect(
	function()
		ClosePopups()
	end
)

CloseGiftBtn.Activated:Connect(
	function()
		ClosePopups()
	end
)

local function ReturnFromBuyToGift()
	BuyPrompt.Visible =
		false

	PurchaseSuccessfulPrompt.Visible =
		false

	SuccessPrompt.Visible =
		false

	LoadingPrompt.Visible =
		false

	GiftPrompt.Visible =
		true

	-- Remove the fullscreen dimmer when returning to Gift Player.
	DarkOverlay.Visible =
		false

	DarkOverlay.BackgroundTransparency =
		1
end

CloseBtnX.MouseButton1Click:Connect(
	function()
		ReturnFromBuyToGift()
	end
)

CloseBtnX.Activated:Connect(
	function()
		ReturnFromBuyToGift()
	end
)

-- ==========================================
-- FORCE TEST
-- ==========================================
ForceTestBtn.MouseButton1Click:Connect(function()
	ShowFakeGiftPrompt()
end)

-- ==========================================
-- HOOK GIFT BUTTON
-- ==========================================
local function HookGiftButton(guiObject)
	if not guiObject:IsA("GuiButton") then
		return
	end

	local isGiftBtn =
		false

	local checkName =
		guiObject.Name:lower()

	if checkName:match(
		"gift"
	)
		or checkName:match(
			"present"
		)
		or checkName:match(
			"send"
		) then

		isGiftBtn =
			true
	end

	for _, child in pairs(
		guiObject:GetDescendants()
	) do

		if child:IsA("TextLabel") then
			local text =
				child.Text:lower()

			if text:match(
				"gift"
			)
				or text:match(
					"send"
				) then

				isGiftBtn =
					true
			end
		end
	end

	if not isGiftBtn then
		return
	end

	if guiObject:GetAttribute(
		"VisualFakeHooked"
	) then
		return
	end

	guiObject:SetAttribute(
		"VisualFakeHooked",
		true
	)

	local BlockerBtn =
		Instance.new(
			"TextButton"
		)

	BlockerBtn.Name =
		"FakeGiftBlocker"

	BlockerBtn.Size =
		UDim2.new(
			1,
			0,
			1,
			0
		)

	BlockerBtn.Position =
		UDim2.new(
			0,
			0,
			0,
			0
		)

	BlockerBtn.BackgroundTransparency =
		1

	BlockerBtn.Text =
		""

	BlockerBtn.ZIndex =
		999999

	BlockerBtn.Parent =
		guiObject

	BlockerBtn.MouseButton1Click:Connect(
		function()

			ShowFakeGiftPrompt()

			local current =
				guiObject.Parent

			while current
				and not current:IsA(
					"ScreenGui"
				) do

				if current:IsA(
					"Frame"
				)
					or current:IsA(
						"CanvasGroup"
					) then

					local n =
						current.Name:lower()

					if n:match(
						"shop"
					)
						or n:match(
							"store"
						)
						or n:match(
							"market"
						) then

						current.Visible =
							false
					end
				end

				current =
					current.Parent
			end

			for _, screen in pairs(
				PlayerGui:GetChildren()
			) do

				if screen:IsA(
					"ScreenGui"
				)
					and screen.Name ~=
					"RobloxFakeUI" then

					local screenName =
						screen.Name:lower()

					if screenName:match(
						"shop"
					)
						or screenName:match(
							"store"
						)
						or screenName:match(
							"market"
						) then

						screen.Enabled =
							false
					end

					for _, child in pairs(
						screen:GetDescendants()
					) do

						if (
							child:IsA(
								"Frame"
							)
							or child:IsA(
								"ScrollingFrame"
							)
							or child:IsA(
								"CanvasGroup"
							)
						)
							and child.Visible then

							local n =
								child.Name:lower()

							if n:match(
								"shop"
							)
								or n:match(
									"store"
								)
								or n:match(
									"market"
								) then

								child.Visible =
									false
							end
						end
					end
				end
			end
		end
	)
end

-- ==========================================
-- INITIAL HOOK
-- ==========================================
for _, obj in pairs(
	PlayerGui:GetDescendants()
) do
	HookGiftButton(obj)
end

-- ==========================================
-- FUTURE HOOKS
-- ==========================================
PlayerGui.DescendantAdded:Connect(
	HookGiftButton
)
