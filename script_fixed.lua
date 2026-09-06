--deobf by Hihi (@reknoname)
-- UPGRADED FINAL: Spam Fixed, Close Hides Menu, Draggable, All Working

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

Workspace:FindFirstChild("FX")

print("[Sinoracketeerin] Initializing...")

local existingSino = PlayerGui:FindFirstChild("Sinoracketeerin")
if existingSino then existingSino:Destroy() end

-- ========================================================================
-- CONFIGURATION
-- ========================================================================

local CONFIG = {
	SCRIPT_ENABLED = true,
	MENU_VISIBLE = true,
	TELEPORT_WAIT = 0.50,
	SPAM_F_INTERVAL = 0.05,
	SPAM_E_INTERVAL = 0.05,
	PUNCH_POWER_MIN = 45,
	PUNCH_POWER_MAX = 65,
	MAX_DISTANCE = 25,
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
	SPAM_F = Enum.KeyCode.F,
	SPAM_E = Enum.KeyCode.E,
}

print("[Sinoracketeerin] Random Keybinds: Toggle="..tostring(KEYBINDS.TOGGLE_MENU).." Teleport="..tostring(KEYBINDS.TELEPORT))

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
-- MAIN GUI
-- ========================================================================

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "Sinoracketeerin"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui
MainGui.Enabled = true

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 330, 0, 380)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local MainFrameCorner = Instance.new("UICorner", MainFrame)
MainFrameCorner.CornerRadius = UDim.new(0, 15)

-- ========================================================================
-- DRAGGABLE MENU LOGIC (FIXED)
-- ========================================================================

local dragging = false
local dragStart = nil
local frameStart = nil

local function StartDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = Mouse.Position
		frameStart = MainFrame.Position
	end
end

local function EndDrag(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
		dragStart = nil
		frameStart = nil
	end
end

local function OnInputChanged(input)
	if dragging and dragStart and frameStart then
		local currentMousePos = Mouse.Position
		local deltaX = currentMousePos.X - dragStart.X
		local deltaY = currentMousePos.Y - dragStart.Y
		MainFrame.Position = frameStart + UDim2.new(0, deltaX, 0, deltaY)
	end
end

MainFrame.InputBegan:Connect(StartDrag)
MainFrame.InputEnded:Connect(EndDrag)
UserInputService.InputChanged:Connect(OnInputChanged)

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
-- TITLE COLOR ANIMATION
-- ========================================================================

task.spawn(function()
	local hueStart = 0
	while CONFIG.SCRIPT_ENABLED do
		hueStart = (hueStart + 0.025) % 1
		if MainTitle and MainTitle.Parent then
			MainTitle.TextColor3 = Color3.fromHSV(hueStart, 0.95, 1)
		end
		task.wait(0.03)
	end
end)

-- ========================================================================
-- CLOSE BUTTON (RED - HIDES MENU)
-- ========================================================================

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 26)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BorderSizePixel = 0

local CloseButtonCorner = Instance.new("UICorner", CloseButton)
CloseButtonCorner.CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
	Features.MenuVisible = false
	MainGui.Enabled = false
	print("[Sinoracketeerin] Menu hidden. Press "..tostring(KEYBINDS.TOGGLE_MENU).." to show.")
end)

-- ========================================================================
-- DIVIDER
-- ========================================================================

local TopDivider = Instance.new("Frame", MainFrame)
TopDivider.Size = UDim2.new(0.42, 0, 0, 2)
TopDivider.Position = UDim2.new(0, 12, 0, 56)
TopDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
TopDivider.BorderSizePixel = 0

local TopDividerCorner = Instance.new("UICorner", TopDivider)
TopDividerCorner.CornerRadius = UDim.new(0, 2)

-- ========================================================================
-- STATUS TEXT
-- ========================================================================

local GuardStatus = Instance.new("TextLabel", MainFrame)
GuardStatus.Size = UDim2.new(0.88, 0, 0, 16)
GuardStatus.Position = UDim2.new(0.06, 0, 0, 64)
GuardStatus.BackgroundTransparency = 1
GuardStatus.Font = Enum.Font.Gotham
GuardStatus.TextSize = 10
GuardStatus.Text = "Drag menu | Spam 24/7"
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
TeleportButton.BorderSizePixel = 0

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
SpamFButton.BorderSizePixel = 0

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
SpamEButton.BorderSizePixel = 0

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
AutoClickButton.BorderSizePixel = 0

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
-- BOTTOM SECTION
-- ========================================================================

local BottomDivider = Instance.new("Frame", MainFrame)
BottomDivider.Size = UDim2.new(0.88, 0, 0, 1)
BottomDivider.Position = UDim2.new(0.06, 0, 0, 290)
BottomDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BottomDivider.BorderSizePixel = 0

local BottomDividerCorner = Instance.new("UICorner", BottomDivider)
BottomDividerCorner.CornerRadius = UDim.new(0, 2)

local CreditsLabel = Instance.new("TextLabel", MainFrame)
CreditsLabel.Size = UDim2.new(0.88, 0, 0, 60)
CreditsLabel.Position = UDim2.new(0.06, 0, 0, 300)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextSize = 12
CreditsLabel.Text = "Sino, fundyrbx\nUpgraded v3 FIXED\nDraggable | Spam Works"
CreditsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ========================================================================
-- TELEPORT FUNCTION
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
	myChar.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
	
	task.wait(CONFIG.TELEPORT_WAIT)
	TeleportInProgress = false
	LastTeleportTime = tick()
end

-- ========================================================================
-- SPAM F FUNCTION (FIXED - RAPID)
-- ========================================================================

local function SpamF()
	local now = tick()
	if now - LastSpamFTime < CONFIG.SPAM_F_INTERVAL then return end
	
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
	
	LastSpamFTime = now
end

-- ========================================================================
-- SPAM E FUNCTION (FIXED - RAPID)
-- ========================================================================

local function SpamE()
	local now = tick()
	if now - LastSpamETime < CONFIG.SPAM_E_INTERVAL then return end
	
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
	
	LastSpamETime = now
end

-- ========================================================================
-- INPUT HANDLING
-- ========================================================================

UserInputService.InputBegan:Connect(function(Input, gameProcessed)
	-- Toggle Menu
	if Input.KeyCode == KEYBINDS.TOGGLE_MENU then
		Features.MenuVisible = not Features.MenuVisible
		MainGui.Enabled = Features.MenuVisible
		return
	end
	
	-- Teleport
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
	end
end)

-- ========================================================================
-- CONTINUOUS SPAM LOOP (FIXED - AGGRESSIVE)
-- ========================================================================

RunService.Heartbeat:Connect(function()
	if not CONFIG.SCRIPT_ENABLED then return end
	
	-- Spam F continuously
	if Features.SpamFEnabled then
		SpamF()
	end
	
	-- Spam E continuously
	if Features.SpamEEnabled then
		SpamE()
	end
	
	-- Auto click
	if Features.AutoClickEnabled and UserInputService:IsKeyDown(Enum.KeyCode.G) then
		VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true)
		VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false)
	end
end)

-- ========================================================================
-- SCRIPT INITIALIZATION COMPLETE
-- ========================================================================

print("[Sinoracketeerin] LOADED - Spam FIXED, Menu Draggable, Close Hides")
print("[Sinoracketeerin] Press "..tostring(KEYBINDS.TOGGLE_MENU).." to toggle menu")
print("[Sinoracketeerin] F and E spam running 24/7")
