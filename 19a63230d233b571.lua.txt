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


-- =========================================================
-- KEY SYSTEM UI
-- =========================================================

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
        local _ = CopyLinkButton.Parent

        CopyLinkButton.Text = "Copy Link"
    end)
end)


-- =========================================================
-- MAIN UI
-- =========================================================

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "Sinoracketeerin"
MainGui.ResetOnSpawn = false
MainGui.Parent = PlayerGui
MainGui.Enabled = false


local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 360)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -180)
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


-- =========================================================
-- TITLE
-- =========================================================

local MainTitle = Instance.new("TextLabel", MainFrame)
MainTitle.Size = UDim2.new(1, -60, 0, 48)
MainTitle.Position = UDim2.new(0, 12, 0, 8)
MainTitle.BackgroundTransparency = 1
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.TextSize = 24
MainTitle.Text = "Sinoracketeerin"
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)


-- =========================================================
-- TITLE COLOR ANIMATION
-- =========================================================

task.spawn(function()
    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.0025, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.005, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.007500000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.01, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.0125, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.015000000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.0175, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.020000000000000004, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.022500000000000003, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.025000000000000005, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.027500000000000007, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.030000000000000006, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.03250000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.03500000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.03750000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.04000000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.042500000000000005, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.045000000000000005, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.0475, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.05, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.0525, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.05499999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.05749999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.059999999999999984, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.06249999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.06499999999999997, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.06749999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.06999999999999997, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.07249999999999997, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.07499999999999996, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.07749999999999996, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.07999999999999995, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.08249999999999995, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.08499999999999995, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.08749999999999994, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.08999999999999994, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.09249999999999993, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.09499999999999993, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.09749999999999992, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.09999999999999992, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.10249999999999991, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.10499999999999991, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.10749999999999992, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1099999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1124999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1149999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1174999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.11999999999999988, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.12249999999999989, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.12499999999999988, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1274999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.12999999999999987, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.13249999999999987, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.13499999999999987, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.13749999999999987, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.13999999999999985, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.14249999999999985, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.14499999999999985, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.14749999999999985, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.14999999999999986, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.15249999999999983, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.15499999999999983, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.15749999999999983, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.15999999999999984, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1624999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1649999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.16749999999999982, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.16999999999999982, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.17249999999999982, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1749999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1774999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1799999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1824999999999998, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.18499999999999983, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.18749999999999983, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.18999999999999986, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.19249999999999987, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1949999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.1974999999999999, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.19999999999999993, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.20249999999999993, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.20499999999999996, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.20749999999999996, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.21, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.2125, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.21500000000000002, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.21750000000000003, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.22000000000000006, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.22250000000000006, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.2250000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.2275000000000001, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.23000000000000012, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.23250000000000012, 0.95, 1)

    task.wait(0.03)
    MainTitle.TextColor3 = Color3.fromHSV(0.23500000000000015, 0.95, 1)

    
end)


-- =========================================================
-- DIVIDER
-- =========================================================

local TopDivider = Instance.new("Frame", MainFrame)
TopDivider.Size = UDim2.new(0.42, 0, 0, 2)
TopDivider.Position = UDim2.new(0, 12, 0, 56)
TopDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)


local TopDividerCorner = Instance.new("UICorner", TopDivider)
TopDividerCorner.CornerRadius = UDim.new(0, 2)


-- =========================================================
-- CLOSE BUTTON
-- =========================================================

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


-- =========================================================
-- STATUS TEXT
-- =========================================================

local GuardStatus = Instance.new("TextLabel", MainFrame)
GuardStatus.Size = UDim2.new(0.88, 0, 0, 16)
GuardStatus.Position = UDim2.new(0.06, 0, 0, 64)
GuardStatus.BackgroundTransparency = 1
GuardStatus.Font = Enum.Font.Gotham
GuardStatus.TextSize = 10
GuardStatus.Text = "Menu guard: F/E disabled while menu open"
GuardStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
GuardStatus.TextXAlignment = Enum.TextXAlignment.Center


-- =========================================================
-- TELEPORT
-- =========================================================

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


-- =========================================================
-- SPAM F
-- =========================================================

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


-- =========================================================
-- SPAM E
-- =========================================================

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


-- =========================================================
-- AUTO CLICK
-- =========================================================

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


-- =========================================================
-- BOTTOM SECTION
-- =========================================================

local BottomDivider = Instance.new("Frame", MainFrame)
BottomDivider.Size = UDim2.new(0.88, 0, 0, 1)
BottomDivider.Position = UDim2.new(0.06, 0, 0, 290)
BottomDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)


local BottomDividerCorner = Instance.new("UICorner", BottomDivider)
BottomDividerCorner.CornerRadius = UDim.new(0, 2)


local CreditsLabel = Instance.new("TextLabel", MainFrame)
CreditsLabel.Size = UDim2.new(0.88, 0, 0, 40)
CreditsLabel.Position = UDim2.new(0.06, 0, 0, 300)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextSize = 14
CreditsLabel.Text = "Sino, fundyrbx"
CreditsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Center


-- =========================================================
-- BUTTON EVENTS
-- =========================================================

CloseButton.MouseButton1Click:Connect(function()
    MainGui:Destroy()

    print("[Sinoracketeerin] UI closed by user.")
end)


TeleportButton.MouseButton1Click:Connect(function()
end)


SpamFButton.MouseButton1Click:Connect(function()
end)


SpamEButton.MouseButton1Click:Connect(function()
end)


AutoClickButton.MouseButton1Click:Connect(function()
end)


-- =========================================================
-- INPUT EVENT
-- =========================================================

UserInputService.InputBegan:Connect(function(Input)
end)


CloseButton.MouseButton1Click:Connect(function()
end)


-- =========================================================
-- HEARTBEAT
-- =========================================================

RunService.Heartbeat:Connect(function()
end)


-- =========================================================
-- CHECK KEY
-- =========================================================

CheckKeyButton.MouseButton1Click:Connect(function()
end)


PlayerGui:FindFirstChild("KeySys")

print("[Sinoracketeerin] Sinoracketeerin loaded.")