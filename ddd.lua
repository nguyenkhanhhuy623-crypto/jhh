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

if PlayerGui:FindFirstChild("KeySys") then
    PlayerGui.KeySys:Destroy()
end

PlayerGui:FindFirstChild("Sinoracketeerin")
if PlayerGui:FindFirstChild("Sinoracketeerin") then
    PlayerGui.Sinoracketeerin:Destroy()
end


-- =========================================================
-- MAIN UI (BILLBOARD GUI - BAY THEO TRÁI CẦU)
-- =========================================================

-- Tạo BillboardGui thay vì ScreenGui để UI bay theo nhân vật
local MainGui = Instance.new("BillboardGui")
MainGui.Name = "Sinoracketeerin"
MainGui.ResetOnSpawn = false
MainGui.Parent = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
MainGui.Enabled = true
MainGui.Size = UDim2.new(0, 330, 0, 360)
MainGui.Adornee = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
MainGui.StudsOffset = Vector3.new(0, 3, 0) -- Đặt UI phía trên nhân vật
MainGui.MaxDistance = 50


local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 360)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui


local MainFrameCorner = Instance.new("UICorner", MainFrame)
MainFrameCorner.CornerRadius = UDim.new(0, 10)


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
-- TITLE COLOR ANIMATION (ĐÃ RÚT GỌN)
-- =========================================================

task.spawn(function()
    local hue = 0
    while true do
        task.wait(0.03)
        hue = (hue + 0.0025) % 1
        MainTitle.TextColor3 = Color3.fromHSV(hue, 0.95, 1)
    end
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


-- =========================================================
-- THEO DÕI NHÂN VẬT ĐỂ CẬP NHẬT BILLBOARD
-- =========================================================

-- Hàm cập nhật Billboard khi nhân vật thay đổi
local function onCharacterAdded(character)
    MainGui.Parent = character
    MainGui.Adornee = character
end

-- Khi nhân vật spawn lần đầu
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Khi nhân vật respawn
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)


-- =========================================================
-- KEYBIND ĐỂ MỞ MENU (TÙY CHỌN)
-- =========================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then  -- Mở menu bằng Right Control
        if MainGui and MainGui.Parent then
            MainGui.Enabled = not MainGui.Enabled
            print("[Sinoracketeerin] Menu toggled: " .. tostring(MainGui.Enabled))
        end
    end
end)


print("[Sinoracketeerin] Sinoracketeerin loaded.")