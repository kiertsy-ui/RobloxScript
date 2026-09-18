-- ==========================================
-- CONFIG & SETTINGS
-- ==========================================
Settings = {
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

PurchasePrice = 3499

-- Requested badge / selected-recipient state
SelectedGiftDisplayName = ""
SelectedGiftUsername = ""
ActiveGiftSource = "Shop"
BadgeEnabled = false
BadgeTypeIndex = 1
BadgeTypes = {
	"Developer",
	"Creator",
	"TikTok Creator"
}
LocalBadgeBillboard = nil

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
Players = game:GetService("Players")
UserService = game:GetService("UserService")
UserInputService = game:GetService("UserInputService")
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
ContentProvider = game:GetService("ContentProvider")
TextService = game:GetService("TextService")

Player = Players.LocalPlayer
PlayerGui = Player:WaitForChild("PlayerGui")

-- ==========================================
-- GUI CONTAINER
-- ==========================================
UIContainer = nil

success, coreGui = pcall(function()
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

ScreenGui = Instance.new("ScreenGui")
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
ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(0, 300, 0, 690)
ControlPanel.Position = UDim2.new(0, 20, 0.5, -345)
ControlPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ControlPanel.BorderSizePixel = 0
ControlPanel.Parent = ScreenGui

Instance.new(
	"UICorner",
	ControlPanel
).CornerRadius = UDim.new(0, 8)

CPad =
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

CLayout =
	Instance.new(
		"UIListLayout",
		ControlPanel
	)

CLayout.Padding =
	UDim.new(0, 8)

CTitle =
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

BalanceBox =
	CreateCPInput(
		"",
		FormatNumber(
			Settings.Balance
		)
	)

UserBoxes = {}

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

ForceTestBtn =
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

HideControlPanelBtn = Instance.new("TextButton", ControlPanel)
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
ControlPanelHidden = false
ControlPanelNormalPosition = ControlPanel.Position
ControlPanelNormalSize = ControlPanel.Size

-- This button is only visible in hidden mode and sits directly above Fake User 1.
OpenFullPanelBtn = Instance.new("TextButton", ControlPanel)
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
BadgeToggle = Instance.new("TextButton", ControlPanel)
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
BadgeToggleStroke = Instance.new("UIStroke", BadgeToggle)
BadgeToggleStroke.Color = Color3.fromRGB(84, 86, 95)
BadgeToggleStroke.Thickness = 1

BadgeTypeButton = Instance.new("TextButton", ControlPanel)
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
BadgeTypeStroke = Instance.new("UIStroke", BadgeTypeButton)
BadgeTypeStroke.Color = Color3.fromRGB(71, 73, 82)
BadgeTypeStroke.Thickness = 1

BadgeHint = Instance.new("TextLabel", ControlPanel)
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
dragging = false
dragInput = nil
dragStart = nil
startPos = nil

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
DarkOverlay =
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
SpawnModelPanel = Instance.new("Frame")
SpawnModelPanel.Name = "SpawnModelPanel"
SpawnModelPanel.Size = ControlPanelNormalSize
SpawnModelPanel.Position = ControlPanelNormalPosition
SpawnModelPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SpawnModelPanel.BorderSizePixel = 0
SpawnModelPanel.Visible = false
SpawnModelPanel.ZIndex = 1500
SpawnModelPanel.Parent = ScreenGui

Instance.new("UICorner", SpawnModelPanel).CornerRadius = UDim.new(0, 8)

SpawnPanelStroke = Instance.new("UIStroke", SpawnModelPanel)
SpawnPanelStroke.Color = Color3.fromRGB(60, 60, 68)
SpawnPanelStroke.Thickness = 1

SpawnTitle = Instance.new("TextLabel", SpawnModelPanel)
SpawnTitle.Size = UDim2.new(1, -30, 0, 28)
SpawnTitle.Position = UDim2.new(0, 15, 0, 12)
SpawnTitle.BackgroundTransparency = 1
SpawnTitle.Text = "SPAWN MODEL"
SpawnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnTitle.Font = Enum.Font.GothamBold
SpawnTitle.TextSize = 16
SpawnTitle.TextXAlignment = Enum.TextXAlignment.Left
SpawnTitle.ZIndex = 1502

SpawnInfo = Instance.new("TextLabel", SpawnModelPanel)
SpawnInfo.Size = UDim2.new(1, -30, 0, 20)
SpawnInfo.Position = UDim2.new(0, 15, 0, 42)
SpawnInfo.BackgroundTransparency = 1
SpawnInfo.Text = "Scanning EGG / LUMINOUS models..."
SpawnInfo.TextColor3 = Color3.fromRGB(165, 165, 175)
SpawnInfo.Font = Enum.Font.Gotham
SpawnInfo.TextSize = 11
SpawnInfo.TextXAlignment = Enum.TextXAlignment.Left
SpawnInfo.ZIndex = 1502

SpawnHeightLabel = Instance.new("TextLabel", SpawnModelPanel)
SpawnHeightLabel.Size = UDim2.fromOffset(75, 22)
SpawnHeightLabel.Position = UDim2.fromOffset(15, 70)
SpawnHeightLabel.BackgroundTransparency = 1
SpawnHeightLabel.Text = "Height"
SpawnHeightLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
SpawnHeightLabel.Font = Enum.Font.GothamMedium
SpawnHeightLabel.TextSize = 11
SpawnHeightLabel.TextXAlignment = Enum.TextXAlignment.Left
SpawnHeightLabel.ZIndex = 1502

SpawnHeightBox = Instance.new("TextBox", SpawnModelPanel)
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

SpawnSizeLabel = Instance.new("TextLabel", SpawnModelPanel)
SpawnSizeLabel.Size = UDim2.fromOffset(55, 22)
SpawnSizeLabel.Position = UDim2.fromOffset(155, 70)
SpawnSizeLabel.BackgroundTransparency = 1
SpawnSizeLabel.Text = "Size"
SpawnSizeLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
SpawnSizeLabel.Font = Enum.Font.GothamMedium
SpawnSizeLabel.TextSize = 11
SpawnSizeLabel.TextXAlignment = Enum.TextXAlignment.Left
SpawnSizeLabel.ZIndex = 1502

SpawnSizeBox = Instance.new("TextBox", SpawnModelPanel)
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

SpawnSearchBox = Instance.new("TextBox", SpawnModelPanel)
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

RefreshModelsBtn = Instance.new("TextButton", SpawnModelPanel)
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

SpawnModelList = Instance.new("ScrollingFrame", SpawnModelPanel)
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

SpawnModelListLayout = Instance.new("UIListLayout", SpawnModelList)
SpawnModelListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SpawnModelListLayout.Padding = UDim.new(0, 6)

SpawnModelListPadding = Instance.new("UIPadding", SpawnModelList)
SpawnModelListPadding.PaddingBottom = UDim.new(0, 8)

-- ==========================================
-- FLOATING SEND BUTTON (SPAWN MODEL)
-- ==========================================
-- The button is independent from ControlPanel so dragging the panel does not
-- move it. It starts in the center of the screen and can be locked in place.
ShowFakeGiftPrompt = nil
SpawnModelSendLocked = false
-- Once SEND has been locked for the first time, it remains visible for the rest
-- of this script session, including when switching tabs.
SpawnModelSendEverLocked = false
SpawnModelSendDragging = false
SpawnModelSendPressed = false
SpawnModelSendDragged = false
SpawnModelSendDragInput = nil
SpawnModelSendDragStart = nil
SpawnModelSendStartPosition = nil
SpawnModelSendButton = nil
SpawnModelSendLockButton = nil
SpawnModelSendStatus = nil
SpawnModelRealShopButton = nil

local function SpawnModel_FindRealShopButton()
	if not PlayerGui then return nil end

	local best = nil
	local bestArea = -1
	local bestExact = -1

	for _, obj in ipairs(PlayerGui:GetDescendants()) do
		if obj:IsA("TextButton") or obj:IsA("ImageButton") then
			local name = string.lower(tostring(obj.Name or ""))
			local text = obj:IsA("TextButton") and string.lower(tostring(obj.Text or "")) or ""
			local exact = 0
			if name == "shop" or name == "shopbutton" or text == "shop" then
				exact = 2
			elseif name:find("shop", 1, true) or name:find("store", 1, true)
				or text:find("shop", 1, true) then
				exact = 1
			end

			if exact > 0 then
				local size = obj.AbsoluteSize
				local area = math.max(size.X, 0) * math.max(size.Y, 0)
				if size.X > 10 and size.Y > 10 and (exact > bestExact or (exact == bestExact and area > bestArea)) then
					best = obj
					bestArea = area
					bestExact = exact
				end
			end
		end
	end

	return best
end

local function SpawnModel_ApplySendSize()
	if not SpawnModelSendButton then return end
	local shop = SpawnModel_FindRealShopButton()
	SpawnModelRealShopButton = shop

	-- Keep SEND slightly smaller than the real Shop button while preserving
	-- the Shop button's exact aspect ratio. This is the only visual change.
	local widthScale = 0.6331526784 -- keep current width unchanged
	local heightScale = 0.9576435 -- SEND height +10% again; width unchanged
	if shop and shop.AbsoluteSize.X > 10 and shop.AbsoluteSize.Y > 10 then
		local width = math.max(1, math.floor(shop.AbsoluteSize.X * widthScale + 0.5))
		local height = math.max(1, math.floor(shop.AbsoluteSize.Y * heightScale + 0.5))
		SpawnModelSendButton.Size = UDim2.fromOffset(width, height)
	else
		-- Safe startup fallback matching the same additional 20% reduction.
		SpawnModelSendButton.Size = UDim2.fromOffset(117, 76)
	end
end

SpawnModelSendButton = Instance.new("TextButton", ScreenGui)
SpawnModelSendButton.Name = "SpawnModelSendButton"
SpawnModelSendButton.AnchorPoint = Vector2.new(0.5, 0.5)
SpawnModelSendButton.Position = UDim2.fromScale(0.5, 0.5)
SpawnModelSendButton.BackgroundColor3 = Color3.fromRGB(247, 210, 44)
SpawnModelSendButton.BorderSizePixel = 0
SpawnModelSendButton.Text = ""
SpawnModelSendButton.AutoButtonColor = false
SpawnModelSendButton.Active = true
SpawnModelSendButton.Visible = false
SpawnModelSendButton.ZIndex = 400
SpawnModelSendButton.ClipsDescendants = true
-- DarkOverlay is ZIndex 500. Keep the entire floating SEND button below it,
-- including its icon/text children, so the black fullscreen dimmer can cover it.
SpawnModelSendButton.ZIndex = 400
pcall(function()
	SendDepth.ZIndex = 401
	SendTriangle.ZIndex = 402
	SendText.ZIndex = 403
end)

SendCorner = Instance.new("UICorner", SpawnModelSendButton)
SendCorner.CornerRadius = UDim.new(0, 4)

SendStroke = Instance.new("UIStroke", SpawnModelSendButton)
-- Soft, thin yellow outer border matching the reference.
SendStroke.Color = Color3.fromRGB(0, 0, 0)
SendStroke.Thickness = 3
SendStroke.Transparency = 0.03
SendStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

SendBackgroundGradient = Instance.new("UIGradient", SpawnModelSendButton)
SendBackgroundGradient.Name = "SendBackgroundGradient"
SendBackgroundGradient.Rotation = 90
SendBackgroundGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 232, 93)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 220, 55)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(230, 174, 16))
})

SendDepth = Instance.new("ImageLabel", SpawnModelSendButton)
SendDepth.Name = "SendDepth"
SendDepth.AnchorPoint = Vector2.new(0, 0)
SendDepth.Position = UDim2.fromScale(0, 0)
SendDepth.Size = UDim2.fromScale(1, 1)
SendDepth.BackgroundTransparency = 1
SendDepth.Image = "rbxassetid://90325592797235"
SendDepth.ImageColor3 = Color3.fromRGB(255, 255, 255)
SendDepth.ImageTransparency = 0.60
-- Repeat the supplied asset across the entire SEND button.
-- Do NOT stretch a single copy; use Tile and a 3x larger tile so each repeated effect is larger.
SendDepth.ScaleType = Enum.ScaleType.Tile
SendDepth.TileSize = UDim2.fromOffset(76.608, 76.608)
SendDepth.ZIndex = 401
SendDepth.Active = false

SendTriangle = Instance.new("ImageLabel", SpawnModelSendButton)
SendTriangle.Name = "SendTriangle"
SendTriangle.AnchorPoint = Vector2.new(0, 0.5)
SendTriangle.Position = UDim2.new(0.055, 0, 0.5, 0)
SendTriangle.Size = UDim2.new(0.276, 0, 0.75, 0)
SendTriangle.BackgroundTransparency = 1
SendTriangle.Image = "rbxassetid://79657591184601"
SendTriangle.ImageColor3 = Color3.fromRGB(255, 255, 255)
SendTriangle.ScaleType = Enum.ScaleType.Fit
SendTriangle.ZIndex = 402
SendTriangle.Active = false

SendText = Instance.new("TextLabel", SpawnModelSendButton)
SendText.Name = "SendText"
SendText.AnchorPoint = Vector2.new(0.5, 0.5)
SendText.Position = UDim2.new(0.64, 0, 0.49, 0)
SendText.Size = UDim2.new(0.594, 0, 0.7776, 0)
SendText.BackgroundTransparency = 1
SendText.Text = "Send"
SendText.TextColor3 = Color3.fromRGB(255, 255, 255)
SendText.Font = Enum.Font.GothamBlack
SendText.TextScaled = true
SendText.TextXAlignment = Enum.TextXAlignment.Center
SendText.TextYAlignment = Enum.TextYAlignment.Center
SendText.ZIndex = 403
SendText.Active = false

SendTextConstraint = Instance.new("UITextSizeConstraint", SendText)
SendTextConstraint.MinTextSize = 10
SendTextConstraint.MaxTextSize = 37

SendTextStroke = Instance.new("UIStroke", SendText)
SendTextStroke.Color = Color3.fromRGB(0, 0, 0)
SendTextStroke.Thickness = 3.2

SpawnModelSendLockButton = Instance.new("TextButton", SpawnModelPanel)
SpawnModelSendLockButton.Name = "LockSendPosition"
SpawnModelSendLockButton.Size = UDim2.fromOffset(126, 24)
SpawnModelSendLockButton.Position = UDim2.fromOffset(15, 136)
SpawnModelSendLockButton.BackgroundColor3 = Color3.fromRGB(70, 70, 78)
SpawnModelSendLockButton.BorderSizePixel = 0
SpawnModelSendLockButton.Text = "LOCK SEND"
SpawnModelSendLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnModelSendLockButton.Font = Enum.Font.GothamBold
SpawnModelSendLockButton.TextSize = 10
SpawnModelSendLockButton.AutoButtonColor = false
SpawnModelSendLockButton.ZIndex = 1507
Instance.new("UICorner", SpawnModelSendLockButton).CornerRadius = UDim.new(0, 4)

SpawnModelSendStatus = Instance.new("TextLabel", SpawnModelPanel)
SpawnModelSendStatus.Name = "SendLockStatus"
SpawnModelSendStatus.Size = UDim2.fromOffset(114, 24)
SpawnModelSendStatus.Position = UDim2.fromOffset(148, 136)
SpawnModelSendStatus.BackgroundTransparency = 1
SpawnModelSendStatus.Text = "UNLOCKED • DRAG"
SpawnModelSendStatus.TextColor3 = Color3.fromRGB(150, 150, 160)
SpawnModelSendStatus.Font = Enum.Font.Gotham
SpawnModelSendStatus.TextSize = 9
SpawnModelSendStatus.TextXAlignment = Enum.TextXAlignment.Left
SpawnModelSendStatus.TextYAlignment = Enum.TextYAlignment.Center
SpawnModelSendStatus.ZIndex = 1507

SpawnModelList.Position = UDim2.fromOffset(15, 167)

SpawnModel_ApplySendSize()

SpawnModelEntries = {}
SpawnModelSources = {}
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


SpawnModelSaved = {}
SpawnModelFirstScanDone = false

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

SavedRowOrder = -100000

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
-- SPAWN PET TAB (integrated from script111)
-- ==========================================
-- This module intentionally uses one shared state table so it does not add
-- many top-level local registers to the host script.
SpawnPetState = rawget(_G, "__BestScriptSpawnPetState") or {}
_G.__BestScriptSpawnPetState = SpawnPetState

SpawnPetState.ServicePlayers = Players
SpawnPetState.ServiceReplicatedStorage = ReplicatedStorage
SpawnPetState.ServiceRunService = RunService
SpawnPetState.ServiceContentProvider = ContentProvider
SpawnPetState.Meta = SpawnPetState.Meta or {name="", rarity="", perSecond="", image="", animationId="", animationName=""}
-- Authoritative pet-data fields discovered from the real game sources.
SpawnPetState.Meta.category = SpawnPetState.Meta.category or ""
SpawnPetState.Meta.scale = tonumber(SpawnPetState.Meta.scale) or 1
SpawnPetState.Meta.mutations = SpawnPetState.Meta.mutations or {}
SpawnPetState.Meta.baseMutation = SpawnPetState.Meta.baseMutation
SpawnPetState.Meta.creatorTemporary = SpawnPetState.Meta.creatorTemporary == true
SpawnPetState.Meta.hasBeenFirstPlaced = SpawnPetState.Meta.hasBeenFirstPlaced ~= false
SpawnPetState.Meta.earningRate = tonumber(SpawnPetState.Meta.earningRate) or 0
SpawnPetState.Meta.perSecondValue = tonumber(SpawnPetState.Meta.perSecondValue) or 0
SpawnPetState.Meta.rarityNumber = tonumber(SpawnPetState.Meta.rarityNumber) or 0
SpawnPetState.SpawnedTools = SpawnPetState.SpawnedTools or {}
SpawnPetState.HotbarBindings = SpawnPetState.HotbarBindings or {}
SpawnPetState.HotbarOriginals = SpawnPetState.HotbarOriginals or {}
SpawnPetState.AnimationTrackByClone = SpawnPetState.AnimationTrackByClone or {}
SpawnPetState.ToolToClone = SpawnPetState.ToolToClone or {}
SpawnPetState.ToolToSlot = SpawnPetState.ToolToSlot or {}
SpawnPetState.AssetItemByClone = SpawnPetState.AssetItemByClone or setmetatable({}, {__mode="k"})
SpawnPetState.SearchToken = 0

function SpawnPet_Normalize(value)
	value = tostring(value or "")
	value = string.gsub(value, "\r", " ")
	value = string.gsub(value, "\n", " ")
	value = string.gsub(value, "%s+", " ")
	value = string.gsub(value, "^%s+", "")
	value = string.gsub(value, "%s+$", "")
	return value
end

function SpawnPet_AssetId(value)
	local text = tostring(value or "")
	local id = string.match(text, "rbxassetid://(%d+)")
	if id then return id end
	id = string.match(text, "[?&]id=(%d+)")
	if id then return id end
	return nil
end

function SpawnPet_Rarity(value)
	local v = SpawnPet_Normalize(value)
	if v == "" then return "" end
	local cleaned = string.lower(v)
	cleaned = string.gsub(cleaned, "^rarity%s*[:=]%s*", "")
	cleaned = string.gsub(cleaned, "^odds%s*[:=]%s*", "")
	cleaned = SpawnPet_Normalize(cleaned)
	local labels = {
		common=true, uncommon=true, rare=true, superrare=true, ["super rare"]=true,
		epic=true, legendary=true, mythic=true, secret=true, eternal=true,
		divine=true, exclusive=true, celestial=true, ultra=true, cosmic=true,
		godly=true, transcendent=true, trans=true, limited=true, og=true,
	}
	if labels[cleaned] then return v end
	if labels[string.gsub(cleaned, "%s+", "")] then return v end
	return ""
end

function SpawnPet_FormatRate(value)
	-- IMPORTANT: never invent display formatting for Pet income. Preserve the
	-- exact string supplied by the game's runtime/config source.
	return SpawnPet_Normalize(value)
end

function SpawnPet_FormatWeight(value)
	local text = SpawnPet_Normalize(value)
	if text == "" then return "" end
	if string.find(string.lower(text), "kg", 1, true) then
		return text
	end
	local numeric = tonumber(text)
	if numeric then
		local whole, frac = string.match(text, "^([%d%-]+)(%.%d+)?$")
		if whole then
			local sign = ""
			if string.sub(whole, 1, 1) == "-" then
				sign = "-"
				whole = string.sub(whole, 2)
			end
			while #whole > 3 do
				whole = string.sub(whole, 1, #whole - 3) .. "," .. string.sub(whole, -3)
			end
			return sign .. whole .. (frac or "") .. "Kg"
		end
		return text .. "Kg"
	end
	return text
end

function SpawnPet_FindWeightInInstance(root)
	if not root then return "" end
	local found = ""
	local function consider(key, value)
		if found ~= "" then return end
		local k = string.lower(SpawnPet_Normalize(key))
		local v = SpawnPet_Normalize(value)
		if v == "" then return end
		if k == "weight" or k == "petweight" or k == "weightdisplay" or k == "kg" or k == "kilograms" or string.find(k, "weight", 1, true) then
			found = SpawnPet_FormatWeight(v)
			return
		end
		if string.find(string.lower(v), "kg", 1, true) and string.find(string.lower(k), "weight", 1, true) then
			found = SpawnPet_FormatWeight(v)
		end
	end

	for k, v in pairs(root:GetAttributes()) do
		consider(k, v)
	end
	if found ~= "" then return found end

	local count = 0
	for _, obj in ipairs(root:GetDescendants()) do
		count = count + 1
		if count > 1400 or found ~= "" then break end
		for k, v in pairs(obj:GetAttributes()) do
			consider(k, v)
		end
		if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") then
			consider(obj.Name, obj.Value)
		end
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
			local t = SpawnPet_Normalize(obj.Text)
			if string.find(string.lower(t), "kg", 1, true) then
				found = SpawnPet_FormatWeight(t)
			end
		end
	end
	return found
end

function SpawnPet_ReadObject(obj)
	if not obj then return "" end
	local ok, value = pcall(function()
		if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") or obj:IsA("BoolValue") then return obj.Value end
		if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then return obj.Text end
		if obj:IsA("ImageLabel") or obj:IsA("ImageButton") then return obj.Image end
		return nil
	end)
	if ok then return SpawnPet_Normalize(value) end
	return ""
end

function SpawnPet_DirectAssetModel(query)
	local wanted = string.lower(SpawnPet_Normalize(query))
	if wanted == "" then return nil end
	local assets = ReplicatedStorage:FindFirstChild("AssetModels")
	if not assets then return nil end
	local exact, contains = nil, nil
	for _, child in ipairs(assets:GetChildren()) do
		if child:IsA("Model") then
			local n = string.lower(SpawnPet_Normalize(child.Name))
			if n == wanted then
				exact = child
				break
			elseif not contains and string.find(n, wanted, 1, true) then
				contains = child
			end
		end
	end
	return exact or contains
end

function SpawnPet_FindConfigModule(query)
	local wanted = SpawnPet_Normalize(query)
	if wanted == "" then return nil end
	local data = ReplicatedStorage:FindFirstChild("Data")
	local assets = data and data:FindFirstChild("Assets")
	local configs = assets and assets:FindFirstChild("Configs")
	if not configs then return nil end
	local direct = configs:FindFirstChild(wanted)
	if direct and direct:IsA("ModuleScript") then return direct end
	local lower = string.lower(wanted)
	for _, child in ipairs(configs:GetChildren()) do
		if child:IsA("ModuleScript") and string.lower(tostring(child.Name)) == lower then return child end
	end
	return nil
end

function SpawnPet_InspectConfigTable(config, result)
	result = result or {name="", rarity="", perSecond="", image="", animationId="", animationName=""}
	if type(config) ~= "table" then return result end
	local seen = {}
	local function walk(tbl, path, depth)
		if type(tbl) ~= "table" or seen[tbl] or depth > 9 then return end
		seen[tbl] = true
		local keys = {}
		for k in pairs(tbl) do keys[#keys + 1] = k end
		table.sort(keys, function(a,b) return tostring(a) < tostring(b) end)
		for _, key in ipairs(keys) do
			local value = tbl[key]
			local k = string.lower(SpawnPet_Normalize(key))
			local p = string.lower(path == "" and k or (path .. "." .. k))
			local keyRate = string.find(k, "persecond", 1, true) or string.find(k, "generation", 1, true) or string.find(k, "income", 1, true) or string.find(k, "earning", 1, true) or string.find(k, "production", 1, true)
			local keyAnim = string.find(k, "animation", 1, true) or string.find(k, "animid", 1, true) or string.find(k, "idle", 1, true) or string.find(k, "walk", 1, true) or string.find(k, "run", 1, true) or string.find(k, "fly", 1, true) or string.find(k, "swim", 1, true) or string.find(k, "track", 1, true)
			local keyImage = string.find(k, "image", 1, true) or string.find(k, "icon", 1, true) or string.find(k, "thumbnail", 1, true)
			local keyRarity = (k == "rarity" or k == "odds" or string.find(k, "rarity", 1, true) ~= nil)
			if typeof(value) == "Instance" then
				if value:IsA("Animation") and keyAnim and result.animationId == "" then
					local id = SpawnPet_AssetId(value.AnimationId)
					if id then result.animationId = "rbxassetid://" .. id; result.animationName = value.Name end
				elseif value:IsA("StringValue") or value:IsA("NumberValue") or value:IsA("IntValue") then
					local iv = SpawnPet_ReadObject(value)
					if keyRate and result.perSecond == "" then result.perSecond = iv end
					if keyRarity and result.rarity == "" then result.rarity = iv end
					if keyImage and result.image == "" then
						local id = SpawnPet_AssetId(iv)
						if id then result.image = "rbxassetid://"..id end
					end
					if keyAnim and result.animationId == "" then
						local id = SpawnPet_AssetId(iv)
						if id then result.animationId = "rbxassetid://"..id; result.animationName = value.Name end
					end
				end
			elseif type(value) == "table" then
				walk(value, p, depth + 1)
			elseif type(value) == "string" or type(value) == "number" then
				local text = SpawnPet_Normalize(value)
				if result.name == "" and (k == "displayname" or k == "petname") and text ~= "" then result.name = text end
				if result.rarity == "" and keyRarity and text ~= "" then result.rarity = text end
				if result.perSecond == "" and keyRate and text ~= "" then result.perSecond = text end
				if result.image == "" and keyImage then
					local id = SpawnPet_AssetId(text)
					if id then result.image = "rbxassetid://"..id end
				end
				if result.animationId == "" and keyAnim then
					local id = SpawnPet_AssetId(text)
					if id then result.animationId = "rbxassetid://"..id; result.animationName = tostring(key) end
				end
			end
		end
	end
	walk(config, "", 0)
	result.rarity = SpawnPet_Rarity(result.rarity)
	result.perSecond = SpawnPet_FormatRate(result.perSecond)
	return result
end

function SpawnPet_ReadAssetModelMetadata(model)
	local result = {name=model and model.Name or "", rarity="", perSecond="", image="", animationId="", animationName=""}
	if not model then return result end

	-- Only accept image data from explicit image/icon fields or clearly named
	-- image widgets. AssetModels may also contain unrelated effect textures/UI.
	local function setByName(key, value)
		local k = string.lower(SpawnPet_Normalize(key))
		local v = SpawnPet_Normalize(value)
		if v == "" then return end
		if k == "displayname" or k == "petname" then
			if result.name == "" then result.name = v end
		elseif k == "rarity" or k == "odds" or string.find(k, "rarity", 1, true) then
			if result.rarity == "" then result.rarity = v end
		elseif k == "persecond" or k == "perseconddisplay" or string.find(k, "generation", 1, true) or string.find(k, "income", 1, true) or string.find(k, "earning", 1, true) then
			if result.perSecond == "" then result.perSecond = v end
		elseif k == "image" or k == "imageid" or k == "icon" or k == "petimage" or k == "peticon" or k == "thumbnail" or k == "thumbnailid" then
			if result.image == "" then
				local id = SpawnPet_AssetId(v)
				if id then result.image = "rbxassetid://"..id end
			end
		end
	end

	for k, v in pairs(model:GetAttributes()) do setByName(k, v) end

	local data = model:FindFirstChild("Data", true)
	if data then
		setByName("DisplayName", SpawnPet_ReadObject(data:FindFirstChild("DisplayName", true)))
		setByName("PetName", SpawnPet_ReadObject(data:FindFirstChild("PetName", true)))
		setByName("Odds", SpawnPet_ReadObject(data:FindFirstChild("Odds", true)))
		setByName("Rarity", SpawnPet_ReadObject(data:FindFirstChild("Rarity", true)))
		setByName("PerSecond", SpawnPet_ReadObject(data:FindFirstChild("PerSecond", true)))
		setByName("PerSecondDisplay", SpawnPet_ReadObject(data:FindFirstChild("PerSecondDisplay", true)))
		setByName("Image", SpawnPet_ReadObject(data:FindFirstChild("Image", true)))
		setByName("ImageId", SpawnPet_ReadObject(data:FindFirstChild("ImageId", true)))
		setByName("PetImage", SpawnPet_ReadObject(data:FindFirstChild("PetImage", true)))
		setByName("Icon", SpawnPet_ReadObject(data:FindFirstChild("Icon", true)))
		setByName("PetIcon", SpawnPet_ReadObject(data:FindFirstChild("PetIcon", true)))
		setByName("Thumbnail", SpawnPet_ReadObject(data:FindFirstChild("Thumbnail", true)))
	end

	local count = 0
	for _, obj in ipairs(model:GetDescendants()) do
		count = count + 1
		if count > 1800 then break end

		if obj:IsA("Animation") and result.animationId == "" then
			local id = SpawnPet_AssetId(obj.AnimationId)
			if id then result.animationId="rbxassetid://"..id; result.animationName=obj.Name end
		end

		for k, v in pairs(obj:GetAttributes()) do setByName(k, v) end

		if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") then
			setByName(obj.Name, SpawnPet_ReadObject(obj))
		end

		if (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and result.image == "" then
			local widgetName = string.lower(SpawnPet_Normalize(obj.Name))
			local parentName = obj.Parent and string.lower(SpawnPet_Normalize(obj.Parent.Name)) or ""
			local namedWidget = widgetName == "icon" or widgetName == "peticon" or widgetName == "petimage" or widgetName == "image" or widgetName == "imageid" or widgetName == "thumbnail" or widgetName == "thumbnailimage"
			local namedContainer = parentName == "icon" or parentName == "peticon" or parentName == "petimage" or parentName == "thumbnail" or parentName == "image"
			if namedWidget or namedContainer then
				local id = SpawnPet_AssetId(obj.Image)
				if id then result.image="rbxassetid://"..id end
			end
		end
	end

	result.rarity = SpawnPet_Rarity(result.rarity)
	result.perSecond = SpawnPet_FormatRate(result.perSecond)
	return result
end

function SpawnPet_GetAssetModelNameplate(assetModel, petName)
	if not assetModel then return nil end
	local wanted = string.lower(SpawnPet_Normalize(petName or assetModel.Name or ""))
	local firstBillboard = nil
	local firstTextBillboard = nil

	-- Do not require live-filled text to exist in the source AssetModel.
	for _, obj in ipairs(assetModel:GetDescendants()) do
		if obj:IsA("BillboardGui") then
			firstBillboard = firstBillboard or obj
			local hasText = false
			local exactName = false
			for _, child in ipairs(obj:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") then
					hasText = true
					local n = string.lower(SpawnPet_Normalize(child.Name))
					local t = string.lower(SpawnPet_Normalize(child.Text))
					if (n == "displayname" or n == "petname") and t == wanted then exactName = true end
				end
			end
			if exactName then return obj end
			if hasText and not firstTextBillboard then firstTextBillboard = obj end
		end
	end

	return firstTextBillboard or firstBillboard
end

function SpawnPet_GetConfigMetadata(name)
	local module = SpawnPet_FindConfigModule(name)
	if not module then return {name="", rarity="", perSecond="", image="", animationId="", animationName=""} end
	if not SpawnPetState.ConfigCache then SpawnPetState.ConfigCache = {} end
	if SpawnPetState.ConfigCache[module] then return SpawnPetState.ConfigCache[module] end
	local ok, data = pcall(require, module)
	if not ok or type(data) ~= "table" then
		SpawnPetState.ConfigCache[module] = {name="", rarity="", perSecond="", image="", animationId="", animationName=""}
		return SpawnPetState.ConfigCache[module]
	end
	local result = SpawnPet_InspectConfigTable(data, nil)
	SpawnPetState.ConfigCache[module] = result
	return result
end

function SpawnPet_FindHotbar()
	local pg = Player and Player:FindFirstChild("PlayerGui")
	if not pg then return nil end
	local gui = pg:FindFirstChild("BackpackGui")
	local backpackGui = gui and gui:FindFirstChild("Backpack")
	return backpackGui and backpackGui:FindFirstChild("Hotbar") or nil
end

function SpawnPet_GetSlotPetText(slot)
	if not slot then return "" end
	local tip = slot:FindFirstChild("ToolTip", true)
	if tip and (tip:IsA("TextLabel") or tip:IsA("TextButton")) then
		return SpawnPet_Normalize(tip.Text)
	end
	return ""
end

function SpawnPet_GetAssetsDirectoryIcon(name)
	-- PRIMARY / AUTHORITATIVE ICON SOURCE:
	-- ReplicatedStorage.Data.Assets -> Directory -> <PetName> -> Icon
	-- Example required by the game:
	-- ReplicatedStorage.Data.Assets.Directory.Kitsune.Icon
	-- Do NOT use a generic ImageLabel, Hotbar icon, AssetModel image, or
	-- another pet's texture when this exact Directory.<Pet>.Icon exists.
	local wanted = SpawnPet_Normalize(name)
	if wanted == "" then return "" end

	local data = ReplicatedStorage and ReplicatedStorage:FindFirstChild("Data")
	local assets = data and data:FindFirstChild("Assets")
	if not assets then return "" end

	local function readIconValue(value)
		if value == nil then return "" end
		local tv = typeof(value)
		if tv == "string" or tv == "number" then
			local id = SpawnPet_AssetId(value)
			if id then return "rbxassetid://" .. id end
			return ""
		end
		if tv == "Instance" then
			if value:IsA("StringValue") or value:IsA("NumberValue") or value:IsA("IntValue") then
				local id = SpawnPet_AssetId(value.Value)
				if id then return "rbxassetid://" .. id end
			elseif value:IsA("ImageLabel") or value:IsA("ImageButton") then
				local id = SpawnPet_AssetId(value.Image)
				if id then return "rbxassetid://" .. id end
			end
		end
		return ""
	end

	local function findCaseInsensitive(container, childName)
		if not container then return nil end
		local direct = container:FindFirstChild(childName)
		if direct then return direct end
		local wantedLower = string.lower(childName)
		for _, child in ipairs(container:GetChildren()) do
			if string.lower(tostring(child.Name)) == wantedLower then
				return child
			end
		end
		return nil
	end

	local function readDirectoryModule(moduleScript)
		local ok, result = pcall(require, moduleScript)
		if not ok or type(result) ~= "table" then return "" end

		local directory = result.Directory
		if type(directory) ~= "table" then
			-- Some versions expose Directory with a different capitalization.
			for key, value in pairs(result) do
				if string.lower(tostring(key)) == "directory" and type(value) == "table" then
					directory = value
					break
				end
			end
		end
		if type(directory) ~= "table" then return "" end

		local petEntry = directory[wanted]
		if petEntry == nil then
			local wantedLower = string.lower(wanted)
			for key, value in pairs(directory) do
				if string.lower(tostring(key)) == wantedLower then
					petEntry = value
					break
				end
			end
		end
		if type(petEntry) ~= "table" then return "" end

		-- EXACT FIELD: Directory.<PetName>.Icon
		local icon = petEntry.Icon
		if icon == nil then
			for key, value in pairs(petEntry) do
				if string.lower(tostring(key)) == "icon" then
					icon = value
					break
				end
			end
		end
		return readIconValue(icon)
	end

	-- Case 1: Assets itself is the ModuleScript that returns the Assets table.
	if assets:IsA("ModuleScript") then
		local icon = readDirectoryModule(assets)
		if icon ~= "" then return icon end
	end

	-- Case 2: Assets contains a Directory ModuleScript / Folder.
	local directoryObject = findCaseInsensitive(assets, "Directory")
	if directoryObject then
		if directoryObject:IsA("ModuleScript") then
			local icon = readDirectoryModule(directoryObject)
			if icon ~= "" then return icon end
		elseif directoryObject:IsA("Folder") or directoryObject:IsA("Configuration") or directoryObject:IsA("Model") then
			local petObject = findCaseInsensitive(directoryObject, wanted)
			if petObject then
				local iconObject = findCaseInsensitive(petObject, "Icon")
				local icon = readIconValue(iconObject)
				if icon ~= "" then return icon end
			end
		end
	end

	return ""
end

-- ==========================================
-- AUTHORITATIVE PET DATA / EARNINGS
-- ==========================================
-- Source confirmed from the game's real modules:
--   Assets.Directory[Category].DisplayName
--   Assets.Directory[Category].Rarity.DisplayName
--   Assets.Directory[Category].Rarity.RarityNumber
--   Assets.Directory[Category].EarningRate
--   AssetEarnings.LiveRatePerSecond(assetItem, ..., ..., player)
-- The AssetEarnings source applies the real Scale, Mutations, entitlement
-- bonus, admin earnings multiplier and player earnings multiplier.

function SpawnPet_GetAuthoritativeDirectoryEntry(category)
	category = SpawnPet_Normalize(category)
	if category == "" then return nil, "empty-category" end

	local ok, Assets = pcall(function()
		return require(ReplicatedStorage.Data.Assets)
	end)
	if not ok or type(Assets) ~= "table" then
		return nil, "assets-require-failed"
	end

	local directory = Assets.Directory
	if type(directory) ~= "table" then
		return nil, "directory-missing"
	end

	local direct = directory[category]
	if type(direct) == "table" then
		return direct, "exact"
	end

	local wanted = string.lower(category)
	for key, value in pairs(directory) do
		if string.lower(tostring(key)) == wanted and type(value) == "table" then
			return value, "case-insensitive"
		end
	end

	return nil, "not-found"
end

function SpawnPet_GetAuthoritativeCategory(sourceModel, fallback)
	if sourceModel and sourceModel:IsA("Model") then
		local ok, value = pcall(function()
			return sourceModel:GetAttribute("Category")
		end)
		if ok and type(value) == "string" and SpawnPet_Normalize(value) ~= "" then
			return SpawnPet_Normalize(value)
		end
	end

	local wanted = SpawnPet_Normalize(fallback or "")
	if wanted ~= "" then return wanted end
	if sourceModel then return SpawnPet_Normalize(sourceModel.Name) end
	return ""
end

function SpawnPet_ParseMutationList(value)
	if type(value) == "table" then
		local result = {}
		for _, item in ipairs(value) do
			local text = SpawnPet_Normalize(item)
			if text ~= "" then result[#result + 1] = text end
		end
		return result
	end

	local text = SpawnPet_Normalize(value)
	if text == "" then return {} end

	local result = {}
	text = string.gsub(text, ";", ",")
	for piece in string.gmatch(text, "[^,]+") do
		piece = SpawnPet_Normalize(piece)
		if piece ~= "" then result[#result + 1] = piece end
	end
	return result
end

function SpawnPet_ReadSourcePetField(sourceModel, key, fallback)
	if sourceModel and sourceModel:IsA("Model") then
		local ok, value = pcall(function()
			return sourceModel:GetAttribute(key)
		end)
		if ok and value ~= nil then return value end
	end
	return fallback
end

function SpawnPet_BuildAuthoritativeAssetItem(sourceModel, meta, scaleOverride)
	meta = meta or {}

	local category = SpawnPet_GetAuthoritativeCategory(
		sourceModel,
		meta.category or meta.name or ""
	)

	local sourceScale = SpawnPet_ReadSourcePetField(sourceModel, "Scale", nil)
	local metaScale = tonumber(meta.scale)
	local scale = tonumber(scaleOverride)
		or tonumber(sourceScale)
		or metaScale
		or 1
	if not scale or scale <= 0 then scale = 1 end

	local sourceMutations = SpawnPet_ReadSourcePetField(sourceModel, "Mutations", nil)
	local mutations = SpawnPet_ParseMutationList(
		sourceMutations ~= nil and sourceMutations or meta.mutations
	)

	local sourceBaseMutation = SpawnPet_ReadSourcePetField(sourceModel, "BaseMutation", nil)
	local baseMutation = sourceBaseMutation ~= nil and sourceBaseMutation or meta.baseMutation

	local creatorTemporary = SpawnPet_ReadSourcePetField(sourceModel, "CreatorTemporary", nil)
	if type(creatorTemporary) ~= "boolean" then
		creatorTemporary = meta.creatorTemporary == true
	end

	local firstPlaced = SpawnPet_ReadSourcePetField(sourceModel, "HasBeenFirstPlaced", nil)
	if type(firstPlaced) ~= "boolean" then
		firstPlaced = meta.hasBeenFirstPlaced ~= false
	end

	local uid = SpawnPet_ReadSourcePetField(sourceModel, "UID", nil)
	if uid == nil then uid = SpawnPet_ReadSourcePetField(sourceModel, "Uid", nil) end

	local eyeColor = SpawnPet_ReadSourcePetField(sourceModel, "EyeColor", nil)
	local colorSeed = SpawnPet_ReadSourcePetField(sourceModel, "ColorSeed", nil)
	local colorIndex = SpawnPet_ReadSourcePetField(sourceModel, "ColorIndex", nil)
	local personality = SpawnPet_ReadSourcePetField(sourceModel, "Personality", nil)

	local item = {
		Category = category,
		Scale = scale,
		Mutations = mutations,
		BaseMutation = baseMutation,
		CreatorTemporary = creatorTemporary,
		HasBeenFirstPlaced = firstPlaced,
	}

	if uid ~= nil then item.UID = uid end
	if eyeColor ~= nil then item.EyeColor = eyeColor end
	if colorSeed ~= nil then item.ColorSeed = colorSeed end
	if colorIndex ~= nil then item.ColorIndex = colorIndex end
	if personality ~= nil then item.Personality = personality end

	return item
end

-- ==========================================
-- REAL GAME RIG / BILLBOARD PIPELINE
-- ==========================================
-- The discovered game pipeline builds the visible pet from AssetItem through
-- AssetRigFactory.Build(...) and creates its overhead data card through
-- AssetInfoBillboard.Attach(...). This helper prefers that exact pipeline and
-- only falls back to the legacy cloned-render-model path if the live module is
-- unavailable in the current client.
function SpawnPet_BuildRealGameRig(assetItem)
	if type(assetItem) ~= "table" then return nil, "invalid-asset-item" end

	local okFactory, AssetRigFactory = pcall(function()
		return require(ReplicatedStorage.Shared.Modules.AssetRigFactory)
	end)
	if not okFactory or type(AssetRigFactory) ~= "table" or type(AssetRigFactory.Build) ~= "function" then
		return nil, "AssetRigFactory.Build-unavailable"
	end

	local okBuild, model = pcall(function()
		return AssetRigFactory.Build(assetItem)
	end)
	if not okBuild or not model or not model:IsA("Model") then
		return nil, "AssetRigFactory.Build-failed:" .. tostring(model)
	end

	return model, "AssetRigFactory.Build"
end

function SpawnPet_AttachRealGameBillboard(clone, meta)
	if not clone or not clone:IsA("Model") then return nil, "invalid-model" end

	local okInfo, AssetInfoBillboard = pcall(function()
		return require(ReplicatedStorage.Shared.Modules.AssetInfoBillboard)
	end)
	if not okInfo or type(AssetInfoBillboard) ~= "table" or type(AssetInfoBillboard.Attach) ~= "function" then
		return nil, "AssetInfoBillboard.Attach-unavailable"
	end

	local item = SpawnPet_BuildAuthoritativeAssetItem(
		SpawnPetState.Source,
		meta or {},
		meta and tonumber(meta.scale) or nil
	)

	local okAttach, billboard = pcall(function()
		return AssetInfoBillboard.Attach(
			clone,
			item.Category,
			item,
			tonumber(meta and meta.perSecondValue) or nil
		)
	end)

	if not okAttach then
		return nil, "AssetInfoBillboard.Attach-failed:" .. tostring(billboard)
	end

	return billboard, "AssetInfoBillboard.Attach"
end

function SpawnPet_FindGameRootPart(model)
	if not model or not model:IsA("Model") then return nil end
	local primary = model.PrimaryPart
	if primary and primary:IsA("BasePart") then return primary end
	for _, wanted in ipairs({"Segment1", "HumanoidRootPart", "CENTER", "Head"}) do
		local obj = model:FindFirstChild(wanted, true)
		if obj and obj:IsA("BasePart") then return obj end
	end
	return model:FindFirstChildWhichIsA("BasePart", true)
end

function SpawnPet_FormatAuthoritativeRate(rate)
	local n = tonumber(rate)
	if not n or n <= 0 then return "" end

	local ok, formatted = pcall(function()
		local Simple = require(ReplicatedStorage.Packages.FormatNumber.Simple)
		return Simple.FormatCompact(math.round(n))
	end)
	if ok and formatted ~= nil then
		return SpawnPet_Normalize(formatted) .. "/s"
	end
	return SpawnPet_FormatRate(math.round(n)) .. "/s"
end

function SpawnPet_CalculateAuthoritativeEarnings(sourceModel, meta, scaleOverride)
	meta = meta or {}

	local item = SpawnPet_BuildAuthoritativeAssetItem(sourceModel, meta, scaleOverride)
	local category = item.Category

	local okEntry, directoryEntry = pcall(function()
		local entry = SpawnPet_GetAuthoritativeDirectoryEntry(category)
		return entry
	end)
	if not okEntry then directoryEntry = nil end

	local earningRate = 0
	local rarityName = ""
	local rarityNumber = 0
	local displayName = ""

	if type(directoryEntry) == "table" then
		earningRate = tonumber(directoryEntry.EarningRate) or 0
		displayName = SpawnPet_Normalize(directoryEntry.DisplayName or category)
		local rarity = directoryEntry.Rarity
		if type(rarity) == "table" then
			rarityName = SpawnPet_Normalize(rarity.DisplayName or "")
			rarityNumber = tonumber(rarity.RarityNumber) or 0
		end
	end

	-- The real game function is authoritative whenever it can be called.
	-- It performs AssetItem validation and the real earnings formula.
	local okEarnings, AssetEarnings = pcall(function()
		return require(ReplicatedStorage.Shared.Util.AssetEarnings)
	end)

	local exactRate = nil
	local exactSource = "unavailable"

	if okEarnings and type(AssetEarnings) == "table" and type(AssetEarnings.LiveRatePerSecond) == "function" then
		local okLive, value = pcall(function()
			return AssetEarnings.LiveRatePerSecond(item, nil, nil, Player)
		end)
		if okLive and type(value) == "number" then
			exactRate = math.max(math.round(value), 0)
			exactSource = "AssetEarnings.LiveRatePerSecond"
		end
	end

	-- Narrow fallback reproduces the discovered AssetEarnings formula if the
	-- runtime function rejects a locally reconstructed item. No broad scan.
	if exactRate == nil and type(directoryEntry) == "table" then
		local mutationFactor = 1
		local okMut, Mutations = pcall(function()
			return require(ReplicatedStorage.Shared.Modules.Mutations)
		end)
		if okMut and type(Mutations) == "table" and type(Mutations.EarningsFor) == "function" then
			local okFactor, factor = pcall(function()
				return Mutations.EarningsFor(item.Mutations)
			end)
			if okFactor and type(factor) == "number" then
				mutationFactor = factor
			end
		end

		local scale = item.Scale
		local scaleFactor
		if scale <= 5 then
			scaleFactor = scale ^ 1.85
		else
			scaleFactor = (scale / 5) ^ 1.2 * 19.637875755794113
		end

		local bonus = 0
		local okMon, MonetizationEntitlements = pcall(function()
			return require(ReplicatedStorage.Shared.Util.MonetizationEntitlements)
		end)
		if okMon and type(MonetizationEntitlements) == "table" and type(MonetizationEntitlements.AssetMoneyAdditiveBonus) == "function" then
			local okBonus, value = pcall(function()
				return MonetizationEntitlements.AssetMoneyAdditiveBonus(nil, nil)
			end)
			if okBonus and type(value) == "number" then bonus = value end
		end

		local adminMultiplier = 1
		local playerMultiplier = 1
		local okAdmin, AdminBoosts = pcall(function()
			return require(ReplicatedStorage.Shared.Util.AdminBoosts)
		end)
		if okAdmin and type(AdminBoosts) == "table" and type(AdminBoosts.ReadMultiplier) == "function" and AdminBoosts.EARNINGS ~= nil then
			local okValue, value = pcall(function()
				return AdminBoosts.ReadMultiplier(AdminBoosts.EARNINGS)
			end)
			if okValue and type(value) == "number" then adminMultiplier = value end
		end

		local okBoost, PlayerEarningsBoost = pcall(function()
			return require(ReplicatedStorage.Shared.Util.PlayerEarningsBoost)
		end)
		if okBoost and type(PlayerEarningsBoost) == "table" and type(PlayerEarningsBoost.GetMultiplier) == "function" then
			local okValue, value = pcall(function()
				return PlayerEarningsBoost.GetMultiplier(Player)
			end)
			if okValue and type(value) == "number" then playerMultiplier = value end
		end

		local entitled = math.round(
			(math.max(earningRate, 0))
			* scaleFactor
			* mutationFactor
			* (1 + bonus)
		)
		entitled = math.max(entitled, 1)

		exactRate = math.max(math.round(entitled * adminMultiplier * playerMultiplier), 0)
		exactSource = "AssetEarnings-compatible fallback"
	end

	return {
		item = item,
		category = category,
		scale = item.Scale,
		mutations = item.Mutations,
		baseMutation = item.BaseMutation,
		creatorTemporary = item.CreatorTemporary,
		hasBeenFirstPlaced = item.HasBeenFirstPlaced,
		earningRate = earningRate,
		displayName = displayName,
		rarity = rarityName,
		rarityNumber = rarityNumber,
		perSecondValue = exactRate or 0,
		perSecond = SpawnPet_FormatAuthoritativeRate(exactRate or 0),
		rateSource = exactSource,
	}
end

function SpawnPet_ApplyAuthoritativePetData(sourceModel, meta, scaleOverride)
	meta = meta or {}

	local result = SpawnPet_CalculateAuthoritativeEarnings(sourceModel, meta, scaleOverride)

	meta.category = result.category
	meta.scale = result.scale
	meta.mutations = result.mutations
	meta.baseMutation = result.baseMutation
	meta.creatorTemporary = result.creatorTemporary
	meta.hasBeenFirstPlaced = result.hasBeenFirstPlaced
	meta.earningRate = result.earningRate
	meta.perSecondValue = result.perSecondValue
	meta.perSecond = result.perSecond
	meta.raritySource = "assets-directory"
	meta.rateSource = result.rateSource

	if result.displayName ~= "" then
		meta.name = result.displayName
	elseif SpawnPet_Normalize(meta.name) == "" then
		meta.name = result.category
	end

	if result.rarity ~= "" then meta.rarity = result.rarity end
	meta.rarityNumber = result.rarityNumber

	local exactIcon = SpawnPet_GetAssetsDirectoryIcon(result.category)
	if exactIcon ~= "" then
		meta.image = exactIcon
	end

	return meta
end

function SpawnPet_GetReal2DIcon(name)
	-- The Assets Directory lookup is intentionally FIRST and authoritative.
	local exactAssetsIcon = SpawnPet_GetAssetsDirectoryIcon(name)
	if exactAssetsIcon ~= "" then
		return exactAssetsIcon
	end

	-- Legacy runtime fallbacks are kept only when Directory.<Pet>.Icon does not
	-- exist, so the new exact source can never be overwritten by another icon.
	local wanted = string.lower(SpawnPet_Normalize(name))
	local hotbar = SpawnPet_FindHotbar()
	if hotbar then
		for _, slot in ipairs(hotbar:GetChildren()) do
			local tip = SpawnPet_GetSlotPetText(slot)
			if tip ~= "" then
				local petText = string.lower(SpawnPet_Normalize(string.match(tip, "^[^|]+") or tip))
				if petText == wanted then
					local icon = slot:FindFirstChild("Icon", true)
					if icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) then
						local id = SpawnPet_AssetId(icon.Image)
						if id then return "rbxassetid://" .. id end
					end
				end
			end
		end
	end
	return ""
end

-- Direct in-game rarity resolver. All rarity text/style comes from live game UI
-- or ReplicatedStorage.Data.Rarity.Configs.<Rarity>; no hard-coded rarity colors.
function SpawnPet_FindRarityConfigModule(rarity)
    local wanted = string.lower(SpawnPet_Rarity(rarity or ""))
    if wanted == "" then return nil end
    local data = ReplicatedStorage:FindFirstChild("Data")
    local rarityRoot = data and data:FindFirstChild("Rarity")
    local configs = rarityRoot and rarityRoot:FindFirstChild("Configs")
    if not configs then return nil end
    local direct = configs:FindFirstChild(SpawnPet_Rarity(rarity))
    if direct and direct:IsA("ModuleScript") then return direct end
    for _, child in ipairs(configs:GetChildren()) do
        if child:IsA("ModuleScript") and string.lower(tostring(child.Name)) == wanted then
            return child
        end
    end
    return nil
end

function SpawnPet_ReadRarityConfig(rarity)
    local module = SpawnPet_FindRarityConfigModule(rarity)
    if not module then return nil end
    SpawnPetState.RarityConfigCache = SpawnPetState.RarityConfigCache or {}
    if SpawnPetState.RarityConfigCache[module] then return SpawnPetState.RarityConfigCache[module] end
    local ok, data = pcall(require, module)
    if not ok then return nil end
    local result = {name=SpawnPet_Rarity(rarity), textColor=nil, gradient=nil, strokeColor=nil, strokeThickness=nil}
    local seen = {}
    local function inspect(value, keyName, depth)
        if depth > 7 or value == nil then return end
        local tv = typeof(value)
        local lk = string.lower(SpawnPet_Normalize(keyName or ""))
        if tv == "Color3" then
            if lk:find("stroke",1,true) or lk:find("outline",1,true) then
                result.strokeColor = result.strokeColor or value
            else
                result.textColor = result.textColor or value
            end
            return
        end
        if tv == "ColorSequence" then
            result.gradient = result.gradient or value
            return
        end
        if type(value) ~= "table" then return end
        if seen[value] then return end
        seen[value] = true
        for k, v in pairs(value) do
            local n = tostring(k)
            local lt = string.lower(SpawnPet_Normalize(n))
            if typeof(v) == "Color3" then
                inspect(v, lt, depth + 1)
            elseif typeof(v) == "ColorSequence" then
                inspect(v, lt, depth + 1)
            elseif type(v) == "number" then
                if (lt:find("strokethickness",1,true) or lt:find("outlinethickness",1,true)) and not result.strokeThickness then
                    result.strokeThickness = v
                end
            elseif type(v) == "table" then
                inspect(v, lt, depth + 1)
            end
        end
    end
    inspect(data, "", 0)
    SpawnPetState.RarityConfigCache[module] = result
    return result
end

function SpawnPet_FindRealRarityLabel(rarity)
    local wanted = string.lower(SpawnPet_Rarity(rarity or ""))
    if wanted == "" then return nil end
    local roots = {}
    if PlayerGui then roots[#roots+1] = PlayerGui end
    if ReplicatedStorage then roots[#roots+1] = ReplicatedStorage end
    if Workspace then roots[#roots+1] = Workspace end
    for _, root in ipairs(roots) do
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                local parent = obj.Parent
                local gradient = parent and (parent:FindFirstChild("RarityGradient") or parent:FindFirstChild("RarityGradient", true))
                local style = gradient and string.lower(SpawnPet_Normalize(gradient:GetAttribute("__gradient_style") or "")) or ""
                if style == wanted then return obj end
                local ownText = string.lower(SpawnPet_Rarity(obj.Text or ""))
                if ownText == wanted then return obj end
            end
        end
    end
    return nil
end

function SpawnPet_GetRarityStyleSource(rarity)
    local label = SpawnPet_FindRealRarityLabel(rarity)
    if label then return {label=label, source="live-rarity-ui", config=nil} end
    local cfg = SpawnPet_ReadRarityConfig(rarity)
    if cfg then return {label=nil, source="replicated-rarity-config", config=cfg} end
    return nil
end

function SpawnPet_ApplyAuthoritativeRarityVisual(label, rarity)
    if not label then return false end
    local wanted = SpawnPet_Rarity(rarity)
    if wanted == "" then return false end
    local style = SpawnPet_GetRarityStyleSource(wanted)
    if not style then return false end
    if style.label then
        pcall(function() label.TextColor3 = style.label.TextColor3 end)
        local srcGradient = style.label:FindFirstChild("RarityGradient", true) or (style.label.Parent and style.label.Parent:FindFirstChild("RarityGradient", true))
        if srcGradient and srcGradient:IsA("UIGradient") then
            local old = label:FindFirstChildWhichIsA("UIGradient")
            if old then pcall(function() old:Destroy() end) end
            local cloned = srcGradient:Clone()
            cloned.Parent = label
        end
        local srcStroke = style.label:FindFirstChildWhichIsA("UIStroke")
        if srcStroke then
            local dstStroke = label:FindFirstChildWhichIsA("UIStroke")
            if not dstStroke then
                dstStroke = srcStroke:Clone()
                dstStroke.Parent = label
            else
                pcall(function()
                    dstStroke.Color = srcStroke.Color
                    dstStroke.Thickness = srcStroke.Thickness
                    dstStroke.Transparency = srcStroke.Transparency
                end)
            end
        end
        return true
    end
    if style.config then
        if style.config.textColor then pcall(function() label.TextColor3 = style.config.textColor end) end
        if style.config.gradient then
            local old = label:FindFirstChildWhichIsA("UIGradient")
            if old then pcall(function() old:Destroy() end) end
            local g = Instance.new("UIGradient")
            g.Name = "GameRarityGradient"
            g.Color = style.config.gradient
            g.Parent = label
        end
        if style.config.strokeColor then
            local stroke = label:FindFirstChildWhichIsA("UIStroke")
            if not stroke then
                stroke = Instance.new("UIStroke")
                stroke.Parent = label
            end
            pcall(function() stroke.Color = style.config.strokeColor end)
            if style.config.strokeThickness then pcall(function() stroke.Thickness = style.config.strokeThickness end) end
        end
        return style.config.textColor ~= nil or style.config.gradient ~= nil
    end
    return false
end

function SpawnPet_GetRuntimeDisplayMetadata(name)
	local wanted = string.lower(SpawnPet_Normalize(name or ""))
	if wanted == "" then return nil end

	local roots = {Workspace, PlayerGui}
	for _, root in ipairs(roots) do
		if root then
			for _, gui in ipairs(root:GetDescendants()) do
				if gui:IsA("BillboardGui") then
					local matched = false
					for _, obj in ipairs(gui:GetDescendants()) do
						if obj:IsA("TextLabel") or obj:IsA("TextButton") then
							local n = string.lower(SpawnPet_Normalize(obj.Name))
							local t = string.lower(SpawnPet_Normalize(obj.Text))
							if t == wanted and (n == "displayname" or n == "petname" or t == wanted) then
								matched = true
								break
							end
						end
					end

					if matched then
						local result = {name=SpawnPet_Normalize(name), rarity="", perSecond="", image="", animationId="", animationName=""}
						for _, obj in ipairs(gui:GetDescendants()) do
							if obj:IsA("TextLabel") or obj:IsA("TextButton") then
								local n = string.lower(SpawnPet_Normalize(obj.Name))
								local t = SpawnPet_Normalize(obj.Text)
								if result.rarity == "" then
									local parsed = SpawnPet_Rarity(t)
									if parsed ~= "" and n ~= "displayname" and n ~= "petname" then
										result.rarity = parsed
									end
								end
								if result.perSecond == "" and (n == "persecond" or n == "perseconddisplay" or n == "generation" or n == "income" or n == "earning" or n == "production" or n == "cash" or n == "money") then
									if t ~= "" then result.perSecond = t end
								elseif result.perSecond == "" and string.find(string.lower(t), "/s", 1, true) then
									if t ~= "" then result.perSecond = t end
								end
							end
						if result.image == "" and (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) then
							local id = SpawnPet_AssetId(obj.Image)
							if id then result.image = "rbxassetid://" .. id end
						end
					end
					return result
				end
			end
		end
	end
	end
	return nil
end

function SpawnPet_GetAuthoritativeRarity(name, assetModel)
    local cleanName = SpawnPet_Normalize(name or (assetModel and assetModel.Name) or "")
    if cleanName == "" then return "", "missing-name" end
    local lowerName = string.lower(cleanName)

    -- 1) Exact active hotbar item for the same Pet. RarityGradient is the game's own style tag.
    local hotbar = SpawnPet_FindHotbar()
    if hotbar then
        for _, slot in ipairs(hotbar:GetChildren()) do
            local tip = SpawnPet_GetSlotPetText(slot)
            local petPart = string.lower(SpawnPet_Normalize(string.match(tip, "^[^|]+") or tip))
            if petPart == lowerName then
                local toolName = slot:FindFirstChild("ToolName", true)
                if toolName then
                    local rg = toolName:FindFirstChild("RarityGradient", true)
                    local style = rg and string.lower(SpawnPet_Normalize(rg:GetAttribute("__gradient_style") or "")) or ""
                    local parsed = SpawnPet_Rarity(style)
                    if parsed ~= "" then return parsed, "hotbar-rarity-gradient" end
                end
            end
        end
    end

    -- 2) Exact runtime nameplate of this Pet only.
    for _, root in ipairs({Workspace, PlayerGui}) do
        if root then
            for _, gui in ipairs(root:GetDescendants()) do
                if gui:IsA("BillboardGui") then
                    local matched = false
                    for _, obj in ipairs(gui:GetDescendants()) do
                        if (obj:IsA("TextLabel") or obj:IsA("TextButton")) then
                            local n = string.lower(tostring(obj.Name or ""))
                            local t = string.lower(SpawnPet_Normalize(obj.Text or ""))
                            if (n == "displayname" or n == "petname") and t == lowerName then matched = true; break end
                        end
                    end
                    if matched then
                        for _, obj in ipairs(gui:GetDescendants()) do
                            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                                local n = string.lower(tostring(obj.Name or ""))
                                if n == "rarity" or n == "odds" or n:find("rarity",1,true) then
                                    local parsed = SpawnPet_Rarity(obj.Text or "")
                                    if parsed ~= "" then return parsed, "runtime-nameplate" end
                                    local rg = obj:FindFirstChild("RarityGradient", true)
                                    local style = rg and SpawnPet_Rarity(rg:GetAttribute("__gradient_style") or "") or ""
                                    if style ~= "" then return style, "runtime-nameplate-gradient" end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- 3) Attributes/values anywhere inside the exact AssetModels Pet.
    if assetModel then
        for _, obj in ipairs(assetModel:GetDescendants()) do
            local attrs = obj:GetAttributes()
            for key, value in pairs(attrs) do
                local k = string.lower(SpawnPet_Normalize(key))
                if k == "rarity" or k == "odds" or k:find("rarity",1,true) then
                    local parsed = SpawnPet_Rarity(value)
                    if parsed ~= "" then return parsed, "assetmodel-descendant-attribute" end
                end
            end
            if obj:IsA("StringValue") or obj:IsA("NumberValue") or obj:IsA("IntValue") then
                local n = string.lower(SpawnPet_Normalize(obj.Name or ""))
                if n == "rarity" or n == "odds" or n:find("rarity",1,true) then
                    local parsed = SpawnPet_Rarity(obj.Value)
                    if parsed ~= "" then return parsed, "assetmodel-descendant-value" end
                end
            end
        end
        local meta = SpawnPet_ReadAssetModelMetadata(assetModel)
        local parsed = SpawnPet_Rarity(meta.rarity)
        if parsed ~= "" then return parsed, "assetmodel" end
    end

    -- 4) Exact ReplicatedStorage.Data.Assets.Configs.<Pet> module output.
    local cfg = SpawnPet_GetConfigMetadata(cleanName)
    local parsed = SpawnPet_Rarity(cfg.rarity)
    if parsed ~= "" then return parsed, "asset-config" end

    -- No authoritative source found. Do not invent a rarity.
    return "", "not-found"
end

function SpawnPet_FindRarityStyle(rarity)
    local wanted = string.lower(SpawnPet_Rarity(rarity or ""))
    if wanted == "" then return nil end
    return SpawnPet_FindRealRarityLabel(wanted)
end

function SpawnPet_FindNameplateTemplate(name, assetModel)
	local wanted = string.lower(SpawnPet_Normalize(name or ""))
	if wanted == "" then return nil end

	-- PRIMARY SOURCE: exact ReplicatedStorage.AssetModels.<PetName>.
	if assetModel and assetModel.Parent then
		local sourceGui = SpawnPet_GetAssetModelNameplate(assetModel, wanted)
		if sourceGui then return sourceGui end
	end

	-- FALLBACK ONLY: exact live runtime nameplate for the same Pet.
	for _, root in ipairs({Workspace, PlayerGui}) do
		if root then
			for _, obj in ipairs(root:GetDescendants()) do
				if obj:IsA("BillboardGui") and obj.Enabled then
					for _, child in ipairs(obj:GetDescendants()) do
						if child:IsA("TextLabel") or child:IsA("TextButton") then
							local n = string.lower(SpawnPet_Normalize(child.Name))
							local t = string.lower(SpawnPet_Normalize(child.Text))
							if t == wanted and (n == "displayname" or n == "petname") then return obj end
						end
					end
				end
			end
		end
	end

	return nil
end

function SpawnPet_ApplyGradientFromSource(target, source)
	if not target or not source then return end
	local src = source:FindFirstChildWhichIsA("UIGradient", true)
	if src then
		local old = target:FindFirstChildWhichIsA("UIGradient")
		if old then pcall(function() old:Destroy() end) end
		local clone = src:Clone()
		clone.Parent=target
	end
	local stroke = source:FindFirstChildWhichIsA("UIStroke", true)
	if stroke then
		local old=target:FindFirstChildWhichIsA("UIStroke")
		if old then pcall(function() old.Color=stroke.Color; old.Thickness=stroke.Thickness end) end
	end
end

-- ==========================================
-- NAMEPLATE RESIZE / PIXEL STABILITY
-- ==========================================
-- Keep the game's existing nameplate visuals, but make the rendered card
-- screen-stable after a client-window resize.
--
-- ROOT CAUSE:
-- The real AssetInfoBillboard and the fallback both use BillboardGui world
-- space sizing (UDim2.Scale). When the Roblox window becomes smaller, the
-- camera/viewport can change and the billboard may project to only a handful
-- of pixels. Its fixed TextSize then becomes effectively invisible.
--
-- FIX:
-- 1) Capture the nameplate's actual on-screen pixel size at creation time.
-- 2) When the viewport changes, convert ONLY the BillboardGui Size to that
--    captured pixel size using UDim2.fromOffset(...).
-- 3) Preserve the game's Adornee, StudsOffset, children, text, colors,
--    gradients, strokes and layout.
-- 4) If the game rebuilds the BillboardGui during resize, register the new
--    instance and reuse the previous pixel baseline for that same pet model.
--
-- This deliberately does NOT create a second visible nameplate.
SpawnPetState.NameplateResizeData = setmetatable({}, {__mode="k"})
SpawnPetState.NameplatePixelBaselineByModel = SpawnPetState.NameplatePixelBaselineByModel
    or setmetatable({}, {__mode="k"})

-- Prevent duplicate resize watchers when this host script is executed again.
pcall(function()
    if SpawnPetState.NameplateResizeViewportConnection then
        SpawnPetState.NameplateResizeViewportConnection:Disconnect()
    end
end)
pcall(function()
    if SpawnPetState.NameplateResizeCameraConnection then
        SpawnPetState.NameplateResizeCameraConnection:Disconnect()
    end
end)

if SpawnPetState.NameplateResizeModelConnections then
    for model, connection in pairs(SpawnPetState.NameplateResizeModelConnections) do
        pcall(function()
            if connection then connection:Disconnect() end
        end)
    end
end

SpawnPetState.NameplateResizeWatcherStarted = false
SpawnPetState.NameplateResizeBoundCamera = nil
SpawnPetState.NameplateResizeViewportConnection = nil
SpawnPetState.NameplateResizeCameraConnection = nil
SpawnPetState.NameplateResizeModelConnections = setmetatable({}, {__mode="k"})
SpawnPetState.NameplateResizeAncestryBound = setmetatable({}, {__mode="k"})

local function SpawnPet_NameplateModelFromGui(gui)
    if not gui then return nil end
    local node = gui.Parent
    for _ = 1, 8 do
        if not node then break end
        if node:IsA("Model") then return node end
        node = node.Parent
    end
    return nil
end

local function SpawnPet_NameplateCapturePixels(gui, tries)
    if not gui or not gui.Parent then return end
    tries = tries or 0

    local absolute = gui.AbsoluteSize
    local w = math.floor((absolute and absolute.X or 0) + 0.5)
    local h = math.floor((absolute and absolute.Y or 0) + 0.5)

    -- At very small camera/viewport sizes Roblox can report a tiny billboard
    -- canvas even though the child text still needs a normal 3-line card.
    -- Derive a safe minimum from the actual text bounds instead of inventing
    -- new text styling. This is used only when the captured canvas is too small.
    if w > 2 and h > 2 then
        local textWidth = 0
        local textHeight = 0
        local textCount = 0
        for _, child in ipairs(gui:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                local bounds = child.TextBounds
                if bounds and bounds.X > textWidth then textWidth = bounds.X end
                if bounds and bounds.Y > 0 then
                    textHeight = textHeight + bounds.Y
                    textCount = textCount + 1
                end
            end
        end

        local neededW = math.floor(textWidth + 24 + 0.5)
        local neededH = math.floor(textHeight + math.max(16, textCount * 3) + 0.5)
        w = math.max(w, neededW, 120)
        h = math.max(h, neededH, 52)

        local model = SpawnPet_NameplateModelFromGui(gui)
        local data = SpawnPetState.NameplateResizeData[gui]
        if data then
            data.basePixelWidth = w
            data.basePixelHeight = h
            data.captured = true
            if model then
                SpawnPetState.NameplatePixelBaselineByModel[model] = {
                    width = w,
                    height = h,
                }
            end
        end
        return
    end

    if tries < 12 then
        task.delay(0.05, function()
            SpawnPet_NameplateCapturePixels(gui, tries + 1)
        end)
    end
end

local function SpawnPet_NameplateApplyPixelLock(gui, data)
    if not gui or not gui.Parent or not data then return end
    local width = tonumber(data.basePixelWidth)
    local height = tonumber(data.basePixelHeight)
    if not width or not height or width <= 2 or height <= 2 then return end

    pcall(function()
        -- Once resized, Offset gives a stable pixel canvas. The internals of
        -- the game's billboard remain untouched.
        gui.Size = UDim2.fromOffset(width, height)
        gui.Enabled = true
        gui.AlwaysOnTop = true
        if gui.MaxDistance > 0 and gui.MaxDistance < 1000 then
            gui.MaxDistance = 1000
        end
    end)
end

function SpawnPet_RefreshNameplateSizes()
    local camera = Workspace.CurrentCamera
    if not camera then return end

    for gui, data in pairs(SpawnPetState.NameplateResizeData) do
        if not gui or not gui.Parent then
            SpawnPetState.NameplateResizeData[gui] = nil
        elseif data then
            SpawnPet_NameplateApplyPixelLock(gui, data)
        end
    end
end

local function SpawnPet_NameplateViewportChanged()
    -- The camera may update immediately and the game's own billboard module
    -- can update on the following frames. Apply several times to beat either
    -- ordering without changing anything while the viewport is stable.
    task.defer(SpawnPet_RefreshNameplateSizes)
    task.delay(0.03, SpawnPet_RefreshNameplateSizes)
    task.delay(0.08, SpawnPet_RefreshNameplateSizes)
    task.delay(0.16, SpawnPet_RefreshNameplateSizes)
    task.delay(0.30, SpawnPet_RefreshNameplateSizes)

    -- Keep the pixel lock active for a short settling window. If the game
    -- module writes its original Size back during the resize, restore ours.
    local untilTime = os.clock() + 0.55
    while os.clock() < untilTime do
        SpawnPet_RefreshNameplateSizes()
        task.wait()
    end
end

local function SpawnPet_BindNameplateResizeWatcher()
    if SpawnPetState.NameplateResizeWatcherStarted then return end
    SpawnPetState.NameplateResizeWatcherStarted = true

    SpawnPetState.NameplateResizeCameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        local camera = Workspace.CurrentCamera
        SpawnPetState.NameplateResizeBoundCamera = camera

        if SpawnPetState.NameplateResizeViewportConnection then
            pcall(function()
                SpawnPetState.NameplateResizeViewportConnection:Disconnect()
            end)
            SpawnPetState.NameplateResizeViewportConnection = nil
        end

        if camera then
            SpawnPetState.NameplateResizeViewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                task.spawn(SpawnPet_NameplateViewportChanged)
            end)
        end
    end)

    local camera = Workspace.CurrentCamera
    SpawnPetState.NameplateResizeBoundCamera = camera
    if camera then
        SpawnPetState.NameplateResizeViewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            task.spawn(SpawnPet_NameplateViewportChanged)
        end)
    end
end

function SpawnPet_RegisterNameplate(gui)
    if not gui or not gui:IsA("BillboardGui") or not gui.Parent then return end

    local model = SpawnPet_NameplateModelFromGui(gui)
    local existing = SpawnPetState.NameplateResizeData[gui]
    if not existing then
        existing = {
            gui = gui,
            captured = false,
            basePixelWidth = nil,
            basePixelHeight = nil,
        }
        SpawnPetState.NameplateResizeData[gui] = existing

        -- If this is a rebuilt billboard for the same pet, reuse the first
        -- billboard's known-good screen size rather than capturing a tiny,
        -- already-resized version.
        local inherited = model and SpawnPetState.NameplatePixelBaselineByModel[model]
        if inherited and inherited.width > 2 and inherited.height > 2 then
            existing.basePixelWidth = inherited.width
            existing.basePixelHeight = inherited.height
            existing.captured = true
        end

        task.defer(function()
            if existing.captured then
                return
            end
            SpawnPet_NameplateCapturePixels(gui, 0)
        end)
    end

    SpawnPet_BindNameplateResizeWatcher()

    if model and not SpawnPetState.NameplateResizeModelConnections[model] then
        -- Catch a game-side billboard rebuild during/after window resizing.
        SpawnPetState.NameplateResizeModelConnections[model] = model.DescendantAdded:Connect(function(obj)
            if obj:IsA("BillboardGui") then
                task.defer(function()
                    if obj.Parent then
                        SpawnPet_RegisterNameplate(obj)
                    end
                end)
            end
        end)
    end

    if not SpawnPetState.NameplateResizeAncestryBound[gui] then
        SpawnPetState.NameplateResizeAncestryBound[gui] = true
        gui.AncestryChanged:Connect(function(_, parent)
            if not parent then
                SpawnPetState.NameplateResizeData[gui] = nil
            end
        end)
    end
end

function SpawnPet_CreateGuaranteedNameplate(clone, meta)
	if not clone then return nil end
	meta = meta or {}

	local nameText = SpawnPet_Normalize(meta.name or clone.Name or "")
	local rarityText = SpawnPet_Rarity(meta.rarity or "")
	local rateText = SpawnPet_Normalize(meta.perSecond or "")
	if nameText == "" and rarityText == "" and rateText == "" then return nil end

	-- Remove only our own fallback plate. Never remove or replace the game's
	-- AssetInfoBillboard plate.
	local old = clone:FindFirstChild("__SpawnPetGuaranteedNameplate")
	if old then pcall(function() old:Destroy() end) end

	-- The real game rig is centered around CENTER. Use it first so the fallback
	-- is positioned from the same reference used by AssetInfoBillboard.
	local adornee = nil
	for _, wanted in ipairs({"CENTER", "HumanoidRootPart", "Head", "UpperHead"}) do
		local obj = clone:FindFirstChild(wanted, true)
		if obj and (obj:IsA("BasePart") or obj:IsA("Attachment")) then
			adornee = obj
			break
		end
	end

	if not adornee then
		local highestY = -math.huge
		local highestPart = nil
		for _, obj in ipairs(clone:GetDescendants()) do
			if obj:IsA("BasePart") then
				local ok, pos = pcall(function() return obj.Position end)
				if ok and pos.Y > highestY then
					highestY = pos.Y
					highestPart = obj
				end
			end
		end
		adornee = highestPart
	end

	if not adornee then return nil end

	local gui = Instance.new("BillboardGui")
	gui.Name = "__SpawnPetGuaranteedNameplate"
	gui.Adornee = adornee

	-- Use world-space scale rather than a fixed pixel canvas. The real game
	-- AssetInfoBillboard uses UDim2.fromScale and scales its card with CENTER.
	gui.Size = UDim2.fromScale(0.861, 0.767)

	-- CENTER is lower than the head, so use a modest world offset instead of
	-- the old fixed 3.8-stud offset which pushed the plate too high.
	local centerSizeY = 1
	if clone:FindFirstChild("CENTER", true) then
		local center = clone:FindFirstChild("CENTER", true)
		if center:IsA("BasePart") then
			centerSizeY = math.max(center.Size.Y, 0.2)
		end
	end
	gui.StudsOffset = Vector3.new(0, math.clamp(centerSizeY * 2.1 + 1.4, 2.0, 5.5), 0)

	gui.MaxDistance = 1000
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	gui.Enabled = true
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = clone
	SpawnPet_RegisterNameplate(gui)

	local holder = Instance.new("Frame")
	holder.Name = "TextHolder"
	holder.Size = UDim2.fromScale(1, 1)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.Parent = gui

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 0)
	layout.Parent = holder

	local function makeLabel(name, txt, size, order)
		local label = Instance.new("TextLabel")
		label.Name = name
		label.Size = UDim2.new(1, 0, 0, size)
		label.LayoutOrder = order
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Text = txt or ""
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		label.TextStrokeTransparency = 0
		label.Font = Enum.Font.GothamBold
		label.TextScaled = false
		label.TextSize = size == 32 and 23 or 20
		label.TextWrapped = false
		label.TextXAlignment = Enum.TextXAlignment.Center
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.ClipsDescendants = false
		label.ZIndex = 10
		label.Parent = holder

		-- The real plate uses a larger world-space card. Do not clamp it down
		-- to the previous 17-22px range.
		local constraint = Instance.new("UITextSizeConstraint")
		constraint.MinTextSize = size == 32 and 19 or 16
		constraint.MaxTextSize = size == 32 and 28 or 24
		constraint.Parent = label
		return label
	end

	local rarityLabel
	if rarityText ~= "" then
		rarityLabel = makeLabel("Rarity", rarityText, 32, 1)
	end

	if nameText ~= "" then
		makeLabel("DisplayName", nameText, 32, 2)
	end

	if rateText ~= "" then
		makeLabel("PerSecond", rateText, 32, 3)
	end

	if rarityLabel and SpawnPet_ApplyAuthoritativeRarityVisual then
		pcall(function()
			SpawnPet_ApplyAuthoritativeRarityVisual(rarityLabel, rarityText)
		end)
	end

	return gui
end

function SpawnPet_BuildNameplate(clone, meta)
	if not clone then return nil end
	meta = meta or {}

	local requestedName = SpawnPet_Normalize(meta.name or clone.Name or "")
	if requestedName == "" then return nil end

	-- IMPORTANT:
	-- AssetInfoBillboard.Attach() is the game's authoritative nameplate path.
	-- Once it exists, NEVER resize it, change its StudsOffset, change its
	-- Adornee, or replace its text. The previous version did exactly that and
	-- caused the spawned nameplate to become smaller and sit too high.
	for _, existing in ipairs(clone:GetDescendants()) do
		if existing:IsA("BillboardGui") then
			local hasDisplay = existing:FindFirstChild("DisplayName", true)
			local hasRate = existing:FindFirstChild("PerSecond", true)
			local hasOdds = existing:FindFirstChild("Odds", true)
				or existing:FindFirstChild("Rarity", true)

			if hasDisplay and (hasRate or hasOdds) then
				pcall(function()
					existing.Enabled = true
					existing.AlwaysOnTop = true
				end)
				SpawnPet_RegisterNameplate(existing)
				return existing
			end
		end
	end

	-- Try the real game Attach path one more time using the same AssetItem
	-- already stored for this clone. This avoids inventing a second layout.
	local storedItem = SpawnPetState.AssetItemByClone
		and SpawnPetState.AssetItemByClone[clone]

	if storedItem and type(storedItem) == "table" then
		local okInfo, AssetInfoBillboard = pcall(function()
			return require(ReplicatedStorage.Shared.Modules.AssetInfoBillboard)
		end)

		if okInfo and type(AssetInfoBillboard) == "table"
			and type(AssetInfoBillboard.Attach) == "function" then

			local okAttach = pcall(function()
				AssetInfoBillboard.Attach(
					clone,
					storedItem.Category,
					storedItem,
					tonumber(meta.perSecondValue) or nil
				)
			end)

			if okAttach then
				for _, existing in ipairs(clone:GetDescendants()) do
					if existing:IsA("BillboardGui") then
						local hasDisplay = existing:FindFirstChild("DisplayName", true)
						local hasRate = existing:FindFirstChild("PerSecond", true)
						local hasOdds = existing:FindFirstChild("Odds", true)
							or existing:FindFirstChild("Rarity", true)

						if hasDisplay and (hasRate or hasOdds) then
							pcall(function()
								existing.Enabled = true
								existing.AlwaysOnTop = true
							end)
							SpawnPet_RegisterNameplate(existing)
							return existing
						end
					end
				end
			end
		end
	end

	-- Only use our fallback when the game's real billboard truly could not be
	-- created. Its sizing/positioning now follows CENTER instead of the old
	-- fixed 280x94 / 3.8-stud layout.
	return SpawnPet_CreateGuaranteedNameplate(clone, meta)
end

function SpawnPet_CaptureRealHandPose()
	local character=Player and Player.Character
	local backpack=Player and Player:FindFirstChildOfClass("Backpack")
	local containers={character,backpack}
	for _, container in ipairs(containers) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("VirtualPet") ~= true then
					local handle=child:FindFirstChild("Handle")
					local model=child:FindFirstChildWhichIsA("Model",true)
					if handle and handle:IsA("BasePart") and model then
						local ok, rel=pcall(function() return handle.CFrame:ToObjectSpace(model:GetPivot()) end)
						if ok then return {grip=child.Grip, relative=rel, toolName=child.Name} end
					end
				end
			end
		end
	end
	return nil
end

function SpawnPet_EnsureAnimator(clone)
	local animator=clone:FindFirstChildWhichIsA("Animator",true)
	if animator then return animator end
	local controller=clone:FindFirstChildWhichIsA("AnimationController",true)
	if not controller then
		controller=Instance.new("AnimationController")
		controller.Name="SpawnPetAnimationController"
		controller.Parent=clone
	end
	animator=controller:FindFirstChildOfClass("Animator")
	if not animator then
		animator=Instance.new("Animator")
		animator.Parent=controller
	end
	return animator
end

function SpawnPet_PlayAnimation1(clone, meta)
	local animator=SpawnPet_EnsureAnimator(clone)
	if not animator then return false end
	local id=SpawnPet_AssetId(meta.animationId)
	local sourceAnimation=nil
	if not id then
		for _, obj in ipairs(clone:GetDescendants()) do
			if obj:IsA("Animation") then
				id=SpawnPet_AssetId(obj.AnimationId)
				if id then sourceAnimation=obj; break end
			end
		end
	end
	if not id then return false end
	local animation=sourceAnimation or Instance.new("Animation")
	if not sourceAnimation then animation.Name="__SpawnPetAnimation1"; animation.AnimationId="rbxassetid://"..id; animation.Parent=clone end
	local ok, track=pcall(function() return animator:LoadAnimation(animation) end)
	if not ok or not track then return false end
	pcall(function() track.Looped=true; track.Priority=Enum.AnimationPriority.Idle; track:Play(0.08,1,1) end)
	SpawnPetState.AnimationTrackByClone=SpawnPetState.AnimationTrackByClone or {}
	SpawnPetState.AnimationTrackByClone[clone]=track
	return true
end

function SpawnPet_PrepareHandPhysics(clone)
	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("BasePart") then
			pcall(function()
				obj.Anchored=false
				obj.CanCollide=false
				obj.CanTouch=false
				obj.CanQuery=false
				obj.Massless=true
				obj.LocalTransparencyModifier=0
			end)
		end
		if obj:IsA("Humanoid") then
			pcall(function() obj.AutoRotate=false; obj.WalkSpeed=0; obj.JumpPower=0 end)
		end
	end
end

function SpawnPet_GetNumber(box, fallback)
	local value=tonumber(SpawnPet_Normalize(box and box.Text or ""))
	if not value then return fallback end
	return value
end

function SpawnPet_FindFreeHotbarSlot()
	local hotbar=SpawnPet_FindHotbar()
	if not hotbar then return nil end
	local candidates={}
	for _, obj in ipairs(hotbar:GetChildren()) do
		local number=tonumber(tostring(obj.Name):match("%d+"))
		if number and obj:IsA("GuiButton") then candidates[#candidates+1]={n=number,slot=obj} end
	end
	table.sort(candidates,function(a,b) return a.n<b.n end)
	for _, item in ipairs(candidates) do
		local slot=item.slot
		if slot:GetAttribute("__SpawnPetOccupied") ~= true then
			local tip=SpawnPet_GetSlotPetText(slot)
			local icon=slot:FindFirstChild("Icon",true)
			local image=(icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton"))) and SpawnPet_Normalize(icon.Image or "") or ""
			if tip=="" and image=="" then return slot end
		end
	end
	return nil
end

function SpawnPet_BindHotbarSlot(slot, tool, meta, iconId)
	if not slot then return false end
	-- Never overwrite an occupied pet slot. Send must never mutate existing hotbar pets.
	if slot:GetAttribute("__SpawnPetOccupied") == true then return false end
	SpawnPetState.HotbarOriginals = SpawnPetState.HotbarOriginals or {}
	if not SpawnPetState.HotbarOriginals[slot] then
		local icon=slot:FindFirstChild("Icon",true)
		local tip=slot:FindFirstChild("ToolTip",true)
		SpawnPetState.HotbarOriginals[slot] = {
			icon = icon and ((icon:IsA("ImageLabel") or icon:IsA("ImageButton")) and icon.Image or "") or "",
			tooltip = tip and ((tip:IsA("TextLabel") or tip:IsA("TextButton")) and tip.Text or "") or ""
		}
	end
	slot:SetAttribute("__SpawnPetOccupied", true)
	slot:SetAttribute("__SpawnPetName", meta.name)
	local icon=slot:FindFirstChild("Icon",true)
	if icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) and iconId~="" then
		pcall(function() icon.Image=iconId end)
	end
	local tip=slot:FindFirstChild("ToolTip",true)
	if tip and (tip:IsA("TextLabel") or tip:IsA("TextButton")) then
		local tooltipText = meta.name
		if SpawnPet_Normalize(meta.perSecond) ~= "" then tooltipText = meta.name.." | "..meta.perSecond end
		pcall(function() tip.Text=tooltipText end)
	end
	local old=SpawnPetState.HotbarBindings[slot]
	if old then pcall(function() old:Disconnect() end) end
	local connection
	connection=slot.Activated:Connect(function()
		if tool and tool.Parent then
			local humanoid=Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then pcall(function() humanoid:EquipTool(tool) end) end
		end
	end)
	SpawnPetState.HotbarBindings[slot]=connection
	SpawnPetState.ToolToSlot = SpawnPetState.ToolToSlot or {}
	SpawnPetState.ToolToSlot[tool] = slot
	return true
end

function SpawnPet_CreateTool(sourceModel, meta)
	if not sourceModel or not sourceModel.Parent or not sourceModel:IsA("Model") then return nil end
	local backpack=Player and Player:FindFirstChildOfClass("Backpack")
	if not backpack then return nil end

	meta = meta or {}

	-- Existing SizeBox stays usable, but the default value "1" now means
	-- "use the pet's real runtime Scale". A different value is an explicit
	-- manual scale override and earnings are recalculated for that scale.
	local sizeInput = SpawnPet_GetNumber(SpawnPetState.SizeBox,1)
	local runtimeScale = tonumber(meta.scale) or 1
	local spawnScale = (math.abs(sizeInput - 1) < 0.000001)
		and runtimeScale
		or math.clamp(sizeInput,0.05,10)
	local height=math.clamp(SpawnPet_GetNumber(SpawnPetState.HeightBox,0.5),-10,10)

	-- Rebuild the REAL game AssetItem from the selected pet's authoritative
	-- attributes: Category, Scale, Mutations, BaseMutation, palette fields.
	local assetItem = SpawnPet_BuildAuthoritativeAssetItem(sourceModel, meta, spawnScale)

	-- Prefer the same game model construction path used by the live game.
	local clone, buildSource = SpawnPet_BuildRealGameRig(assetItem)
	local usedRealPipeline = clone ~= nil

	-- Compatibility fallback only when the live AssetRigFactory module cannot
	-- be called in the current client.
	if not clone then
		local oldArchivable=sourceModel.Archivable
		sourceModel.Archivable=true
		local ok, legacyClone=pcall(function() return sourceModel:Clone() end)
		sourceModel.Archivable=oldArchivable
		if not ok or not legacyClone then return nil end
		clone = legacyClone
		buildSource = "legacy-source-model-fallback"
	end

	-- Do not strip the real rig's descendants before the game module has had a
	-- chance to create them. The AssetRigFactory-built model is already the
	-- game's own visual rig. On the fallback path, retain the previous safety
	-- stripping behavior for foreign scripts/modules inside the cloned source.
	if not usedRealPipeline then
		for _, obj in ipairs(clone:GetDescendants()) do
			if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
				pcall(function() obj:Destroy() end)
			end
		end
	end

	SpawnPet_PrepareHandPhysics(clone)

	-- The real AssetRigFactory already resized the rig with assetItem.Scale.
	-- Never ScaleTo() it again on the authoritative path, otherwise its visible
	-- proportions and its $/s would drift away from the runtime asset.
	if not usedRealPipeline then
		pcall(function() clone:ScaleTo(spawnScale) end)
	end

	local root = SpawnPet_FindGameRootPart(clone)
	if not root or not root:IsA("BasePart") then
		pcall(function() clone:Destroy() end)
		return nil
	end
	if not clone.PrimaryPart then pcall(function() clone.PrimaryPart = root end) end

	local tool=Instance.new("Tool")
	tool.Name=meta.name ~= "" and meta.name or tostring(assetItem.Category)
	tool.ToolTip=(meta.perSecond ~= "" and (tool.Name.." | "..meta.perSecond) or tool.Name)
	tool.RequiresHandle=true
	tool.CanBeDropped=false
	tool.ManualActivationOnly=true
	tool:SetAttribute("VirtualPet", true)
	tool:SetAttribute("PetName", meta.name)
	meta.rarity = SpawnPet_Rarity(meta.rarity)
	tool:SetAttribute("PetRarity", meta.rarity)
	tool:SetAttribute("PetRarityNumber", tonumber(meta.rarityNumber) or 0)
	tool:SetAttribute("PetBPS", meta.perSecond)
	tool:SetAttribute("PetPerSecond", tonumber(meta.perSecondValue) or 0)
	tool:SetAttribute("PetCategory", tostring(meta.category or assetItem.Category))
	tool:SetAttribute("PetScale", tonumber(meta.scale) or spawnScale)
	tool:SetAttribute("PetEarningRate", tonumber(meta.earningRate) or 0)
	tool:SetAttribute("PetMutations", table.concat(meta.mutations or {}, ", "))
	tool:SetAttribute("PetBaseMutation", tostring(meta.baseMutation or ""))
	tool:SetAttribute("PetObjects", #clone:GetDescendants())
	tool:SetAttribute("SpawnPetSource", sourceModel:GetFullName())
	tool:SetAttribute("SpawnPetBuildSource", buildSource)
	local sourceWeight = SpawnPet_FindWeightInInstance(sourceModel)
	if sourceWeight ~= "" then
		pcall(function() tool:SetAttribute("PetWeight", sourceWeight) end)
	end
	if meta.image~="" then pcall(function() tool.TextureId=meta.image end) end

	local config=Instance.new("Configuration")
	config.Name="Configuration"
	config.Parent=tool
	pcall(function() config:SetAttribute("displayName",meta.name) end)
	if meta.rarity ~= "" then pcall(function() config:SetAttribute("rarity",meta.rarity) end) end
	if meta.perSecond ~= "" then
		pcall(function() config:SetAttribute("perSecondDisplay",meta.perSecond) end)
		pcall(function() config:SetAttribute("perSecond",tonumber(meta.perSecondValue) or 0) end)
	end
	pcall(function() config:SetAttribute("category",tostring(assetItem.Category)) end)
	pcall(function() config:SetAttribute("scale",tonumber(spawnScale) or 1) end)
	pcall(function() config:SetAttribute("earningRate",tonumber(meta.earningRate) or 0) end)
	pcall(function() config:SetAttribute("rarityNumber",tonumber(meta.rarityNumber) or 0) end)
	pcall(function() config:SetAttribute("mutations",table.concat(meta.mutations or {}, ", ")) end)
	pcall(function() config:SetAttribute("baseMutation",tostring(meta.baseMutation or "")) end)

	-- Store the exact local AssetItem in a weak-key state table so later UI
	-- refreshes can rebuild the same game billboard without guessing data again.
	SpawnPetState.AssetItemByClone = SpawnPetState.AssetItemByClone or setmetatable({}, {__mode="k"})
	SpawnPetState.AssetItemByClone[clone] = assetItem

	local handle=Instance.new("Part")
	handle.Name="Handle"
	handle.Size=Vector3.new(0.2,0.2,0.2)
	handle.Transparency=1
	handle.CanCollide=false
	handle.CanTouch=false
	handle.CanQuery=false
	handle.Massless=true
	handle.Anchored=false
	handle.Parent=tool

	local realPose=SpawnPet_CaptureRealHandPose()
	local weld=Instance.new("Weld")
	weld.Name="__SpawnPetHandWeld"
	weld.Part0=handle
	weld.Part1=root
	weld.C0=CFrame.new()
	weld.C1=CFrame.new()
	weld.Parent=handle
	handle.CFrame=root.CFrame
	clone.Parent=tool

	-- Create the game's own overhead card first. It uses the actual
	-- AssetInfoBillboard.Attach pipeline, including the game's rarity/display
	-- formatting and exact PerSecond field. Fallback to the legacy repaired
	-- nameplate only if Attach is unavailable or rejects the reconstructed item.
	local realBillboard = nil
	pcall(function()
		realBillboard = SpawnPet_AttachRealGameBillboard(clone, meta)
	end)

	if realBillboard and realBillboard:IsA("BillboardGui") then
		SpawnPet_RegisterNameplate(realBillboard)
		tool:SetAttribute("SpawnPetNameplateSource","AssetInfoBillboard.Attach")
	else
		tool:SetAttribute("SpawnPetNameplateSource","legacy-fallback")
	end

	-- Re-run the nameplate repair after the Tool is equipped. The repair function
	-- now preserves a real game billboard and only falls back when none exists.
	task.defer(function()
		if tool.Parent and clone.Parent then
			pcall(function() SpawnPet_BuildNameplate(clone, meta) end)
		end
	end)
	tool.Equipped:Connect(function()
		task.defer(function()
			if tool.Parent and clone.Parent then
				pcall(function() SpawnPet_BuildNameplate(clone, meta) end)
			end
		end)
	end)

	if realPose and realPose.grip then
		pcall(function() tool.Grip=realPose.grip * CFrame.new(0,height,0) end)
	else
		pcall(function() tool.Grip=CFrame.new(0,height,0) end)
	end

	tool.Parent=backpack
	-- Keep all spawned pets in Backpack; hotbar buttons equip them on click.
	SpawnPetState.SpawnedTools[#SpawnPetState.SpawnedTools+1]=tool
	SpawnPetState.ToolToClone=SpawnPetState.ToolToClone or {}
	SpawnPetState.ToolToClone[tool]=clone
	return tool, clone
end

function SpawnPet_UpdatePreview(meta)
    meta = meta or {}
    meta.rarity = SpawnPet_Rarity(meta.rarity)
    SpawnPetState.Meta = meta
    if SpawnPetState.NameLabel then SpawnPetState.NameLabel.Text = meta.name end
    if SpawnPetState.RarityLabel then
        SpawnPetState.RarityLabel.Text = meta.rarity
        SpawnPetState.RarityLabel.Visible = meta.rarity ~= ""
        SpawnPetState.RarityLabel.TextTransparency = meta.rarity ~= "" and 0 or 1
        if meta.rarity ~= "" then
            SpawnPet_ApplyAuthoritativeRarityVisual(SpawnPetState.RarityLabel, meta.rarity)
        end
    end
    if SpawnPetState.RateLabel then SpawnPetState.RateLabel.Text = meta.perSecond or "" end
    if SpawnPetState.Icon then SpawnPetState.Icon.Image = meta.image ~= "" and meta.image or "" end
    if SpawnPetState.Status then SpawnPetState.Status.Text = (meta.name ~= "" and "Found: " .. meta.name .. " • " .. meta.rarity or "Pet not found") end
end

function SpawnPet_Search(query)
    query = SpawnPet_Normalize(query)
    SpawnPetState.SearchToken = (SpawnPetState.SearchToken or 0) + 1
    local token = SpawnPetState.SearchToken
    if query == "" then
        SpawnPet_UpdatePreview({name="", rarity="", perSecond="", image="", animationId="", animationName=""})
        SpawnPetState.Source = nil
        return
    end

    local model = SpawnPet_DirectAssetModel(query)
    local canonicalName = model and model.Name or query
    local meta = {
        name=canonicalName,
        rarity="",
        perSecond="",
        image="",
        animationId="",
        animationName="",
        category=model and SpawnPet_GetAuthoritativeCategory(model, canonicalName) or canonicalName,
        scale=model and tonumber(SpawnPet_ReadSourcePetField(model, "Scale", nil)) or nil,
        mutations=model and SpawnPet_ParseMutationList(SpawnPet_ReadSourcePetField(model, "Mutations", "")) or {},
        baseMutation=model and SpawnPet_ReadSourcePetField(model, "BaseMutation", nil) or nil,
        creatorTemporary=model and (SpawnPet_ReadSourcePetField(model, "CreatorTemporary", false) == true) or false,
        hasBeenFirstPlaced=model and (SpawnPet_ReadSourcePetField(model, "HasBeenFirstPlaced", true) ~= false) or true,
        earningRate=0,
        perSecondValue=0,
        rarityNumber=0,
    }

    -- AUTHORITATIVE DATA: Assets.Directory[Category]
    -- This is now the first and final source for name, rarity, icon and earnings.
    meta = SpawnPet_ApplyAuthoritativePetData(model, meta, meta.scale)

    -- Keep the existing animation discovery, but it no longer gets to replace
    -- authoritative name/rate/rarity/icon data.
    if model then
        local assetMeta = SpawnPet_ReadAssetModelMetadata(model)
        if assetMeta.animationId ~= "" then
            meta.animationId = assetMeta.animationId
            meta.animationName = assetMeta.animationName
        end
        if meta.image == "" and assetMeta.image ~= "" then meta.image = assetMeta.image end
    end

    -- Animation/config fallbacks are kept exactly for existing functionality.
    local cfg = SpawnPet_GetConfigMetadata(canonicalName)
    if meta.animationId == "" then
        meta.animationId = cfg.animationId
        meta.animationName = cfg.animationName
    end

    -- Re-apply authoritative values after all legacy fallbacks so they cannot
    -- overwrite the real game values.
    meta = SpawnPet_ApplyAuthoritativePetData(model, meta, meta.scale)

    if token ~= SpawnPetState.SearchToken then return end
    SpawnPetState.Source = model
    SpawnPet_UpdatePreview(meta)
    print("[SpawnPet] Search", canonicalName,
        "category=", meta.category,
        "rarity=", meta.rarity,
        "rate=", meta.perSecond,
        "rateSource=", meta.rateSource)
end

function SpawnPet_SpawnCurrent()
    local source=SpawnPetState.Source
    if not source or not source.Parent then
        if SpawnPetState.Status then SpawnPetState.Status.Text="Search a Pet first" end
        return
    end

    local meta=SpawnPetState.Meta or {}
    local sizeInput = SpawnPet_GetNumber(SpawnPetState.SizeBox,1)
    local runtimeScale = tonumber(meta.scale) or 1
    local spawnScale = (math.abs(sizeInput - 1) < 0.000001) and runtimeScale or math.clamp(sizeInput,0.05,10)
    meta=SpawnPet_ApplyAuthoritativePetData(source,meta,spawnScale)
    SpawnPetState.Meta=meta
    SpawnPet_UpdatePreview(meta)

    if SpawnPetState.Status then
        SpawnPetState.Status.Text="SPAWNING "..tostring(meta.name).."..."
    end

    -- IMPORTANT: hotbar capacity is never a spawn limit.
    -- Create/tracking always happens first. The hotbar is only an optional shortcut.
    local tool, clone=SpawnPet_CreateTool(source,meta)
    if not tool then
        if SpawnPetState.Status then SpawnPetState.Status.Text="Spawn failed" end
        return
    end

    local slot=SpawnPet_FindFreeHotbarSlot()
    if slot then
        pcall(function()
            SpawnPet_BindHotbarSlot(slot,tool,meta,meta.image)
        end)
        tool:SetAttribute("VirtualPetInventoryOnly", false)
        tool:SetAttribute("VirtualPetHotbarVisible", true)
    else
        -- No free hotbar slot: keep the pet alive and tracked, but do not
        -- overwrite any visible hotbar item. The Send Player inventory reads
        -- SpawnPetState.SpawnedTools, so this pet remains selectable there.
        tool:SetAttribute("VirtualPetInventoryOnly", true)
        tool:SetAttribute("VirtualPetHotbarVisible", false)

        local humanoid=Player and Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        local backpack=Player and Player:FindFirstChildOfClass("Backpack")
        if humanoid then
            pcall(function() humanoid:UnequipTools() end)
        end
        if backpack and tool.Parent ~= backpack then
            pcall(function() tool.Parent=backpack end)
        end
    end

    if clone then
        SpawnPet_PlayAnimation1(clone,meta)
        SpawnPet_BuildNameplate(clone,meta)
    end

    if SpawnPetState.Status then
        if slot then
            SpawnPetState.Status.Text="SPAWNED: "..meta.name.." • "..meta.perSecond.." • slot "..tostring(slot.Name)
        else
            SpawnPetState.Status.Text="SPAWNED: "..meta.name.." • "..meta.perSecond.." • inventory only"
        end
    end

    -- Return the actual Tool so batch spawning can count a real successful
    -- spawn instead of assuming the function succeeded merely because it was
    -- called.
    return tool, clone
end

SpawnPetState.BatchBusy = false
SpawnPetState.BatchButtons = SpawnPetState.BatchButtons or {}

function SpawnPet_SpawnBatch(count)
    count = math.floor(tonumber(count) or 0)
    if count <= 0 then return end
    if SpawnPetState.BatchBusy then return end

    local source = SpawnPetState.Source
    if not source or not source.Parent then
        if SpawnPetState.Status then SpawnPetState.Status.Text = "Search a Pet first" end
        return
    end

    SpawnPetState.BatchBusy = true

    for _, button in ipairs(SpawnPetState.BatchButtons or {}) do
        if button and button.Parent then
            button.Active = false
            button.AutoButtonColor = false
            button.TextTransparency = 0.15
        end
    end

    local spawned = 0
    local failed = 0
    for i = 1, count do
        -- Keep the exact same SpawnPet_SpawnCurrent path so every spawned pet
        -- retains the authoritative data, animation, nameplate and hotbar /
        -- inventory-only behavior already used by the single-spawn button.
        if SpawnPetState.Source ~= source or not source.Parent then
            break
        end

        -- One bad asset-build/clone call must NOT abort the whole x10/x20/x30
        -- batch. We also detect a Tool that was successfully created but whose
        -- final visual step raised an error, so we do NOT retry and duplicate
        -- an already-created pet.
        local made = false
        local beforeTools = {}
        for _, existingTool in ipairs(SpawnPetState.SpawnedTools or {}) do
            beforeTools[existingTool] = true
        end

        local ok, tool = pcall(function()
            return SpawnPet_SpawnCurrent()
        end)
        if ok and tool then
            made = true
        else
            for _, currentTool in ipairs(SpawnPetState.SpawnedTools or {}) do
                if currentTool and not beforeTools[currentTool] then
                    made = true
                    break
                end
            end
        end

        -- Retry only when no new Tool was created at all (for example, a
        -- transient clone/build failure before the Tool could be registered).
        if not made then
            for attempt = 1, 2 do
                task.wait(0.08)
                beforeTools = {}
                for _, existingTool in ipairs(SpawnPetState.SpawnedTools or {}) do
                    beforeTools[existingTool] = true
                end
                local retryOk, retryTool = pcall(function()
                    return SpawnPet_SpawnCurrent()
                end)
                if retryOk and retryTool then
                    made = true
                    break
                end
                for _, currentTool in ipairs(SpawnPetState.SpawnedTools or {}) do
                    if currentTool and not beforeTools[currentTool] then
                        made = true
                        break
                    end
                end
                if made then break end
            end
        end

        if made then
            spawned += 1
        else
            failed += 1
        end

        -- Yield after every pet so 10/20/30 large rigs do not lock the client
        -- render thread and so Roblox has time to parent/initialize each Tool.
        task.wait(0.05)
    end

    SpawnPetState.BatchBusy = false

    for _, button in ipairs(SpawnPetState.BatchButtons or {}) do
        if button and button.Parent then
            button.Active = true
            button.AutoButtonColor = true
            button.TextTransparency = 0
        end
    end

    local meta = SpawnPetState.Meta or {}
    local name = tostring(meta.name or "Pet")
    if SpawnPetState.Status then
        if spawned == count then
            SpawnPetState.Status.Text = "SPAWNED x" .. tostring(spawned) .. " • " .. name
        else
            SpawnPetState.Status.Text = "SPAWNED x" .. tostring(spawned) .. " / " .. tostring(count)
                .. " • " .. name .. " • failed " .. tostring(failed)
        end
    end
end

function SpawnPet_ClearCurrentUI()
	if SpawnPetState.Icon then SpawnPetState.Icon.Image="" end
	if SpawnPetState.NameLabel then SpawnPetState.NameLabel.Text="" end
	if SpawnPetState.RarityLabel then SpawnPetState.RarityLabel.Text=""; SpawnPetState.RarityLabel.Visible=false; SpawnPetState.RarityLabel.TextTransparency=1 end
	if SpawnPetState.RateLabel then SpawnPetState.RateLabel.Text="" end
	if SpawnPetState.Status then SpawnPetState.Status.Text="Search a Pet name and press Enter" end
	SpawnPetState.Source=nil
	SpawnPetState.Meta={name="",rarity="",perSecond="",image="",animationId="",animationName="",category="",scale=1,mutations={},baseMutation=nil,creatorTemporary=false,hasBeenFirstPlaced=true,earningRate=0,perSecondValue=0,rarityNumber=0}
end

function SpawnPet_ClearSpawnedPets()
	local removed = {}

	local function markAndDestroyTool(tool)
		if not tool or not tool:IsA("Tool") or tool:GetAttribute("VirtualPet") ~= true then
			return
		end
		removed[tool] = true
		local clone = SpawnPetState.ToolToClone and SpawnPetState.ToolToClone[tool]
		if clone and SpawnPetState.AnimationTrackByClone then
			local track = SpawnPetState.AnimationTrackByClone[clone]
			if track then pcall(function() track:Stop(0) end) end
			SpawnPetState.AnimationTrackByClone[clone] = nil
		end
		if SpawnPetState.AssetItemByClone and clone then
			SpawnPetState.AssetItemByClone[clone] = nil
		end
		SpawnPetState.ToolToClone[tool] = nil
		pcall(function() tool:Destroy() end)
	end

	-- First clear the exact tracked spawned tools.
	for _, tool in ipairs(SpawnPetState.SpawnedTools or {}) do
		markAndDestroyTool(tool)
	end

	-- Safety pass for VirtualPet tools that survived outside the tracked table.
	for _, container in ipairs({Player.Character, Player:FindFirstChildOfClass("Backpack")}) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				markAndDestroyTool(child)
			end
		end
	end

	-- Restore only hotbar slots previously modified by this SpawnPet system.
	for slot, original in pairs(SpawnPetState.HotbarOriginals or {}) do
		if slot and slot.Parent then
			if slot:GetAttribute("__SpawnPetOccupied") == true then
				local icon = slot:FindFirstChild("Icon", true)
				if icon and (icon:IsA("ImageLabel") or icon:IsA("ImageButton")) and original.icon ~= nil then
					pcall(function() icon.Image = original.icon end)
				end
				local tip = slot:FindFirstChild("ToolTip", true)
				if tip and (tip:IsA("TextLabel") or tip:IsA("TextButton")) and original.tooltip ~= nil then
					pcall(function() tip.Text = original.tooltip end)
				end
				slot:SetAttribute("__SpawnPetOccupied", nil)
				slot:SetAttribute("__SpawnPetName", nil)
			end
		end
	end

	for slot, connection in pairs(SpawnPetState.HotbarBindings or {}) do
		if connection then pcall(function() connection:Disconnect() end) end
		SpawnPetState.HotbarBindings[slot] = nil
	end

	table.clear(SpawnPetState.SpawnedTools)
	table.clear(SpawnPetState.ToolToClone)
	table.clear(SpawnPetState.ToolToSlot)
	table.clear(SpawnPetState.AnimationTrackByClone)
	table.clear(SpawnPetState.HotbarOriginals)
	SpawnPet_ClearCurrentUI()
	if SpawnPetState.Status then
		SpawnPetState.Status.Text = "CLEARED PETS"
	end
	return removed
end

-- Panel is created before MainTabBar so SetMainTab can reference it safely.
function SpawnPet_InitUI()
	if SpawnPetState.Panel and SpawnPetState.Panel.Parent then return end
	SpawnPetState.Panel = Instance.new("Frame")
	SpawnPetState.Panel.Name = "SpawnPet"
	SpawnPetState.Panel.Size = ControlPanelNormalSize
	SpawnPetState.Panel.Position = ControlPanelNormalPosition
	SpawnPetState.Panel.BackgroundColor3 = Color3.fromRGB(25,25,30)
	SpawnPetState.Panel.BorderSizePixel = 0
	SpawnPetState.Panel.Visible = false
	SpawnPetState.Panel.ZIndex = 1550
	SpawnPetState.Panel.Parent = ScreenGui
	Instance.new("UICorner", SpawnPetState.Panel).CornerRadius = UDim.new(0,8)
	local spStroke=Instance.new("UIStroke",SpawnPetState.Panel)
	spStroke.Color=Color3.fromRGB(60,60,68)
	spStroke.Thickness=1

	local spTitle=Instance.new("TextLabel",SpawnPetState.Panel)
	spTitle.Size=UDim2.new(1,-30,0,24)
	spTitle.Position=UDim2.fromOffset(15,10)
	spTitle.BackgroundTransparency=1
	spTitle.Text="SpawnPet"
	spTitle.TextColor3=Color3.fromRGB(255,255,255)
	spTitle.Font=Enum.Font.GothamBold
	spTitle.TextSize=16
	spTitle.TextXAlignment=Enum.TextXAlignment.Left
	spTitle.ZIndex=1552

	local spSearch=Instance.new("TextBox",SpawnPetState.Panel)
	spSearch.Name="SpawnPetSearch"
	spSearch.Size=UDim2.new(1,-30,0,30)
	spSearch.Position=UDim2.fromOffset(15,38)
	spSearch.BackgroundColor3=Color3.fromRGB(40,40,45)
	spSearch.BorderSizePixel=0
	spSearch.PlaceholderText="Search Pet name... (Enter)"
	spSearch.PlaceholderColor3=Color3.fromRGB(130,130,140)
	spSearch.Text=""
	spSearch.TextColor3=Color3.fromRGB(255,255,255)
	spSearch.Font=Enum.Font.GothamMedium
	spSearch.TextSize=12
	spSearch.ClearTextOnFocus=false
	spSearch.ZIndex=1553
	Instance.new("UICorner",spSearch).CornerRadius=UDim.new(0,5)
	SpawnPetState.SearchBox=spSearch

	local spPreview=Instance.new("Frame",SpawnPetState.Panel)
	spPreview.Size=UDim2.new(1,-30,0,180)
	spPreview.Position=UDim2.fromOffset(15,76)
	spPreview.BackgroundColor3=Color3.fromRGB(31,31,37)
	spPreview.BorderSizePixel=0
	spPreview.ZIndex=1551
	Instance.new("UICorner",spPreview).CornerRadius=UDim.new(0,6)

	local spIcon=Instance.new("ImageLabel",spPreview)
	spIcon.Name="Pet2DIcon"
	spIcon.Size=UDim2.fromOffset(128,128)
	spIcon.Position=UDim2.fromOffset(10,10)
	spIcon.BackgroundTransparency=1
	spIcon.ScaleType=Enum.ScaleType.Fit
	spIcon.ZIndex=1554
	SpawnPetState.Icon=spIcon

	local spRarity=Instance.new("TextLabel",spPreview)
	spRarity.Size=UDim2.new(1,-156,0,28)
	spRarity.Position=UDim2.fromOffset(148,16)
	spRarity.BackgroundTransparency=1
	spRarity.Text=""
	spRarity.TextColor3=Color3.fromRGB(255,255,255)
	spRarity.Font=Enum.Font.GothamBold
	spRarity.TextSize=13
	spRarity.TextXAlignment=Enum.TextXAlignment.Left
	spRarity.ZIndex=1554
	spRarity.Visible=false
	spRarity.TextTransparency=1
	SpawnPetState.RarityLabel=spRarity

	local spName=Instance.new("TextLabel",spPreview)
	spName.Size=UDim2.new(1,-156,0,30)
	spName.Position=UDim2.fromOffset(148,48)
	spName.BackgroundTransparency=1
	spName.Text=""
	spName.TextColor3=Color3.fromRGB(255,255,255)
	spName.Font=Enum.Font.GothamBold
	spName.TextSize=15
	spName.TextXAlignment=Enum.TextXAlignment.Left
	spName.ZIndex=1554
	SpawnPetState.NameLabel=spName

	local spRate=Instance.new("TextLabel",spPreview)
	spRate.Size=UDim2.new(1,-156,0,26)
	spRate.Position=UDim2.fromOffset(148,80)
	spRate.BackgroundTransparency=1
	spRate.Text=""
	spRate.TextColor3=Color3.fromRGB(65,255,40)
	spRate.Font=Enum.Font.GothamBold
	spRate.TextSize=14
	spRate.TextXAlignment=Enum.TextXAlignment.Left
	spRate.ZIndex=1554
	SpawnPetState.RateLabel=spRate

	local spStatus=Instance.new("TextLabel",SpawnPetState.Panel)
	spStatus.Size=UDim2.new(1,-30,0,20)
	spStatus.Position=UDim2.fromOffset(15,262)
	spStatus.BackgroundTransparency=1
	spStatus.Text="Search a Pet name and press Enter"
	spStatus.TextColor3=Color3.fromRGB(155,155,165)
	spStatus.Font=Enum.Font.Gotham
	spStatus.TextSize=10
	spStatus.TextXAlignment=Enum.TextXAlignment.Left
	spStatus.ZIndex=1552
	SpawnPetState.Status=spStatus

	local spHeightLabel=Instance.new("TextLabel",SpawnPetState.Panel)
	spHeightLabel.Size=UDim2.fromOffset(70,20)
	spHeightLabel.Position=UDim2.fromOffset(15,292)
	spHeightLabel.BackgroundTransparency=1
	spHeightLabel.Text="Height"
	spHeightLabel.TextColor3=Color3.fromRGB(210,210,215)
	spHeightLabel.Font=Enum.Font.GothamMedium
	spHeightLabel.TextSize=11
	spHeightLabel.TextXAlignment=Enum.TextXAlignment.Left
	spHeightLabel.ZIndex=1552

	local spHeight=Instance.new("TextBox",SpawnPetState.Panel)
	spHeight.Size=UDim2.fromOffset(80,25)
	spHeight.Position=UDim2.fromOffset(70,290)
	spHeight.BackgroundColor3=Color3.fromRGB(40,40,45)
	spHeight.BorderSizePixel=0
	spHeight.Text="0.5"
	spHeight.TextColor3=Color3.fromRGB(255,255,255)
	spHeight.Font=Enum.Font.GothamMedium
	spHeight.TextSize=11
	spHeight.ClearTextOnFocus=false
	spHeight.ZIndex=1553
	Instance.new("UICorner",spHeight).CornerRadius=UDim.new(0,4)
	SpawnPetState.HeightBox=spHeight

	local spWeightLabel=Instance.new("TextLabel",SpawnPetState.Panel)
	spWeightLabel.Size=UDim2.fromOffset(70,20)
	spWeightLabel.Position=UDim2.fromOffset(160,292)
	spWeightLabel.BackgroundTransparency=1
	spWeightLabel.Text="Weight/Scale"
	spWeightLabel.TextColor3=Color3.fromRGB(210,210,215)
	spWeightLabel.Font=Enum.Font.GothamMedium
	spWeightLabel.TextSize=10
	spWeightLabel.TextXAlignment=Enum.TextXAlignment.Left
	spWeightLabel.ZIndex=1552

	local spWeight=Instance.new("TextBox",SpawnPetState.Panel)
	spWeight.Size=UDim2.fromOffset(55,25)
	spWeight.Position=UDim2.fromOffset(233,290)
	spWeight.BackgroundColor3=Color3.fromRGB(40,40,45)
	spWeight.BorderSizePixel=0
	spWeight.Text="1"
	spWeight.TextColor3=Color3.fromRGB(255,255,255)
	spWeight.Font=Enum.Font.GothamMedium
	spWeight.TextSize=11
	spWeight.ClearTextOnFocus=false
	spWeight.ZIndex=1553
	Instance.new("UICorner",spWeight).CornerRadius=UDim.new(0,4)
	SpawnPetState.SizeBox=spWeight
	spWeight.FocusLost:Connect(function()
		if SpawnPetState.Source and SpawnPetState.Meta and SpawnPetState.Meta.name ~= "" then
			local updated = SpawnPet_ApplyAuthoritativePetData(SpawnPetState.Source, SpawnPetState.Meta, math.clamp(SpawnPet_GetNumber(spWeight, SpawnPetState.Meta.scale or 1),0.05,10))
			SpawnPet_UpdatePreview(updated)
		end
	end)

	local spSpawn=Instance.new("TextButton",SpawnPetState.Panel)
	spSpawn.Name="SpawnPetButton"
	spSpawn.Size=UDim2.new(0.5,-4,0,40)
	spSpawn.Position=UDim2.fromOffset(15,330)
	spSpawn.BackgroundColor3=Color3.fromRGB(118,255,10)
	spSpawn.BorderSizePixel=0
	spSpawn.Text="SPAWN PET"
	spSpawn.TextColor3=Color3.fromRGB(0,0,0)
	spSpawn.Font=Enum.Font.GothamBold
	spSpawn.TextSize=13
	spSpawn.AutoButtonColor=true
	spSpawn.ZIndex=1553
	Instance.new("UICorner",spSpawn).CornerRadius=UDim.new(0,6)
	SpawnPetState.SpawnButton=spSpawn

	local spClear=Instance.new("TextButton",SpawnPetState.Panel)
	spClear.Name="ClearPetButton"
	spClear.Size=UDim2.new(0.5,-4,0,40)
	spClear.Position=UDim2.new(0.5,1,0,330)
	spClear.BackgroundColor3=Color3.fromRGB(150,40,200)
	spClear.BorderSizePixel=0
	spClear.Text="CLEAR PET"
	spClear.TextColor3=Color3.fromRGB(255,255,255)
	spClear.Font=Enum.Font.GothamBold
	spClear.TextSize=12
	spClear.AutoButtonColor=true
	spClear.ZIndex=1553
	Instance.new("UICorner",spClear).CornerRadius=UDim.new(0,6)
	SpawnPetState.ClearButton=spClear

	-- Quick spawn batch buttons: x10 / x20 / x30.
	-- They call the same single-spawn path repeatedly, so hotbar capacity is
	-- still only a display limit; overflow pets remain in virtual inventory.
	local batchCounts = {10, 20, 30}
	SpawnPetState.BatchButtons = {}
	for index, amount in ipairs(batchCounts) do
		local batchBtn = Instance.new("TextButton", SpawnPetState.Panel)
		batchBtn.Name = "SpawnPetBatch" .. tostring(amount)
		batchBtn.Size = UDim2.fromOffset(80, 34)
		batchBtn.Position = UDim2.fromOffset(15 + (index - 1) * 90, 378)
		batchBtn.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
		batchBtn.BorderSizePixel = 0
		batchBtn.Text = "x" .. tostring(amount)
		batchBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
		batchBtn.Font = Enum.Font.GothamBold
		batchBtn.TextSize = 14
		batchBtn.AutoButtonColor = true
		batchBtn.ZIndex = 1553
		Instance.new("UICorner", batchBtn).CornerRadius = UDim.new(0, 6)
		local batchStroke = Instance.new("UIStroke", batchBtn)
		batchStroke.Color = Color3.fromRGB(255, 255, 255)
		batchStroke.Thickness = 2
		SpawnPetState.BatchButtons[index] = batchBtn

		batchBtn.Activated:Connect(function()
			SpawnPet_SpawnBatch(amount)
		end)
	end

	spSearch.FocusLost:Connect(function(enterPressed)
		if enterPressed then SpawnPet_Search(spSearch.Text) end
	end)
	spSpawn.Activated:Connect(function() SpawnPet_SpawnCurrent() end)
	spClear.Activated:Connect(function() SpawnPet_ClearSpawnedPets() end)
end

SpawnPet_InitUI()

-- ==========================================
-- MAIN TABS
-- ==========================================
MainTabBar = Instance.new("Frame", ControlPanel)
MainTabBar.Name = "MainTabBar"
MainTabBar.Size = UDim2.new(1, 0, 0, 30)
MainTabBar.BackgroundTransparency = 1
MainTabBar.BorderSizePixel = 0
MainTabBar.LayoutOrder = -200
MainTabBar.ZIndex = 1600

GiftTabBtn = Instance.new("TextButton", MainTabBar)
GiftTabBtn.Size = UDim2.new(1/3, -6, 1, 0)
GiftTabBtn.Position = UDim2.fromOffset(0, 0)
GiftTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
GiftTabBtn.BorderSizePixel = 0
GiftTabBtn.Text = "GIFT PLAYER"
GiftTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GiftTabBtn.Font = Enum.Font.GothamBold
GiftTabBtn.TextSize = 10
GiftTabBtn.ZIndex = 1601
Instance.new("UICorner", GiftTabBtn).CornerRadius = UDim.new(0, 4)

SpawnTabBtn = Instance.new("TextButton", MainTabBar)
SpawnTabBtn.Size = UDim2.new(1/3, -6, 1, 0)
SpawnTabBtn.Position = UDim2.new(1/3, 2, 0, 0)
SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
SpawnTabBtn.BorderSizePixel = 0
SpawnTabBtn.Text = "SPAWN MODEL"
SpawnTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnTabBtn.Font = Enum.Font.GothamBold
SpawnTabBtn.TextSize = 10
SpawnTabBtn.ZIndex = 1601
Instance.new("UICorner", SpawnTabBtn).CornerRadius = UDim.new(0, 4)

SpawnPetTabBtn = Instance.new("TextButton", MainTabBar)
SpawnPetTabBtn.Size = UDim2.new(1/3, -6, 1, 0)
SpawnPetTabBtn.Position = UDim2.new(2/3, 4, 0, 0)
SpawnPetTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
SpawnPetTabBtn.BorderSizePixel = 0
SpawnPetTabBtn.Text = "SpawnPet"
SpawnPetTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnPetTabBtn.Font = Enum.Font.GothamBold
SpawnPetTabBtn.TextSize = 10
SpawnPetTabBtn.ZIndex = 1601
Instance.new("UICorner", SpawnPetTabBtn).CornerRadius = UDim.new(0, 4)

CurrentMainTab = "Gift"

local function SetMainTab(tabName)
	if tabName == "Spawn" then
		CurrentMainTab = "Spawn"
		SpawnModelSendButton.Visible = true
		SpawnModelPanel.Position = ControlPanel.Position
		SpawnModelPanel.Size = ControlPanel.Size
		SpawnModelPanel.Visible = true
		SpawnPetState.Panel.Visible = false
		ControlPanel.BackgroundTransparency = 1

		GiftTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
		SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
		SpawnPetTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)

		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") and child ~= MainTabBar then child.Visible = false end
		end
		MainTabBar.Visible = true
	elseif tabName == "SpawnPet" then
		CurrentMainTab = "SpawnPet"
		if SpawnModelSendEverLocked then
			SpawnModelSendButton.Visible = true
		else
			SpawnModelSendButton.Visible = false
		end
		SpawnModelPanel.Visible = false
		SpawnPetState.Panel.Position = ControlPanel.Position
		SpawnPetState.Panel.Size = ControlPanel.Size
		SpawnPetState.Panel.Visible = true
		ControlPanel.BackgroundTransparency = 1

		GiftTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
		SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
		SpawnPetTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)

		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") and child ~= MainTabBar then child.Visible = false end
		end
		MainTabBar.Visible = true
	else
		CurrentMainTab = "Gift"
		if SpawnModelSendEverLocked then
			SpawnModelSendButton.Visible = true
		else
			SpawnModelSendButton.Visible = false
		end
		SpawnModelPanel.Visible = false
		SpawnPetState.Panel.Visible = false
		ControlPanel.BackgroundTransparency = 0

		GiftTabBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
		SpawnTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)
		SpawnPetTabBtn.BackgroundColor3 = Color3.fromRGB(46, 48, 56)

		for _, child in ipairs(ControlPanel:GetChildren()) do
			if child:IsA("GuiObject") then child.Visible = true end
		end

		if ControlPanelHidden then
			for _, child in ipairs(ControlPanel:GetChildren()) do
				if child:IsA("GuiObject") then child.Visible = false end
			end
			OpenFullPanelBtn.Visible = true
			for i = 1, 8 do if UserBoxes[i] then UserBoxes[i].Visible = true end end
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

SpawnPetTabBtn.MouseButton1Click:Connect(function()
	if ControlPanelHidden then return end
	SetMainTab("SpawnPet")
end)

-- Put the Spawn Model window back in the same place when the Control Panel is moved.
ControlPanel:GetPropertyChangedSignal("Position"):Connect(function()
	if SpawnModelPanel.Visible then SpawnModelPanel.Position = ControlPanel.Position end
	if SpawnPetState.Panel.Visible then SpawnPetState.Panel.Position = ControlPanel.Position end
end)

ControlPanel:GetPropertyChangedSignal("Size"):Connect(function()
	if SpawnModelPanel.Visible then SpawnModelPanel.Size = ControlPanel.Size end
	if SpawnPetState.Panel.Visible then SpawnPetState.Panel.Size = ControlPanel.Size end
end)

-- ==========================================
-- GIFT PLAYER
-- ==========================================
GiftPrompt =
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

GiftOuterStroke =
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

TiledBackground =
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

-- Solid Gift Player background sampled from the supplied reference image.
-- The old background texture is intentionally removed.
TiledBackground.BackgroundTransparency = 0
TiledBackground.BackgroundColor3 = Color3.fromRGB(52, 36, 68)
TiledBackground.Image = ""
TiledBackground.ImageTransparency = 1
TiledBackground.BorderSizePixel = 0
TiledBackground.ZIndex = 650
TiledBackground.Active = false

-- Full Gift Player background effect requested by the user.
-- This is layered over the solid deep-purple base and under the center
-- effect/player rows, so it covers the whole table without blocking input.
GiftPlayer_FullBackgroundEffect = Instance.new("ImageLabel", GiftPrompt)
GiftPlayer_FullBackgroundEffect.Name = "GiftPlayerFullBackgroundEffect"
GiftPlayer_FullBackgroundEffect.Size = UDim2.new(1, 0, 1, 0)
GiftPlayer_FullBackgroundEffect.Position = UDim2.new(0, 0, 0, 0)
GiftPlayer_FullBackgroundEffect.BackgroundTransparency = 1
GiftPlayer_FullBackgroundEffect.BorderSizePixel = 0
GiftPlayer_FullBackgroundEffect.Image = "rbxassetid://131176354845909"
GiftPlayer_FullBackgroundEffect.ImageColor3 = Color3.fromRGB(125, 70, 175)
GiftPlayer_FullBackgroundEffect.ImageTransparency = 0.45
GiftPlayer_FullBackgroundEffect.ScaleType = Enum.ScaleType.Tile
GiftPlayer_FullBackgroundEffect.TileSize = UDim2.fromOffset(60, 60)
GiftPlayer_FullBackgroundEffect.ZIndex = 651
GiftPlayer_FullBackgroundEffect.Active = false
GiftPlayer_FullBackgroundEffect.Visible = true

-- Supplied center effect for the Gift Player table. It sits behind the
-- player rows so it remains visible through the transparent list while the
-- player content stays fully readable and interactive.
GiftPlayer_CenterEffect = Instance.new("ImageLabel", GiftPrompt)
GiftPlayer_CenterEffect.Name = "GiftPlayerCenterEffect"
GiftPlayer_CenterEffect.Size = UDim2.new(1, -24, 1, -115)
GiftPlayer_CenterEffect.Position = UDim2.new(0, 12, 0, 100)
GiftPlayer_CenterEffect.BackgroundTransparency = 1
GiftPlayer_CenterEffect.BorderSizePixel = 0
GiftPlayer_CenterEffect.Image = "rbxassetid://126841495627073"
GiftPlayer_CenterEffect.ImageColor3 = Color3.fromRGB(165, 72, 235)
GiftPlayer_CenterEffect.ImageTransparency = 0.48
GiftPlayer_CenterEffect.ScaleType = Enum.ScaleType.Stretch
GiftPlayer_CenterEffect.ZIndex = 652
GiftPlayer_CenterEffect.Active = false
GiftPlayer_CenterEffect.Visible = true

-- ==========================================
-- GIFT HEADER
-- ==========================================
-- HEADER OUTER BORDER (white -> pink -> purple)
HeaderBorder = Instance.new("Frame", GiftPrompt)
HeaderBorder.Name = "GiftHeaderBorder"
HeaderBorder.Size = UDim2.new(1, 0, 0, 90)
HeaderBorder.Position = UDim2.new(0, 0, 0, 0)
HeaderBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderBorder.BorderSizePixel = 0
HeaderBorder.ZIndex = 5

HeaderBorderGradient = Instance.new("UIGradient", HeaderBorder)
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

HeaderFrame = Instance.new("Frame", GiftPrompt)
HeaderFrame.Name = "GiftHeader"
-- 50% thinner header border: 1.5px inset on every side instead of 3px.
HeaderFrame.Size = UDim2.new(1, -4, 0, 86)
HeaderFrame.Position = UDim2.new(0, 2, 0, 2)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- SUPPLIED HEADER EFFECT
-- Asset 98981360538955 is rendered as a dedicated overlay inside the Gift Player bar.
-- It stays above the gradient/pattern but below the icon, title and close button.
HeaderGlow =
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
	ContentProvider:PreloadAsync({HeaderGlow, GiftPlayer_HeaderCenterEffect})
end)

HeaderFrame.BorderSizePixel =
	0

HeaderFrame.ZIndex =
	800

-- Additional supplied purple effect for the entire Gift Player header bar.
-- It is a separate overlay so the 126841495627073 effect is visible on the
-- bar without replacing the existing header gradient/pattern.
GiftPlayer_HeaderCenterEffect = Instance.new("ImageLabel", HeaderFrame)
GiftPlayer_HeaderCenterEffect.Name = "GiftPlayerHeaderCenterEffect"
GiftPlayer_HeaderCenterEffect.Size = UDim2.new(1, 0, 1, 0)
GiftPlayer_HeaderCenterEffect.Position = UDim2.new(0, 0, 0, 0)
GiftPlayer_HeaderCenterEffect.BackgroundTransparency = 1
GiftPlayer_HeaderCenterEffect.BorderSizePixel = 0
GiftPlayer_HeaderCenterEffect.Image = "rbxassetid://126841495627073"
GiftPlayer_HeaderCenterEffect.ImageColor3 = Color3.fromRGB(165, 72, 235)
GiftPlayer_HeaderCenterEffect.ImageTransparency = 0.48
GiftPlayer_HeaderCenterEffect.ScaleType = Enum.ScaleType.Stretch
GiftPlayer_HeaderCenterEffect.ZIndex = 805
GiftPlayer_HeaderCenterEffect.Active = false
GiftPlayer_HeaderCenterEffect.Visible = true

HeaderGradient =
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
HeaderBottomBorder =
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
GiftIcon =
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
TitleText =
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

TitleStroke =
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
HeaderPattern =
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
CloseBtnContainer =
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

CloseContainerStroke =
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

CloseGiftBtn =
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

CloseXText =
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

CloseXStroke =
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
PlayerList =
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
	860

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

-- Gift Player row builder uses GiftPlayer_PlayerList as its parent.
-- Keep a direct alias to the actual ScrollingFrame so rows are parented
-- to the visible Gift Player list instead of being created unparented.
GiftPlayer_PlayerList = PlayerList
GiftPlayer_PlayerList.Name = "GiftPlayerList"
GiftPlayer_PlayerList.Active = true
GiftPlayer_PlayerList.ClipsDescendants = true

ListLayout =
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

ListPadding =
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

-- ==========================================
-- ==========================================
-- GIFT PLAYER BODY
-- Keep Gift Player's original purple body/background.
-- The Send Player panel is independently styled blue; Gift Player is not.
-- ==========================================

RowUIList = {}

-- ==========================================
-- LOADING / SELECT ANIMATION
-- ==========================================
LoadingPrompt =
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
LoadGiftIcon =
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

LoadGiftScale =
	Instance.new(
		"UIScale",
		LoadGiftIcon
	)

LoadGiftScale.Scale =
	1

LoadRing =
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
BuyPrompt =
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
BuyTitleBar =
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
TopBalanceContainer =
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

TopLayout =
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

TopIcon =
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

TopBalanceLbl =
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
CloseBtnX =
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
ItemImage =
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
ItemName =
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
PriceContainer =
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

PriceLayout =
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

PriceIcon =
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

PriceLabel =
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
BuyBtn =
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

BuyGradient =
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

BuyText =
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

sweepTween = nil
buySweepFinished = false
buyPressing = false

BUY_NORMAL_COLOR = Color3.fromRGB(45, 95, 255)
BUY_READY_COLOR = Color3.fromRGB(45, 95, 255)
BUY_PRESSED_COLOR = Color3.fromRGB(20, 35, 105)

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

SuccessPrompt = nil
PurchaseSuccessfulPrompt = nil
StartConfetti = nil
RefreshPurchaseSuccessfulTitle = nil

-- ==========================================
-- BUY CLICK / 1 SECOND CONFIRM DELAY
-- FIXED RESULT FLOW:
-- Buy -> 1s delay -> Purchase Successful + Purchase Completed + Confetti
-- ==========================================

local function ShowPurchaseResult()
	-- SEND PLAYER has a completely independent post-buy flow.
	-- Gift Player keeps its original Purchase Completed / Success UI.
	if ActiveGiftSource == "SendCompose" and StartSendPlayerPostBuyFlow then
		BuyPrompt.Visible = false
		StartSendPlayerPostBuyFlow()
		return
	end

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

	if SendPlayerPrompt then
		SendPlayerPrompt.Visible = false
	end

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

	-- Gift Player keeps its original 1-second confirmation delay.
	-- Send Player starts its independent 2-second green-ring/gift-box sequence
	-- immediately after Buy is pressed.
	if ActiveGiftSource ~= "SendCompose" then
		task.wait(1.0)
	end

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

SuccessStroke =
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
SuccessTitle =
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
CloseBtnX2 =
	Instance.new(
		"TextButton",
		SuccessPrompt
	)

CloseBtnX2.Size = UDim2.fromOffset(56, 56)
CloseBtnX2.Position = UDim2.new(1, -10, 0, 0)
CloseBtnX2.AnchorPoint = Vector2.new(1, 0)
CloseBtnX2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtnX2.BackgroundTransparency = 0
CloseBtnX2.BorderSizePixel = 0
CloseBtnX2.Text = "X"
CloseBtnX2.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtnX2.Font = Enum.Font.FredokaOne
CloseBtnX2.TextSize = 36
CloseBtnX2.TextXAlignment = Enum.TextXAlignment.Center
CloseBtnX2.TextYAlignment = Enum.TextYAlignment.Center
CloseBtnX2.AutoButtonColor = false
CloseBtnX2.ZIndex = 1002
CloseBtnX2.Visible = false
CloseBtnX2.Active = false
local CloseBtnX2Stroke = Instance.new("UIStroke", CloseBtnX2)
CloseBtnX2Stroke.Color = Color3.fromRGB(0, 0, 0)
CloseBtnX2Stroke.Thickness = 3

-- ==========================================
-- CHECK CIRCLE
-- ==========================================
CheckCircle =
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

CheckCircleCorner =
	Instance.new(
		"UICorner",
		CheckCircle
	)

CheckCircleCorner.CornerRadius =
	UDim.new(
		1,
		0
	)

CheckStroke =
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

CheckIcon =
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
SuccessSub =
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
OkBtn =
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
PurchaseSuccessfulBackground =
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
	0.12

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

PurchaseSuccessfulStroke =
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
PurchaseSuccessfulClose =
	Instance.new(
		"TextButton",
		PurchaseSuccessfulPrompt
	)

PurchaseSuccessfulClose.Name = "PurchaseSuccessfulClose"
PurchaseSuccessfulClose.Size = UDim2.fromOffset(56, 56)
PurchaseSuccessfulClose.Position = UDim2.new(1, -10, 0, 0)
PurchaseSuccessfulClose.AnchorPoint = Vector2.new(1, 0)
PurchaseSuccessfulClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PurchaseSuccessfulClose.BackgroundTransparency = 0
PurchaseSuccessfulClose.BorderSizePixel = 0
PurchaseSuccessfulClose.Text = "X"
PurchaseSuccessfulClose.TextColor3 = Color3.fromRGB(255, 255, 255)
PurchaseSuccessfulClose.Font = Enum.Font.FredokaOne
PurchaseSuccessfulClose.TextSize = 36
PurchaseSuccessfulClose.TextXAlignment = Enum.TextXAlignment.Center
PurchaseSuccessfulClose.TextYAlignment = Enum.TextYAlignment.Center
PurchaseSuccessfulClose.AutoButtonColor = false
PurchaseSuccessfulClose.ZIndex = 903
PurchaseSuccessfulClose.Visible = false
PurchaseSuccessfulClose.Active = false
PurchaseSuccessfulCloseStroke = Instance.new("UIStroke", PurchaseSuccessfulClose)
PurchaseSuccessfulCloseStroke.Color = Color3.fromRGB(0, 0, 0)
PurchaseSuccessfulCloseStroke.Thickness = 3

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

PurchaseSuccessfulTitle =
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

PurchaseSuccessfulTitleStroke =
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

SuccessfulOkBtn =
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
	Color3.fromRGB(
		118,
		255,
		10
	)

SuccessfulOkBtn.BorderSizePixel =
	0

SuccessfulOkBtn.Text =
	""

SuccessfulOkBtn.AutoButtonColor =
	false

SuccessfulOkBtn.Active =
	true

SuccessfulOkBtn.ZIndex =
	1002

Instance.new(
	"UICorner",
	SuccessfulOkBtn
).CornerRadius =
	UDim.new(
		0,
		8
	)

SuccessfulOkStroke =
	Instance.new(
		"UIStroke",
		SuccessfulOkBtn
	)

SuccessfulOkStroke.Color =
	Color3.fromRGB(
		255,
		255,
		255
	)

SuccessfulOkStroke.Thickness =
	3

SuccessfulOkWhiteBorderOverlay =
	Instance.new(
		"Frame",
		SuccessfulOkBtn
	)

SuccessfulOkWhiteBorderOverlay.Name =
	"WhiteBorderOverlay"

SuccessfulOkWhiteBorderOverlay.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

SuccessfulOkWhiteBorderOverlay.Position =
	UDim2.fromOffset(
		0,
		0
	)

SuccessfulOkWhiteBorderOverlay.BackgroundTransparency =
	1

SuccessfulOkWhiteBorderOverlay.BorderSizePixel =
	0

SuccessfulOkWhiteBorderOverlay.ZIndex =
	1006

SuccessfulOkWhiteBorderOverlay.Active =
	false

Instance.new(
	"UICorner",
	SuccessfulOkWhiteBorderOverlay
).CornerRadius =
	UDim.new(
		0,
		8
	)

SuccessfulOkVisibleWhiteStroke =
	Instance.new(
		"UIStroke",
		SuccessfulOkWhiteBorderOverlay
	)

SuccessfulOkVisibleWhiteStroke.Color =
	Color3.fromRGB(
		255,
		255,
		255
	)

SuccessfulOkVisibleWhiteStroke.Thickness =
	3

SuccessfulOkPattern =
	Instance.new(
		"ImageLabel",
		SuccessfulOkBtn
	)

SuccessfulOkPattern.Name =
	"SelectStylePattern"

SuccessfulOkPattern.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

SuccessfulOkPattern.Position =
	UDim2.fromOffset(
		0,
		0
	)

SuccessfulOkPattern.BackgroundTransparency =
	1

SuccessfulOkPattern.BorderSizePixel =
	0

SuccessfulOkPattern.Image =
	"rbxassetid://90325592797235"

SuccessfulOkPattern.ScaleType =
	Enum.ScaleType.Tile

SuccessfulOkPattern.TileSize =
	UDim2.fromOffset(
		60,
		60
	)

SuccessfulOkPattern.ImageTransparency =
	0.72

SuccessfulOkPattern.ImageColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

SuccessfulOkPattern.ZIndex =
	1004

SuccessfulOkPattern.Active =
	false

SuccessfulOkText =
	Instance.new(
		"TextLabel",
		SuccessfulOkBtn
	)

SuccessfulOkText.Name =
	"OkText"

SuccessfulOkText.Size =
	UDim2.new(
		1,
		0,
		1,
		0
	)

SuccessfulOkText.Position =
	UDim2.fromOffset(
		0,
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
	52

SuccessfulOkText.TextXAlignment =
	Enum.TextXAlignment.Center

SuccessfulOkText.TextYAlignment =
	Enum.TextYAlignment.Center

SuccessfulOkText.TextScaled =
	false

SuccessfulOkText.TextWrapped =
	false

SuccessfulOkText.ZIndex =
	1007

SuccessfulOkText.Active =
	false

SuccessfulOkTextStroke =
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
	2

SuccessfulOkBtn.MouseEnter:Connect(function()
	SuccessfulOkBtn.BackgroundColor3 =
		Color3.fromRGB(
			128,
			255,
			20
		)
end)

SuccessfulOkBtn.MouseLeave:Connect(function()
	SuccessfulOkBtn.BackgroundColor3 =
		Color3.fromRGB(
			118,
			255,
			10
		)
end)

SuccessfulOkBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		SuccessfulOkBtn.BackgroundColor3 =
			Color3.fromRGB(
				92,
				225,
				0
			)
	end
end)

SuccessfulOkBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		SuccessfulOkBtn.BackgroundColor3 =
			Color3.fromRGB(
				128,
				255,
				20
			)
	end
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

AvatarCache = {}          -- keyed by UserId, never by row/display name
AvatarLoading = {}        -- keyed by UserId

-- ==========================================
-- ROBLOX RANDOM AVATAR FALLBACK FOR UNKNOWN USERNAMES
-- Uses Roblox's official public user search endpoint with the first
-- 3 characters of the entered username, then randomly selects a real
-- Roblox user from the returned results and uses that user's real avatar.
-- No generated initials / invented avatar data are used.
-- ==========================================
HttpService = game:GetService("HttpService")
RobloxRandomAvatarCache = {} -- [typedUsernameLower] = { UserId, Username, DisplayName, Image }

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

-- ==========================================
-- GIFT PLAYER AVATAR PIPELINE — MATCH SEND PLAYER
-- ==========================================
-- Gift Player now uses the same avatar-resolution/request pattern as
-- Send Player: per-row request tokens, username -> UserId resolution,
-- shared UserId cache, per-row loading guard, real HeadShot thumbnail,
-- preload, and stale-request protection.  No generated/random avatar
-- fallback is used here.
GiftPlayerAvatarLoading = GiftPlayerAvatarLoading or {}
GiftPlayerAvatarRequestId = GiftPlayerAvatarRequestId or {}

function GiftPlayer_RequestAvatar(index, username)
	local row = RowUIList[index]
	if not row then return end

	local cleanUsername = tostring(username or ""):gsub("^%s+", ""):gsub("%s+$", "")
	GiftPlayerAvatarRequestId[index] = (GiftPlayerAvatarRequestId[index] or 0) + 1
	local requestId = GiftPlayerAvatarRequestId[index]
	row.Avatar.Visible = false
	row.FallbackAvatar.Visible = false
	row.FallbackAvatarText.Text = ""
	row.Avatar.Image = ""

	if cleanUsername == "" then
		GiftPlayerAvatarLoading[index] = nil
		return
	end

	if GiftPlayerAvatarLoading[index] == cleanUsername then
		return
	end
	GiftPlayerAvatarLoading[index] = cleanUsername

	task.spawn(function()
		local userId = nil
		local okId, resolvedId = pcall(function()
			return Players:GetUserIdFromNameAsync(cleanUsername)
		end)
		if okId and resolvedId then
			userId = resolvedId
		end

		if GiftPlayerAvatarRequestId[index] ~= requestId then
			if GiftPlayerAvatarLoading[index] == cleanUsername then
				GiftPlayerAvatarLoading[index] = nil
			end
			return
		end

		if userId then
			row.UserId = userId
			local cached = AvatarCache[userId]
			if cached and cached ~= "" then
				row.Avatar.Image = cached
				row.Avatar.Visible = true
				row.FallbackAvatar.Visible = false
				if GiftPlayerAvatarLoading[index] == cleanUsername then
					GiftPlayerAvatarLoading[index] = nil
				end
				return
			end

			local thumbOk, avatarImage = pcall(function()
				local image = Players:GetUserThumbnailAsync(
					userId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size150x150
				)
				return image
			end)

			if thumbOk
				and type(avatarImage) == "string"
				and avatarImage ~= ""
				and avatarImage ~= "rbxasset://textures/ui/GuiImagePlaceholder.png" then
				AvatarCache[userId] = avatarImage
				if GiftPlayerAvatarRequestId[index] == requestId then
					row.Avatar.Image = avatarImage
					row.Avatar.Visible = true
					row.FallbackAvatar.Visible = false
				end
			end
		end

		if GiftPlayerAvatarLoading[index] == cleanUsername then
			GiftPlayerAvatarLoading[index] = nil
		end
	end)
end

local function UpdatePlayerRow(
	displayName,
	realUserName,
	rowUI
)
	local cleanUserName =
		(realUserName or ""):gsub("^%s+", ""):gsub("%s+$", "")

	local cleanDisplayName =
		(displayName or ""):gsub("^%s+", ""):gsub("%s+$", "")

	if not rowUI then
		return
	end

	-- Empty slot: match Send Player behavior by hiding the row and
	-- clearing its avatar/text state.
	if cleanUserName == "" then
		rowUI.Row.Visible = false
		rowUI.NameLabel.Text = ""
		rowUI.UserLabel.Text = ""
		rowUI.Username = ""
		rowUI.UserId = nil
		rowUI.Avatar.Visible = false
		rowUI.Avatar.Image = ""
		rowUI.AvatarRequestUsername = ""

		if rowUI.FallbackAvatar then
			rowUI.FallbackAvatar.Visible = false
		end

		if rowUI.FallbackAvatarText then
			rowUI.FallbackAvatarText.Text = ""
		end

		if rowUI and rowUI.Row and RowUIList then
			for index, sourceRow in ipairs(RowUIList) do
				if sourceRow == rowUI then
					GiftPlayerAvatarRequestId[index] =
						(GiftPlayerAvatarRequestId[index] or 0) + 1
					GiftPlayerAvatarLoading[index] = nil
					break
				end
			end
		end

		return
	end

	rowUI.Row.Visible = true
	rowUI.NameLabel.Text =
		cleanDisplayName ~= "" and cleanDisplayName or cleanUserName
	rowUI.UserLabel.Text = "@" .. cleanUserName
	rowUI.Username = cleanUserName
	rowUI.UserId = nil

	rowUI.Avatar.Visible = false
	rowUI.Avatar.Image = ""
	rowUI.Avatar.ImageTransparency = 0
	rowUI.Avatar.BackgroundTransparency = 1
	rowUI.Avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	rowUI.Avatar.ScaleType = Enum.ScaleType.Crop
	rowUI.Avatar.ZIndex = 871
	rowUI.AvatarRequestUsername = cleanUserName

	if rowUI.FallbackAvatar then
		rowUI.FallbackAvatar.Visible = false
	end

	if rowUI.FallbackAvatarText then
		rowUI.FallbackAvatarText.Text = ""
	end

	-- Use exactly the same real-avatar request pipeline as Send Player.
	local index = nil
	for i = 1, 8 do
		if RowUIList[i] == rowUI then
			index = i
			break
		end
	end

	if index then
		GiftPlayer_RequestAvatar(index, cleanUserName)
	end
end


-- ==========================================
-- PLAYER ROWS — FULL SEND PLAYER STRUCTURE TRANSPLANTED
-- ==========================================
-- Gift Player now uses the Send Player player-row construction wholesale:
-- same hierarchy, dimensions, avatar setup, labels, ZIndex, button layers,
-- pattern texture, white border overlay and interaction visuals.
-- Only the Gift Player palette (purple) and action text/handler (Select) differ.
RowUIList = {}

function GiftPlayer_CreateRow(index)
	local Row = Instance.new("Frame", GiftPlayer_PlayerList)
	Row.Name = "GiftPlayerRow_" .. tostring(index)
	Row.Size = UDim2.new(1, -10, 0, 112)
	Row.BackgroundColor3 = Color3.fromRGB(52, 36, 68)
	Row.BorderSizePixel = 0
	Row.ClipsDescendants = true
	Row.LayoutOrder = index
	Row.Visible = false
	Row.ZIndex = 860
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 12)

	GiftPlayer_RowColorBackground = Instance.new("Frame", Row)
	GiftPlayer_RowColorBackground.Name = "PlayerRowColorBackground"
	GiftPlayer_RowColorBackground.Size = UDim2.new(1, 0, 1, 0)
	GiftPlayer_RowColorBackground.Position = UDim2.new(0, 0, 0, 0)
	GiftPlayer_RowColorBackground.BackgroundColor3 = Color3.fromRGB(52, 36, 68)
	GiftPlayer_RowColorBackground.BackgroundTransparency = 0
	GiftPlayer_RowColorBackground.BorderSizePixel = 0
	GiftPlayer_RowColorBackground.ZIndex = 861
	GiftPlayer_RowColorBackground.Active = false
	Instance.new("UICorner", GiftPlayer_RowColorBackground).CornerRadius = UDim.new(0, 12)

	GiftPlayer_RowBackgroundGradient = Instance.new("UIGradient", GiftPlayer_RowColorBackground)
	GiftPlayer_RowBackgroundGradient.Name = "PlayerRowBackground2Color"
	GiftPlayer_RowBackgroundGradient.Rotation = 90
	GiftPlayer_RowBackgroundGradient.Color = ColorSequence.new({
		-- Top is intentionally darker; bottom is slightly brighter purple.
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(52, 36, 68)),
		ColorSequenceKeypoint.new(0.49, Color3.fromRGB(52, 36, 68)),
		ColorSequenceKeypoint.new(0.51, Color3.fromRGB(74, 54, 98)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(74, 54, 98))
	})
	GiftPlayer_RowBackgroundGradient.Transparency = NumberSequence.new(0)

	-- Same supplied center effect, now layered into each Player Row with a
	-- purple tint so the player area shares the Gift Player visual language.
	GiftPlayer_RowEffect = Instance.new("ImageLabel", Row)
	GiftPlayer_RowEffect.Name = "PlayerRowEffect"
	GiftPlayer_RowEffect.Size = UDim2.new(1, 0, 1, 0)
	GiftPlayer_RowEffect.Position = UDim2.new(0, 0, 0, 0)
	GiftPlayer_RowEffect.BackgroundTransparency = 1
	GiftPlayer_RowEffect.BorderSizePixel = 0
	GiftPlayer_RowEffect.Image = "rbxassetid://126841495627073"
	GiftPlayer_RowEffect.ImageColor3 = Color3.fromRGB(165, 72, 235)
	GiftPlayer_RowEffect.ImageTransparency = 0.64
	GiftPlayer_RowEffect.ScaleType = Enum.ScaleType.Stretch
	GiftPlayer_RowEffect.ZIndex = 862
	GiftPlayer_RowEffect.Active = false
	GiftPlayer_RowEffect.Visible = true

	GiftPlayer_RowInner = Instance.new("Frame", Row)
	GiftPlayer_RowInner.Name = "RowInner"
	GiftPlayer_RowInner.Size = UDim2.new(1, -4, 1, -4)
	GiftPlayer_RowInner.Position = UDim2.new(0, 2, 0, 2)
	GiftPlayer_RowInner.BackgroundTransparency = 1
	GiftPlayer_RowInner.BorderSizePixel = 0
	GiftPlayer_RowInner.ZIndex = 862
	GiftPlayer_RowInner.Active = false
	Instance.new("UICorner", GiftPlayer_RowInner).CornerRadius = UDim.new(0, 10)

	GiftPlayer_AvatarFrame = Instance.new("Frame", Row)
	GiftPlayer_AvatarFrame.Name = "AvatarFrame"
	GiftPlayer_AvatarFrame.Size = UDim2.fromOffset(80, 80)
	GiftPlayer_AvatarFrame.Position = UDim2.new(0, 15, 0.5, -40)
	GiftPlayer_AvatarFrame.BackgroundTransparency = 1
	GiftPlayer_AvatarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	GiftPlayer_AvatarFrame.BorderSizePixel = 0
	GiftPlayer_AvatarFrame.ZIndex = 870
	GiftPlayer_AvatarFrame.Visible = true
	GiftPlayer_AvatarFrame.ClipsDescendants = true
	Instance.new("UIAspectRatioConstraint", GiftPlayer_AvatarFrame).AspectRatio = 1
	Instance.new("UICorner", GiftPlayer_AvatarFrame).CornerRadius = UDim.new(0, 12)

	-- 100% transparent avatar area for Send Player as well.

	GiftPlayer_Avatar = Instance.new("ImageLabel", GiftPlayer_AvatarFrame)
	GiftPlayer_Avatar.Name = "Avatar"
	GiftPlayer_Avatar.Size = UDim2.fromOffset(80, 80)
	GiftPlayer_Avatar.Position = UDim2.fromOffset(0, 0)
	GiftPlayer_Avatar.BackgroundTransparency = 1
	GiftPlayer_Avatar.BorderSizePixel = 0
	GiftPlayer_Avatar.ScaleType = Enum.ScaleType.Crop
	GiftPlayer_Avatar.BackgroundColor3 = Color3.fromRGB(44, 20, 77)
	GiftPlayer_Avatar.Visible = false
	GiftPlayer_Avatar.ClipsDescendants = true
	GiftPlayer_Avatar.ImageTransparency = 0
	GiftPlayer_Avatar.ZIndex = 871
	Instance.new("UICorner", GiftPlayer_Avatar).CornerRadius = UDim.new(0, 12)

	GiftPlayer_FallbackAvatar = Instance.new("Frame", GiftPlayer_AvatarFrame)
	GiftPlayer_FallbackAvatar.Name = "FallbackAvatar"
	GiftPlayer_FallbackAvatar.Size = UDim2.fromOffset(80, 80)
	GiftPlayer_FallbackAvatar.Position = UDim2.fromOffset(0, 0)
	GiftPlayer_FallbackAvatar.BorderSizePixel = 0
	GiftPlayer_FallbackAvatar.BackgroundTransparency = 1
	GiftPlayer_FallbackAvatar.Visible = false
	GiftPlayer_FallbackAvatar.ZIndex = 872
	Instance.new("UICorner", GiftPlayer_FallbackAvatar).CornerRadius = UDim.new(0, 12)

	GiftPlayer_FallbackAvatarText = Instance.new("TextLabel", GiftPlayer_FallbackAvatar)
	GiftPlayer_FallbackAvatarText.Name = "FallbackAvatarText"
	GiftPlayer_FallbackAvatarText.Size = UDim2.fromScale(1, 1)
	GiftPlayer_FallbackAvatarText.BackgroundTransparency = 1
	GiftPlayer_FallbackAvatarText.Text = ""
	GiftPlayer_FallbackAvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
	GiftPlayer_FallbackAvatarText.Font = Enum.Font.GothamBlack
	GiftPlayer_FallbackAvatarText.TextSize = 23
	GiftPlayer_FallbackAvatarText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	GiftPlayer_FallbackAvatarText.TextStrokeTransparency = 0.25
	GiftPlayer_FallbackAvatarText.TextXAlignment = Enum.TextXAlignment.Center
	GiftPlayer_FallbackAvatarText.TextYAlignment = Enum.TextYAlignment.Center
	GiftPlayer_FallbackAvatarText.ZIndex = 873

	GiftPlayer_NameLabel = Instance.new("TextLabel", Row)
	GiftPlayer_NameLabel.Name = "NameLabel"
	GiftPlayer_NameLabel.Size = UDim2.new(0, 300, 0, 34)
	GiftPlayer_NameLabel.Position = UDim2.new(0, 110, 0, 20)
	GiftPlayer_NameLabel.BackgroundTransparency = 1
	GiftPlayer_NameLabel.ZIndex = 874
	GiftPlayer_NameLabel.Text = ""
	GiftPlayer_NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	GiftPlayer_NameLabel.Font = Enum.Font.FredokaOne
	GiftPlayer_NameLabel.TextSize = 34
	GiftPlayer_NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	GiftPlayer_NameLabel.TextYAlignment = Enum.TextYAlignment.Center
	GiftPlayer_NameLabel.TextScaled = false
	GiftPlayer_NameLabel.TextWrapped = false
	GiftPlayer_NameStroke = Instance.new("UIStroke", GiftPlayer_NameLabel)
	GiftPlayer_NameStroke.Color = Color3.fromRGB(0, 0, 0)
	GiftPlayer_NameStroke.Thickness = 2

	GiftPlayer_UserLabel = Instance.new("TextLabel", Row)
	GiftPlayer_UserLabel.Name = "UserLabel"
	GiftPlayer_UserLabel.Size = UDim2.new(0, 330, 0, 28)
	GiftPlayer_UserLabel.Position = UDim2.new(0, 110, 0, 57)
	GiftPlayer_UserLabel.BackgroundTransparency = 1
	GiftPlayer_UserLabel.ZIndex = 875
	GiftPlayer_UserLabel.Text = ""
	GiftPlayer_UserLabel.TextColor3 = Color3.fromRGB(211, 211, 211)
	GiftPlayer_UserLabel.Font = Enum.Font.FredokaOne
	GiftPlayer_UserLabel.TextSize = 27
	GiftPlayer_UserLabel.TextXAlignment = Enum.TextXAlignment.Left
	GiftPlayer_UserLabel.TextYAlignment = Enum.TextYAlignment.Center
	GiftPlayer_UserLabel.TextScaled = false
	GiftPlayer_UserLabel.TextWrapped = false
	GiftPlayer_UserStroke = Instance.new("UIStroke", GiftPlayer_UserLabel)
	GiftPlayer_UserStroke.Color = Color3.fromRGB(0, 0, 0)
	GiftPlayer_UserStroke.Thickness = 2

	-- SELECT button: visually mirrors Gift Player's Select button exactly.
	-- Same size, corner radius, white outer stroke, pattern texture, text font/size,
	-- black text outline, and hover/pressed colors. The only difference is the label: "Select".
	GiftPlayer_SelectBtnContainer = Instance.new("Frame", Row)
	GiftPlayer_SelectBtnContainer.Name = "SelectBtnContainer"
	GiftPlayer_SelectBtnContainer.Size = UDim2.new(0, 174, 0, 70)
	GiftPlayer_SelectBtnContainer.Position = UDim2.new(1, -190, 0.5, -35)
	GiftPlayer_SelectBtnContainer.BackgroundTransparency = 1
	GiftPlayer_SelectBtnContainer.BorderSizePixel = 0
	GiftPlayer_SelectBtnContainer.ZIndex = 876

	GiftPlayer_SelectBtn = Instance.new("TextButton", GiftPlayer_SelectBtnContainer)
	local selectButton = GiftPlayer_SelectBtn
	GiftPlayer_SelectBtn.Name = "SelectBtn"
	GiftPlayer_SelectBtn.Size = UDim2.new(1, 0, 1, 0)
	GiftPlayer_SelectBtn.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
	GiftPlayer_SelectBtn.BorderSizePixel = 0
	GiftPlayer_SelectBtn.Text = ""
	GiftPlayer_SelectBtn.AutoButtonColor = false
	GiftPlayer_SelectBtn.ZIndex = 877
	GiftPlayer_SelectBtn.Active = true

	Instance.new("UICorner", GiftPlayer_SelectBtn).CornerRadius = UDim.new(0, 8)

	GiftPlayer_SelectWhiteStroke = Instance.new("UIStroke", GiftPlayer_SelectBtn)
	GiftPlayer_SelectWhiteStroke.Color = Color3.fromRGB(255, 255, 255)
	GiftPlayer_SelectWhiteStroke.Thickness = 3

	-- Exact white border overlay used by Gift Player's Select button.
	GiftPlayer_SelectWhiteBorderOverlay = Instance.new("Frame", GiftPlayer_SelectBtn)
	GiftPlayer_SelectWhiteBorderOverlay.Name = "WhiteBorderOverlay"
	GiftPlayer_SelectWhiteBorderOverlay.Size = UDim2.new(1, 0, 1, 0)
	GiftPlayer_SelectWhiteBorderOverlay.Position = UDim2.new(0, 0, 0, 0)
	GiftPlayer_SelectWhiteBorderOverlay.BackgroundTransparency = 1
	GiftPlayer_SelectWhiteBorderOverlay.BorderSizePixel = 0
	GiftPlayer_SelectWhiteBorderOverlay.ZIndex = 879

	Instance.new("UICorner", GiftPlayer_SelectWhiteBorderOverlay).CornerRadius = UDim.new(0, 8)

	GiftPlayer_SelectVisibleWhiteStroke = Instance.new("UIStroke", GiftPlayer_SelectWhiteBorderOverlay)
	GiftPlayer_SelectVisibleWhiteStroke.Color = Color3.fromRGB(255, 255, 255)
	GiftPlayer_SelectVisibleWhiteStroke.Thickness = 3
	GiftPlayer_SelectVisibleWhiteStroke.Transparency = 0

	-- Exact Select pattern layer.
	GiftPlayer_SelectPattern = Instance.new("ImageLabel")
	GiftPlayer_SelectPattern.Name = "SelectPattern"
	GiftPlayer_SelectPattern.Size = UDim2.new(1, 0, 1, 0)
	GiftPlayer_SelectPattern.Position = UDim2.new(0, 0, 0, 0)
	GiftPlayer_SelectPattern.BackgroundTransparency = 1
	GiftPlayer_SelectPattern.BorderSizePixel = 0
	GiftPlayer_SelectPattern.Image = "rbxassetid://90325592797235"
	GiftPlayer_SelectPattern.ScaleType = Enum.ScaleType.Tile
	GiftPlayer_SelectPattern.TileSize = UDim2.fromOffset(60, 60)
	GiftPlayer_SelectPattern.ImageTransparency = 0.72
	GiftPlayer_SelectPattern.ZIndex = 878
	GiftPlayer_SelectPattern.Active = false
	GiftPlayer_SelectPattern.Parent = GiftPlayer_SelectBtn

	-- Exact Select text treatment, with the label changed from Select to Send.
	GiftPlayer_SelectText = Instance.new("TextLabel", GiftPlayer_SelectBtn)
	GiftPlayer_SelectText.Name = "SelectText"
	GiftPlayer_SelectText.Size = UDim2.new(1, 0, 1, 0)
	GiftPlayer_SelectText.BackgroundTransparency = 1
	GiftPlayer_SelectText.Text = "Select"
	GiftPlayer_SelectText.TextColor3 = Color3.fromRGB(255, 255, 255)
	GiftPlayer_SelectText.Font = Enum.Font.FredokaOne
	GiftPlayer_SelectText.TextSize = 52
	GiftPlayer_SelectText.TextXAlignment = Enum.TextXAlignment.Center
	GiftPlayer_SelectText.TextYAlignment = Enum.TextYAlignment.Center
	GiftPlayer_SelectText.TextScaled = false
	GiftPlayer_SelectText.TextWrapped = false
	GiftPlayer_SelectText.ZIndex = 880
	GiftPlayer_SelectText.Active = false

	GiftPlayer_SelectTextStroke = Instance.new("UIStroke", GiftPlayer_SelectText)
	GiftPlayer_SelectTextStroke.Color = Color3.fromRGB(0, 0, 0)
	GiftPlayer_SelectTextStroke.Thickness = 2

	selectButton.MouseEnter:Connect(function()
		selectButton.BackgroundColor3 = Color3.fromRGB(128, 255, 20)
	end)
	selectButton.MouseLeave:Connect(function()
		selectButton.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
	end)
	selectButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			selectButton.BackgroundColor3 = Color3.fromRGB(92, 225, 0)
		end
	end)
	selectButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			selectButton.BackgroundColor3 = Color3.fromRGB(128, 255, 20)
		end
	end)
	-- Select visual for now: intentionally no MouseButton1Click handler.
	-- Gift Player Select keeps the original purchase flow. The button itself is
	-- structurally identical to Send Player; only its action remains Gift Player-specific.
	GiftPlayer_SelectBtn.MouseButton1Click:Connect(function()
		local giftRow = RowUIList[index]
		if not giftRow then return end

		SelectedGiftDisplayName = giftRow.NameLabel.Text
		SelectedGiftUsername = giftRow.UserLabel.Text:gsub("^@", "")

		ActiveGiftSource = "Shop"
		SendPlayerPrompt.Visible = false
		RefreshPurchaseSuccessfulTitle()

		GiftPrompt.Visible = false
		LoadingPrompt.Visible = true
		BuyPrompt.Visible = false
		DarkOverlay.Visible = true
		DarkOverlay.BackgroundTransparency = 0.5
		LoadRing.Rotation = 0
		LoadGiftScale.Scale = 1

		local animationStart = os.clock()
		local rotateConnection = RunService.RenderStepped:Connect(function(dt)
			if not LoadingPrompt.Visible then return end
			LoadRing.Rotation = (LoadRing.Rotation + 180 * dt) % 360
			local elapsed = os.clock() - animationStart
			LoadGiftScale.Scale = 1 + math.sin(elapsed * math.pi * 2.2) * 0.11
		end)

		task.wait(2)

		if rotateConnection then
			rotateConnection:Disconnect()
			rotateConnection = nil
		end

		LoadGiftScale.Scale = 1
		LoadingPrompt.Visible = false
		BuyPrompt.Visible = true
	end)

	RowUIList[index] = {
		Row = Row,
		AvatarFrame = GiftPlayer_AvatarFrame,
		Avatar = GiftPlayer_Avatar,
		FallbackAvatar = GiftPlayer_FallbackAvatar,
		FallbackAvatarText = GiftPlayer_FallbackAvatarText,
		NameLabel = GiftPlayer_NameLabel,
		UserLabel = GiftPlayer_UserLabel,
		SelectBtn = GiftPlayer_SelectBtn,
		SelectText = GiftPlayer_SelectText,
		Username = "",
		UserId = nil
	}
end

for i = 1, 8 do
	GiftPlayer_CreateRow(i)
	UpdatePlayerRow(Settings.FakeUsers[i], Settings.RealUsernames[i], RowUIList[i])
end

-- ==========================================
-- GIFT PLAYER REFRESH — SAME DATA FLOW AS SEND PLAYER
-- ==========================================
function GiftPlayer_RefreshRows()
	if not PlayerList or not RowUIList then return end
	PlayerList.Visible = true
	PlayerList.ZIndex = 860

	for index = 1, 8 do
		local row = RowUIList[index]
		if row then
			local username = tostring((Settings.RealUsernames and Settings.RealUsernames[index]) or "")
			username = username:gsub("^%s+", ""):gsub("%s+$", "")
			local displayName = tostring((Settings.FakeUsers and Settings.FakeUsers[index]) or "")
			displayName = displayName:gsub("^%s+", ""):gsub("%s+$", "")

			UpdatePlayerRow(displayName, username, row)
		end
	end
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
			if type(SendPlayer_RefreshRows) == "function" then
				SendPlayer_RefreshRows()
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
			if type(SendPlayer_RefreshRows) == "function" then
				SendPlayer_RefreshRows()
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
			if type(SendPlayer_RefreshRows) == "function" then
				SendPlayer_RefreshRows()
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
			if type(SendPlayer_RefreshRows) == "function" then
				SendPlayer_RefreshRows()
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
			if type(SendPlayer_RefreshRows) == "function" then
				SendPlayer_RefreshRows()
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
			if type(SendPlayer_RefreshRows) == "function" then
				SendPlayer_RefreshRows()
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
	if type(SendPlayer_RefreshRows) == "function" then
		SendPlayer_RefreshRows()
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
-- SEND BUTTON LOCK / DRAG
-- ==========================================
local function SpawnModel_UpdateSendLockVisual()
	if not SpawnModelSendLockButton then return end
	if SpawnModelSendLocked then
		SpawnModelSendLockButton.Text = "UNLOCK SEND"
		SpawnModelSendLockButton.BackgroundColor3 = Color3.fromRGB(150, 40, 200)
		SpawnModelSendStatus.Text = "LOCKED • CLICK SEND"
		SpawnModelSendStatus.TextColor3 = Color3.fromRGB(230, 170, 255)
	else
		SpawnModelSendLockButton.Text = "LOCK SEND"
		SpawnModelSendLockButton.BackgroundColor3 = Color3.fromRGB(70, 70, 78)
		SpawnModelSendStatus.Text = "UNLOCKED • DRAG"
		SpawnModelSendStatus.TextColor3 = Color3.fromRGB(150, 150, 160)
	end
end

SpawnModelSendLockButton.Activated:Connect(function()
	SpawnModelSendLocked = not SpawnModelSendLocked
	if SpawnModelSendLocked then
		SpawnModelSendEverLocked = true
		SpawnModelSendButton.Visible = true
	end
	SpawnModelSendDragging = false
	SpawnModelSendDragged = false
	SpawnModel_UpdateSendLockVisual()
end)

SpawnModelSendButton.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	SpawnModelSendPressed = true
	SpawnModelSendDragged = false

	if not SpawnModelSendLocked then
		SpawnModelSendDragging = true
		SpawnModelSendDragStart = input.Position
		SpawnModelSendStartPosition = SpawnModelSendButton.Position
	else
		SpawnModelSendDragging = false
	end
end)

SpawnModelSendButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		SpawnModelSendDragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not SpawnModelSendDragging or SpawnModelSendLocked then return end
	if input ~= SpawnModelSendDragInput then return end
	local delta = input.Position - SpawnModelSendDragStart
	if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
		SpawnModelSendDragged = true
	end
	SpawnModelSendButton.Position = UDim2.new(
		SpawnModelSendStartPosition.X.Scale,
		SpawnModelSendStartPosition.X.Offset + delta.X,
		SpawnModelSendStartPosition.Y.Scale,
		SpawnModelSendStartPosition.Y.Offset + delta.Y
	)
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local wasDragging = SpawnModelSendDragging
	local wasPressed = SpawnModelSendPressed
	local wasDragged = SpawnModelSendDragged
	SpawnModelSendDragging = false
	SpawnModelSendPressed = false
	SpawnModelSendDragInput = nil
	SpawnModelSendDragged = false

	if wasPressed and not wasDragging and not wasDragged and SpawnModelSendLocked then
		-- SEND opens its own independent Send Player panel.
		if type(ShowSendPlayerPrompt) == "function" then
			ShowSendPlayerPrompt()
		end
	end
end)

SpawnModel_UpdateSendLockVisual()

-- ==========================================
-- INDEPENDENT SEND PLAYER PANEL
-- ==========================================
-- IMPORTANT:
-- This panel is rebuilt from scratch. It does NOT clone GiftPrompt and does
-- NOT reuse any GiftPrompt GuiObject. The visual structure, player fields and
-- button construction are recreated from the same Gift Player definitions.
SendPlayerPrompt = Instance.new("Frame", ScreenGui)
SendPlayerPrompt.Name = "SendPlayerPrompt"
SendPlayerPrompt.Size = UDim2.new(0, 820, 0, 610)
SendPlayerPrompt.Position = UDim2.new(0.5, 0, 0.5, 0)
SendPlayerPrompt.AnchorPoint = Vector2.new(0.5, 0.5)
SendPlayerPrompt.BackgroundColor3 = Color3.fromRGB(10, 48, 82)
SendPlayerPrompt.BorderSizePixel = 0
SendPlayerPrompt.Visible = false
SendPlayerPrompt.ClipsDescendants = true
SendPlayerPrompt.ZIndex = 850

-- The main Send Player window is intentionally rectangular. Only the header
-- bar below is rounded, matching the requested reference appearance.
SendPlayer_OuterStroke = Instance.new("UIStroke", SendPlayerPrompt)
SendPlayer_OuterStroke.Name = "SendPlayerOuterStroke"
SendPlayer_OuterStroke.Color = Color3.fromRGB(0, 0, 0)
SendPlayer_OuterStroke.Thickness = 2

-- Match GiftPrompt's tiled background structure, but use the Send Player blue palette.
SendPlayer_TiledBackground = Instance.new("ImageLabel", SendPlayerPrompt)
SendPlayer_TiledBackground.Name = "SendPlayerTiledBackground"
SendPlayer_TiledBackground.Size = UDim2.fromScale(1, 1)
SendPlayer_TiledBackground.Position = UDim2.fromScale(0, 0)
SendPlayer_TiledBackground.BackgroundTransparency = 1
SendPlayer_TiledBackground.BorderSizePixel = 0
SendPlayer_TiledBackground.ScaleType = Enum.ScaleType.Tile
SendPlayer_TiledBackground.TileSize = UDim2.fromOffset(30, 30)
SendPlayer_TiledBackground.Image = "rbxassetid://90325592797235"
SendPlayer_TiledBackground.ImageColor3 = Color3.fromRGB(75, 155, 205)
SendPlayer_TiledBackground.ImageTransparency = 0.88
SendPlayer_TiledBackground.ZIndex = 851
SendPlayer_TiledBackground.Active = false

-- Unified panel-wide effect requested by the user.
-- Same asset is used on Gift Player and Send Player/Compose, tinted to the
-- active blue palette so the three panels share the exact texture while
-- retaining their respective color themes.
SendPlayer_FullBackgroundEffect = Instance.new("ImageLabel", SendPlayerPrompt)
SendPlayer_FullBackgroundEffect.Name = "SendPlayerFullBackgroundEffect"
SendPlayer_FullBackgroundEffect.Size = UDim2.new(1, 0, 1, 0)
SendPlayer_FullBackgroundEffect.Position = UDim2.fromOffset(0, 0)
SendPlayer_FullBackgroundEffect.BackgroundTransparency = 1
SendPlayer_FullBackgroundEffect.BorderSizePixel = 0
SendPlayer_FullBackgroundEffect.Image = "rbxassetid://131176354845909"
SendPlayer_FullBackgroundEffect.ImageColor3 = Color3.fromRGB(75, 155, 205)
SendPlayer_FullBackgroundEffect.ImageTransparency = 0.45
SendPlayer_FullBackgroundEffect.ScaleType = Enum.ScaleType.Tile
SendPlayer_FullBackgroundEffect.TileSize = UDim2.fromOffset(60, 60)
SendPlayer_FullBackgroundEffect.ZIndex = 852
SendPlayer_FullBackgroundEffect.Active = false
SendPlayer_FullBackgroundEffect.Visible = true

SendPlayer_BackgroundGradient = Instance.new("UIGradient", SendPlayerPrompt)
SendPlayer_BackgroundGradient.Name = "SendPlayerBackgroundGradient"
SendPlayer_BackgroundGradient.Rotation = 90
SendPlayer_BackgroundGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(10, 48, 82)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(17, 78, 120)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 125, 175))
})
SendPlayer_BackgroundGradient.Enabled = true

SendPlayer_CenterEffect = Instance.new("ImageLabel", SendPlayerPrompt)
SendPlayer_CenterEffect.Name = "SendPlayerCenterEffect"
SendPlayer_CenterEffect.Size = UDim2.new(1, -24, 1, -115)
SendPlayer_CenterEffect.Position = UDim2.new(0, 12, 0, 100)
SendPlayer_CenterEffect.BackgroundTransparency = 1
SendPlayer_CenterEffect.BorderSizePixel = 0
SendPlayer_CenterEffect.Image = "rbxassetid://126841495627073"
SendPlayer_CenterEffect.ImageColor3 = Color3.fromRGB(95, 190, 245)
SendPlayer_CenterEffect.ImageTransparency = 0.48
SendPlayer_CenterEffect.ScaleType = Enum.ScaleType.Stretch
SendPlayer_CenterEffect.ZIndex = 853
SendPlayer_CenterEffect.Active = false
SendPlayer_CenterEffect.Visible = true


-- ==========================================
-- SEND PLAYER HEADER (same construction as Gift Player)
-- ==========================================
SendPlayer_HeaderBorder = Instance.new("Frame", SendPlayerPrompt)
SendPlayer_HeaderBorder.Name = "SendPlayerHeaderBorder"
SendPlayer_HeaderBorder.Size = UDim2.new(1, 0, 0, 90)
SendPlayer_HeaderBorder.Position = UDim2.new(0, 0, 0, 0)
SendPlayer_HeaderBorder.BackgroundColor3 = Color3.fromRGB(70, 170, 235)
SendPlayer_HeaderBorder.BorderSizePixel = 0
SendPlayer_HeaderBorder.ZIndex = 855
SendPlayer_HeaderBorder.ClipsDescendants = true
local SendPlayer_HeaderBorderCorner = Instance.new("UICorner", SendPlayer_HeaderBorder)
-- Send Player 1 header: square corners (no rounding on the title bar).
SendPlayer_HeaderBorderCorner.CornerRadius = UDim.new(0, 0)

SendPlayer_HeaderBorderGradient = Instance.new("UIGradient", SendPlayer_HeaderBorder)
SendPlayer_HeaderBorderGradient.Name = "SendPlayerHeaderBorderGradient"
SendPlayer_HeaderBorderGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 220, 255)),
	ColorSequenceKeypoint.new(0.10, Color3.fromRGB(145, 230, 255)),
	ColorSequenceKeypoint.new(0.22, Color3.fromRGB(80, 190, 245)),
	ColorSequenceKeypoint.new(0.38, Color3.fromRGB(28, 125, 205)),
	ColorSequenceKeypoint.new(0.56, Color3.fromRGB(115, 215, 255)),
	ColorSequenceKeypoint.new(0.72, Color3.fromRGB(70, 175, 235)),
	ColorSequenceKeypoint.new(0.86, Color3.fromRGB(45, 145, 220)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 95, 170))
})

SendPlayer_HeaderFrame = Instance.new("Frame", SendPlayerPrompt)
SendPlayer_HeaderFrame.Name = "SendPlayerHeader"
SendPlayer_HeaderFrame.Size = UDim2.new(1, -4, 0, 86)
SendPlayer_HeaderFrame.Position = UDim2.new(0, 2, 0, 2)
SendPlayer_HeaderFrame.BackgroundColor3 = Color3.fromRGB(70, 175, 240)
SendPlayer_HeaderFrame.BorderSizePixel = 0
SendPlayer_HeaderFrame.ZIndex = 856
SendPlayer_HeaderFrame.ClipsDescendants = true
local SendPlayer_HeaderCorner = Instance.new("UICorner", SendPlayer_HeaderFrame)
-- Keep the Send Player 1 title bar fully rectangular.
SendPlayer_HeaderCorner.CornerRadius = UDim.new(0, 0)

SendPlayer_HeaderGradient = Instance.new("UIGradient", SendPlayer_HeaderFrame)
SendPlayer_HeaderGradient.Name = "SendPlayerHeaderGradient"
SendPlayer_HeaderGradient.Rotation = 0
SendPlayer_HeaderGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 220, 255)),
	ColorSequenceKeypoint.new(0.16, Color3.fromRGB(48, 145, 220)),
	ColorSequenceKeypoint.new(0.34, Color3.fromRGB(35, 125, 205)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(155, 235, 255)),
	ColorSequenceKeypoint.new(0.63, Color3.fromRGB(105, 210, 250)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(40, 145, 225)),
	ColorSequenceKeypoint.new(0.90, Color3.fromRGB(30, 115, 195)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 70, 145))
})

SendPlayer_HeaderGlow = Instance.new("ImageLabel", SendPlayer_HeaderFrame)
SendPlayer_HeaderGlow.Name = "SendPlayerHeaderGlow"
SendPlayer_HeaderGlow.Size = UDim2.new(0, 542, 1, 0)
SendPlayer_HeaderGlow.Position = UDim2.new(0, 271, 0, 0)
SendPlayer_HeaderGlow.AnchorPoint = Vector2.new(0, 0)
SendPlayer_HeaderGlow.BackgroundTransparency = 1
SendPlayer_HeaderGlow.BorderSizePixel = 0
SendPlayer_HeaderGlow.Image = "rbxassetid://98981360538955"
SendPlayer_HeaderGlow.ImageColor3 = Color3.fromRGB(145, 225, 255)
SendPlayer_HeaderGlow.ImageTransparency = 0.10
SendPlayer_HeaderGlow.ScaleType = Enum.ScaleType.Stretch
SendPlayer_HeaderGlow.ResampleMode = Enum.ResamplerMode.Default
SendPlayer_HeaderGlow.ZIndex = 858
SendPlayer_HeaderGlow.Visible = true
SendPlayer_HeaderGlow.Active = false
pcall(function()
	ContentProvider:PreloadAsync({SendPlayer_HeaderGlow})
end)

SendPlayer_HeaderPattern = Instance.new("ImageLabel", SendPlayer_HeaderFrame)
SendPlayer_HeaderPattern.Name = "SendPlayerHeaderPattern"
SendPlayer_HeaderPattern.Size = UDim2.new(1, 0, 1, -4)
SendPlayer_HeaderPattern.Position = UDim2.new(0, 0, 0, 0)
SendPlayer_HeaderPattern.BackgroundTransparency = 1
SendPlayer_HeaderPattern.BorderSizePixel = 0
SendPlayer_HeaderPattern.Image = "rbxassetid://90325592797235"
SendPlayer_HeaderPattern.ScaleType = Enum.ScaleType.Tile
SendPlayer_HeaderPattern.TileSize = UDim2.fromOffset(60, 60)
SendPlayer_HeaderPattern.ImageColor3 = Color3.fromRGB(120, 210, 255)
SendPlayer_HeaderPattern.ImageTransparency = 0.82
SendPlayer_HeaderPattern.ZIndex = 857
SendPlayer_HeaderPattern.Active = false

SendPlayer_GiftIcon = Instance.new("ImageLabel", SendPlayer_HeaderFrame)
SendPlayer_GiftIcon.Name = "SendPlayerGiftIcon"
SendPlayer_GiftIcon.Size = UDim2.fromOffset(58, 66)
SendPlayer_GiftIcon.Position = UDim2.new(0, 14, 0.5, -33)
SendPlayer_GiftIcon.BackgroundTransparency = 1
SendPlayer_GiftIcon.BorderSizePixel = 0
SendPlayer_GiftIcon.Image = "rbxassetid://91482729206521"
SendPlayer_GiftIcon.ScaleType = Enum.ScaleType.Fit
SendPlayer_GiftIcon.ImageTransparency = 0
SendPlayer_GiftIcon.ZIndex = 910
SendPlayer_GiftIcon.Active = false

SendPlayer_TitleText = Instance.new("TextLabel", SendPlayer_HeaderFrame)
SendPlayer_TitleText.Name = "SendPlayerTitleText"
SendPlayer_TitleText.Size = UDim2.new(0, 440, 1, 0)
SendPlayer_TitleText.Position = UDim2.new(0, 86, 0, 0)
SendPlayer_TitleText.BackgroundTransparency = 1
SendPlayer_TitleText.Text = "Send Player"
SendPlayer_TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
SendPlayer_TitleText.Font = Enum.Font.FredokaOne
SendPlayer_TitleText.TextSize = 54
SendPlayer_TitleText.TextXAlignment = Enum.TextXAlignment.Left
SendPlayer_TitleText.TextYAlignment = Enum.TextYAlignment.Center
SendPlayer_TitleText.TextScaled = false
SendPlayer_TitleText.TextWrapped = false
SendPlayer_TitleText.ZIndex = 920
SendPlayer_TitleStroke = Instance.new("UIStroke", SendPlayer_TitleText)
SendPlayer_TitleStroke.Color = Color3.fromRGB(0, 0, 0)
SendPlayer_TitleStroke.Thickness = 4.5

SendPlayer_CloseBtnContainer = Instance.new("Frame", SendPlayer_HeaderFrame)
SendPlayer_CloseBtnContainer.Name = "SendPlayerCloseBtnContainer"
SendPlayer_CloseBtnContainer.Size = UDim2.new(0, 56, 0, 56)
SendPlayer_CloseBtnContainer.Position = UDim2.new(1, -10, 0.5, 0)
SendPlayer_CloseBtnContainer.AnchorPoint = Vector2.new(1, 0.5)
SendPlayer_CloseBtnContainer.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SendPlayer_CloseBtnContainer.BorderSizePixel = 0
SendPlayer_CloseBtnContainer.ZIndex = 979
SendPlayer_CloseBtnContainer.Active = false
SendPlayer_CloseStroke = Instance.new("UIStroke", SendPlayer_CloseBtnContainer)
SendPlayer_CloseStroke.Color = Color3.fromRGB(0, 0, 0)
SendPlayer_CloseStroke.Thickness = 3

SendPlayer_CloseBtn = Instance.new("ImageButton", SendPlayer_CloseBtnContainer)
SendPlayer_CloseBtn.Name = "SendPlayerCloseBtn"
SendPlayer_CloseBtn.Size = UDim2.new(1, 0, 1, -6)
SendPlayer_CloseBtn.Position = UDim2.new(0, 0, 0, 0)
SendPlayer_CloseBtn.BackgroundTransparency = 1
SendPlayer_CloseBtn.BorderSizePixel = 0
SendPlayer_CloseBtn.Image = ""
SendPlayer_CloseBtn.ScaleType = Enum.ScaleType.Fit
SendPlayer_CloseBtn.AutoButtonColor = false
SendPlayer_CloseBtn.ZIndex = 981

SendPlayer_CloseXText = Instance.new("TextLabel", SendPlayer_CloseBtnContainer)
SendPlayer_CloseXText.Name = "CloseX"
SendPlayer_CloseXText.Size = UDim2.new(1, 0, 1, -4)
SendPlayer_CloseXText.Position = UDim2.new(0, 0, 0, 0)
SendPlayer_CloseXText.BackgroundTransparency = 1
SendPlayer_CloseXText.Text = "X"
SendPlayer_CloseXText.TextColor3 = Color3.fromRGB(255, 255, 255)
SendPlayer_CloseXText.Font = Enum.Font.FredokaOne
SendPlayer_CloseXText.TextSize = 36
SendPlayer_CloseXText.TextXAlignment = Enum.TextXAlignment.Center
SendPlayer_CloseXText.TextYAlignment = Enum.TextYAlignment.Center
SendPlayer_CloseXText.ZIndex = 982
SendPlayer_CloseXStroke = Instance.new("UIStroke", SendPlayer_CloseXText)
SendPlayer_CloseXStroke.Color = Color3.fromRGB(0, 0, 0)
SendPlayer_CloseXStroke.Thickness = 4
SendPlayer_CloseXText.Active = false

SendPlayer_CloseBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		SendPlayer_CloseBtn.Size = UDim2.new(1, 0, 1, 0)
	end
end)

SendPlayer_CloseBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		SendPlayer_CloseBtn.Size = UDim2.new(1, 0, 1, -6)
	end
end)

-- ==========================================
-- SEND PLAYER LIST
-- Same dimensions, spacing and ScrollingFrame construction as Gift Player.
-- ==========================================
SendPlayer_PlayerList = Instance.new("ScrollingFrame", SendPlayerPrompt)
SendPlayer_PlayerList.Name = "SendPlayerList"
SendPlayer_PlayerList.Size = UDim2.new(1, -24, 1, -115)
SendPlayer_PlayerList.Position = UDim2.new(0, 12, 0, 100)
SendPlayer_PlayerList.BackgroundTransparency = 1
SendPlayer_PlayerList.BorderSizePixel = 0
SendPlayer_PlayerList.ZIndex = 860
SendPlayer_PlayerList.ScrollBarThickness = 8
SendPlayer_PlayerList.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
SendPlayer_PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
SendPlayer_PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SendPlayer_PlayerList.Active = true
SendPlayer_PlayerList.ClipsDescendants = true

SendPlayer_ListLayout = Instance.new("UIListLayout", SendPlayer_PlayerList)
SendPlayer_ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SendPlayer_ListLayout.Padding = UDim.new(0, 10)

SendPlayer_ListPadding = Instance.new("UIPadding", SendPlayer_PlayerList)
SendPlayer_ListPadding.PaddingTop = UDim.new(0, 5)
SendPlayer_ListPadding.PaddingBottom = UDim.new(0, 5)

SendPlayerRows = {}
SendPlayerAvatarLoading = {}
SendPlayerAvatarRequestId = {}

-- Build a player row from scratch using the exact Gift Player row construction.
function SendPlayer_CreateRow(index)
	local Row = Instance.new("Frame", SendPlayer_PlayerList)
	Row.Name = "GiftPlayerRow_" .. tostring(index)
	Row.Size = UDim2.new(1, -10, 0, 112)
	Row.BackgroundColor3 = Color3.fromRGB(33, 9, 67)
	Row.BorderSizePixel = 0
	Row.ClipsDescendants = true
	Row.LayoutOrder = index
	Row.Visible = false
	Row.ZIndex = 860
	Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 12)

	SendPlayer_RowColorBackground = Instance.new("Frame", Row)
	SendPlayer_RowColorBackground.Name = "PlayerRowColorBackground"
	SendPlayer_RowColorBackground.Size = UDim2.new(1, 0, 1, 0)
	SendPlayer_RowColorBackground.Position = UDim2.new(0, 0, 0, 0)
	SendPlayer_RowColorBackground.BackgroundColor3 = Color3.fromRGB(12, 45, 78)
	SendPlayer_RowColorBackground.BackgroundTransparency = 0
	SendPlayer_RowColorBackground.BorderSizePixel = 0
	SendPlayer_RowColorBackground.ZIndex = 861
	SendPlayer_RowColorBackground.Active = false
	Instance.new("UICorner", SendPlayer_RowColorBackground).CornerRadius = UDim.new(0, 12)

	SendPlayer_RowBackgroundGradient = Instance.new("UIGradient", SendPlayer_RowColorBackground)
	SendPlayer_RowBackgroundGradient.Name = "PlayerRowBackground2Color"
	SendPlayer_RowBackgroundGradient.Rotation = 90
	SendPlayer_RowBackgroundGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(12, 45, 78)),
		ColorSequenceKeypoint.new(0.49, Color3.fromRGB(12, 45, 78)),
		ColorSequenceKeypoint.new(0.51, Color3.fromRGB(48, 128, 185)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(48, 128, 185))
	})
	SendPlayer_RowBackgroundGradient.Transparency = NumberSequence.new(0)
SendPlayer_RowEffect = Instance.new("ImageLabel", Row)
SendPlayer_RowEffect.Name = "PlayerRowEffect"
SendPlayer_RowEffect.Size = UDim2.new(1, 0, 1, 0)
SendPlayer_RowEffect.Position = UDim2.new(0, 0, 0, 0)
SendPlayer_RowEffect.BackgroundTransparency = 1
SendPlayer_RowEffect.BorderSizePixel = 0
SendPlayer_RowEffect.Image = "rbxassetid://126841495627073"
SendPlayer_RowEffect.ImageColor3 = Color3.fromRGB(95, 190, 245)
SendPlayer_RowEffect.ImageTransparency = 0.64
SendPlayer_RowEffect.ScaleType = Enum.ScaleType.Stretch
SendPlayer_RowEffect.ZIndex = 862
SendPlayer_RowEffect.Active = false
SendPlayer_RowEffect.Visible = true


	SendPlayer_RowInner = Instance.new("Frame", Row)
	SendPlayer_RowInner.Name = "RowInner"
	SendPlayer_RowInner.Size = UDim2.new(1, -4, 1, -4)
	SendPlayer_RowInner.Position = UDim2.new(0, 2, 0, 2)
	SendPlayer_RowInner.BackgroundTransparency = 1
	SendPlayer_RowInner.BorderSizePixel = 0
	SendPlayer_RowInner.ZIndex = 862
	SendPlayer_RowInner.Active = false
	Instance.new("UICorner", SendPlayer_RowInner).CornerRadius = UDim.new(0, 10)

	SendPlayer_AvatarFrame = Instance.new("Frame", Row)
	SendPlayer_AvatarFrame.Name = "AvatarFrame"
	SendPlayer_AvatarFrame.Size = UDim2.fromOffset(80, 80)
	SendPlayer_AvatarFrame.Position = UDim2.new(0, 15, 0.5, -40)
	SendPlayer_AvatarFrame.BackgroundTransparency = 1
	SendPlayer_AvatarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SendPlayer_AvatarFrame.BorderSizePixel = 0
	SendPlayer_AvatarFrame.ZIndex = 870
	SendPlayer_AvatarFrame.Visible = true
	SendPlayer_AvatarFrame.ClipsDescendants = true
	Instance.new("UIAspectRatioConstraint", SendPlayer_AvatarFrame).AspectRatio = 1
	Instance.new("UICorner", SendPlayer_AvatarFrame).CornerRadius = UDim.new(0, 12)

	-- 100% transparent avatar area for Send Player as well.

	SendPlayer_Avatar = Instance.new("ImageLabel", SendPlayer_AvatarFrame)
	SendPlayer_Avatar.Name = "Avatar"
	SendPlayer_Avatar.Size = UDim2.fromOffset(80, 80)
	SendPlayer_Avatar.Position = UDim2.fromOffset(0, 0)
	SendPlayer_Avatar.BackgroundTransparency = 1
	SendPlayer_Avatar.BorderSizePixel = 0
	SendPlayer_Avatar.ScaleType = Enum.ScaleType.Crop
	SendPlayer_Avatar.BackgroundColor3 = Color3.fromRGB(12, 45, 78)
	SendPlayer_Avatar.Visible = false
	SendPlayer_Avatar.ClipsDescendants = true
	SendPlayer_Avatar.ImageTransparency = 0
	SendPlayer_Avatar.ZIndex = 871
	Instance.new("UICorner", SendPlayer_Avatar).CornerRadius = UDim.new(0, 12)

	SendPlayer_FallbackAvatar = Instance.new("Frame", SendPlayer_AvatarFrame)
	SendPlayer_FallbackAvatar.Name = "FallbackAvatar"
	SendPlayer_FallbackAvatar.Size = UDim2.fromOffset(80, 80)
	SendPlayer_FallbackAvatar.Position = UDim2.fromOffset(0, 0)
	SendPlayer_FallbackAvatar.BorderSizePixel = 0
	SendPlayer_FallbackAvatar.BackgroundTransparency = 1
	SendPlayer_FallbackAvatar.Visible = false
	SendPlayer_FallbackAvatar.ZIndex = 872
	Instance.new("UICorner", SendPlayer_FallbackAvatar).CornerRadius = UDim.new(0, 12)

	SendPlayer_FallbackAvatarText = Instance.new("TextLabel", SendPlayer_FallbackAvatar)
	SendPlayer_FallbackAvatarText.Name = "FallbackAvatarText"
	SendPlayer_FallbackAvatarText.Size = UDim2.fromScale(1, 1)
	SendPlayer_FallbackAvatarText.BackgroundTransparency = 1
	SendPlayer_FallbackAvatarText.Text = ""
	SendPlayer_FallbackAvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
	SendPlayer_FallbackAvatarText.Font = Enum.Font.GothamBlack
	SendPlayer_FallbackAvatarText.TextSize = 23
	SendPlayer_FallbackAvatarText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	SendPlayer_FallbackAvatarText.TextStrokeTransparency = 0.25
	SendPlayer_FallbackAvatarText.TextXAlignment = Enum.TextXAlignment.Center
	SendPlayer_FallbackAvatarText.TextYAlignment = Enum.TextYAlignment.Center
	SendPlayer_FallbackAvatarText.ZIndex = 873

	SendPlayer_NameLabel = Instance.new("TextLabel", Row)
	SendPlayer_NameLabel.Name = "NameLabel"
	SendPlayer_NameLabel.Size = UDim2.new(0, 300, 0, 34)
	SendPlayer_NameLabel.Position = UDim2.new(0, 110, 0, 20)
	SendPlayer_NameLabel.BackgroundTransparency = 1
	SendPlayer_NameLabel.ZIndex = 874
	SendPlayer_NameLabel.Text = ""
	SendPlayer_NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	SendPlayer_NameLabel.Font = Enum.Font.FredokaOne
	SendPlayer_NameLabel.TextSize = 34
	SendPlayer_NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	SendPlayer_NameLabel.TextYAlignment = Enum.TextYAlignment.Center
	SendPlayer_NameLabel.TextScaled = false
	SendPlayer_NameLabel.TextWrapped = false
	SendPlayer_NameStroke = Instance.new("UIStroke", SendPlayer_NameLabel)
	SendPlayer_NameStroke.Color = Color3.fromRGB(0, 0, 0)
	SendPlayer_NameStroke.Thickness = 2

	SendPlayer_UserLabel = Instance.new("TextLabel", Row)
	SendPlayer_UserLabel.Name = "UserLabel"
	SendPlayer_UserLabel.Size = UDim2.new(0, 330, 0, 28)
	SendPlayer_UserLabel.Position = UDim2.new(0, 110, 0, 57)
	SendPlayer_UserLabel.BackgroundTransparency = 1
	SendPlayer_UserLabel.ZIndex = 875
	SendPlayer_UserLabel.Text = ""
	SendPlayer_UserLabel.TextColor3 = Color3.fromRGB(211, 211, 211)
	SendPlayer_UserLabel.Font = Enum.Font.FredokaOne
	SendPlayer_UserLabel.TextSize = 27
	SendPlayer_UserLabel.TextXAlignment = Enum.TextXAlignment.Left
	SendPlayer_UserLabel.TextYAlignment = Enum.TextYAlignment.Center
	SendPlayer_UserLabel.TextScaled = false
	SendPlayer_UserLabel.TextWrapped = false
	SendPlayer_UserStroke = Instance.new("UIStroke", SendPlayer_UserLabel)
	SendPlayer_UserStroke.Color = Color3.fromRGB(0, 0, 0)
	SendPlayer_UserStroke.Thickness = 2

	-- SEND button: visually mirrors Gift Player's Select button exactly.
	-- Same size, corner radius, white outer stroke, pattern texture, text font/size,
	-- black text outline, and hover/pressed colors. The only difference is the label: "Send".
	SendPlayer_SendBtnContainer = Instance.new("Frame", Row)
	SendPlayer_SendBtnContainer.Name = "SendBtnContainer"
	SendPlayer_SendBtnContainer.Size = UDim2.new(0, 174, 0, 70)
	SendPlayer_SendBtnContainer.Position = UDim2.new(1, -190, 0.5, -35)
	SendPlayer_SendBtnContainer.BackgroundTransparency = 1
	SendPlayer_SendBtnContainer.BorderSizePixel = 0
	SendPlayer_SendBtnContainer.ZIndex = 876

	SendPlayer_SendBtn = Instance.new("TextButton", SendPlayer_SendBtnContainer)
	local sendButton = SendPlayer_SendBtn
	SendPlayer_SendBtn.Name = "SendBtn"
	SendPlayer_SendBtn.Size = UDim2.new(1, 0, 1, 0)
	SendPlayer_SendBtn.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
	SendPlayer_SendBtn.BorderSizePixel = 0
	SendPlayer_SendBtn.Text = ""
	SendPlayer_SendBtn.AutoButtonColor = false
	SendPlayer_SendBtn.ZIndex = 877
	SendPlayer_SendBtn.Active = true

	Instance.new("UICorner", SendPlayer_SendBtn).CornerRadius = UDim.new(0, 8)

	SendPlayer_SendWhiteStroke = Instance.new("UIStroke", SendPlayer_SendBtn)
	SendPlayer_SendWhiteStroke.Color = Color3.fromRGB(255, 255, 255)
	SendPlayer_SendWhiteStroke.Thickness = 3

	-- Exact white border overlay used by Gift Player's Select button.
	SendPlayer_SendWhiteBorderOverlay = Instance.new("Frame", SendPlayer_SendBtn)
	SendPlayer_SendWhiteBorderOverlay.Name = "WhiteBorderOverlay"
	SendPlayer_SendWhiteBorderOverlay.Size = UDim2.new(1, 0, 1, 0)
	SendPlayer_SendWhiteBorderOverlay.Position = UDim2.new(0, 0, 0, 0)
	SendPlayer_SendWhiteBorderOverlay.BackgroundTransparency = 1
	SendPlayer_SendWhiteBorderOverlay.BorderSizePixel = 0
	SendPlayer_SendWhiteBorderOverlay.ZIndex = 879

	Instance.new("UICorner", SendPlayer_SendWhiteBorderOverlay).CornerRadius = UDim.new(0, 8)

	SendPlayer_SendVisibleWhiteStroke = Instance.new("UIStroke", SendPlayer_SendWhiteBorderOverlay)
	SendPlayer_SendVisibleWhiteStroke.Color = Color3.fromRGB(255, 255, 255)
	SendPlayer_SendVisibleWhiteStroke.Thickness = 3
	SendPlayer_SendVisibleWhiteStroke.Transparency = 0

	-- Exact Select pattern layer.
	SendPlayer_SendPattern = Instance.new("ImageLabel")
	SendPlayer_SendPattern.Name = "SendPattern"
	SendPlayer_SendPattern.Size = UDim2.new(1, 0, 1, 0)
	SendPlayer_SendPattern.Position = UDim2.new(0, 0, 0, 0)
	SendPlayer_SendPattern.BackgroundTransparency = 1
	SendPlayer_SendPattern.BorderSizePixel = 0
	SendPlayer_SendPattern.Image = "rbxassetid://90325592797235"
	SendPlayer_SendPattern.ScaleType = Enum.ScaleType.Tile
	SendPlayer_SendPattern.TileSize = UDim2.fromOffset(60, 60)
	SendPlayer_SendPattern.ImageTransparency = 0.72
	SendPlayer_SendPattern.ZIndex = 878
	SendPlayer_SendPattern.Active = false
	SendPlayer_SendPattern.Parent = SendPlayer_SendBtn

	-- Exact Select text treatment, with the label changed from Select to Send.
	SendPlayer_SendText = Instance.new("TextLabel", SendPlayer_SendBtn)
	SendPlayer_SendText.Name = "SendText"
	SendPlayer_SendText.Size = UDim2.new(1, 0, 1, 0)
	SendPlayer_SendText.BackgroundTransparency = 1
	SendPlayer_SendText.Text = "Send"
	SendPlayer_SendText.TextColor3 = Color3.fromRGB(255, 255, 255)
	SendPlayer_SendText.Font = Enum.Font.FredokaOne
	SendPlayer_SendText.TextSize = 52
	SendPlayer_SendText.TextXAlignment = Enum.TextXAlignment.Center
	SendPlayer_SendText.TextYAlignment = Enum.TextYAlignment.Center
	SendPlayer_SendText.TextScaled = false
	SendPlayer_SendText.TextWrapped = false
	SendPlayer_SendText.ZIndex = 880
	SendPlayer_SendText.Active = false

	SendPlayer_SendTextStroke = Instance.new("UIStroke", SendPlayer_SendText)
	SendPlayer_SendTextStroke.Color = Color3.fromRGB(0, 0, 0)
	SendPlayer_SendTextStroke.Thickness = 2

	sendButton.MouseEnter:Connect(function()
		sendButton.BackgroundColor3 = Color3.fromRGB(128, 255, 20)
	end)
	sendButton.MouseLeave:Connect(function()
		sendButton.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
	end)
	sendButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			sendButton.BackgroundColor3 = Color3.fromRGB(92, 225, 0)
		end
	end)
	sendButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			sendButton.BackgroundColor3 = Color3.fromRGB(128, 255, 20)
		end
	end)
	-- Open the send-gift compose table for this recipient.
	sendButton.MouseButton1Click:Connect(function()
		if type(ShowSendGiftCompose) == "function" then
			ShowSendGiftCompose(index)
		end
	end)

	SendPlayerRows[index] = {
		Row = Row,
		AvatarFrame = SendPlayer_AvatarFrame,
		Avatar = SendPlayer_Avatar,
		FallbackAvatar = SendPlayer_FallbackAvatar,
		FallbackAvatarText = SendPlayer_FallbackAvatarText,
		NameLabel = SendPlayer_NameLabel,
		UserLabel = SendPlayer_UserLabel,
		SendBtn = SendPlayer_SendBtn,
		SendText = SendPlayer_SendText,
		Username = "",
		UserId = nil
	}
end

for i = 1, 8 do
	SendPlayer_CreateRow(i)
end

function SendPlayer_ApplyTitle()
	if not SendPlayer_TitleText then return end
	SendPlayer_TitleText.Text = "Send Player"
end

function SendPlayer_SetAvatarFromSource(index, source)
	local row = SendPlayerRows[index]
	if not row or not source then return false end

	if source.Avatar and source.Avatar.Image and source.Avatar.Image ~= "" then
		row.Avatar.Image = source.Avatar.Image
		row.Avatar.Visible = source.Avatar.Visible == true
		row.Avatar.ImageTransparency = source.Avatar.ImageTransparency
		row.Avatar.BackgroundTransparency = 1
		row.Avatar.ScaleType = Enum.ScaleType.Crop
		row.Avatar.ImageColor3 = source.Avatar.ImageColor3
		row.FallbackAvatar.Visible = false
		row.FallbackAvatarText.Text = ""
		return true
	end

	if source.FallbackAvatar and source.FallbackAvatar.Visible then
		row.Avatar.Visible = false
		row.FallbackAvatar.Visible = true
		row.FallbackAvatarText.Text = source.FallbackAvatarText and source.FallbackAvatarText.Text or ""
		return true
	end

	if source.RandomRobloxUserId then
		row.UserId = source.RandomRobloxUserId
	end
	return false
end

function SendPlayer_RequestAvatar(index, username)
	local row = SendPlayerRows[index]
	if not row then return end

	local cleanUsername = tostring(username or ""):gsub("^%s+", ""):gsub("%s+$", "")
	SendPlayerAvatarRequestId[index] = (SendPlayerAvatarRequestId[index] or 0) + 1
	local requestId = SendPlayerAvatarRequestId[index]
	row.Avatar.Visible = false
	row.FallbackAvatar.Visible = false
	row.FallbackAvatarText.Text = ""
	row.Avatar.Image = ""

	if cleanUsername == "" then
		SendPlayerAvatarLoading[index] = nil
		return
	end

	if SendPlayerAvatarLoading[index] == cleanUsername then
		return
	end
	SendPlayerAvatarLoading[index] = cleanUsername

	task.spawn(function()
		local userId = nil
		local okId, resolvedId = pcall(function()
			return Players:GetUserIdFromNameAsync(cleanUsername)
		end)
		if okId and resolvedId then
			userId = resolvedId
		end

		if SendPlayerAvatarRequestId[index] ~= requestId then
			if SendPlayerAvatarLoading[index] == cleanUsername then
				SendPlayerAvatarLoading[index] = nil
			end
			return
		end

		if userId then
			row.UserId = userId
			local cached = AvatarCache[userId]
			if cached and cached ~= "" then
				row.Avatar.Image = cached
				row.Avatar.Visible = true
				row.FallbackAvatar.Visible = false
				if SendPlayerAvatarLoading[index] == cleanUsername then
					SendPlayerAvatarLoading[index] = nil
				end
				return
			end

			local thumbOk, avatarImage = pcall(function()
				local image = Players:GetUserThumbnailAsync(
					userId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size150x150
				)
				return image
			end)

			if thumbOk
				and type(avatarImage) == "string"
				and avatarImage ~= ""
				and avatarImage ~= "rbxasset://textures/ui/GuiImagePlaceholder.png" then
				AvatarCache[userId] = avatarImage
				if SendPlayerAvatarRequestId[index] == requestId then
					row.Avatar.Image = avatarImage
					row.Avatar.Visible = true
					row.FallbackAvatar.Visible = false
				end
			end
		end

		if SendPlayerAvatarLoading[index] == cleanUsername then
			SendPlayerAvatarLoading[index] = nil
		end
	end)
end

function SendPlayer_RefreshRows()
	if not SendPlayer_PlayerList then return end
	SendPlayer_PlayerList.Visible = true
	SendPlayer_PlayerList.ZIndex = 860
	if SendPlayer_TiledBackground then
		SendPlayer_TiledBackground.ZIndex = 851
	end

	for index = 1, 8 do
		local row = SendPlayerRows[index]
		if row then
			local source = RowUIList and RowUIList[index] or nil
			local configuredUsername = tostring((Settings.RealUsernames and Settings.RealUsernames[index]) or "")
			configuredUsername = configuredUsername:gsub("^%s+", ""):gsub("%s+$", "")
			local configuredDisplayName = tostring((Settings.FakeUsers and Settings.FakeUsers[index]) or "")
			configuredDisplayName = configuredDisplayName:gsub("^%s+", ""):gsub("%s+$", "")

			if configuredUsername == "" and (not source or not source.Row or not source.Row.Visible) then
				row.Row.Visible = false
				row.NameLabel.Text = ""
				row.UserLabel.Text = ""
				row.Avatar.Visible = false
				row.FallbackAvatar.Visible = false
				row.Avatar.Image = ""
				continue
			end

			row.Row.Visible = true

			-- Use the fully resolved Gift Player display when it exists; this keeps
			-- Fake User + real username + Roblox avatar behavior identical in data,
			-- while the Send row itself remains a brand-new independent UI tree.
			if source and source.Row and source.Row.Visible then
				row.NameLabel.Text = source.NameLabel and source.NameLabel.Text or configuredDisplayName
				row.UserLabel.Text = source.UserLabel and source.UserLabel.Text or (configuredUsername ~= "" and ("@" .. configuredUsername) or "")
				row.Username = source.Username or configuredUsername
				row.UserId = source.UserId

				local copiedAvatar = SendPlayer_SetAvatarFromSource(index, source)
				if not copiedAvatar then
					SendPlayer_RequestAvatar(index, configuredUsername)
				end
			else
				row.NameLabel.Text = configuredDisplayName ~= "" and configuredDisplayName or configuredUsername
				row.UserLabel.Text = configuredUsername ~= "" and ("@" .. configuredUsername) or ""
				row.Username = configuredUsername
				row.UserId = nil
				if not SendPlayer_SetAvatarFromSource(index, source) then
					SendPlayer_RequestAvatar(index, configuredUsername)
				end
			end
		end
	end
end

SendPlayer_CloseBtn.MouseButton1Click:Connect(function()
	SendPlayerPrompt.Visible = false
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
end)
SendPlayer_CloseBtn.Activated:Connect(function()
	SendPlayerPrompt.Visible = false
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
end)

-- Build all 8 Send Player rows immediately; opening the panel later only refreshes data.
SendPlayer_RefreshRows()

-- ==========================================
-- SHOW GIFT PROMPT
-- ==========================================

ShowFakeGiftPrompt = function()
	ActiveGiftSource = "Shop"
	GiftPlayer_RefreshRows()
	SendPlayerPrompt.Visible = false
	if SendGiftComposePrompt then SendGiftComposePrompt.Visible = false end
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
-- SEND GIFT COMPOSE WINDOW
-- Fullscreen Send Player compose UI based on the supplied reference image.
-- Opens after pressing a player-row SEND button.
-- Inventory contains ONLY virtual pets created by SpawnPet.
-- ==========================================
SendGiftComposePrompt = Instance.new("Frame", ScreenGui)
SendGiftComposePrompt.Name = "SendGiftComposePrompt"
SendGiftComposePrompt.Size = UDim2.new(0, 1240, 0, 780)
SendGiftComposePrompt.Position = UDim2.new(0.5, 0, 0.5, 0)
SendGiftComposePrompt.AnchorPoint = Vector2.new(0.5, 0.5)
SendGiftComposePrompt.BackgroundColor3 = Color3.fromRGB(10, 48, 82)
SendGiftComposePrompt.BorderSizePixel = 0
SendGiftComposePrompt.Visible = false
SendGiftComposePrompt.ClipsDescendants = true
SendGiftComposePrompt.ZIndex = 1100
Instance.new("UICorner", SendGiftComposePrompt).CornerRadius = UDim.new(0, 18)
SendGiftComposePromptStroke = Instance.new("UIStroke", SendGiftComposePrompt)
SendGiftComposePromptStroke.Color = Color3.fromRGB(2, 9, 18)
SendGiftComposePromptStroke.Thickness = 4

-- Unified full-panel effect shared by all Send Player surfaces.
SendGiftComposeFullBackgroundEffect = Instance.new("ImageLabel", SendGiftComposePrompt)
SendGiftComposeFullBackgroundEffect.Name = "SendGiftComposeFullBackgroundEffect"
SendGiftComposeFullBackgroundEffect.Size = UDim2.new(1, 0, 1, 0)
SendGiftComposeFullBackgroundEffect.Position = UDim2.fromOffset(0, 0)
SendGiftComposeFullBackgroundEffect.BackgroundTransparency = 1
SendGiftComposeFullBackgroundEffect.BorderSizePixel = 0
SendGiftComposeFullBackgroundEffect.Image = "rbxassetid://131176354845909"
SendGiftComposeFullBackgroundEffect.ImageColor3 = Color3.fromRGB(75, 155, 205)
SendGiftComposeFullBackgroundEffect.ImageTransparency = 0.45
SendGiftComposeFullBackgroundEffect.ScaleType = Enum.ScaleType.Tile
SendGiftComposeFullBackgroundEffect.TileSize = UDim2.fromOffset(60, 60)
SendGiftComposeFullBackgroundEffect.ZIndex = 1100
SendGiftComposeFullBackgroundEffect.Active = false
SendGiftComposeFullBackgroundEffect.Visible = true

-- Header
SendGiftComposeHeaderBorder = Instance.new("Frame", SendGiftComposePrompt)
SendGiftComposeHeaderBorder.Name = "SendGiftComposeHeaderBorder"
SendGiftComposeHeaderBorder.Size = UDim2.new(1, 0, 0, 90)
SendGiftComposeHeaderBorder.Position = UDim2.fromOffset(0, 0)
SendGiftComposeHeaderBorder.BackgroundColor3 = Color3.fromRGB(70, 170, 235)
SendGiftComposeHeaderBorder.BorderSizePixel = 0
SendGiftComposeHeaderBorder.ZIndex = 1101
-- Send Player 2 title bar uses the same rounded corner radius as the panel background.
local SendGiftComposeHeaderBorderCorner = Instance.new("UICorner", SendGiftComposeHeaderBorder)
SendGiftComposeHeaderBorderCorner.CornerRadius = UDim.new(0, 18)

SendGiftComposeHeaderBorderGradient = Instance.new("UIGradient", SendGiftComposeHeaderBorder)
SendGiftComposeHeaderBorderGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 220, 255)),
	ColorSequenceKeypoint.new(0.10, Color3.fromRGB(145, 230, 255)),
	ColorSequenceKeypoint.new(0.22, Color3.fromRGB(80, 190, 245)),
	ColorSequenceKeypoint.new(0.38, Color3.fromRGB(28, 125, 205)),
	ColorSequenceKeypoint.new(0.56, Color3.fromRGB(115, 215, 255)),
	ColorSequenceKeypoint.new(0.72, Color3.fromRGB(70, 175, 235)),
	ColorSequenceKeypoint.new(0.86, Color3.fromRGB(45, 145, 220)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 95, 170))
})

SendGiftComposeHeader = Instance.new("Frame", SendGiftComposePrompt)
SendGiftComposeHeader.Name = "Header"
SendGiftComposeHeader.Size = UDim2.new(1, -4, 0, 86)
SendGiftComposeHeader.Position = UDim2.fromOffset(2, 2)
SendGiftComposeHeader.BackgroundColor3 = Color3.fromRGB(70, 175, 240)
SendGiftComposeHeader.BorderSizePixel = 0
SendGiftComposeHeader.ZIndex = 1102
SendGiftComposeHeader.ClipsDescendants = true
local SendGiftComposeHeaderCorner = Instance.new("UICorner", SendGiftComposeHeader)
SendGiftComposeHeaderCorner.CornerRadius = UDim.new(0, 18)

SendGiftComposeHeaderGradient = Instance.new("UIGradient", SendGiftComposeHeader)
SendGiftComposeHeaderGradient.Rotation = 0
SendGiftComposeHeaderGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 220, 255)),
	ColorSequenceKeypoint.new(0.16, Color3.fromRGB(48, 145, 220)),
	ColorSequenceKeypoint.new(0.34, Color3.fromRGB(35, 125, 205)),
	ColorSequenceKeypoint.new(0.50, Color3.fromRGB(155, 235, 255)),
	ColorSequenceKeypoint.new(0.63, Color3.fromRGB(105, 210, 250)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(40, 145, 225)),
	ColorSequenceKeypoint.new(0.90, Color3.fromRGB(30, 115, 195)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(12, 70, 145))
})

-- Same diagonal light-streak effect used by the existing Send Player header.
SendGiftComposeHeaderGlow = Instance.new("ImageLabel", SendGiftComposeHeader)
SendGiftComposeHeaderGlow.Name = "SendPlayerHeaderGlow"
SendGiftComposeHeaderGlow.Size = UDim2.new(0, 778, 1, 0)
SendGiftComposeHeaderGlow.Position = UDim2.new(0, 393, 0, 0)
SendGiftComposeHeaderGlow.BackgroundTransparency = 1
SendGiftComposeHeaderGlow.BorderSizePixel = 0
SendGiftComposeHeaderGlow.Image = "rbxassetid://98981360538955"
SendGiftComposeHeaderGlow.ImageColor3 = Color3.fromRGB(145, 225, 255)
SendGiftComposeHeaderGlow.ImageTransparency = 0.10
SendGiftComposeHeaderGlow.ScaleType = Enum.ScaleType.Stretch
SendGiftComposeHeaderGlow.ResampleMode = Enum.ResamplerMode.Default
SendGiftComposeHeaderGlow.ZIndex = 1104
SendGiftComposeHeaderGlow.Visible = true
SendGiftComposeHeaderGlow.Active = false
pcall(function()
	ContentProvider:PreloadAsync({SendGiftComposeHeaderGlow})
end)

SendGiftComposeHeaderPattern = Instance.new("ImageLabel", SendGiftComposeHeader)
SendGiftComposeHeaderPattern.Name = "SendPlayerHeaderPattern"
SendGiftComposeHeaderPattern.Size = UDim2.new(1, 0, 1, -4)
SendGiftComposeHeaderPattern.Position = UDim2.fromOffset(0, 0)
SendGiftComposeHeaderPattern.BackgroundTransparency = 1
SendGiftComposeHeaderPattern.BorderSizePixel = 0
SendGiftComposeHeaderPattern.Image = "rbxassetid://90325592797235"
SendGiftComposeHeaderPattern.ScaleType = Enum.ScaleType.Tile
SendGiftComposeHeaderPattern.TileSize = UDim2.fromOffset(60, 60)
SendGiftComposeHeaderPattern.ImageColor3 = Color3.fromRGB(120, 210, 255)
SendGiftComposeHeaderPattern.ImageTransparency = 0.72
SendGiftComposeHeaderPattern.ZIndex = 1103
SendGiftComposeHeaderPattern.Active = false
SendGiftComposeHeaderCenterEffect = Instance.new("ImageLabel", SendGiftComposeHeader)
SendGiftComposeHeaderCenterEffect.Name = "SendGiftComposeHeaderCenterEffect"
SendGiftComposeHeaderCenterEffect.Size = UDim2.new(1, 0, 1, 0)
SendGiftComposeHeaderCenterEffect.Position = UDim2.fromOffset(0, 0)
SendGiftComposeHeaderCenterEffect.BackgroundTransparency = 1
SendGiftComposeHeaderCenterEffect.BorderSizePixel = 0
SendGiftComposeHeaderCenterEffect.Image = "rbxassetid://126841495627073"
SendGiftComposeHeaderCenterEffect.ImageColor3 = Color3.fromRGB(95, 190, 245)
SendGiftComposeHeaderCenterEffect.ImageTransparency = 0.48
SendGiftComposeHeaderCenterEffect.ScaleType = Enum.ScaleType.Stretch
SendGiftComposeHeaderCenterEffect.ZIndex = 1105
SendGiftComposeHeaderCenterEffect.Active = false
SendGiftComposeHeaderCenterEffect.Visible = true

SendGiftComposeGiftIcon = Instance.new("ImageLabel", SendGiftComposeHeader)
SendGiftComposeGiftIcon.Name = "SendGiftComposeGiftIcon"
SendGiftComposeGiftIcon.Size = UDim2.fromOffset(58, 66)
SendGiftComposeGiftIcon.Position = UDim2.new(0, 14, 0.5, -33)
SendGiftComposeGiftIcon.BackgroundTransparency = 1
SendGiftComposeGiftIcon.BorderSizePixel = 0
SendGiftComposeGiftIcon.Image = "rbxassetid://79657591184601"
SendGiftComposeGiftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeGiftIcon.ScaleType = Enum.ScaleType.Fit
SendGiftComposeGiftIcon.ImageTransparency = 0
SendGiftComposeGiftIcon.ZIndex = 1108
SendGiftComposeGiftIcon.Active = false

SendGiftComposeHeaderTitle = Instance.new("TextLabel", SendGiftComposeHeader)
SendGiftComposeHeaderTitle.Size = UDim2.new(0, 440, 1, 0)
SendGiftComposeHeaderTitle.Position = UDim2.fromOffset(86, 0)
SendGiftComposeHeaderTitle.BackgroundTransparency = 1
SendGiftComposeHeaderTitle.Text = "Send Player"
SendGiftComposeHeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeHeaderTitle.Font = Enum.Font.FredokaOne
SendGiftComposeHeaderTitle.TextSize = 54
SendGiftComposeHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeHeaderTitle.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeHeaderTitle.TextScaled = false
SendGiftComposeHeaderTitle.TextWrapped = false
SendGiftComposeHeaderTitle.ZIndex = 1107
SendGiftComposeHeaderTitleStroke = Instance.new("UIStroke", SendGiftComposeHeaderTitle)
SendGiftComposeHeaderTitleStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeHeaderTitleStroke.Thickness = 4.5

SendGiftComposeHeaderClose = Instance.new("TextButton", SendGiftComposeHeader)
SendGiftComposeHeaderClose.Size = UDim2.fromOffset(56, 56)
SendGiftComposeHeaderClose.Position = UDim2.new(1, -10, 0.5, 0)
SendGiftComposeHeaderClose.AnchorPoint = Vector2.new(1, 0.5)
SendGiftComposeHeaderClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SendGiftComposeHeaderClose.BorderSizePixel = 0
SendGiftComposeHeaderClose.Text = "X"
SendGiftComposeHeaderClose.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeHeaderClose.Font = Enum.Font.FredokaOne
SendGiftComposeHeaderClose.TextSize = 36
SendGiftComposeHeaderClose.AutoButtonColor = false
SendGiftComposeHeaderClose.ZIndex = 1109
SendGiftComposeHeaderCloseStroke = Instance.new("UIStroke", SendGiftComposeHeaderClose)
SendGiftComposeHeaderCloseStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeHeaderCloseStroke.Thickness = 3
SendGiftComposeHeaderClose.Visible = true
SendGiftComposeHeaderClose.Active = true
SendGiftComposeHeaderClose.MouseEnter:Connect(function() SendGiftComposeHeaderClose.BackgroundColor3 = Color3.fromRGB(220, 0, 0) end)
SendGiftComposeHeaderClose.MouseLeave:Connect(function() SendGiftComposeHeaderClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0) end)

-- Left: Your Inventory
SendGiftComposeInventoryPanel = Instance.new("Frame", SendGiftComposePrompt)
SendGiftComposeInventoryPanel.Name = "YourInventory"
SendGiftComposeInventoryPanel.Size = UDim2.new(0, 476, 0, 562)
SendGiftComposeInventoryPanel.Position = UDim2.fromOffset(28, 118)
SendGiftComposeInventoryPanel.BackgroundColor3 = Color3.fromRGB(10, 33, 55)
SendGiftComposeInventoryPanel.BackgroundTransparency = 0.06
SendGiftComposeInventoryPanel.BorderSizePixel = 0
SendGiftComposeInventoryPanel.ZIndex = 1101
SendGiftComposeInventoryPanel.ClipsDescendants = true
SendGiftComposeBodyCenterEffect = Instance.new("ImageLabel", SendGiftComposePrompt)
SendGiftComposeBodyCenterEffect.Name = "SendGiftComposeBodyCenterEffect"
SendGiftComposeBodyCenterEffect.Size = UDim2.new(1, -24, 1, -115)
SendGiftComposeBodyCenterEffect.Position = UDim2.new(0, 12, 0, 100)
SendGiftComposeBodyCenterEffect.BackgroundTransparency = 1
SendGiftComposeBodyCenterEffect.BorderSizePixel = 0
SendGiftComposeBodyCenterEffect.Image = "rbxassetid://126841495627073"
SendGiftComposeBodyCenterEffect.ImageColor3 = Color3.fromRGB(95, 190, 245)
SendGiftComposeBodyCenterEffect.ImageTransparency = 0.48
SendGiftComposeBodyCenterEffect.ScaleType = Enum.ScaleType.Stretch
SendGiftComposeBodyCenterEffect.ZIndex = 1100
SendGiftComposeBodyCenterEffect.Active = false
SendGiftComposeBodyCenterEffect.Visible = true

Instance.new("UICorner", SendGiftComposeInventoryPanel).CornerRadius = UDim.new(0, 14)
SendGiftComposeInventoryStroke = Instance.new("UIStroke", SendGiftComposeInventoryPanel)
SendGiftComposeInventoryStroke.Color = Color3.fromRGB(47, 76, 106)
SendGiftComposeInventoryStroke.Thickness = 2

SendGiftComposeInventoryGradient = Instance.new("UIGradient", SendGiftComposeInventoryPanel)
SendGiftComposeInventoryGradient.Rotation = 90
SendGiftComposeInventoryGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 45, 78)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 26, 45))
})

SendGiftComposeInventoryTitle = Instance.new("TextLabel", SendGiftComposeInventoryPanel)
SendGiftComposeInventoryTitle.Size = UDim2.new(1, -28, 0, 36)
SendGiftComposeInventoryTitle.Position = UDim2.fromOffset(14, 9)
SendGiftComposeInventoryTitle.BackgroundTransparency = 1
SendGiftComposeInventoryTitle.Text = "Your Inventory"
SendGiftComposeInventoryTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeInventoryTitle.Font = Enum.Font.FredokaOne
SendGiftComposeInventoryTitle.TextSize = 30
SendGiftComposeInventoryTitle.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeInventoryTitle.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeInventoryTitle.ZIndex = 1104
SendGiftComposeInventoryTitleStroke = Instance.new("UIStroke", SendGiftComposeInventoryTitle)
SendGiftComposeInventoryTitleStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeInventoryTitleStroke.Thickness = 2

SendGiftComposeInventorySearchFrame = Instance.new("Frame", SendGiftComposeInventoryPanel)
SendGiftComposeInventorySearchFrame.Name = "SearchBar"
SendGiftComposeInventorySearchFrame.Size = UDim2.new(1, -28, 0, 46)
SendGiftComposeInventorySearchFrame.Position = UDim2.fromOffset(14, 53)
SendGiftComposeInventorySearchFrame.BackgroundColor3 = Color3.fromRGB(10, 27, 46)
SendGiftComposeInventorySearchFrame.BorderSizePixel = 0
SendGiftComposeInventorySearchFrame.ZIndex = 1103
Instance.new("UICorner", SendGiftComposeInventorySearchFrame).CornerRadius = UDim.new(0, 24)
SendGiftComposeInventorySearchStroke = Instance.new("UIStroke", SendGiftComposeInventorySearchFrame)
SendGiftComposeInventorySearchStroke.Color = Color3.fromRGB(49, 83, 118)
SendGiftComposeInventorySearchStroke.Thickness = 2

SendGiftComposeInventorySearchIcon = Instance.new("TextLabel", SendGiftComposeInventorySearchFrame)
SendGiftComposeInventorySearchIcon.Size = UDim2.fromOffset(36, 36)
SendGiftComposeInventorySearchIcon.Position = UDim2.fromOffset(11, 5)
SendGiftComposeInventorySearchIcon.BackgroundTransparency = 1
SendGiftComposeInventorySearchIcon.Text = "🔍"
SendGiftComposeInventorySearchIcon.TextColor3 = Color3.fromRGB(105, 215, 255)
SendGiftComposeInventorySearchIcon.Font = Enum.Font.GothamBold
SendGiftComposeInventorySearchIcon.TextSize = 20
SendGiftComposeInventorySearchIcon.TextXAlignment = Enum.TextXAlignment.Center
SendGiftComposeInventorySearchIcon.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeInventorySearchIcon.ZIndex = 1105
SendGiftComposeInventorySearchIcon.Active = false

SendGiftComposeInventorySearch = Instance.new("TextBox", SendGiftComposeInventorySearchFrame)
SendGiftComposeInventorySearch.Name = "SearchText"
SendGiftComposeInventorySearch.Size = UDim2.new(1, -56, 1, 0)
SendGiftComposeInventorySearch.Position = UDim2.fromOffset(49, 0)
SendGiftComposeInventorySearch.BackgroundTransparency = 1
SendGiftComposeInventorySearch.BorderSizePixel = 0
SendGiftComposeInventorySearch.PlaceholderText = "Search Chicken, Egg, Fox..."
SendGiftComposeInventorySearch.PlaceholderColor3 = Color3.fromRGB(138, 171, 207)
SendGiftComposeInventorySearch.Text = ""
SendGiftComposeInventorySearch.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeInventorySearch.Font = Enum.Font.FredokaOne
SendGiftComposeInventorySearch.TextSize = 18
SendGiftComposeInventorySearch.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeInventorySearch.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeInventorySearch.ClearTextOnFocus = false
SendGiftComposeInventorySearch.ZIndex = 1104

SendGiftComposeInventoryList = Instance.new("ScrollingFrame", SendGiftComposeInventoryPanel)
SendGiftComposeInventoryList.Name = "SpawnedPets"
SendGiftComposeInventoryList.Size = UDim2.new(1, -28, 1, -126)
SendGiftComposeInventoryList.Position = UDim2.fromOffset(14, 118)
SendGiftComposeInventoryList.BackgroundTransparency = 1
SendGiftComposeInventoryList.BorderSizePixel = 0
SendGiftComposeInventoryList.ScrollBarThickness = 6
SendGiftComposeInventoryList.ScrollBarImageColor3 = Color3.fromRGB(84, 127, 169)
SendGiftComposeInventoryList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SendGiftComposeInventoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
SendGiftComposeInventoryList.ZIndex = 1103
SendGiftComposeInventoryList.Active = true

SendGiftComposeInventoryGrid = Instance.new("UIGridLayout", SendGiftComposeInventoryList)
SendGiftComposeInventoryGrid.CellSize = UDim2.fromOffset(130, 122)
SendGiftComposeInventoryGrid.CellPadding = UDim2.fromOffset(8, 8)
SendGiftComposeInventoryGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
SendGiftComposeInventoryGrid.SortOrder = Enum.SortOrder.LayoutOrder

SendGiftComposeInventoryEmpty = Instance.new("TextLabel", SendGiftComposeInventoryPanel)
SendGiftComposeInventoryEmpty.Size = UDim2.new(1, -39, 0, 55)
SendGiftComposeInventoryEmpty.Position = UDim2.fromOffset(20, 220)
SendGiftComposeInventoryEmpty.BackgroundTransparency = 1
SendGiftComposeInventoryEmpty.Text = "No spawned pets yet"
SendGiftComposeInventoryEmpty.TextColor3 = Color3.fromRGB(164, 194, 226)
SendGiftComposeInventoryEmpty.Font = Enum.Font.FredokaOne
SendGiftComposeInventoryEmpty.TextSize = 20
SendGiftComposeInventoryEmpty.TextXAlignment = Enum.TextXAlignment.Center
SendGiftComposeInventoryEmpty.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeInventoryEmpty.Visible = false
SendGiftComposeInventoryEmpty.ZIndex = 1106

-- Right: Preparing Gift
SendGiftComposePreparingPanel = Instance.new("Frame", SendGiftComposePrompt)
SendGiftComposePreparingPanel.Name = "PreparingGift"
SendGiftComposePreparingPanel.Size = UDim2.fromOffset(642, 567)
SendGiftComposePreparingPanel.Position = UDim2.fromOffset(570, 118)
SendGiftComposePreparingPanel.BackgroundColor3 = Color3.fromRGB(10, 33, 55)
SendGiftComposePreparingPanel.BackgroundTransparency = 0.06
SendGiftComposePreparingPanel.BorderSizePixel = 0
SendGiftComposePreparingPanel.ZIndex = 1101
SendGiftComposePreparingPanel.ClipsDescendants = true
Instance.new("UICorner", SendGiftComposePreparingPanel).CornerRadius = UDim.new(0, 14)
SendGiftComposePreparingStroke = Instance.new("UIStroke", SendGiftComposePreparingPanel)
SendGiftComposePreparingStroke.Color = Color3.fromRGB(47, 76, 106)
SendGiftComposePreparingStroke.Thickness = 2

SendGiftComposePreparingGradient = Instance.new("UIGradient", SendGiftComposePreparingPanel)
SendGiftComposePreparingGradient.Rotation = 90
SendGiftComposePreparingGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 45, 78)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 26, 45))
})

SendGiftComposePreparingTitle = Instance.new("TextLabel", SendGiftComposePreparingPanel)
SendGiftComposePreparingTitle.Size = UDim2.new(1, -33, 0, 38)
SendGiftComposePreparingTitle.Position = UDim2.fromOffset(19, 9)
SendGiftComposePreparingTitle.BackgroundTransparency = 1
SendGiftComposePreparingTitle.Text = "Preparing Gift"
SendGiftComposePreparingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposePreparingTitle.Font = Enum.Font.FredokaOne
SendGiftComposePreparingTitle.TextSize = 30
SendGiftComposePreparingTitle.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposePreparingTitle.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposePreparingTitle.ZIndex = 1104
SendGiftComposePreparingTitleStroke = Instance.new("UIStroke", SendGiftComposePreparingTitle)
SendGiftComposePreparingTitleStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposePreparingTitleStroke.Thickness = 2

-- =========================================================
-- =========================================================
-- SEND ICON TRANSFER INDICATORS
-- Use the exact same icon asset that is used inside the floating SEND button.
-- Each indicator keeps a small dark offset copy underneath to preserve depth.
-- =========================================================
SendGiftComposeTransferArrows = Instance.new("Frame", SendGiftComposePrompt)
SendGiftComposeTransferArrows.Name = "TransferArrows"
SendGiftComposeTransferArrows.Size = UDim2.fromOffset(90, 112)
SendGiftComposeTransferArrows.Position = UDim2.fromOffset(492, 336)
SendGiftComposeTransferArrows.BackgroundTransparency = 1
SendGiftComposeTransferArrows.BorderSizePixel = 0
SendGiftComposeTransferArrows.ZIndex = 1120
SendGiftComposeTransferArrows.Active = false

SendGiftComposeGreenArrow = Instance.new("ImageLabel", SendGiftComposeTransferArrows)
SendGiftComposeGreenArrow.Name = "RightSendIcon"
SendGiftComposeGreenArrow.Size = UDim2.fromOffset(80, 54)
SendGiftComposeGreenArrow.Position = UDim2.fromOffset(3, 0)
SendGiftComposeGreenArrow.BackgroundTransparency = 1
SendGiftComposeGreenArrow.BorderSizePixel = 0
SendGiftComposeGreenArrow.Image = "rbxassetid://79657591184601"
SendGiftComposeGreenArrow.ImageColor3 = Color3.fromRGB(118, 255, 10)
SendGiftComposeGreenArrow.ScaleType = Enum.ScaleType.Fit
SendGiftComposeGreenArrow.ZIndex = 1123
SendGiftComposeGreenArrow.Active = false

SendGiftComposeGreenArrowShadow = Instance.new("ImageLabel", SendGiftComposeTransferArrows)
SendGiftComposeGreenArrowShadow.Name = "RightSendIconShadow"
SendGiftComposeGreenArrowShadow.Size = UDim2.fromOffset(80, 54)
SendGiftComposeGreenArrowShadow.Position = UDim2.fromOffset(7, 4)
SendGiftComposeGreenArrowShadow.BackgroundTransparency = 1
SendGiftComposeGreenArrowShadow.BorderSizePixel = 0
SendGiftComposeGreenArrowShadow.Image = "rbxassetid://79657591184601"
SendGiftComposeGreenArrowShadow.ImageColor3 = Color3.fromRGB(0, 82, 8)
SendGiftComposeGreenArrowShadow.ImageTransparency = 0.15
SendGiftComposeGreenArrowShadow.ScaleType = Enum.ScaleType.Fit
SendGiftComposeGreenArrowShadow.ZIndex = 1121
SendGiftComposeGreenArrowShadow.Active = false

SendGiftComposeOrangeArrow = Instance.new("ImageLabel", SendGiftComposeTransferArrows)
SendGiftComposeOrangeArrow.Name = "LeftSendIcon"
SendGiftComposeOrangeArrow.Size = UDim2.fromOffset(80, 54)
SendGiftComposeOrangeArrow.Position = UDim2.fromOffset(3, 58)
SendGiftComposeOrangeArrow.BackgroundTransparency = 1
SendGiftComposeOrangeArrow.BorderSizePixel = 0
SendGiftComposeOrangeArrow.Image = "rbxassetid://79657591184601"
SendGiftComposeOrangeArrow.ImageColor3 = Color3.fromRGB(255, 170, 58)
SendGiftComposeOrangeArrow.ScaleType = Enum.ScaleType.Fit
SendGiftComposeOrangeArrow.Rotation = 180
SendGiftComposeOrangeArrow.ZIndex = 1123
SendGiftComposeOrangeArrow.Active = false

SendGiftComposeOrangeArrowShadow = Instance.new("ImageLabel", SendGiftComposeTransferArrows)
SendGiftComposeOrangeArrowShadow.Name = "LeftSendIconShadow"
SendGiftComposeOrangeArrowShadow.Size = UDim2.fromOffset(80, 54)
SendGiftComposeOrangeArrowShadow.Position = UDim2.fromOffset(7, 62)
SendGiftComposeOrangeArrowShadow.BackgroundTransparency = 1
SendGiftComposeOrangeArrowShadow.BorderSizePixel = 0
SendGiftComposeOrangeArrowShadow.Image = "rbxassetid://79657591184601"
SendGiftComposeOrangeArrowShadow.ImageColor3 = Color3.fromRGB(132, 62, 0)
SendGiftComposeOrangeArrowShadow.ImageTransparency = 0.15
SendGiftComposeOrangeArrowShadow.ScaleType = Enum.ScaleType.Fit
SendGiftComposeOrangeArrowShadow.Rotation = 180
SendGiftComposeOrangeArrowShadow.ZIndex = 1121
SendGiftComposeOrangeArrowShadow.Active = false

-- Recipient card
SendGiftComposeRecipientCard = Instance.new("Frame", SendGiftComposePreparingPanel)
SendGiftComposeRecipientCard.Size = UDim2.new(1, -41, 0, 94)
SendGiftComposeRecipientCard.Position = UDim2.fromOffset(20, 69)
SendGiftComposeRecipientCard.BackgroundColor3 = Color3.fromRGB(8, 25, 43)
SendGiftComposeRecipientCard.BorderSizePixel = 0
SendGiftComposeRecipientCard.ZIndex = 1102
Instance.new("UICorner", SendGiftComposeRecipientCard).CornerRadius = UDim.new(0, 11)
SendGiftComposeRecipientStroke = Instance.new("UIStroke", SendGiftComposeRecipientCard)
SendGiftComposeRecipientStroke.Color = Color3.fromRGB(50, 82, 118)
SendGiftComposeRecipientStroke.Thickness = 2

-- Local player's avatar / "Your Mail"
SendGiftComposeYourAvatar = Instance.new("ImageLabel", SendGiftComposeRecipientCard)
SendGiftComposeYourAvatar.Name = "YourMailAvatar"
SendGiftComposeYourAvatar.Size = UDim2.fromOffset(64, 64)
SendGiftComposeYourAvatar.Position = UDim2.fromOffset(14, 15)
SendGiftComposeYourAvatar.BackgroundTransparency = 1
SendGiftComposeYourAvatar.BorderSizePixel = 0
SendGiftComposeYourAvatar.ScaleType = Enum.ScaleType.Crop
SendGiftComposeYourAvatar.ImageTransparency = 0
SendGiftComposeYourAvatar.ZIndex = 1105
Instance.new("UICorner", SendGiftComposeYourAvatar).CornerRadius = UDim.new(0, 11)

SendGiftComposeYourAvatarStroke = Instance.new("UIStroke", SendGiftComposeYourAvatar)
SendGiftComposeYourAvatarStroke.Color = Color3.fromRGB(56, 83, 114)
SendGiftComposeYourAvatarStroke.Thickness = 2

SendGiftComposeYourMail = Instance.new("TextLabel", SendGiftComposeRecipientCard)
SendGiftComposeYourMail.Size = UDim2.fromOffset(141, 94)
SendGiftComposeYourMail.Position = UDim2.fromOffset(91, 0)
SendGiftComposeYourMail.BackgroundTransparency = 1
SendGiftComposeYourMail.Text = "Your Mail"
SendGiftComposeYourMail.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeYourMail.Font = Enum.Font.FredokaOne
SendGiftComposeYourMail.TextSize = 24
SendGiftComposeYourMail.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeYourMail.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeYourMail.ZIndex = 1105
SendGiftComposeYourMailStroke = Instance.new("UIStroke", SendGiftComposeYourMail)
SendGiftComposeYourMailStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeYourMailStroke.Thickness = 2

-- Recipient relation label between Your Mail and the selected user.
SendGiftComposeSentTo = Instance.new("TextLabel", SendGiftComposeRecipientCard)
SendGiftComposeSentTo.Name = "SentToLabel"
-- Keep the relation label exactly centered in the free space
-- between the sender text block and the selected-recipient avatar.
SendGiftComposeSentTo.Size = UDim2.fromOffset(100, 40)
SendGiftComposeSentTo.Position = UDim2.new(0, 301, 0.5, -20)
SendGiftComposeSentTo.AnchorPoint = Vector2.new(0.5, 0)
SendGiftComposeSentTo.BackgroundTransparency = 1
SendGiftComposeSentTo.BorderSizePixel = 0
SendGiftComposeSentTo.Text = "Send To"
SendGiftComposeSentTo.TextColor3 = Color3.fromRGB(205, 214, 226)
SendGiftComposeSentTo.Font = Enum.Font.FredokaOne
SendGiftComposeSentTo.TextSize = 22
SendGiftComposeSentTo.TextXAlignment = Enum.TextXAlignment.Center
SendGiftComposeSentTo.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeSentTo.ZIndex = 1107
SendGiftComposeSentTo.Active = false
SendGiftComposeSentToStroke = Instance.new("UIStroke", SendGiftComposeSentTo)
SendGiftComposeSentToStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeSentToStroke.Thickness = 2

-- Selected recipient avatar + display name.
SendGiftComposeRecipientAvatar = Instance.new("ImageLabel", SendGiftComposeRecipientCard)
SendGiftComposeRecipientAvatar.Name = "RecipientAvatar"
SendGiftComposeRecipientAvatar.Size = UDim2.fromOffset(64, 64)
-- Leave a clear 14px gap between the selected avatar and its name.
SendGiftComposeRecipientAvatar.Position = UDim2.new(1, -232, 0.5, -32)
SendGiftComposeRecipientAvatar.BackgroundTransparency = 1
SendGiftComposeRecipientAvatar.BorderSizePixel = 0
SendGiftComposeRecipientAvatar.ScaleType = Enum.ScaleType.Crop
SendGiftComposeRecipientAvatar.ImageTransparency = 0
SendGiftComposeRecipientAvatar.Visible = true
SendGiftComposeRecipientAvatar.ZIndex = 1108
Instance.new("UICorner", SendGiftComposeRecipientAvatar).CornerRadius = UDim.new(0, 11)

SendGiftComposeRecipientAvatarStroke = Instance.new("UIStroke", SendGiftComposeRecipientAvatar)
SendGiftComposeRecipientAvatarStroke.Color = Color3.fromRGB(56, 83, 114)
SendGiftComposeRecipientAvatarStroke.Thickness = 2

SendGiftComposeRecipientName = Instance.new("TextLabel", SendGiftComposeRecipientCard)
SendGiftComposeRecipientName.Name = "RecipientName"
SendGiftComposeRecipientName.Size = UDim2.fromOffset(140, 94)
-- Keep a clear 14px gap from the selected avatar; text stays in its own block.
SendGiftComposeRecipientName.Position = UDim2.new(1, -150, 0, 0)
SendGiftComposeRecipientName.BackgroundTransparency = 1
SendGiftComposeRecipientName.Text = ""
SendGiftComposeRecipientName.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeRecipientName.Font = Enum.Font.FredokaOne
SendGiftComposeRecipientName.TextSize = 21
SendGiftComposeRecipientName.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeRecipientName.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeRecipientName.TextWrapped = false
SendGiftComposeRecipientName.TextTruncate = Enum.TextTruncate.AtEnd
SendGiftComposeRecipientName.ClipsDescendants = true
SendGiftComposeRecipientName.ZIndex = 1108
SendGiftComposeRecipientName.Active = false

SendGiftComposeRecipientNameStroke = Instance.new("UIStroke", SendGiftComposeRecipientName)
SendGiftComposeRecipientNameStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeRecipientNameStroke.Thickness = 2

-- Automatically center "Send To" in the exact gap between the visible end
-- of the sender text ("Your Mail") and the left edge of the recipient avatar.
-- This uses TextBounds, so it follows the real rendered text width instead of
-- assuming that the whole label width is occupied. It also re-centers whenever
-- the text/card/avatar geometry changes.
function SendGiftCompose_CenterSentTo()
	if not SendGiftComposeSentTo
		or not SendGiftComposeYourMail
		or not SendGiftComposeRecipientAvatar
		or not SendGiftComposeRecipientCard then
		return
	end

	local cardPos = SendGiftComposeRecipientCard.AbsolutePosition
	local senderPos = SendGiftComposeYourMail.AbsolutePosition
	local senderBounds = SendGiftComposeYourMail.TextBounds
	local avatarPos = SendGiftComposeRecipientAvatar.AbsolutePosition

	-- The sender label is left-aligned, so TextBounds.X marks the actual
	-- right edge of the rendered "Your Mail" text.
	local senderTextRight = senderPos.X + senderBounds.X
	local recipientAvatarLeft = avatarPos.X
	local gapCenterX = (senderTextRight + recipientAvatarLeft) * 0.5
	local cardCenterY = SendGiftComposeRecipientCard.AbsolutePosition.Y
		+ SendGiftComposeRecipientCard.AbsoluteSize.Y * 0.5

	SendGiftComposeSentTo.AnchorPoint = Vector2.new(0.5, 0.5)
	SendGiftComposeSentTo.Position = UDim2.fromOffset(
		gapCenterX - cardPos.X,
		cardCenterY - cardPos.Y
	)
end

-- Re-center immediately and whenever the measured text/avatar/card geometry changes.
task.defer(SendGiftCompose_CenterSentTo)
SendGiftComposeYourMail:GetPropertyChangedSignal("TextBounds"):Connect(SendGiftCompose_CenterSentTo)
SendGiftComposeYourMail:GetPropertyChangedSignal("AbsolutePosition"):Connect(SendGiftCompose_CenterSentTo)
SendGiftComposeYourMail:GetPropertyChangedSignal("AbsoluteSize"):Connect(SendGiftCompose_CenterSentTo)
SendGiftComposeRecipientAvatar:GetPropertyChangedSignal("AbsolutePosition"):Connect(SendGiftCompose_CenterSentTo)
SendGiftComposeRecipientAvatar:GetPropertyChangedSignal("AbsoluteSize"):Connect(SendGiftCompose_CenterSentTo)
SendGiftComposeRecipientCard:GetPropertyChangedSignal("AbsolutePosition"):Connect(SendGiftCompose_CenterSentTo)
SendGiftComposeRecipientCard:GetPropertyChangedSignal("AbsoluteSize"):Connect(SendGiftCompose_CenterSentTo)

-- Selected pets area: one stable horizontal row so selected pets never wrap/crop.
SendGiftComposeSelectedFrame = Instance.new("ScrollingFrame", SendGiftComposePreparingPanel)
SendGiftComposeSelectedFrame.Name = "SelectedPets"
SendGiftComposeSelectedFrame.Size = UDim2.new(1, -41, 0, 149)
SendGiftComposeSelectedFrame.Position = UDim2.fromOffset(20, 185)
SendGiftComposeSelectedFrame.BackgroundColor3 = Color3.fromRGB(8, 25, 43)
SendGiftComposeSelectedFrame.BackgroundTransparency = 0.08
SendGiftComposeSelectedFrame.BorderSizePixel = 0
SendGiftComposeSelectedFrame.ScrollBarThickness = 6
SendGiftComposeSelectedFrame.ScrollBarImageColor3 = Color3.fromRGB(64, 97, 132)
SendGiftComposeSelectedFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
SendGiftComposeSelectedFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
SendGiftComposeSelectedFrame.ScrollingDirection = Enum.ScrollingDirection.X
SendGiftComposeSelectedFrame.ZIndex = 1102
SendGiftComposeSelectedFrame.ClipsDescendants = true
Instance.new("UICorner", SendGiftComposeSelectedFrame).CornerRadius = UDim.new(0, 11)
SendGiftComposeSelectedStroke = Instance.new("UIStroke", SendGiftComposeSelectedFrame)
SendGiftComposeSelectedStroke.Color = Color3.fromRGB(54, 84, 117)
SendGiftComposeSelectedStroke.Thickness = 2

SendGiftComposeSelectedGrid = Instance.new("UIListLayout", SendGiftComposeSelectedFrame)
SendGiftComposeSelectedGrid.FillDirection = Enum.FillDirection.Horizontal
SendGiftComposeSelectedGrid.HorizontalAlignment = Enum.HorizontalAlignment.Left
SendGiftComposeSelectedGrid.VerticalAlignment = Enum.VerticalAlignment.Center
SendGiftComposeSelectedGrid.Padding = UDim.new(0, 8)
SendGiftComposeSelectedGrid.SortOrder = Enum.SortOrder.LayoutOrder

SendGiftComposeSelectedPadding = Instance.new("UIPadding", SendGiftComposeSelectedFrame)
SendGiftComposeSelectedPadding.PaddingLeft = UDim.new(0, 8)
SendGiftComposeSelectedPadding.PaddingRight = UDim.new(0, 8)
SendGiftComposeSelectedPadding.PaddingTop = UDim.new(0, 6)
SendGiftComposeSelectedPadding.PaddingBottom = UDim.new(0, 6)

SendGiftComposeSelectedEmpty = Instance.new("TextLabel", SendGiftComposeSelectedFrame)
SendGiftComposeSelectedEmpty.Size = UDim2.new(1, -20, 1, 0)
SendGiftComposeSelectedEmpty.Position = UDim2.fromOffset(10, 0)
SendGiftComposeSelectedEmpty.BackgroundTransparency = 1
SendGiftComposeSelectedEmpty.Text = ""
SendGiftComposeSelectedEmpty.TextColor3 = Color3.fromRGB(130, 150, 175)
SendGiftComposeSelectedEmpty.Font = Enum.Font.FredokaOne
SendGiftComposeSelectedEmpty.TextSize = 17
SendGiftComposeSelectedEmpty.TextXAlignment = Enum.TextXAlignment.Center
SendGiftComposeSelectedEmpty.TextYAlignment = Enum.TextYAlignment.Center
SendGiftComposeSelectedEmpty.ZIndex = 1103

-- Recipient note
SendGiftComposeNoteTitle = Instance.new("TextLabel", SendGiftComposePreparingPanel)
SendGiftComposeNoteTitle.Size = UDim2.new(1, -41, 0, 30)
SendGiftComposeNoteTitle.Position = UDim2.fromOffset(20, 344)
SendGiftComposeNoteTitle.BackgroundTransparency = 1
SendGiftComposeNoteTitle.Text = "Recipient"
SendGiftComposeNoteTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeNoteTitle.Font = Enum.Font.FredokaOne
SendGiftComposeNoteTitle.TextSize = 27
SendGiftComposeNoteTitle.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeNoteTitle.ZIndex = 1104
SendGiftComposeNoteTitleStroke = Instance.new("UIStroke", SendGiftComposeNoteTitle)
SendGiftComposeNoteTitleStroke.Color = Color3.fromRGB(0, 0, 0)
SendGiftComposeNoteTitleStroke.Thickness = 2

SendGiftComposeNoteBox = Instance.new("TextBox", SendGiftComposePreparingPanel)
SendGiftComposeNoteBox.Size = UDim2.new(1, -41, 0, 157)
SendGiftComposeNoteBox.Position = UDim2.fromOffset(20, 379)
SendGiftComposeNoteBox.BackgroundColor3 = Color3.fromRGB(8, 25, 43)
SendGiftComposeNoteBox.BorderSizePixel = 0
SendGiftComposeNoteBox.PlaceholderText = "Note\n(Type your gift message here...)"
SendGiftComposeNoteBox.PlaceholderColor3 = Color3.fromRGB(137, 165, 198)
SendGiftComposeNoteBox.Text = ""
SendGiftComposeNoteBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SendGiftComposeNoteBox.Font = Enum.Font.FredokaOne
SendGiftComposeNoteBox.TextSize = 18
SendGiftComposeNoteBox.TextWrapped = true
SendGiftComposeNoteBox.TextXAlignment = Enum.TextXAlignment.Left
SendGiftComposeNoteBox.TextYAlignment = Enum.TextYAlignment.Top
SendGiftComposeNoteBox.ClearTextOnFocus = false
SendGiftComposeNoteBox.ZIndex = 1104
Instance.new("UICorner", SendGiftComposeNoteBox).CornerRadius = UDim.new(0, 11)
SendGiftComposeNoteStroke = Instance.new("UIStroke", SendGiftComposeNoteBox)
SendGiftComposeNoteStroke.Color = Color3.fromRGB(52, 84, 117)
SendGiftComposeNoteStroke.Thickness = 2

-- Bottom buttons: exact Gift Player Select-button visual construction.
-- Same size, corner radius, double white border, pattern texture and text size.
function SendGiftCompose_BuildGiftStyleButton(parent, name, label, x, y, baseColor, hoverColor, pressColor)
	local container = Instance.new("Frame", parent)
	container.Name = name .. "Container"
	container.Size = UDim2.fromOffset(164, 66)
	container.Position = UDim2.fromOffset(x, y)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ZIndex = 1105

	local button = Instance.new("TextButton", container)
	button.Name = name
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundColor3 = baseColor
	button.BorderSizePixel = 0
	button.Text = ""
	button.AutoButtonColor = false
	button.ZIndex = 1106
	button.Active = true
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

	local outerStroke = Instance.new("UIStroke", button)
	outerStroke.Color = Color3.fromRGB(255, 255, 255)
	outerStroke.Thickness = 3

	local overlay = Instance.new("Frame", button)
	overlay.Name = "WhiteBorderOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.Position = UDim2.fromOffset(0, 0)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.ZIndex = 1108
	Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 8)

	local overlayStroke = Instance.new("UIStroke", overlay)
	overlayStroke.Color = Color3.fromRGB(255, 255, 255)
	overlayStroke.Thickness = 3

	local pattern = Instance.new("ImageLabel", button)
	pattern.Name = "ButtonPattern"
	pattern.Size = UDim2.new(1, 0, 1, 0)
	pattern.Position = UDim2.fromOffset(0, 0)
	pattern.BackgroundTransparency = 1
	pattern.BorderSizePixel = 0
	pattern.Image = "rbxassetid://90325592797235"
	pattern.ImageColor3 = Color3.fromRGB(255, 255, 255)
	pattern.ImageTransparency = 0.72
	pattern.ScaleType = Enum.ScaleType.Tile
	pattern.TileSize = UDim2.fromOffset(60, 60)
	pattern.ZIndex = 1107
	pattern.Active = false

	local textLabel = Instance.new("TextLabel", button)
	textLabel.Name = "ButtonText"
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.fromOffset(0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = label
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.FredokaOne
	textLabel.TextSize = 50
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.TextScaled = false
	textLabel.TextWrapped = false
	textLabel.ZIndex = 1109
	textLabel.Active = false

	local textStroke = Instance.new("UIStroke", textLabel)
	textStroke.Color = Color3.fromRGB(0, 0, 0)
	textStroke.Thickness = 2

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = hoverColor
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = baseColor
	end)
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			button.BackgroundColor3 = pressColor
		end
	end)
	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			button.BackgroundColor3 = hoverColor
		end
	end)

	return button, textLabel, container
end

SendGiftComposeCancel, SendGiftComposeCancelText, SendGiftComposeCancelContainer =
	SendGiftCompose_BuildGiftStyleButton(
		SendGiftComposePrompt,
		"CancelButton",
		"Cancel",
		825, 700,
		Color3.fromRGB(250, 24, 24),
		Color3.fromRGB(255, 55, 55),
		Color3.fromRGB(220, 10, 10)
	)

SendGiftComposeSend, SendGiftComposeSendText, SendGiftComposeSendContainer =
	SendGiftCompose_BuildGiftStyleButton(
		SendGiftComposePrompt,
		"SendButton",
		"Send",
		1008, 700,
		Color3.fromRGB(118, 255, 10),
		Color3.fromRGB(128, 255, 20),
		Color3.fromRGB(92, 225, 0)
	)

SendGiftCompose_SelectedTools = {}
SendGiftCompose_RecipientIndex = nil
SendGiftCompose_InventoryToken = 0
SendGiftCompose_OwnAvatarToken = 0

function SendGiftCompose_ClearSelectedCards()
	if not SendGiftComposeSelectedFrame then return end
	for _, child in ipairs(SendGiftComposeSelectedFrame:GetChildren()) do
		if child:IsA("GuiButton") or child.Name == "SelectedPetCard" or child.Name == "PetViewport" then
			child:Destroy()
		end
	end
	SendGiftComposeSelectedEmpty.Visible = #SendGiftCompose_SelectedTools == 0
end

function SendGiftCompose_BuildViewport(parent, tool, name, size)
	local heldModel = tool and tool:FindFirstChild("HeldModel")
	if not heldModel or not heldModel:IsA("Model") then return false end

	local viewport = Instance.new("ViewportFrame", parent)
	viewport.Name = name or "PetViewport"
	viewport.Size = size or UDim2.fromOffset(110, 93)
	viewport.AnchorPoint = Vector2.new(0.5, 0)
	viewport.Position = UDim2.new(0.5, 0, 0, 8)
	viewport.BackgroundTransparency = 1
	viewport.BorderSizePixel = 0
	viewport.ZIndex = 1106
	viewport.Ambient = Color3.fromRGB(180, 190, 205)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-1, -1, -1)

	local world = Instance.new("WorldModel", viewport)
	local clone = heldModel:Clone()
	clone.Parent = world

	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Anchored = true
			obj.CanCollide = false
			obj.CanTouch = false
			obj.CanQuery = false
		end
	end

	local camera = Instance.new("Camera", viewport)
	camera.Parent = viewport
	viewport.CurrentCamera = camera

	local cf, bounds = clone:GetBoundingBox()
	local extent = math.max(bounds.X, bounds.Y, bounds.Z, 1)
	camera.CFrame = CFrame.new(
		cf.Position + Vector3.new(0, extent * 0.08, extent * 1.9),
		cf.Position + Vector3.new(0, extent * 0.05, 0)
	)
	return true
end

function SendGiftCompose_GetPetName(tool)
	return tostring(tool and (tool:GetAttribute("PetName") or tool.Name) or "Spawned Pet")
end
function SendGiftCompose_GetPetRate(tool)
	if not tool then return "" end
	local value = ""
	pcall(function() value = tostring(tool:GetAttribute("PetBPS") or "") end)
	if value == "" then
		pcall(function() value = tostring(tool:GetAttribute("PetPerSecond") or "") end)
	end
	value = tostring(SpawnPet_Normalize(value))
	if value == "" or value == "0" then return "" end
	if not string.find(string.lower(value), "/s", 1, true) then
		value = value .. "/s"
	end
	if string.sub(value, 1, 1) ~= "$" then
		value = "$" .. value
	end
	return value
end

function SendGiftCompose_AddPetRateRow(card, y, z)
	local rate = Instance.new("Frame", card)
	rate.Name = "PetRateContainer"
	rate.Size = UDim2.new(1, -10, 0, 20)
	rate.Position = UDim2.fromOffset(5, y)
	rate.BackgroundTransparency = 1
	rate.BorderSizePixel = 0
	rate.ZIndex = z or 1110
	rate.ClipsDescendants = true

	local content = Instance.new("Frame", rate)
	content.Name = "RateContent"
	content.AutomaticSize = Enum.AutomaticSize.X
	content.Size = UDim2.fromOffset(0, 20)
	content.Position = UDim2.new(0.5, 0, 0.5, 0)
	content.AnchorPoint = Vector2.new(0.5, 0.5)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ZIndex = (z or 1110) + 1

	local layout = Instance.new("UIListLayout", content)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 2)

	local money = Instance.new("ImageLabel", content)
	money.Name = "MoneyIcon"
	money.Size = UDim2.fromOffset(18, 18)
	money.BackgroundTransparency = 1
	money.BorderSizePixel = 0
	money.Image = "rbxassetid://110828258588470"
	money.ScaleType = Enum.ScaleType.Fit
	money.Visible = true
	money.LayoutOrder = 1
	money.ZIndex = (z or 1110) + 2

	local text = Instance.new("TextLabel", content)
	text.Name = "PetRate"
	text.AutomaticSize = Enum.AutomaticSize.X
	text.Size = UDim2.new(0, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = SendGiftCompose_GetPetRate(card:FindFirstChild("PetToolRef") and card.PetToolRef.Value or nil)
	text.TextColor3 = Color3.fromRGB(118, 255, 10)
	text.Font = Enum.Font.GothamBold
	text.TextSize = 17
	text.TextScaled = false
	text.TextWrapped = false
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.TextYAlignment = Enum.TextYAlignment.Center
	text.TextTruncate = Enum.TextTruncate.AtEnd
	text.LayoutOrder = 2
	text.ZIndex = (z or 1110) + 2
	local constraint = Instance.new("UITextSizeConstraint", text)
	constraint.MinTextSize = 12
	constraint.MaxTextSize = 17
	local stroke = Instance.new("UIStroke", text)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.5

	return rate
end

function SendGiftCompose_IsSelected(tool)
	for _, selected in ipairs(SendGiftCompose_SelectedTools) do
		if selected == tool then return true end
	end
	return false
end

function SendGiftCompose_SelectedCellSize(count)
	return 130, 122
end

function SendGiftCompose_RefreshSelectedPets()
	if not SendGiftComposeSelectedGrid or not SendGiftComposeSelectedFrame then return end

	for _, child in ipairs(SendGiftComposeSelectedFrame:GetChildren()) do
		if child:IsA("GuiButton") or child.Name == "SelectedPetCard" or child.Name == "PetViewport" then
			child:Destroy()
		end
	end

	local count = #SendGiftCompose_SelectedTools
	local cellW, cellH = SendGiftCompose_SelectedCellSize(count)
	SendGiftComposeSelectedEmpty.Visible = count == 0

	for order, tool in ipairs(SendGiftCompose_SelectedTools) do
		if tool and tool.Parent then
			local card = Instance.new("TextButton", SendGiftComposeSelectedFrame)
			card.Name = "SelectedPetCard"
			card.Size = UDim2.fromOffset(cellW, cellH)
			card.BackgroundColor3 = Color3.fromRGB(15, 31, 52)
			card.BackgroundTransparency = 0.03
			card.BorderSizePixel = 0
			card.Text = ""
			card.AutoButtonColor = false
			card.LayoutOrder = order
			card.ZIndex = 1105
			card.ClipsDescendants = true
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

			local stroke = Instance.new("UIStroke", card)
			stroke.Color = Color3.fromRGB(61, 91, 125)
			stroke.Thickness = 2

			-- Artwork always stays inside the card and above the label area.
			local icon = Instance.new("ImageLabel", card)
			icon.Name = "PetIcon"
			icon.Size = UDim2.fromOffset(104, 64)
			icon.Position = UDim2.fromOffset(13, 5)
			icon.BackgroundTransparency = 1
			icon.BorderSizePixel = 0
			icon.ScaleType = Enum.ScaleType.Fit
			icon.Image = tostring(tool.TextureId or "")
			icon.Visible = icon.Image ~= ""
			icon.ZIndex = 1106

			if not icon.Visible then
				SendGiftCompose_BuildViewport(card, tool, "PetViewport", UDim2.fromOffset(104, 64))
			end

			-- Pet name is below the image (never in the top-left corner).
			local name = Instance.new("TextLabel", card)
			name.Name = "PetName"
			name.Size = UDim2.new(1, -10, 0, 20)
			name.Position = UDim2.fromOffset(5, 70)
			name.BackgroundTransparency = 1
			name.Text = SendGiftCompose_GetPetName(tool)
			name.TextColor3 = Color3.fromRGB(255, 255, 255)
			name.Font = Enum.Font.FredokaOne
			name.TextSize = 15
			name.TextXAlignment = Enum.TextXAlignment.Center
			name.TextYAlignment = Enum.TextYAlignment.Center
			name.TextTruncate = Enum.TextTruncate.AtEnd
			name.ZIndex = 1107
			local nameStroke = Instance.new("UIStroke", name)
			nameStroke.Color = Color3.fromRGB(0, 0, 0)
			nameStroke.Thickness = 1.3

			local selectedToolRef = Instance.new("ObjectValue", card)
			selectedToolRef.Name = "PetToolRef"
			selectedToolRef.Value = tool
			SendGiftCompose_AddPetRateRow(card, 91, 1108)


			card.MouseEnter:Connect(function()
				card.BackgroundColor3 = Color3.fromRGB(24, 47, 72)
			end)
			card.MouseLeave:Connect(function()
				card.BackgroundColor3 = Color3.fromRGB(15, 31, 52)
			end)
			card.MouseButton1Click:Connect(function()
				local newList = {}
				for _, selected in ipairs(SendGiftCompose_SelectedTools) do
					if selected ~= tool then
						table.insert(newList, selected)
					end
				end
				SendGiftCompose_SelectedTools = newList
				SendGiftCompose_RefreshSelectedPets()
				SendGiftCompose_RefreshInventory()
			end)
		end
	end
end

function SendGiftCompose_UpdateInventorySelectionVisuals()
	if not SendGiftComposeInventoryList then return end

	for _, card in ipairs(SendGiftComposeInventoryList:GetChildren()) do
		if card:IsA("TextButton") and card.Name == "SpawnedPetCard" then
			local ref = card:FindFirstChild("PetToolRef")
			local petTool = ref and ref.Value or nil
			local selected = petTool and SendGiftCompose_IsSelected(petTool) or false

			card:SetAttribute("__SendGiftSelected", selected)
			card.BackgroundColor3 = selected and Color3.fromRGB(13, 70, 42) or Color3.fromRGB(9, 23, 39)

			local border = nil
			for _, child in ipairs(card:GetChildren()) do
				if child:IsA("UIStroke") and child.Name ~= "SelectedBrightGlow" then
					border = child
					break
				end
			end

			local glow = card:FindFirstChild("SelectedBrightGlow")
			local badge = card:FindFirstChild("SelectedPetBadge")
			if selected then
				if border then
					border.Color = Color3.fromRGB(72, 255, 132)
					border.Thickness = 4.5
				end
				if not glow then
					glow = Instance.new("UIStroke", card)
					glow.Name = "SelectedBrightGlow"
					glow.Color = Color3.fromRGB(170, 255, 195)
					glow.Transparency = 0.18
					glow.Thickness = 2.5
				end
				if not badge then
					badge = Instance.new("ImageLabel", card)
					badge.Name = "SelectedPetBadge"
					badge.Size = UDim2.fromOffset(36, 36)
					badge.Position = UDim2.new(1, -3, 0, 3)
					badge.AnchorPoint = Vector2.new(1, 0)
					badge.BackgroundTransparency = 1
					badge.BorderSizePixel = 0
					badge.Image = "rbxassetid://77814691332116"
					badge.ImageColor3 = Color3.fromRGB(255, 255, 255)
					badge.ImageTransparency = 0
					badge.ScaleType = Enum.ScaleType.Fit
					badge.ZIndex = 1112
					badge.Active = false
				end
				badge.Visible = true
			else
				if glow then glow:Destroy() end
				if badge then badge:Destroy() end
				if border then
					border.Color = Color3.fromRGB(54, 91, 128)
					border.Thickness = 2
				end
			end
		end
	end
end

function SendGiftCompose_TogglePetSelection(tool)
	if not tool or not tool.Parent then return end

	if SendGiftCompose_IsSelected(tool) then
		local newList = {}
		for _, selected in ipairs(SendGiftCompose_SelectedTools) do
			if selected ~= tool then table.insert(newList, selected) end
		end
		SendGiftCompose_SelectedTools = newList
	else
		table.insert(SendGiftCompose_SelectedTools, tool)
	end

	SendGiftCompose_RefreshSelectedPets()
	SendGiftCompose_UpdateInventorySelectionVisuals()
end

function SendGiftCompose_ClearSelectedVisual()
	SendGiftCompose_SelectedTools = {}
	SendGiftCompose_RefreshSelectedPets()
end

function SendGiftCompose_CreateInventoryCard(tool, order)
	local selected = SendGiftCompose_IsSelected(tool)
	local card = Instance.new("TextButton", SendGiftComposeInventoryList)
	card.Name = "SpawnedPetCard"
	card.Size = UDim2.fromOffset(130, 122)
	card.BackgroundColor3 = selected
		and Color3.fromRGB(13, 70, 42)
		or Color3.fromRGB(9, 23, 39)
	card.BorderSizePixel = 0
	card.Text = ""
	card.AutoButtonColor = false
	card.LayoutOrder = order
	card.ZIndex = 1104
	card:SetAttribute("__SendGiftSelected", selected)
	card.ClipsDescendants = true
	-- Store the exact Tool on the card so selection visuals can update in place.
	-- This avoids destroying/recreating cards and prevents pet-image flicker.
	local toolRef = Instance.new("ObjectValue", card)
	toolRef.Name = "PetToolRef"
	toolRef.Value = tool
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

	-- Bright blue selection frame.
	local stroke = Instance.new("UIStroke", card)
	stroke.Color = selected
		and Color3.fromRGB(72, 255, 132)
		or Color3.fromRGB(54, 91, 128)
	stroke.Thickness = selected and 4.5 or 2

	if selected then
		local glow = Instance.new("UIStroke", card)
		glow.Name = "SelectedBrightGlow"
		glow.Color = Color3.fromRGB(170, 255, 195)
		glow.Transparency = 0.18
		glow.Thickness = 2.5
	end

	local scale = Instance.new("UIScale", card)
	scale.Name = "SendGiftSelectionScale"
	scale.Scale = 1

	local icon = Instance.new("ImageLabel", card)
	icon.Name = "PetIcon"
	icon.Size = UDim2.fromOffset(104, 64)
	icon.Position = UDim2.fromOffset(13, 5)
	icon.BackgroundTransparency = 1
	icon.BorderSizePixel = 0
	icon.ScaleType = Enum.ScaleType.Fit
	icon.Image = tostring(tool.TextureId or "")
	icon.Visible = icon.Image ~= ""
	icon.ZIndex = 1105

	if not icon.Visible then
		SendGiftCompose_BuildViewport(card, tool, "CardPetViewport", UDim2.fromOffset(104, 64))
	end

	-- Match the supplied reference: name first, then the secondary info, both BELOW the artwork.
	local petName = SendGiftCompose_GetPetName(tool)
	local weight = ""
	pcall(function() weight = tostring(tool:GetAttribute("PetWeight") or "") end)
	if weight == "" then
		weight = SpawnPet_FindWeightInInstance(tool)
	end

	local name = Instance.new("TextLabel", card)
	name.Name = "PetName"
	name.Size = UDim2.new(1, -10, 0, 18)
	name.Position = UDim2.fromOffset(5, 70)
	name.BackgroundTransparency = 1
	name.Text = petName
	name.TextColor3 = Color3.fromRGB(255, 255, 255)
	name.Font = Enum.Font.FredokaOne
	name.TextSize = 13
	name.TextXAlignment = Enum.TextXAlignment.Center
	name.TextYAlignment = Enum.TextYAlignment.Center
	name.TextTruncate = Enum.TextTruncate.AtEnd
	name.ZIndex = 1110
	local nameStroke = Instance.new("UIStroke", name)
	nameStroke.Color = Color3.fromRGB(0, 0, 0)
	nameStroke.Thickness = 1.5

	SendGiftCompose_AddPetRateRow(card, 91, 1110)

	local weightLabel = Instance.new("TextLabel", card)
	weightLabel.Name = "PetWeight"
	weightLabel.Size = UDim2.new(1, -10, 0, 16)
	weightLabel.Position = UDim2.fromOffset(5, 111)
	weightLabel.BackgroundTransparency = 1
	weightLabel.Visible = false
	weightLabel.Text = weight ~= "" and "(" .. weight:gsub("^%((.*)%)$", "%1") .. ")" or ""
	weightLabel.TextColor3 = Color3.fromRGB(163, 194, 225)
	weightLabel.Font = Enum.Font.FredokaOne
	weightLabel.TextSize = 10
	weightLabel.TextXAlignment = Enum.TextXAlignment.Center
	weightLabel.TextYAlignment = Enum.TextYAlignment.Center
	weightLabel.TextTruncate = Enum.TextTruncate.AtEnd
	weightLabel.ZIndex = 1110
	local weightStroke = Instance.new("UIStroke", weightLabel)
	weightStroke.Color = Color3.fromRGB(0, 0, 0)
	weightStroke.Thickness = 1

	-- Larger/brighter selected badge, fully clipped inside the card.
	if selected then
		local selectedBadge = Instance.new("ImageLabel", card)
		selectedBadge.Name = "SelectedPetBadge"
		selectedBadge.Size = UDim2.fromOffset(36, 36)
		selectedBadge.Position = UDim2.new(1, -3, 0, 3)
		selectedBadge.AnchorPoint = Vector2.new(1, 0)
		selectedBadge.BackgroundTransparency = 1
		selectedBadge.BorderSizePixel = 0
		selectedBadge.Image = "rbxassetid://77814691332116"
		-- Keep the asset's original green/white colors instead of tinting it cyan.
		selectedBadge.ImageColor3 = Color3.fromRGB(255, 255, 255)
		selectedBadge.ImageTransparency = 0
		selectedBadge.ScaleType = Enum.ScaleType.Fit
		selectedBadge.ZIndex = 1112
		selectedBadge.Active = false
	end

	card.MouseEnter:Connect(function()
		if not SendGiftCompose_IsSelected(tool) then
			card.BackgroundColor3 = Color3.fromRGB(18, 39, 62)
		end
	end)

	card.MouseLeave:Connect(function()
		if SendGiftCompose_IsSelected(tool) then
			card.BackgroundColor3 = Color3.fromRGB(13, 70, 42)
		else
			card.BackgroundColor3 = Color3.fromRGB(9, 23, 39)
		end
	end)

	card.MouseButton1Click:Connect(function()
		if card:GetAttribute("__PetClickBusy") then
			return
		end
		card:SetAttribute("__PetClickBusy", true)

		-- Animate only the pet artwork. The card size stays fixed, so the
		-- UIListLayout never reflows and the image cannot jump/disappear.
		local target = icon
		if not target or not target.Parent or not target.Visible then
			target = card:FindFirstChild("CardPetViewport") or card:FindFirstChild("PetViewport")
		end

		if target and target.Parent and target:IsA("GuiObject") then
			local baseSize = target.Size
			local basePos = target.Position
			local growSize = UDim2.new(
				baseSize.X.Scale,
				math.floor(baseSize.X.Offset * 1.07),
				baseSize.Y.Scale,
				math.floor(baseSize.Y.Offset * 1.07)
			)
			local growPos = UDim2.new(
				basePos.X.Scale,
				basePos.X.Offset - math.floor((growSize.X.Offset - baseSize.X.Offset) * 0.5),
				basePos.Y.Scale,
				basePos.Y.Offset - math.floor((growSize.Y.Offset - baseSize.Y.Offset) * 0.5)
			)
			local grow = TweenService:Create(
				target,
				TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size = growSize, Position = growPos}
			)
			local shrink = TweenService:Create(
				target,
				TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
				{Size = baseSize, Position = basePos}
			)
			grow:Play()
			grow.Completed:Wait()
			if target.Parent then
				shrink:Play()
				shrink.Completed:Wait()
			end
		end

		if card.Parent then
			SendGiftCompose_TogglePetSelection(tool)
		end
		card:SetAttribute("__PetClickBusy", false)
	end)
end

function SendGiftCompose_RefreshInventory()
	if not SendGiftComposeInventoryList then return end

	SendGiftCompose_InventoryToken = SendGiftCompose_InventoryToken + 1
	local token = SendGiftCompose_InventoryToken

	for _, child in ipairs(SendGiftComposeInventoryList:GetChildren()) do
		if child:IsA("GuiButton") then child:Destroy() end
	end

	local spawned = {}
	for _, tool in ipairs(SpawnPetState.SpawnedTools or {}) do
		if tool
			and tool:IsA("Tool")
			and tool:GetAttribute("VirtualPet") == true
			and tool.Parent then
			table.insert(spawned, tool)
		end
	end

	local query = tostring(SendGiftComposeInventorySearch.Text or "")
		:lower()
		:gsub("^%s+", "")
		:gsub("%s+$", "")

	local count = 0
	for _, tool in ipairs(spawned) do
		if token ~= SendGiftCompose_InventoryToken then return end
		local petName = SendGiftCompose_GetPetName(tool)
		if query == ""
			or petName:lower():find(query, 1, true) then
			count = count + 1
			SendGiftCompose_CreateInventoryCard(tool, count)
		end
	end

	SendGiftComposeInventoryEmpty.Visible = count == 0
	if count == 0 then
		SendGiftComposeInventoryEmpty.Text =
			#spawned == 0
			and "No spawned pets yet"
			or "No spawned pet matches your search"
	end
end

function SendGiftCompose_LoadOwnAvatar()
	SendGiftCompose_OwnAvatarToken = SendGiftCompose_OwnAvatarToken + 1
	local token = SendGiftCompose_OwnAvatarToken
	SendGiftComposeYourAvatar.Image = ""

	local userId = Player and Player.UserId
	if not userId then return end

	task.spawn(function()
		local ok, image = pcall(function()
			local asset, ready = Players:GetUserThumbnailAsync(
				userId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size150x150
			)
			return asset, ready
		end)

		if token ~= SendGiftCompose_OwnAvatarToken then return end
		if ok and image and image ~= "" then
			SendGiftComposeYourAvatar.Image = image
		end
	end)
end

function SendGiftCompose_UpdateRecipient(index)
	SendGiftCompose_RecipientIndex = index

	pcall(function()
		if SendPlayer_RefreshRows then
			SendPlayer_RefreshRows()
		end
	end)

	local row = SendPlayerRows and SendPlayerRows[index] or nil
	local configuredUsername = tostring((Settings.RealUsernames and Settings.RealUsernames[index]) or "")
	configuredUsername = configuredUsername:gsub("^%s+", ""):gsub("%s+$", "")
	local configuredDisplay = tostring((Settings.FakeUsers and Settings.FakeUsers[index]) or "")
	configuredDisplay = configuredDisplay:gsub("^%s+", ""):gsub("%s+$", "")

	local displayName = configuredDisplay ~= "" and configuredDisplay or configuredUsername
	local resolvedUsername = configuredUsername
	local avatarImage = ""
	local resolvedUserId = nil

	if row then
		local rowDisplay = row.NameLabel and tostring(row.NameLabel.Text or "") or ""
		rowDisplay = rowDisplay:gsub("^%s+", ""):gsub("%s+$", "")
		if rowDisplay ~= "" then
			displayName = rowDisplay
		end

		local rowUsername = tostring(row.Username or "")
		rowUsername = rowUsername:gsub("^%s+", ""):gsub("%s+$", "")
		if rowUsername ~= "" then
			resolvedUsername = rowUsername
		elseif row.UserLabel then
			local labelUsername = tostring(row.UserLabel.Text or ""):gsub("^@", "")
			labelUsername = labelUsername:gsub("^%s+", ""):gsub("%s+$", "")
			if labelUsername ~= "" then
				resolvedUsername = labelUsername
			end
		end

		resolvedUserId = row.UserId
		if row.Avatar then
			avatarImage = tostring(row.Avatar.Image or "")
		end
	end

	SendGiftComposeRecipientName.Text = displayName
	SendGiftComposeRecipientName.Visible = true
	SendGiftComposeRecipientAvatar.Visible = true
	SendGiftComposeRecipientAvatar.Image = avatarImage
	task.defer(SendGiftCompose_CenterSentTo)

	if avatarImage == "" and resolvedUsername ~= "" then
		local targetIndex = index
		local usernameForRequest = resolvedUsername
		local knownUserId = resolvedUserId

		task.spawn(function()
			local userId = knownUserId
			if not userId then
				local okId, id = pcall(function()
					return Players:GetUserIdFromNameAsync(usernameForRequest)
				end)
				if okId then
					userId = id
				end
			end
			if not userId then return end

			local okThumb, image = pcall(function()
				local asset = Players:GetUserThumbnailAsync(
					userId,
					Enum.ThumbnailType.HeadShot,
					Enum.ThumbnailSize.Size150x150
				)
				return asset
			end)

			if okThumb and image and image ~= ""
				and SendGiftComposePrompt
				and SendGiftComposePrompt.Visible
				and SendGiftCompose_RecipientIndex == targetIndex then
				SendGiftComposeRecipientAvatar.Image = image
				SendGiftComposeRecipientAvatar.Visible = true
				task.defer(SendGiftCompose_CenterSentTo)
			end
		end)
	end
end

function SendGiftCompose_ClosePanel()
	SendGiftComposePrompt.Visible = false
	SendGiftCompose_RefreshInventory()
	SendPlayer_RefreshRows()
	SendPlayerPrompt.Visible = true
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
end

function ShowSendGiftCompose(index)
	if not SendGiftComposePrompt then return end

	-- Refresh the source player rows first; this keeps name/avatar data in sync
	-- with the exact Send Player row that was clicked.
	pcall(function()
		if SendPlayer_RefreshRows then
			SendPlayer_RefreshRows()
		end
	end)

	SendPlayerPrompt.Visible = false
	GiftPrompt.Visible = false
	BuyPrompt.Visible = false
	LoadingPrompt.Visible = false
	SuccessPrompt.Visible = false
	PurchaseSuccessfulPrompt.Visible = false

	-- Open the compose panel immediately so a slow avatar request can never
	-- prevent the panel itself from appearing.
	SendGiftComposePrompt.Visible = true
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1

	pcall(function() SendGiftCompose_UpdateRecipient(index) end)
	pcall(function() SendGiftCompose_ClearSelectedVisual() end)
	pcall(function() SendGiftComposeInventorySearch.Text = "" end)
	pcall(function() SendGiftComposeNoteBox.Text = "" end)
	pcall(function() SendGiftCompose_LoadOwnAvatar() end)
	pcall(function() SendGiftCompose_RefreshInventory() end)
end

SendGiftComposeInventorySearch:GetPropertyChangedSignal("Text"):Connect(function()
	if SendGiftComposePrompt.Visible then
		SendGiftCompose_RefreshInventory()
	end
end)

SendGiftComposeHeaderClose.MouseButton1Click:Connect(SendGiftCompose_ClosePanel)
SendGiftComposeHeaderClose.Activated:Connect(SendGiftCompose_ClosePanel)

SendGiftComposeCancel.MouseButton1Click:Connect(SendGiftCompose_ClosePanel)
SendGiftComposeCancel.Activated:Connect(SendGiftCompose_ClosePanel)

SendGiftCompose_SendBusy = false

function SendGiftCompose_PlaySelectedPetSendAnimation()
	if not SendGiftComposeSend then
		return
	end

	local sendScale = SendGiftComposeSend:FindFirstChild("SendButtonPressScale")
	if not sendScale then
		sendScale = Instance.new("UIScale", SendGiftComposeSend)
		sendScale.Name = "SendButtonPressScale"
		sendScale.Scale = 1
	end

	local grow = TweenService:Create(
		sendScale,
		TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Scale = 1.12}
	)
	local darken = TweenService:Create(
		SendGiftComposeSend,
		TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundColor3 = Color3.fromRGB(70, 175, 0)}
	)
	local shrink = TweenService:Create(
		sendScale,
		TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{Scale = 1}
	)

	grow:Play()
	darken:Play()
	grow.Completed:Wait()
	shrink:Play()
	shrink.Completed:Wait()

	TweenService:Create(
		SendGiftComposeSend,
		TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundColor3 = Color3.fromRGB(118, 255, 10)}
	):Play()
end

SendGiftComposeSend.MouseButton1Click:Connect(function()
	if #SendGiftCompose_SelectedTools == 0 or SendGiftCompose_SendBusy then
		return
	end
	SendGiftCompose_SendBusy = true
	SendGiftCompose_PlaySelectedPetSendAnimation()
	SelectedGiftDisplayName = tostring(SendGiftComposeRecipientName.Text or "Player")
	SelectedGiftUsername = ""
	if SendGiftCompose_RecipientIndex and SendPlayerRows[SendGiftCompose_RecipientIndex] then
		SelectedGiftUsername = tostring(SendPlayerRows[SendGiftCompose_RecipientIndex].Username or "")
	end
	SendSentPetSummary = SendGiftCompose_BuildSentPetSummary(SendGiftCompose_SelectedTools)
	SendGiftCompose_CaptureSentPetVisuals(SendGiftCompose_SelectedTools)
	ActiveGiftSource = "SendCompose"
	SendGiftComposePrompt.Visible = false
	SendPlayerPrompt.Visible = false
	GiftPrompt.Visible = false
	LoadingPrompt.Visible = false
	SuccessPrompt.Visible = false
	PurchaseSuccessfulPrompt.Visible = false
	SendSuccessPrompt.Visible = false
	SendLoadingPrompt.Visible = false
	BuyPrompt.Visible = false
	DarkOverlay.Visible = true
	DarkOverlay.BackgroundTransparency = 0.5

	-- Send 2 no longer opens the Buy Item panel.
	-- The existing post-buy sequence is started directly.
	if StartSendPlayerPostBuyFlow then
		StartSendPlayerPostBuyFlow()
	end
	SendGiftCompose_SendBusy = false
end)

SendGiftComposeSend.Activated:Connect(function()
	if #SendGiftCompose_SelectedTools > 0 then
		SendGiftComposeSend.BackgroundColor3 = Color3.fromRGB(92, 225, 0)
	end
end)

SendSentPetSummary = ""
StartSendPlayerPostBuyFlow = nil

-- ==========================================
-- SEND PLAYER INDEPENDENT POST-BUY FLOW
-- Blue ring + gift box are NOT shared with Gift Player.
-- The success panel is NOT shared with Gift Player.
-- Ribbon animation is independent and continues even after OK is pressed.
-- ==========================================
SendLoadingPrompt = Instance.new("Frame", ScreenGui)
SendLoadingPrompt.Name = "SendPlayerLoadingPrompt"
SendLoadingPrompt.Size = UDim2.fromScale(1, 1)
SendLoadingPrompt.Position = UDim2.fromScale(0, 0)
SendLoadingPrompt.BackgroundTransparency = 1
SendLoadingPrompt.BorderSizePixel = 0
SendLoadingPrompt.Visible = false
SendLoadingPrompt.ZIndex = 1180

SendLoadingGiftIcon = Instance.new("ImageLabel", SendLoadingPrompt)
SendLoadingGiftIcon.Name = "IndependentLoadingGiftIcon"
SendLoadingGiftIcon.Size = UDim2.fromOffset(230, 230)
SendLoadingGiftIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
SendLoadingGiftIcon.AnchorPoint = Vector2.new(0.5, 0.5)
SendLoadingGiftIcon.BackgroundTransparency = 1
SendLoadingGiftIcon.BorderSizePixel = 0
SendLoadingGiftIcon.Image = "rbxassetid://99174903737611"
SendLoadingGiftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
SendLoadingGiftIcon.ImageTransparency = 0
SendLoadingGiftIcon.ScaleType = Enum.ScaleType.Fit
SendLoadingGiftIcon.ZIndex = 1183

SendLoadingRing = Instance.new("ImageLabel", SendLoadingPrompt)
SendLoadingRing.Name = "IndependentBlueRing"
SendLoadingRing.Size = UDim2.fromOffset(550, 550)
SendLoadingRing.Position = UDim2.new(0.5, 0, 0.5, 0)
SendLoadingRing.AnchorPoint = Vector2.new(0.5, 0.5)
SendLoadingRing.BackgroundTransparency = 1
SendLoadingRing.BorderSizePixel = 0
SendLoadingRing.Image = "rbxassetid://2565668394"
SendLoadingRing.ImageColor3 = Color3.fromRGB(35, 160, 255)
SendLoadingRing.ImageTransparency = 0
SendLoadingRing.ScaleType = Enum.ScaleType.Fit
SendLoadingRing.ZIndex = 1182

SendLoadingScale = Instance.new("UIScale", SendLoadingGiftIcon)
SendLoadingScale.Scale = 1
SendLoadingConnection = nil
SendLoadingRunId = 0

SendSuccessPrompt = Instance.new("Frame", ScreenGui)
SendSuccessPrompt.Name = "SendPlayerSuccessPrompt"
SendSuccessPrompt.Size = UDim2.fromOffset(650, 455)
SendSuccessPrompt.Position = UDim2.new(0.5, 0, 0.5, 0)
SendSuccessPrompt.AnchorPoint = Vector2.new(0.5, 0.5)
SendSuccessPrompt.BackgroundColor3 = Color3.fromRGB(7, 30, 55)
SendSuccessPrompt.BackgroundTransparency = 0
SendSuccessPrompt.BorderSizePixel = 0
SendSuccessPrompt.Visible = false
SendSuccessPrompt.ZIndex = 1250
SendSuccessPrompt.ClipsDescendants = false
Instance.new("UICorner", SendSuccessPrompt).CornerRadius = UDim.new(0, 16)

SendSuccessEffect131 = Instance.new("ImageLabel", SendSuccessPrompt)
SendSuccessEffect131.Name = "IndependentEffect131176354845909"
SendSuccessEffect131.Size = UDim2.fromScale(1, 1)
SendSuccessEffect131.Position = UDim2.fromScale(0, 0)
SendSuccessEffect131.BackgroundTransparency = 1
SendSuccessEffect131.BorderSizePixel = 0
SendSuccessEffect131.Image = "rbxassetid://131176354845909"
SendSuccessEffect131.ImageColor3 = Color3.fromRGB(60, 165, 240)
SendSuccessEffect131.ImageTransparency = 0.74
SendSuccessEffect131.ScaleType = Enum.ScaleType.Tile
SendSuccessEffect131.TileSize = UDim2.fromOffset(60, 60)
SendSuccessEffect131.ZIndex = 1251
SendSuccessEffect131.Active = false
Instance.new("UICorner", SendSuccessEffect131).CornerRadius = UDim.new(0, 16)

SendSuccessStroke = Instance.new("UIStroke", SendSuccessPrompt)
SendSuccessStroke.Color = Color3.fromRGB(120, 210, 255)
SendSuccessStroke.Thickness = 3

SendSuccessTitle = Instance.new("TextLabel", SendSuccessPrompt)
SendSuccessTitle.Name = "YouSentAPetTitle"
SendSuccessTitle.Size = UDim2.new(1, -60, 0, 58)
SendSuccessTitle.Position = UDim2.fromOffset(30, 26)
SendSuccessTitle.BackgroundTransparency = 1
SendSuccessTitle.Text = "You Sent a Pet"
SendSuccessTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SendSuccessTitle.Font = Enum.Font.FredokaOne
SendSuccessTitle.TextSize = 42
SendSuccessTitle.TextXAlignment = Enum.TextXAlignment.Center
SendSuccessTitle.TextYAlignment = Enum.TextYAlignment.Center
SendSuccessTitle.ZIndex = 1253
local SendSuccessTitleStroke = Instance.new("UIStroke", SendSuccessTitle)
SendSuccessTitleStroke.Color = Color3.fromRGB(0, 0, 0)
SendSuccessTitleStroke.Thickness = 3

SendSuccessRecipient = Instance.new("TextLabel", SendSuccessPrompt)
SendSuccessRecipient.Name = "SendRecipient"
SendSuccessRecipient.Size = UDim2.new(1, -60, 0, 35)
SendSuccessRecipient.Position = UDim2.fromOffset(30, 82)
SendSuccessRecipient.BackgroundTransparency = 1
SendSuccessRecipient.Text = "to Player"
SendSuccessRecipient.TextColor3 = Color3.fromRGB(190, 225, 255)
SendSuccessRecipient.Font = Enum.Font.FredokaOne
SendSuccessRecipient.TextSize = 24
SendSuccessRecipient.TextXAlignment = Enum.TextXAlignment.Center
SendSuccessRecipient.TextYAlignment = Enum.TextYAlignment.Center
SendSuccessRecipient.ZIndex = 1253
local SendSuccessRecipientStroke = Instance.new("UIStroke", SendSuccessRecipient)
SendSuccessRecipientStroke.Color = Color3.fromRGB(0, 0, 0)
SendSuccessRecipientStroke.Thickness = 2

SendSuccessPetNames = Instance.new("TextLabel", SendSuccessPrompt)
SendSuccessPetNames.Name = "SentPetNamesLegacy"
SendSuccessPetNames.Size = UDim2.fromOffset(1, 1)
SendSuccessPetNames.Position = UDim2.fromOffset(-10, -10)
SendSuccessPetNames.BackgroundTransparency = 1
SendSuccessPetNames.Text = ""
SendSuccessPetNames.Visible = false
SendSuccessPetNames.ZIndex = 1253

SendSuccessPetGrid = Instance.new("ScrollingFrame", SendSuccessPrompt)
SendSuccessPetGrid.Name = "SentPetImageGrid"
SendSuccessPetGrid.Size = UDim2.new(1, -72, 0, 220)
SendSuccessPetGrid.Position = UDim2.fromOffset(36, 125)
SendSuccessPetGrid.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SendSuccessPetGrid.BackgroundTransparency = 1
SendSuccessPetGrid.BorderSizePixel = 0
SendSuccessPetGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
SendSuccessPetGrid.AutomaticCanvasSize = Enum.AutomaticSize.Y
SendSuccessPetGrid.ScrollBarThickness = 6
SendSuccessPetGrid.ScrollBarImageColor3 = Color3.fromRGB(120, 210, 255)
SendSuccessPetGrid.ScrollingDirection = Enum.ScrollingDirection.Y
SendSuccessPetGrid.ZIndex = 1253
SendSuccessPetGrid.ClipsDescendants = true
Instance.new("UICorner", SendSuccessPetGrid).CornerRadius = UDim.new(0, 12)

SendSuccessPetGridPadding = Instance.new("UIPadding", SendSuccessPetGrid)
SendSuccessPetGridPadding.PaddingTop = UDim.new(0, 8)
SendSuccessPetGridPadding.PaddingBottom = UDim.new(0, 8)
SendSuccessPetGridPadding.PaddingLeft = UDim.new(0, 8)
SendSuccessPetGridPadding.PaddingRight = UDim.new(0, 8)

SendSuccessPetGridLayout = Instance.new("UIGridLayout", SendSuccessPetGrid)
SendSuccessPetGridLayout.CellSize = UDim2.fromOffset(130, 122)
SendSuccessPetGridLayout.CellPadding = UDim2.fromOffset(10, 10)
SendSuccessPetGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SendSuccessPetGridLayout.SortOrder = Enum.SortOrder.LayoutOrder

local SendSuccessPetGridStroke = Instance.new("UIStroke", SendSuccessPetGrid)
SendSuccessPetGridStroke.Color = Color3.fromRGB(70, 135, 190)
SendSuccessPetGridStroke.Thickness = 2
SendSuccessPetGridStroke.Transparency = 1

SendSuccessOk = Instance.new("TextButton", SendSuccessPrompt)
SendSuccessOk.Name = "OK"
SendSuccessOk.Size = UDim2.fromOffset(164, 66)
SendSuccessOk.Position = UDim2.new(0.5, -82, 1, -84)
SendSuccessOk.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
SendSuccessOk.BorderSizePixel = 0
SendSuccessOk.Text = ""
SendSuccessOk.AutoButtonColor = false
SendSuccessOk.Active = true
SendSuccessOk.ZIndex = 1254
Instance.new("UICorner", SendSuccessOk).CornerRadius = UDim.new(0, 8)

local SendSuccessOkStroke = Instance.new("UIStroke", SendSuccessOk)
SendSuccessOkStroke.Color = Color3.fromRGB(255, 255, 255)
SendSuccessOkStroke.Thickness = 3

local SendSuccessOkBorderOverlay = Instance.new("Frame", SendSuccessOk)
SendSuccessOkBorderOverlay.Name = "WhiteBorderOverlay"
SendSuccessOkBorderOverlay.Size = UDim2.fromScale(1, 1)
SendSuccessOkBorderOverlay.Position = UDim2.fromScale(0, 0)
SendSuccessOkBorderOverlay.BackgroundTransparency = 1
SendSuccessOkBorderOverlay.BorderSizePixel = 0
SendSuccessOkBorderOverlay.ZIndex = 1256
Instance.new("UICorner", SendSuccessOkBorderOverlay).CornerRadius = UDim.new(0, 8)
local SendSuccessOkBorderStroke = Instance.new("UIStroke", SendSuccessOkBorderOverlay)
SendSuccessOkBorderStroke.Color = Color3.fromRGB(255, 255, 255)
SendSuccessOkBorderStroke.Thickness = 3

local SendSuccessOkPattern = Instance.new("ImageLabel", SendSuccessOk)
SendSuccessOkPattern.Name = "ButtonPattern"
SendSuccessOkPattern.Size = UDim2.fromScale(1, 1)
SendSuccessOkPattern.Position = UDim2.fromScale(0, 0)
SendSuccessOkPattern.BackgroundTransparency = 1
SendSuccessOkPattern.BorderSizePixel = 0
SendSuccessOkPattern.Image = "rbxassetid://90325592797235"
SendSuccessOkPattern.ImageColor3 = Color3.fromRGB(255, 255, 255)
SendSuccessOkPattern.ImageTransparency = 0.72
SendSuccessOkPattern.ScaleType = Enum.ScaleType.Tile
SendSuccessOkPattern.TileSize = UDim2.fromOffset(60, 60)
SendSuccessOkPattern.ZIndex = 1255
SendSuccessOkPattern.Active = false

local SendSuccessOkText = Instance.new("TextLabel", SendSuccessOk)
SendSuccessOkText.Name = "ButtonText"
SendSuccessOkText.Size = UDim2.fromScale(1, 1)
SendSuccessOkText.Position = UDim2.fromScale(0, 0)
SendSuccessOkText.BackgroundTransparency = 1
SendSuccessOkText.Text = "OK"
SendSuccessOkText.TextColor3 = Color3.fromRGB(255, 255, 255)
SendSuccessOkText.Font = Enum.Font.FredokaOne
SendSuccessOkText.TextSize = 50
SendSuccessOkText.TextXAlignment = Enum.TextXAlignment.Center
SendSuccessOkText.TextYAlignment = Enum.TextYAlignment.Center
SendSuccessOkText.TextScaled = false
SendSuccessOkText.TextWrapped = false
SendSuccessOkText.ZIndex = 1257
SendSuccessOkText.Active = false
local SendSuccessOkTextStroke = Instance.new("UIStroke", SendSuccessOkText)
SendSuccessOkTextStroke.Color = Color3.fromRGB(0, 0, 0)
SendSuccessOkTextStroke.Thickness = 2

SendSuccessOk.MouseEnter:Connect(function()
	SendSuccessOk.BackgroundColor3 = Color3.fromRGB(128, 255, 20)
end)
SendSuccessOk.MouseLeave:Connect(function()
	SendSuccessOk.BackgroundColor3 = Color3.fromRGB(118, 255, 10)
end)
SendSuccessOk.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		SendSuccessOk.BackgroundColor3 = Color3.fromRGB(92, 225, 0)
	end
end)
SendSuccessOk.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		SendSuccessOk.BackgroundColor3 = Color3.fromRGB(128, 255, 20)
	end
end)

SendSuccessClose = Instance.new("TextButton", SendSuccessPrompt)
SendSuccessClose.Name = "Close"
SendSuccessClose.Size = UDim2.fromOffset(42, 42)
SendSuccessClose.Position = UDim2.new(1, -8, 0, 8)
SendSuccessClose.AnchorPoint = Vector2.new(1, 0)
SendSuccessClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
SendSuccessClose.BorderSizePixel = 0
SendSuccessClose.Text = "X"
SendSuccessClose.TextColor3 = Color3.fromRGB(255, 255, 255)
SendSuccessClose.Font = Enum.Font.FredokaOne
SendSuccessClose.TextSize = 28
SendSuccessClose.TextXAlignment = Enum.TextXAlignment.Center
SendSuccessClose.TextYAlignment = Enum.TextYAlignment.Center
SendSuccessClose.AutoButtonColor = false
SendSuccessClose.ZIndex = 1255
Instance.new("UICorner", SendSuccessClose).CornerRadius = UDim.new(0, 8)
local SendSuccessCloseStroke = Instance.new("UIStroke", SendSuccessClose)
SendSuccessCloseStroke.Color = Color3.fromRGB(0, 0, 0)
SendSuccessCloseStroke.Thickness = 3
SendSuccessClose.MouseEnter:Connect(function()
	SendSuccessClose.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
end)
SendSuccessClose.MouseLeave:Connect(function()
	SendSuccessClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end)

SendConfettiLayer = Instance.new("Frame", ScreenGui)
SendConfettiLayer.Name = "SendPlayerIndependentRibbonLayer"
SendConfettiLayer.Size = UDim2.fromScale(1, 1)
SendConfettiLayer.Position = UDim2.fromScale(0, 0)
SendConfettiLayer.BackgroundTransparency = 1
SendConfettiLayer.BorderSizePixel = 0
SendConfettiLayer.Visible = false
SendConfettiLayer.ZIndex = 2000
SendConfettiLayer.ClipsDescendants = true
SendConfettiPieces = {}
SendConfettiConnection = nil
SendConfettiRunId = 0

function SendGiftCompose_BuildSentPetSummary(tools)
	local counts = {}
	local order = {}
	local displayNameByKey = {}
	for _, tool in ipairs(tools or {}) do
		local petName = SendGiftCompose_GetPetName(tool)
		petName = tostring(petName):gsub("^%s+", ""):gsub("%s+$", "")
		if petName == "" then petName = "Spawned Pet" end
		local key = petName:lower()
		if not counts[key] then
			counts[key] = 0
			displayNameByKey[key] = petName
			table.insert(order, key)
		end
		counts[key] = counts[key] + 1
	end
	local lines = {}
	for _, key in ipairs(order) do
		if counts[key] > 1 then
			table.insert(lines, "x" .. tostring(counts[key]) .. " " .. displayNameByKey[key])
		else
			table.insert(lines, displayNameByKey[key])
		end
	end
	return table.concat(lines, ",  ")
end

SendSentPetVisuals = {}

function SendGiftCompose_GetPetImage(tool)
	if not tool then
		return ""
	end

	local image = ""
	pcall(function() image = tostring(tool.TextureId or "") end)
	if image ~= "" then
		return image
	end

	local attributeNames = {
		"PetImage",
		"Image",
		"Icon",
		"Thumbnail"
	}
	for _, attributeName in ipairs(attributeNames) do
		local value = tool:GetAttribute(attributeName)
		if value ~= nil then
			image = tostring(value)
			if image ~= "" then
				return image
			end
		end
	end

	local petName = SendGiftCompose_GetPetName(tool)
	if SpawnPet_GetReal2DIcon then
		pcall(function()
			image = tostring(SpawnPet_GetReal2DIcon(petName) or "")
		end)
	end
	return image
end

function SendGiftCompose_CaptureSentPetVisuals(tools)
	SendSentPetVisuals = {}
	for _, tool in ipairs(tools or {}) do
		if tool then
			local visual = {
				Name = SendGiftCompose_GetPetName(tool),
				Image = SendGiftCompose_GetPetImage(tool),
				Rate = SendGiftCompose_GetPetRate(tool),
				Model = nil
			}
			-- Keep the real held model as well as the 2D icon.  The success card
			-- can use the model when available, preserving the pet's runtime look.
			local heldModel = tool:FindFirstChild("HeldModel")
			if heldModel and heldModel:IsA("Model") then
				pcall(function()
					visual.Model = heldModel:Clone()
				end)
			end
			table.insert(SendSentPetVisuals, visual)
		end
	end
end

function SpawnPet_RefillReleasedHotbarSlots(releasedSlots, excludedTools)
	if type(releasedSlots) ~= "table" or #releasedSlots == 0 then return end
	SpawnPetState.ToolToSlot = SpawnPetState.ToolToSlot or {}
	excludedTools = excludedTools or {}

	for _, slot in ipairs(releasedSlots) do
		-- Safety: only truly empty slots may be refilled.
		if slot and slot.Parent and slot:GetAttribute("__SpawnPetOccupied") ~= true then
			local candidate=nil
			for _, tool in ipairs(SpawnPetState.SpawnedTools or {}) do
				if tool and tool.Parent and tool:IsA("Tool")
					and tool:GetAttribute("VirtualPet") == true
					and not excludedTools[tool]
					and not SpawnPetState.ToolToSlot[tool] then
					candidate=tool
					break
				end
			end
			if not candidate then break end

			local meta={
				name=tostring(candidate:GetAttribute("PetName") or candidate.Name or "Spawned Pet"),
				perSecond=tostring(candidate:GetAttribute("PetBPS") or ""),
				image=tostring(candidate.TextureId or ""),
				rarity=tostring(candidate:GetAttribute("PetRarity") or ""),
				scale=tonumber(candidate:GetAttribute("PetScale") or 1) or 1
			}
			if SpawnPet_BindHotbarSlot(slot,candidate,meta,meta.image) then
				candidate:SetAttribute("VirtualPetInventoryOnly", false)
				candidate:SetAttribute("VirtualPetHotbarVisible", true)
				candidate:SetAttribute("VirtualPetPinnedFromSend", nil)
			end
		end
	end
end

function SendGiftCompose_ConsumeSelectedPets()
	-- HOTBAR SAFETY RULE:
	-- A pet that is currently assigned to a real hotbar slot is NEVER moved,
	-- re-bound, unbound, destroyed, or otherwise modified by Send.
	-- Sending that pet only captures its visual for the confirmation screen.
	-- Only pets that are NOT assigned to a hotbar slot are consumed.
	local hotbarSelected = {}
	local inventorySelected = {}

	for _, tool in ipairs(SendGiftCompose_SelectedTools or {}) do
		if tool then
			local slot = SpawnPetState.ToolToSlot and SpawnPetState.ToolToSlot[tool]
			if slot and slot.Parent and slot:GetAttribute('__SpawnPetOccupied') == true then
				hotbarSelected[tool] = true
			else
				inventorySelected[tool] = true
			end
		end
	end

	-- Consume ONLY hidden/inventory-only pets.
	for tool in pairs(inventorySelected) do
		if tool then
			local clone = SpawnPetState.ToolToClone and SpawnPetState.ToolToClone[tool]
			if clone and SpawnPetState.AnimationTrackByClone then
				local track = SpawnPetState.AnimationTrackByClone[clone]
				if track then
					pcall(function() track:Stop(0) end)
				end
				SpawnPetState.AnimationTrackByClone[clone] = nil
			end

			if SpawnPetState.ToolToClone then
				SpawnPetState.ToolToClone[tool] = nil
			end
			if SpawnPetState.ToolToSlot then
				SpawnPetState.ToolToSlot[tool] = nil
			end
			pcall(function() tool:Destroy() end)
		end
	end

	-- Rebuild SpawnedTools, keeping ALL hotbar pets untouched and removing only
	-- the inventory-only pets that were actually selected for Send.
	local kept = {}
	for _, tool in ipairs(SpawnPetState.SpawnedTools or {}) do
		if tool and (not inventorySelected[tool] or hotbarSelected[tool]) then
			table.insert(kept, tool)
		end
	end
	SpawnPetState.SpawnedTools = kept

	-- Nothing in the hotbar is rebound, released, replaced, or restored here.
	-- This intentionally leaves every selected hotbar slot exactly as it was
	-- before Send was pressed.
	SendGiftCompose_SelectedTools = {}
	pcall(function() SendGiftCompose_RefreshSelectedPets() end)
	pcall(function() SendGiftCompose_RefreshInventory() end)
end
-- Returns true only for a pet that is currently protected by the hotbar.
function SpawnPet_IsHotbarPet(tool)
	if not tool then return false end
	local slot = SpawnPetState.ToolToSlot and SpawnPetState.ToolToSlot[tool]
	return slot ~= nil and slot.Parent ~= nil and slot:GetAttribute('__SpawnPetOccupied') == true
end

function SendPlayer_StopLoading()
	SendLoadingRunId = SendLoadingRunId + 1
	if SendLoadingConnection then
		SendLoadingConnection:Disconnect()
		SendLoadingConnection = nil
	end
	SendLoadingPrompt.Visible = false
	SendLoadingScale.Scale = 1
	SendLoadingRing.Rotation = 0
end

function StartSendPlayerIndependentRibbon()
	SendConfettiRunId = SendConfettiRunId + 1
	local runId = SendConfettiRunId
	if SendConfettiConnection then
		SendConfettiConnection:Disconnect()
		SendConfettiConnection = nil
	end
	for _, piece in ipairs(SendConfettiPieces) do
		if piece and piece.Gui and piece.Gui.Parent then pcall(function() piece.Gui:Destroy() end) end
	end
	table.clear(SendConfettiPieces)
	SendConfettiLayer.Visible = true

	local viewport = SendConfettiLayer.AbsoluteSize
	local width = viewport.X > 0 and viewport.X or 1920
	local height = viewport.Y > 0 and viewport.Y or 1080
	local random = Random.new()
	local ribbonCount = 96
	local spawnWindow = 1.6
	local spawned = 0
	local active = 0
	local elapsed = 0
	local colors = {
		Color3.fromRGB(80, 190, 255),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(120, 245, 160),
		Color3.fromRGB(120, 150, 255),
		Color3.fromRGB(220, 250, 255)
	}

	for i = 1, ribbonCount do
		local delayTime = random:NextNumber(0, spawnWindow)
		task.delay(delayTime, function()
			if runId ~= SendConfettiRunId or not SendConfettiLayer.Parent then return end
			local ribbon = Instance.new("Frame")
			ribbon.Name = "SendRibbon_" .. tostring(i)
			ribbon.Size = UDim2.fromOffset(random:NextInteger(10, 22), random:NextInteger(24, 54))
			ribbon.AnchorPoint = Vector2.new(0.5, 0.5)
			ribbon.Position = UDim2.fromOffset(random:NextNumber(-width * 0.04, width * 1.04), random:NextNumber(-160, -20))
			ribbon.BackgroundColor3 = colors[random:NextInteger(1, #colors)]
			ribbon.BorderSizePixel = 0
			ribbon.Rotation = random:NextInteger(-60, 60)
			ribbon.ZIndex = 1231
			ribbon.Parent = SendConfettiLayer

			spawned = spawned + 1
			active = active + 1
			table.insert(SendConfettiPieces, {
				Gui = ribbon,
				x = ribbon.Position.X.Offset,
				y = ribbon.Position.Y.Offset,
				vx = random:NextNumber(-250, 250),
				vy = random:NextNumber(280, 500),
				gravity = random:NextNumber(620, 960),
				rotation = random:NextNumber(-180, 180),
				spin = random:NextNumber(-760, 760),
				wobble = random:NextNumber(12, 32),
				wobbleSpeed = random:NextNumber(2.4, 6.0),
				phase = random:NextNumber(0, math.pi * 2),
				counted = true
			})
		end)
	end

	SendConfettiConnection = RunService.RenderStepped:Connect(function(dt)
		if runId ~= SendConfettiRunId then return end
		elapsed = elapsed + dt
		for index = #SendConfettiPieces, 1, -1 do
			local piece = SendConfettiPieces[index]
			if piece.Gui and piece.Gui.Parent then
				piece.vy = piece.vy + piece.gravity * dt
				piece.x = piece.x + piece.vx * dt
				piece.y = piece.y + piece.vy * dt
				piece.x = piece.x + math.sin(elapsed * piece.wobbleSpeed + piece.phase) * piece.wobble * dt
				piece.rotation = piece.rotation + piece.spin * dt
				piece.Gui.Position = UDim2.fromOffset(piece.x, piece.y)
				piece.Gui.Rotation = piece.rotation
				if piece.y > height + 100 then
					piece.Gui:Destroy()
					if piece.counted then
						piece.counted = false
						active = active - 1
					end
					table.remove(SendConfettiPieces, index)
				end
			else
				if piece.counted then
					piece.counted = false
					active = active - 1
				end
				table.remove(SendConfettiPieces, index)
			end
		end
		if spawned >= ribbonCount and active <= 0 then
			if SendConfettiConnection then
				SendConfettiConnection:Disconnect()
				SendConfettiConnection = nil
			end
			SendConfettiLayer.Visible = false
			table.clear(SendConfettiPieces)
		end
	end)
end

function SendSuccess_ClearPetGrid()
	if not SendSuccessPetGrid then return end
	for _, child in ipairs(SendSuccessPetGrid:GetChildren()) do
		if child:IsA("GuiObject") and child ~= SendSuccessPetGridLayout and child ~= SendSuccessPetGridPadding then
			child:Destroy()
		end
	end
end

function SendSuccess_BuildModelViewport(parent, model)
	if not parent or not model or not model:IsA("Model") then return false end
	local viewport = Instance.new("ViewportFrame", parent)
	viewport.Name = "PetViewport"
	viewport.Size = UDim2.fromOffset(104, 64)
	viewport.Position = UDim2.new(0.5, -52, 0, 5)
	viewport.BackgroundTransparency = 1
	viewport.BorderSizePixel = 0
	viewport.ZIndex = 1256
	viewport.Ambient = Color3.fromRGB(180, 190, 205)
	viewport.LightColor = Color3.fromRGB(255, 255, 255)
	viewport.LightDirection = Vector3.new(-1, -1, -1)

	local world = Instance.new("WorldModel", viewport)
	local clone = model:Clone()
	clone.Parent = world
	for _, obj in ipairs(clone:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Anchored = true
			obj.CanCollide = false
			obj.CanTouch = false
			obj.CanQuery = false
		end
	end

	local camera = Instance.new("Camera", viewport)
	viewport.CurrentCamera = camera
	local cf, bounds = clone:GetBoundingBox()
	local extent = math.max(bounds.X, bounds.Y, bounds.Z, 1)
	camera.CFrame = CFrame.new(
		cf.Position + Vector3.new(0, extent * 0.08, extent * 1.9),
		cf.Position + Vector3.new(0, extent * 0.05, 0)
	)
	return true
end

function SendSuccess_RenderPetImages()
	if not SendSuccessPetGrid then return end
	SendSuccess_ClearPetGrid()

	local count = #SendSentPetVisuals
	local columns = count <= 3 and math.max(count, 1) or 4
	local panelWidth = SendSuccessPetGrid.AbsoluteSize.X
	if panelWidth <= 0 then panelWidth = 578 end
	local cellWidth = math.floor((panelWidth - 20 - (columns - 1) * 10) / columns)
	cellWidth = math.clamp(cellWidth, 130, 130)
	SendSuccessPetGridLayout.CellSize = UDim2.fromOffset(130, 122)
	SendSuccessPetGrid.ClipsDescendants = true

	for order, visual in ipairs(SendSentPetVisuals) do
		local card = Instance.new("Frame", SendSuccessPetGrid)
		card.Name = "SentPetImage_" .. tostring(order)
		card.Size = UDim2.fromOffset(130, 122)
		card.BackgroundColor3 = Color3.fromRGB(9, 23, 39)
		card.BackgroundTransparency = 0
		card.BorderSizePixel = 0
		card.LayoutOrder = order
		card.ZIndex = 1254
		card.ClipsDescendants = true
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)

		-- Inventory-style border and subtle highlight.
		local stroke = Instance.new("UIStroke", card)
		stroke.Name = "PetCardStroke"
		stroke.Color = Color3.fromRGB(70, 145, 205)
		stroke.Thickness = 2
		stroke.Transparency = 0

		local effect = Instance.new("ImageLabel", card)
		effect.Name = "PetCardEffect"
		effect.Size = UDim2.fromScale(1, 1)
		effect.Position = UDim2.fromScale(0, 0)
		effect.BackgroundTransparency = 1
		effect.BorderSizePixel = 0
		effect.Image = "rbxassetid://131176354845909"
		effect.ImageColor3 = Color3.fromRGB(95, 190, 245)
		effect.ImageTransparency = 0.84
		effect.ScaleType = Enum.ScaleType.Tile
		effect.TileSize = UDim2.fromOffset(60, 60)
		effect.ZIndex = 1255
		effect.Active = false

		-- Dedicated avatar frame: keeps the pet icon centered and preserves a
		-- visible colored border/effect like the inventory cards.
		local avatarFrame = Instance.new("Frame", card)
		avatarFrame.Name = "PetAvatarFrame"
		avatarFrame.Size = UDim2.fromOffset(104, 64)
		avatarFrame.Position = UDim2.new(0.5, -52, 0, 5)
		avatarFrame.BackgroundColor3 = Color3.fromRGB(12, 32, 52)
		avatarFrame.BackgroundTransparency = 1
		avatarFrame.BorderSizePixel = 0
		avatarFrame.ClipsDescendants = true
		avatarFrame.ZIndex = 1256
		Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(0, 10)

		local avatarStroke = Instance.new("UIStroke", avatarFrame)
		avatarStroke.Name = "PetAvatarStroke"
		avatarStroke.Color = Color3.fromRGB(70, 145, 205)
		avatarStroke.Thickness = 2
		avatarStroke.Transparency = 1

		local shown = false
		if visual.Image and visual.Image ~= "" then
			local icon = Instance.new("ImageLabel", avatarFrame)
			icon.Name = "PetImage"
			icon.Size = UDim2.fromScale(1, 1)
			icon.Position = UDim2.fromScale(0, 0)
			icon.BackgroundTransparency = 1
			icon.BorderSizePixel = 0
			icon.ScaleType = Enum.ScaleType.Fit
			icon.Image = visual.Image
			icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
			icon.ImageTransparency = 0
			icon.ZIndex = 1257
			shown = true
		end

		if not shown and visual.Model then
			shown = SendSuccess_BuildModelViewport(avatarFrame, visual.Model)
		end

		if not shown then
			local fallback = Instance.new("TextLabel", avatarFrame)
			fallback.Size = UDim2.fromScale(1, 1)
			fallback.Position = UDim2.fromScale(0, 0)
			fallback.BackgroundTransparency = 1
			fallback.Text = "🐾"
			fallback.TextColor3 = Color3.fromRGB(190, 225, 255)
			fallback.Font = Enum.Font.FredokaOne
			fallback.TextSize = 42
			fallback.TextXAlignment = Enum.TextXAlignment.Center
			fallback.TextYAlignment = Enum.TextYAlignment.Center
			fallback.ZIndex = 1257
		end

		local name = Instance.new("TextLabel", card)
		name.Name = "PetName"
		name.Size = UDim2.new(1, -10, 0, 18)
		name.Position = UDim2.fromOffset(5, 70)
		name.BackgroundTransparency = 1
		name.Text = tostring(visual.Name or "Spawned Pet")
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.Font = Enum.Font.FredokaOne
		name.TextSize = 13
		name.TextXAlignment = Enum.TextXAlignment.Center
		name.TextYAlignment = Enum.TextYAlignment.Center
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 1258
		local nameStroke = Instance.new("UIStroke", name)
		nameStroke.Color = Color3.fromRGB(0, 0, 0)
		nameStroke.Thickness = 1.5

		local rate = Instance.new("Frame", card)
		rate.Name = "PetRateContainer"
		rate.Size = UDim2.new(1, -10, 0, 20)
		rate.Position = UDim2.fromOffset(5, 91)
		rate.BackgroundTransparency = 1
		rate.BorderSizePixel = 0
		rate.ZIndex = 1258
		rate.ClipsDescendants = true

		local rateContent = Instance.new("Frame", rate)
		rateContent.Name = "RateContent"
		rateContent.AutomaticSize = Enum.AutomaticSize.X
		rateContent.Size = UDim2.fromOffset(0, 20)
		rateContent.Position = UDim2.new(0.5, 0, 0.5, 0)
		rateContent.AnchorPoint = Vector2.new(0.5, 0.5)
		rateContent.BackgroundTransparency = 1
		rateContent.BorderSizePixel = 0
		rateContent.ZIndex = 1259

		local rateLayout = Instance.new("UIListLayout", rateContent)
		rateLayout.FillDirection = Enum.FillDirection.Horizontal
		rateLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		rateLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		rateLayout.Padding = UDim.new(0, 2)

		local money = Instance.new("ImageLabel", rateContent)
		money.Name = "MoneyIcon"
		money.Size = UDim2.fromOffset(18, 18)
		money.BackgroundTransparency = 1
		money.BorderSizePixel = 0
		money.Image = "rbxassetid://110828258588470"
		money.ImageColor3 = Color3.fromRGB(255, 255, 255)
		money.ImageTransparency = 0
		money.ScaleType = Enum.ScaleType.Fit
		money.Visible = true
		money.ZIndex = 1260

		local rateText = Instance.new("TextLabel", rateContent)
		rateText.Name = "PetRate"
		rateText.AutomaticSize = Enum.AutomaticSize.X
		rateText.Size = UDim2.new(0, 0, 1, 0)
		rateText.BackgroundTransparency = 1
		local rawRate = tostring(visual.Rate or "")
		if rawRate ~= "" and string.sub(rawRate, 1, 1) ~= "$" then rawRate = "$" .. rawRate end
		if rawRate ~= "" and not string.find(string.lower(rawRate), "/s", 1, true) then rawRate = rawRate .. "/s" end
		rateText.Text = rawRate
		rateText.TextColor3 = Color3.fromRGB(118, 255, 10)
		rateText.Font = Enum.Font.GothamBold
		rateText.TextSize = 17
		rateText.TextScaled = false
		rateText.TextWrapped = false
		rateText.TextXAlignment = Enum.TextXAlignment.Left
		rateText.TextYAlignment = Enum.TextYAlignment.Center
		rateText.TextTruncate = Enum.TextTruncate.AtEnd
		rateText.ZIndex = 1260
		local rateConstraint = Instance.new("UITextSizeConstraint", rateText)
		rateConstraint.MinTextSize = 12
		rateConstraint.MaxTextSize = 17
		local rateStroke = Instance.new("UIStroke", rateText)
		rateStroke.Color = Color3.fromRGB(0, 0, 0)
		rateStroke.Thickness = 1.5

	end
end

function ShowSendPlayerSuccess()
	SendLoadingPrompt.Visible = false
	SendPlayerPrompt.Visible = false
	SendGiftComposePrompt.Visible = false
	GiftPrompt.Visible = false
	BuyPrompt.Visible = false
	LoadingPrompt.Visible = false
	SuccessPrompt.Visible = false
	PurchaseSuccessfulPrompt.Visible = false

	-- You Sent a Pet is shown without the fullscreen black dimmer.
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1

	SendSuccessRecipient.Text = "to " .. (SelectedGiftDisplayName ~= "" and SelectedGiftDisplayName or "Player")
	SendSuccessPetNames.Text = ""
	SendSuccess_RenderPetImages()
	SendSuccessPrompt.Visible = true
	StartSendPlayerIndependentRibbon()
end

StartSendPlayerPostBuyFlow = function()
	BuyPrompt.Visible = false
	DarkOverlay.Visible = true
	DarkOverlay.BackgroundTransparency = 0.5
	if #SendSentPetVisuals == 0 and #SendGiftCompose_SelectedTools > 0 then
		SendGiftCompose_CaptureSentPetVisuals(SendGiftCompose_SelectedTools)
	end
	SendGiftCompose_ConsumeSelectedPets()
	SendLoadingRunId = SendLoadingRunId + 1
	local runId = SendLoadingRunId
	if SendLoadingConnection then
		SendLoadingConnection:Disconnect()
		SendLoadingConnection = nil
	end
	SendLoadingRing.Rotation = 0
	SendLoadingScale.Scale = 1
	SendLoadingPrompt.Visible = true
	SendPlayerPrompt.Visible = false
	SendGiftComposePrompt.Visible = false
	GiftPrompt.Visible = false
	SuccessPrompt.Visible = false
	PurchaseSuccessfulPrompt.Visible = false

	local started = os.clock()
	SendLoadingConnection = RunService.RenderStepped:Connect(function(dt)
		if runId ~= SendLoadingRunId or not SendLoadingPrompt.Visible then return end
		SendLoadingRing.Rotation = (SendLoadingRing.Rotation + 240 * dt) % 360
		local elapsed = os.clock() - started
		SendLoadingScale.Scale = 1 + math.sin(elapsed * math.pi * 2.4) * 0.10
	end)

	task.delay(2.0, function()
		if runId ~= SendLoadingRunId then return end
		if SendLoadingConnection then
			SendLoadingConnection:Disconnect()
			SendLoadingConnection = nil
		end
		SendLoadingPrompt.Visible = false
		SendLoadingScale.Scale = 1
		ShowSendPlayerSuccess()
	end)
end

SendSuccessOk.MouseEnter:Connect(function()
	SendSuccessOk.BackgroundColor3 = Color3.fromRGB(90, 195, 255)
end)
SendSuccessOk.MouseLeave:Connect(function()
	SendSuccessOk.BackgroundColor3 = Color3.fromRGB(60, 170, 255)
end)

SendSuccessOk.MouseButton1Click:Connect(function()
	-- IMPORTANT: do not stop the independent ribbon layer here.
	SendSuccessPrompt.Visible = false
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
	ActiveGiftSource = "Send"
	SendPlayer_RefreshRows()
	SendPlayerPrompt.Visible = true
end)

SendSuccessClose.MouseButton1Click:Connect(function()
	-- IMPORTANT: do not stop the independent ribbon layer here either.
	SendSuccessPrompt.Visible = false
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
	ActiveGiftSource = "Send"
	SendPlayer_RefreshRows()
	SendPlayerPrompt.Visible = true
end)

ShowSendPlayerPrompt = function()
	ActiveGiftSource = "Send"
	SuccessPrompt.Visible = false
	PurchaseSuccessfulPrompt.Visible = false
	BuyPrompt.Visible = false
	LoadingPrompt.Visible = false
	GiftPrompt.Visible = false
	if SendGiftComposePrompt then SendGiftComposePrompt.Visible = false end
	SendPlayer_RefreshRows()
	SendPlayer_ApplyTitle()
	SendPlayerPrompt.Visible = true
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
end

-- CLOSE ALL
-- ==========================================
local function ClosePopups(preserveConfetti)
	-- Some purchase-success transitions must let the ribbon finish naturally.
	-- Normal close actions still cancel it immediately.
	if not preserveConfetti then
		ConfettiRunId = ConfettiRunId + 1
		ConfettiHasStarted = false
	end

	DarkOverlay.Visible =
		false

	GiftPrompt.Visible =
		false

	if SendPlayerPrompt then
		SendPlayerPrompt.Visible = false
	end
	if SendGiftComposePrompt then
		SendGiftComposePrompt.Visible = false
	end

	BuyPrompt.Visible =
		false

	SuccessPrompt.Visible =
		false

	PurchaseSuccessfulPrompt.Visible =
		false

	LoadingPrompt.Visible =
		false

	if not preserveConfetti then
		ConfettiLayer.Visible = false

		for _, piece in ipairs(ConfettiPieces) do
			if piece.Gui and piece.Gui.Parent then
				piece.Gui:Destroy()
			end
		end

		table.clear(ConfettiPieces)

		if ConfettiConnection then
			ConfettiConnection:Disconnect()
			ConfettiConnection = nil
		end
	end
end

-- ==========================================
-- CONFETTI STATE
-- ==========================================
ConfettiLayer =
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

ConfettiColors = {
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

ConfettiPieces = {}
ConfettiConnection = nil
ConfettiRunId = 0
ConfettiHasStarted = false

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
	-- Hide Purchase Completed and remove the fullscreen dimmer. The ribbon is
	-- independent and continues until its own natural end.
	SuccessPrompt.Visible = false
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
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
	DarkOverlay.Visible = false
	DarkOverlay.BackgroundTransparency = 1
	-- Do not interrupt Gift Player's ribbon effect. It will stop itself only
	-- after all scheduled ribbons have spawned and all active ribbons have
	-- fallen completely off-screen.
	ClosePopups(true)
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

	if ActiveGiftSource == "SendCompose" then
		SendGiftComposePrompt.Visible = true
		SendPlayerPrompt.Visible = false
		GiftPrompt.Visible = false
		DarkOverlay.Visible = false
		DarkOverlay.BackgroundTransparency = 1
		return
	elseif ActiveGiftSource == "Send" then
		SendPlayer_RefreshRows()
		SendPlayerPrompt.Visible = true
		GiftPrompt.Visible = false
	else
		GiftPrompt.Visible = true
		SendPlayerPrompt.Visible = false
	end

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

	-- Never hook buttons belonging to this script's own UI. In particular,
	-- SpawnModelSendButton contains the word "send" and must open the
	-- independent Send Player panel instead of being intercepted as a game button.
	if ScreenGui and guiObject:IsDescendantOf(ScreenGui) then
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

-- Keep SEND proportional to the actual Shop button if that game UI becomes available later.
task.spawn(function()
	while ScreenGui.Parent do
		-- Keep SEND matched to the real Shop button dimensions whenever possible.
		if CurrentMainTab == "Spawn" or SpawnModelSendEverLocked then
			SpawnModel_ApplySendSize()
		end
		task.wait(1)
	end
end)

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
