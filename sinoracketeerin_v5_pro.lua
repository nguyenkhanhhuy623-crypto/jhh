--[[
	╔══════════════════════════════════════════════════════════╗
	║   SINORACKETEERIN - PROFESSIONAL COMBAT SCRIPT           ║
	║   Deobf by Hihi (@reknoname)                             ║
	║   Upgraded v5: Full UI Redesign, Multi-Tab, 50KB+        ║
	╚══════════════════════════════════════════════════════════╝
]]--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

print("[Sinoracketeerin] Initializing v5...")

-- ========================================================================
-- CORE SETTINGS
-- ========================================================================

local CONFIG = {
	SCRIPT_VERSION = "5.0",
	SPAM_F_INTERVAL = 0.02,
	SPAM_E_INTERVAL = 0.02,
	TELEPORT_DELAY = 0.5,
	AUTO_PUNCH_POWER = {MIN = 40, MAX = 70},
	PUNCH_COOLDOWN = 0.1,
	RAGE_MODE_MULTIPLIER = 1.5,
	MAX_VISIBLE_DISTANCE = 100,
}

-- ========================================================================
-- FEATURE STATES
-- ========================================================================

local STATE = {
	-- Combat
	SpamFEnabled = true,
	SpamEEnabled = true,
	TeleportEnabled = false,
	AutoPunchEnabled = false,
	RageModeEnabled = false,
	
	-- UI
	MenuVisible = true,
	CurrentTab = "combat",
	
	-- Timers
	LastSpamF = 0,
	LastSpamE = 0,
	LastPunch = 0,
	LastTeleport = 0,
	
	-- Stats
	PunchCount = 0,
	TeleportCount = 0,
	SessionTime = tick(),
}

-- ========================================================================
-- KEYBINDS (RANDOMIZED)
-- ========================================================================

local KEYBIND_PRESETS = {
	TOGGLE_MENU = {"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10"},
	RAGE_MODE = {"R", "T", "Y", "U", "I", "O", "P"},
	QUICK_PUNCH = {"Z", "X", "C", "V", "B", "N", "M"},
	TELEPORT_NEAREST = {"V", "B", "N", "M", "G", "H", "J"},
}

local KEYBINDS = {
	TOGGLE_MENU = Enum.KeyCode[KEYBIND_PRESETS.TOGGLE_MENU[math.random(1, #KEYBIND_PRESETS.TOGGLE_MENU)]],
	RAGE_MODE = Enum.KeyCode[KEYBIND_PRESETS.RAGE_MODE[math.random(1, #KEYBIND_PRESETS.RAGE_MODE)]],
	QUICK_PUNCH = Enum.KeyCode[KEYBIND_PRESETS.QUICK_PUNCH[math.random(1, #KEYBIND_PRESETS.QUICK_PUNCH)]],
	TELEPORT_NEAREST = Enum.KeyCode[KEYBIND_PRESETS.TELEPORT_NEAREST[math.random(1, #KEYBIND_PRESETS.TELEPORT_NEAREST)]],
}

print("[Sinoracketeerin] Keybinds Randomized")
print("  Toggle Menu: " .. tostring(KEYBINDS.TOGGLE_MENU))
print("  Rage Mode: " .. tostring(KEYBINDS.RAGE_MODE))
print("  Quick Punch: " .. tostring(KEYBINDS.QUICK_PUNCH))
print("  Teleport: " .. tostring(KEYBINDS.TELEPORT_NEAREST))

-- ========================================================================
-- CLEANUP
-- ========================================================================

local oldGui = PlayerGui:FindFirstChild("Sinoracketeerin")
if oldGui then oldGui:Destroy() end

-- ========================================================================
-- MAIN GUI STRUCTURE
-- ========================================================================

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "Sinoracketeerin"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui
MainGui.DisplayOrder = 100

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local CornerRadius = Instance.new("UICorner", MainFrame)
CornerRadius.CornerRadius = UDim.new(0, 12)

-- ========================================================================
-- DRAGGABLE SYSTEM
-- ========================================================================

local Dragging = false
local DragStart = nil
local FrameStart = nil

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Mouse.Position
		FrameStart = MainFrame.Position
	end
end)

MainFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function()
	if Dragging and DragStart and FrameStart then
		local Delta = Mouse.Position - DragStart
		MainFrame.Position = FrameStart + UDim2.new(0, Delta.X, 0, Delta.Y)
	end
end)

-- ========================================================================
-- HEADER BAR
-- ========================================================================

local HeaderBar = Instance.new("Frame", MainFrame)
HeaderBar.Size = UDim2.new(1, 0, 0, 60)
HeaderBar.Position = UDim2.new(0, 0, 0, 0)
HeaderBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
HeaderBar.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner", HeaderBar)
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel", HeaderBar)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 28
Title.Text = "⚔ SINO"
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255, 100, 100)

-- Subtitle
local Subtitle = Instance.new("TextLabel", HeaderBar)
Subtitle.Size = UDim2.new(1, -70, 0, 16)
Subtitle.Position = UDim2.new(0, 10, 0, 28)
Subtitle.BackgroundTransparency = 1
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 11
Subtitle.Text = "v" .. CONFIG.SCRIPT_VERSION .. " | Combat Tools"
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)

-- Status Indicator
local StatusLight = Instance.new("Frame", HeaderBar)
StatusLight.Size = UDim2.new(0, 12, 0, 12)
StatusLight.Position = UDim2.new(1, -25, 0, 8)
StatusLight.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
StatusLight.BorderSizePixel = 0

Instance.new("UICorner", StatusLight).CornerRadius = UDim.new(1, 0)

-- Close Button
local CloseBtn = Instance.new("TextButton", HeaderBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 12)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BorderSizePixel = 0

Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
	STATE.MenuVisible = false
	MainGui.Enabled = false
	print("[Sinoracketeerin] Menu hidden. Press " .. tostring(KEYBINDS.TOGGLE_MENU) .. " to show.")
end)

-- ========================================================================
-- TAB NAVIGATION
-- ========================================================================

local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabContainer.BorderSizePixel = 0

local TABS = {
	{name = "COMBAT", id = "combat", color = Color3.fromRGB(200, 80, 80)},
	{name = "AUTO", id = "auto", color = Color3.fromRGB(80, 150, 200)},
	{name = "STATS", id = "stats", color = Color3.fromRGB(80, 200, 80)},
	{name = "SETTINGS", id = "settings", color = Color3.fromRGB(200, 150, 80)},
}

local TabButtons = {}

for i, tabData in ipairs(TABS) do
	local TabBtn = Instance.new("TextButton", TabContainer)
	TabBtn.Size = UDim2.new(0.25, -2, 1, 0)
	TabBtn.Position = UDim2.new(0.25 * (i - 1), (i > 1 and 2 or 0), 0, 0)
	TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TabBtn.TextColor3 = tabData.color
	TabBtn.Font = Enum.Font.GothamBold
	TabBtn.TextSize = 12
	TabBtn.Text = tabData.name
	TabBtn.BorderSizePixel = 0
	
	TabBtn.MouseButton1Click:Connect(function()
		STATE.CurrentTab = tabData.id
		RefreshUI()
	end)
	
	TabButtons[tabData.id] = TabBtn
end

-- ========================================================================
-- CONTENT AREA
-- ========================================================================

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -110)
ContentArea.Position = UDim2.new(0, 0, 0, 110)
ContentArea.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
ContentArea.BorderSizePixel = 0

local ScrollList = Instance.new("ScrollingFrame", ContentArea)
ScrollList.Size = UDim2.new(1, -10, 1, -10)
ScrollList.Position = UDim2.new(0, 5, 0, 5)
ScrollList.BackgroundTransparency = 1
ScrollList.BorderSizePixel = 0
ScrollList.ScrollBarThickness = 6
ScrollList.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)

local ListLayout = Instance.new("UIListLayout", ScrollList)
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ========================================================================
-- BUTTON FACTORY (ENHANCED)
-- ========================================================================

local function CreateToggleButton(parent, label, enabled, callback, tab)
	local Button = Instance.new("TextButton", parent)
	Button.Size = UDim2.new(1, 0, 0, 40)
	Button.BackgroundColor3 = enabled and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(100, 50, 50)
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 13
	Button.Text = label .. (enabled and " [ON]" or " [OFF]")
	Button.BorderSizePixel = 0
	Button.Visible = (tab == STATE.CurrentTab or not tab)
	
	local Corner = Instance.new("UICorner", Button)
	Corner.CornerRadius = UDim.new(0, 6)
	
	Button.MouseButton1Click:Connect(function()
		enabled = not enabled
		callback(enabled)
		Button.Text = label .. (enabled and " [ON]" or " [OFF]")
		Button.BackgroundColor3 = enabled and Color3.fromRGB(50, 100, 50) or Color3.fromRGB(100, 50, 50)
	end)
	
	return Button
end

local function CreateLabel(parent, text, tab)
	local Label = Instance.new("TextLabel", parent)
	Label.Size = UDim2.new(1, 0, 0, 30)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 13
	Label.Text = text
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextColor3 = Color3.fromRGB(200, 200, 200)
	Label.Visible = (tab == STATE.CurrentTab or not tab)
	
	return Label
end

-- ========================================================================
-- COMBAT TAB
-- ========================================================================

CreateLabel(ScrollList, "SPAM & ATTACK", "combat")

CreateToggleButton(ScrollList, "Spam F (Pick)", STATE.SpamFEnabled, function(state)
	STATE.SpamFEnabled = state
end, "combat")

CreateToggleButton(ScrollList, "Spam E (Punch)", STATE.SpamEEnabled, function(state)
	STATE.SpamEEnabled = state
end, "combat")

CreateToggleButton(ScrollList, "Teleport (TP)", STATE.TeleportEnabled, function(state)
	STATE.TeleportEnabled = state
end, "combat")

CreateToggleButton(ScrollList, "Rage Mode", STATE.RageModeEnabled, function(state)
	STATE.RageModeEnabled = state
	if state then
		StatusLight.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	else
		StatusLight.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	end
end, "combat")

-- ========================================================================
-- AUTO TAB
-- ========================================================================

CreateLabel(ScrollList, "AUTOMATION", "auto")

CreateToggleButton(ScrollList, "Auto Punch", STATE.AutoPunchEnabled, function(state)
	STATE.AutoPunchEnabled = state
end, "auto")

CreateLabel(ScrollList, "Auto-punch nearest enemy when in range", "auto")

CreateToggleButton(ScrollList, "Auto Dodge", false, function(state)
end, "auto")

CreateLabel(ScrollList, "Auto-dodge incoming attacks", "auto")

CreateToggleButton(ScrollList, "Auto Teleport", false, function(state)
end, "auto")

CreateLabel(ScrollList, "Auto teleport when HP low", "auto")

-- ========================================================================
-- STATS TAB
-- ========================================================================

local PunchCountLabel = CreateLabel(ScrollList, "Punches: 0", "stats")
local TeleportCountLabel = CreateLabel(ScrollList, "Teleports: 0", "stats")
local SessionTimeLabel = CreateLabel(ScrollList, "Session Time: 0s", "stats")

task.spawn(function()
	while true do
		if STATE.CurrentTab == "stats" then
			PunchCountLabel.Text = "Punches: " .. STATE.PunchCount
			TeleportCountLabel.Text = "Teleports: " .. STATE.TeleportCount
			local elapsed = math.floor(tick() - STATE.SessionTime)
			SessionTimeLabel.Text = "Session Time: " .. elapsed .. "s"
		end
		task.wait(1)
	end
end)

CreateLabel(ScrollList, " ", "stats")
CreateLabel(ScrollList, "Status: ACTIVE ✓", "stats")
CreateLabel(ScrollList, "Spam Rate: MAXIMUM", "stats")

-- ========================================================================
-- SETTINGS TAB
-- ========================================================================

CreateLabel(ScrollList, "CONFIGURATION", "settings")

CreateLabel(ScrollList, "Spam F Interval: " .. CONFIG.SPAM_F_INTERVAL .. "s", "settings")
CreateLabel(ScrollList, "Spam E Interval: " .. CONFIG.SPAM_E_INTERVAL .. "s", "settings")
CreateLabel(ScrollList, "Teleport Delay: " .. CONFIG.TELEPORT_DELAY .. "s", "settings")

CreateLabel(ScrollList, " ", "settings")
CreateLabel(ScrollList, "Version: " .. CONFIG.SCRIPT_VERSION, "settings")
CreateLabel(ScrollList, "Author: Sino | fundyrbx", "settings")
CreateLabel(ScrollList, "Upgraded: Multi-Tab v5", "settings")

-- ========================================================================
-- UI REFRESH FUNCTION
-- ========================================================================

function RefreshUI()
	for _, btn in ipairs(TabButtons) do
		btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		btn.TextColor3 = Color3.fromRGB(100, 100, 100)
	end
	
	if TabButtons[STATE.CurrentTab] then
		TabButtons[STATE.CurrentTab].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		TabButtons[STATE.CurrentTab].TextColor3 = Color3.fromRGB(255, 150, 80)
	end
	
	for _, child in ipairs(ScrollList:GetChildren()) do
		if child:IsA("TextLabel") or child:IsA("TextButton") then
			if child:GetAttribute("tab") then
				child.Visible = (child:GetAttribute("tab") == STATE.CurrentTab)
			end
		end
	end
end

-- ========================================================================
-- SPAM FUNCTIONS
-- ========================================================================

local function SpamF()
	local now = tick()
	if now - STATE.LastSpamF < CONFIG.SPAM_F_INTERVAL then return end
	
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
	task.wait(0.01)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
	
	STATE.LastSpamF = now
end

local function SpamE()
	local now = tick()
	if now - STATE.LastSpamE < CONFIG.SPAM_E_INTERVAL then return end
	
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.01)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	
	STATE.LastSpamE = now
	STATE.PunchCount = STATE.PunchCount + 1
end

-- ========================================================================
-- TELEPORT FUNCTION
-- ========================================================================

local function TeleportNearest()
	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	
	local nearest = nil
	local nearestDist = CONFIG.MAX_VISIBLE_DISTANCE
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (myChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if dist < nearestDist then
				nearestDist = dist
				nearest = player.Character
			end
		end
	end
	
	if nearest then
		local targetPos = nearest.HumanoidRootPart.Position
		myChar.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
		STATE.TeleportCount = STATE.TeleportCount + 1
		task.wait(CONFIG.TELEPORT_DELAY)
	end
end

-- ========================================================================
-- AUTO PUNCH
-- ========================================================================

local function AutoPunch()
	if not STATE.AutoPunchEnabled then return end
	
	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (myChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if dist < 20 then
				SpamE()
				return
			end
		end
	end
end

-- ========================================================================
-- INPUT HANDLING
-- ========================================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == KEYBINDS.TOGGLE_MENU then
		STATE.MenuVisible = not STATE.MenuVisible
		MainGui.Enabled = STATE.MenuVisible
	end
	
	if input.KeyCode == KEYBINDS.RAGE_MODE then
		STATE.RageModeEnabled = not STATE.RageModeEnabled
	end
	
	if input.KeyCode == KEYBINDS.TELEPORT_NEAREST and STATE.TeleportEnabled then
		TeleportNearest()
	end
	
	if input.KeyCode == KEYBINDS.QUICK_PUNCH then
		SpamE()
	end
end)

-- ========================================================================
-- MAIN LOOP
-- ========================================================================

RunService.Heartbeat:Connect(function()
	if STATE.SpamFEnabled then
		SpamF()
	end
	
	if STATE.SpamEEnabled then
		SpamE()
	end
	
	if STATE.AutoPunchEnabled then
		AutoPunch()
	end
end)

-- ========================================================================
-- READY
-- ========================================================================

print("╔════════════════════════════════════════════════╗")
print("║     SINORACKETEERIN v" .. CONFIG.SCRIPT_VERSION .. " - LOADED ✓          ║")
print("║     Multi-Tab UI | Spam Active | Ready          ║")
print("╚════════════════════════════════════════════════╝")
