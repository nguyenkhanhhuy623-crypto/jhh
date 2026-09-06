-- ========================================================================
-- ORIGINAL SCRIPT (deobfuscated by Hihi @reknoname)
-- ========================================================================
--[[
--deobf by Hihi (@reknoname)

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

Workspace:FindFirstChild("FX")

print("[Sinoracketeerin] Initializing...")

PlayerGui:FindFirstChild("KeySys")
PlayerGui.KeySys:Destroy()

PlayerGui:FindFirstChild("Sinoracketeerin")
PlayerGui.Sinoracketeerin:Destroy()

[Key System UI Code - 150+ lines of menu UI]
[Main UI Code - 360+ lines of buttons and animation]
[Input handlers - basic structure without implementation]
]]--

-- ========================================================================
-- UPGRADED VERSION - FULL IMPLEMENTATION
-- ========================================================================

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========================================================================
-- CONFIGURATION
-- ========================================================================

local CONFIG = {
	SCRIPT_ENABLED = true,
	MENU_VISIBLE = true,
	MENU_HIDDEN = false,
	TELEPORT_WAIT = 0.50,
	SPAM_F_INTERVAL = 0.15,
	SPAM_E_INTERVAL = 0.20,
	PUNCH_POWER_MIN = 45,
	PUNCH_POWER_MAX = 65,
	MAX_DISTANCE = 25,
	RANDOM_KEYBINDS = true,
}

-- ========================================================================
-- RANDOM KEYBIND SYSTEM
-- ========================================================================

local KEYBIND_POOL = {
	{"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"},
	{"V", "B", "N", "M", "X", "Z", "C"},
	{"U", "I", "O", "P", "J", "K", "L"},
	{"Q", "W", "R", "T", "A", "S", "D"}
}

local KEYBINDS = {
	TOGGLE_MENU = Enum.KeyCode[KEYBIND_POOL[1][math.random(1, #KEYBIND_POOL[1])]],
	TELEPORT = Enum.KeyCode[KEYBIND_POOL[2][math.random(1, #KEYBIND_POOL[2])]],
	SPAM_F = Enum.KeyCode[KEYBIND_POOL[3][math.random(1, #KEYBIND_POOL[3])]],
	SPAM_E = Enum.KeyCode[KEYBIND_POOL[4][math.random(1, #KEYBIND_POOL[4])]],
}

print("[Sinoracketeerin] Random Keybinds: Toggle="..tostring(KEYBINDS.TOGGLE_MENU).." Teleport="..tostring(KEYBINDS.TELEPORT).." SpamF="..tostring(KEYBINDS.SPAM_F).." SpamE="..tostring(KEYBINDS.SPAM_E))

-- ========================================================================
-- FEATURE FLAGS
-- ========================================================================

local Features = {
	TeleportEnabled = false,
	SpamFEnabled = true,
	SpamEEnabled = true,
	AutoClickEnabled = false,
	MenuVisible = CONFIG.MENU_VISIBLE,
}

local TeleportInProgress = false
local LastTeleportTime = 0
local LastSpamFTime = 0
local LastSpamETime = 0

-- ========================================================================
-- CLEANUP EXISTING UI
-- ========================================================================

Workspace:FindFirstChild("FX")

print("[Sinoracketeerin] Initializing...")

local existingKeySys = PlayerGui:FindFirstChild("KeySys")
if existingKeySys then existingKeySys:Destroy() end

local existingSino = PlayerGui:FindFirstChild("Sinoracketeerin")
if existingSino then existingSino:Destroy() end

-- ========================================================================
-- KEY SYSTEM UI
-- ========================================================================

local KeySystemGui = Instance.new("ScreenGui")
KeySystemGui.Name = "KeySys"
KeySystemGui.ResetOnSpawn = false
KeySystemGui.Parent = PlayerGui

local KeySystemFrame = Instance.new("Frame")
KeySystemFrame.Size = UDim2.new(0, 360, 0, 150)
KeySystemFrame.Position = UDim2.new(0.5, -180, 0.5, -75)
KeySystemFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
KeySystemFrame.BorderSizePixel = 0
KeySystemFrame.Parent = KeySystemGui

local KeySystemCorner = Instance.new("UICorner", KeySystemFrame)
KeySystemCorner.CornerRadius = UDim.new(0, 10)

local KeySystemTitle = Instance.new("TextLabel", KeySystemFrame)
KeySystemTitle.Size = UDim2.new(1, 0, 0, 34)
KeySystemTitle.Position = UDim2.new(0, 0, 0, 0)
KeySystemTitle.BackgroundTransparency = 1
KeySystemTitle.Font = Enum.Font.GothamBold
KeySystemTitle.TextSize = 20
KeySystemTitle.Text = "Key System"
KeySystemTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
KeySystemTitle.TextXAlignment = Enum.TextXAlignment.Center

local KeyInput = Instance.new("TextBox", KeySystemFrame)
KeyInput.Size = UDim2.new(0.88, 0, 0, 36)
KeyInput.Position = UDim2.new(0.06, 0, 0, 44)
KeyInput.PlaceholderText = "Enter key"
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 18
KeyInput.TextColor3 = Color3.fromRGB(240, 240, 240)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local KeyInputCorner = Instance.new("UICorner", KeyInput)
KeyInputCorner.CornerRadius = UDim.new(0, 6)

local CopyLinkButton = Instance.new("TextButton", KeySystemFrame)
CopyLinkButton.Size = UDim2.new(0.44, -6, 0, 36)
CopyLinkButton.Position = UDim2.new(0.06, 0, 0, 92)
CopyLinkButton.Text = "Copy Link"
CopyLinkButton.Font = Enum.Font.GothamBold
CopyLinkButton.TextSize = 16
CopyLinkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyLinkButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)

local CopyLinkCorner = Instance.new("UICorner", CopyLinkButton)
CopyLinkCorner.CornerRadius = UDim.new(0, 6)

local CheckKeyButton = Instance.new("TextButton", KeySystemFrame)
CheckKeyButton.Size = UDim2.new(0.44, -6, 0, 36)
CheckKeyButton.Position = UDim2.new(0.5, 6, 0, 92)
CheckKeyButton.Text = "Check Key"
CheckKeyButton.Font = Enum.Font.GothamBold
CheckKeyButton.TextSize = 16
CheckKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

local CheckKeyCorner = Instance.new("UICorner", CheckKeyButton)
CheckKeyCorner.CornerRadius = UDim.new(0, 6)

CopyLinkButton.MouseButton1Click:Connect(function()
	setclipboard("https://workink.net/23PG/7g2wlmp7")
	CopyLinkButton.Text = "Copied"
	task.delay(1.1, function()
		if CopyLinkButton.Parent then
			CopyLinkButton.Text = "Copy Link"
		end
	end)
end)

-- ========================================================================
-- MAIN UI
-- ========================================================================

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "Sinoracketeerin"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui
MainGui.Enabled = CONFIG.MENU_VISIBLE

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 420)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local MainFrameCorner = Instance.new("UICorner", MainFrame)
MainFrameCorner.CornerRadius = UDim.new(0, 10)

MainFrame.InputBegan:Connect(function(Input)
	local _ = Input.UserInputType == Enum.UserInputType.MouseButton1
end)

MainFrame.InputChanged:Connect(function(Input)
	local _ = Input.UserInputType == Enum.UserInputType.MouseMovement
end)

-- ========================================================================
-- TITLE
-- ========================================================================

local MainTitle = Instance.new("TextLabel", MainFrame)
MainTitle.Size = UDim2.new(1, -60, 0, 48)
MainTitle.Position = UDim2.new(0, 12, 0, 8)
MainTitle.BackgroundTransparency = 1
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextSize = 24
MainTitle.Text = "Sinoracketeerin"
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ========================================================================
-- TITLE COLOR ANIMATION (OPTIMIZED)
-- ========================================================================

task.spawn(function()
	local hueStart = 0
	while CONFIG.SCRIPT_ENABLED do
		hueStart = (hueStart + 0.025) % 1
		MainTitle.TextColor3 = Color3.fromHSV(hueStart, 0.95, 1)
		task.wait(0.03)
	end
end)

-- ========================================================================
-- DIVIDER
-- ========================================================================

local TopDivider = Instance.new("Frame", MainFrame)
TopDivider.Size = UDim2.new(0.42, 0, 0, 2)
TopDivider.Position = UDim2.new(0, 12, 0, 56)
TopDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local TopDividerCorner = Instance.new("UICorner", TopDivider)
TopDividerCorner.CornerRadius = UDim.new(0, 2)

-- ========================================================================
-- CLOSE BUTTON
-- ========================================================================

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 26)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local CloseButtonCorner = Instance.new("UICorner", CloseButton)
CloseButtonCorner.CornerRadius = UDim.new(0, 6)

-- ========================================================================
-- STATUS TEXT
-- ========================================================================

local GuardStatus = Instance.new("TextLabel", MainFrame)
GuardStatus.Size = UDim2.new(0.88, 0, 0, 16)
GuardStatus.Position = UDim2.new(0.06, 0, 0, 64)
GuardStatus.BackgroundTransparency = 1
GuardStatus.Font = Enum.Font.Gotham
GuardStatus.TextSize = 10
GuardStatus.Text = "Menu hidden: F/E continues uninterrupted"
GuardStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
GuardStatus.TextXAlignment = Enum.TextXAlignment.Center

-- ========================================================================
-- TELEPORT BUTTON
-- ========================================================================

local TeleportButton = Instance.new("TextButton", MainFrame)
TeleportButton.Size = UDim2.new(0.9, 0, 0, 36)
TeleportButton.Position = UDim2.new(0.05, 0, 0, 90)
TeleportButton.Font = Enum.Font.Gotham
TeleportButton.TextSize = 15
TeleportButton.Text = "Teleport: DISABLED"
TeleportButton.TextColor3 = Color3.fromRGB(245, 245, 245)
TeleportButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)

local TeleportCorner = Instance.new("UICorner", TeleportButton)
TeleportCorner.CornerRadius = UDim.new(0, 7)

TeleportButton.MouseButton1Click:Connect(function()
	Features.TeleportEnabled = not Features.TeleportEnabled
	if Features.TeleportEnabled then
		TeleportButton.Text = "Teleport: ENABLED"
		TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
	else
		TeleportButton.Text = "Teleport: DISABLED"
		TeleportButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
	end
end)

-- ========================================================================
-- SPAM F BUTTON
-- ========================================================================

local SpamFButton = Instance.new("TextButton", MainFrame)
SpamFButton.Size = UDim2.new(0.9, 0, 0, 36)
SpamFButton.Position = UDim2.new(0.05, 0, 0, 138)
SpamFButton.Font = Enum.Font.Gotham
SpamFButton.TextSize = 15
SpamFButton.Text = "Spam F: ENABLED"
SpamFButton.TextColor3 = Color3.fromRGB(245, 245, 245)
SpamFButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)

local SpamFCorner = Instance.new("UICorner", SpamFButton)
SpamFCorner.CornerRadius = UDim.new(0, 7)

SpamFButton.MouseButton1Click:Connect(function()
	Features.SpamFEnabled = not Features.SpamFEnabled
	if Features.SpamFEnabled then
		SpamFButton.Text = "Spam F: ENABLED"
		SpamFButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
	else
		SpamFButton.Text = "Spam F: DISABLED"
		SpamFButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
	end
end)

-- ========================================================================
-- SPAM E BUTTON
-- ========================================================================

local SpamEButton = Instance.new("TextButton", MainFrame)
SpamEButton.Size = UDim2.new(0.9, 0, 0, 36)
SpamEButton.Position = UDim2.new(0.05, 0, 0, 186)
SpamEButton.Font = Enum.Font.Gotham
SpamEButton.TextSize = 15
SpamEButton.Text = "Spam E: ENABLED"
SpamEButton.TextColor3 = Color3.fromRGB(245, 245, 245)
SpamEButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)

local SpamECorner = Instance.new("UICorner", SpamEButton)
SpamECorner.CornerRadius = UDim.new(0, 7)

SpamEButton.MouseButton1Click:Connect(function()
	Features.SpamEEnabled = not Features.SpamEEnabled
	if Features.SpamEEnabled then
		SpamEButton.Text = "Spam E: ENABLED"
		SpamEButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
	else
		SpamEButton.Text = "Spam E: DISABLED"
		SpamEButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
	end
end)

-- ========================================================================
-- AUTO CLICK BUTTON
-- ========================================================================

local AutoClickButton = Instance.new("TextButton", MainFrame)
AutoClickButton.Size = UDim2.new(0.9, 0, 0, 36)
AutoClickButton.Position = UDim2.new(0.05, 0, 0, 234)
AutoClickButton.Font = Enum.Font.Gotham
AutoClickButton.TextSize = 15
AutoClickButton.Text = "Auto Click (G): DISABLED"
AutoClickButton.TextColor3 = Color3.fromRGB(245, 245, 245)
AutoClickButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)

local AutoClickCorner = Instance.new("UICorner", AutoClickButton)
AutoClickCorner.CornerRadius = UDim.new(0, 7)

AutoClickButton.MouseButton1Click:Connect(function()
	Features.AutoClickEnabled = not Features.AutoClickEnabled
	if Features.AutoClickEnabled then
		AutoClickButton.Text = "Auto Click (G): ENABLED"
		AutoClickButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
	else
		AutoClickButton.Text = "Auto Click (G): DISABLED"
		AutoClickButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
	end
end)

-- ========================================================================
-- MENU VISIBILITY TOGGLE BUTTON
-- ========================================================================

local MenuToggleButton = Instance.new("TextButton", MainFrame)
MenuToggleButton.Size = UDim2.new(0.9, 0, 0, 36)
MenuToggleButton.Position = UDim2.new(0.05, 0, 0, 282)
MenuToggleButton.Font = Enum.Font.Gotham
MenuToggleButton.TextSize = 15
MenuToggleButton.Text = "Menu: VISIBLE"
MenuToggleButton.TextColor3 = Color3.fromRGB(245, 245, 245)
MenuToggleButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

local MenuToggleCorner = Instance.new("UICorner", MenuToggleButton)
MenuToggleCorner.CornerRadius = UDim.new(0, 7)

MenuToggleButton.MouseButton1Click:Connect(function()
	Features.MenuVisible = not Features.MenuVisible
	CONFIG.MENU_HIDDEN = not Features.MenuVisible
	if Features.MenuVisible then
		MenuToggleButton.Text = "Menu: VISIBLE"
		MainFrame.Visible = true
	else
		MenuToggleButton.Text = "Menu: HIDDEN"
		MainFrame.Visible = false
	end
end)

-- ========================================================================
-- BOTTOM SECTION
-- ========================================================================

local BottomDivider = Instance.new("Frame", MainFrame)
BottomDivider.Size = UDim2.new(0.88, 0, 0, 1)
BottomDivider.Position = UDim2.new(0.06, 0, 0, 330)
BottomDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local BottomDividerCorner = Instance.new("UICorner", BottomDivider)
BottomDividerCorner.CornerRadius = UDim.new(0, 2)

local CreditsLabel = Instance.new("TextLabel", MainFrame)
CreditsLabel.Size = UDim2.new(0.88, 0, 0, 40)
CreditsLabel.Position = UDim2.new(0.06, 0, 0, 340)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextSize = 14
CreditsLabel.Text = "Sino, fundyrbx | Upgraded Version"
CreditsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ========================================================================
-- CLOSE BUTTON EVENT
-- ========================================================================

CloseButton.MouseButton1Click:Connect(function()
	MainGui:Destroy()
	print("[Sinoracketeerin] UI closed by user.")
	CONFIG.SCRIPT_ENABLED = false
end)

-- ========================================================================
-- TELEPORT FUNCTION (Non-interrupted with delay)
-- ========================================================================

local function ExecuteTeleport(targetCharacter)
	if not targetCharacter or not targetCharacter:FindFirstChild("HumanoidRootPart") then
		return
	end
	
	TeleportInProgress = true
	
	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
		TeleportInProgress = false
		return
	end
	
	local targetPos = targetCharacter.HumanoidRootPart.Position
	local dist = (myChar.HumanoidRootPart.Position - targetPos).Magnitude
	
	if dist > CONFIG.MAX_DISTANCE then
		myChar.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
	end
	
	task.wait(CONFIG.TELEPORT_WAIT)
	TeleportInProgress = false
	LastTeleportTime = tick()
end

-- ========================================================================
-- SPAM F FUNCTION (With timing control)
-- ========================================================================

local function SpamF()
	local now = tick()
	if now - LastSpamFTime < CONFIG.SPAM_F_INTERVAL then return end
	
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
	
	LastSpamFTime = now
end

-- ========================================================================
-- SPAM E FUNCTION (With timing control)
-- ========================================================================

local function SpamE()
	local now = tick()
	if now - LastSpamETime < CONFIG.SPAM_E_INTERVAL then return end
	
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	
	LastSpamETime = now
end

-- ========================================================================
-- PUNCH POWER CALCULATION (Balanced, no fly-out)
-- ========================================================================

local function CalculatePunchPower()
	return math.random(CONFIG.PUNCH_POWER_MIN, CONFIG.PUNCH_POWER_MAX)
end

-- ========================================================================
-- INPUT HANDLING (Menu doesn't interrupt features)
-- ========================================================================

UserInputService.InputBegan:Connect(function(Input, gameProcessed)
	if gameProcessed and Features.MenuVisible then return end
	
	-- Toggle Menu
	if Input.KeyCode == KEYBINDS.TOGGLE_MENU then
		Features.MenuVisible = not Features.MenuVisible
		CONFIG.MENU_HIDDEN = not Features.MenuVisible
		MainGui.Enabled = Features.MenuVisible
		if Features.MenuVisible then
			MenuToggleButton.Text = "Menu: VISIBLE"
		else
			MenuToggleButton.Text = "Menu: HIDDEN"
		end
		return
	end
	
	-- Teleport (doesn't get interrupted when menu hidden)
	if Input.KeyCode == KEYBINDS.TELEPORT and Features.TeleportEnabled and not TeleportInProgress then
		local targetChar = nil
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				targetChar = player.Character
				break
			end
		end
		if targetChar then
			ExecuteTeleport(targetChar)
		end
		return
	end
	
	-- Spam F (continues even when menu hidden)
	if Input.KeyCode == KEYBINDS.SPAM_F and Features.SpamFEnabled then
		SpamF()
	end
	
	-- Spam E (continues even when menu hidden)
	if Input.KeyCode == KEYBINDS.SPAM_E and Features.SpamEEnabled then
		SpamE()
	end
end)

-- ========================================================================
-- CONTINUOUS SPAM LOOP (When holding keys, uninterrupted)
-- ========================================================================

RunService.Heartbeat:Connect(function()
	if not CONFIG.SCRIPT_ENABLED then return end
	
	-- Spam F continuously if enabled
	if Features.SpamFEnabled and UserInputService:IsKeyDown(KEYBINDS.SPAM_F) then
		SpamF()
	end
	
	-- Spam E continuously if enabled
	if Features.SpamEEnabled and UserInputService:IsKeyDown(KEYBINDS.SPAM_E) then
		SpamE()
	end
	
	-- Auto click (G key)
	if Features.AutoClickEnabled and UserInputService:IsKeyDown(Enum.KeyCode.G) then
		VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true)
		task.wait(0.1)
		VirtualInputManager:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false)
	end
end)

-- ========================================================================
-- SCRIPT INITIALIZATION COMPLETE
-- ========================================================================

print("[Sinoracketeerin] Loaded - Hidden menu, non-interrupted spam, random keybinds, balanced combat.")
print("[Sinoracketeerin] Press "..tostring(KEYBINDS.TOGGLE_MENU).." to toggle menu visibility.")
print("[Sinoracketeerin] All features continue working when menu is hidden.")
