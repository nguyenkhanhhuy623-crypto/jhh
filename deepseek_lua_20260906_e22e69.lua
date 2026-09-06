--deobf by Hihi (@reknoname)
-- Nâng cấp: key random, toggle menu, tele + auto spam F sau 0.5s, spam với tốc độ vừa phải

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("[Sinoracketeerin] Initializing...")

-- Xoá GUI cũ nếu có
PlayerGui:FindFirstChild("KeySys") and PlayerGui.KeySys:Destroy()
PlayerGui:FindFirstChild("Sinoracketeerin") and PlayerGui.Sinoracketeerin:Destroy()

-- =========================================================
-- KHỞI TẠO BIẾN TOÀN CỤC
-- =========================================================
local SpamFEnabled = false
local SpamEEnabled = false
local AutoClickEnabled = false
local spamFThread = nil
local spamEThread = nil
local autoClickThread = nil
local lastTeleportTime = 0

-- Tạo key ngẫu nhiên (6 ký tự)
math.randomseed(tick())
local function generateKey(length)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local key = ""
    for i = 1, length do
        key = key .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return key
end
local secretKey = generateKey(6)
print("[Sinoracketeerin] Secret Key: " .. secretKey)

-- Tạo phím tắt toggle menu ngẫu nhiên (A-Z, 0-9)
local keyCodes = {}
for i = 65, 90 do table.insert(keyCodes, Enum.KeyCode[string.char(i)]) end
for i = 48, 57 do table.insert(keyCodes, Enum.KeyCode[string.char(i)]) end
local toggleKey = keyCodes[math.random(1, #keyCodes)]
print("[Sinoracketeerin] Toggle Menu Key: " .. toggleKey.Name)

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
MainGui.Enabled = false  -- ẩn cho đến khi nhập key đúng

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 380)  -- thêm chiều cao cho label toggle
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -190)
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

-- TITLE COLOR ANIMATION (giữ nguyên nhưng có thể đơn giản hoá bằng vòng lặp)
task.spawn(function()
    for hue = 0.0025, 0.235, 0.0025 do
        MainTitle.TextColor3 = Color3.fromHSV(hue, 0.95, 1)
        task.wait(0.03)
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
TeleportButton.Text = "Teleport + Spam F"
TeleportButton.TextColor3 = Color3.fromRGB(245, 245, 245)
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)

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
SpamFButton.Text = "Spam F: DISABLED"
SpamFButton.TextColor3 = Color3.fromRGB(245, 245, 245)
SpamFButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)

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
SpamEButton.Text = "Spam E: DISABLED"
SpamEButton.TextColor3 = Color3.fromRGB(245, 245, 245)
SpamEButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)

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
AutoClickButton.Text = "Auto Click: DISABLED"
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
CreditsLabel.Size = UDim2.new(0.88, 0, 0, 20)
CreditsLabel.Position = UDim2.new(0.06, 0, 0, 300)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextSize = 14
CreditsLabel.Text = "Sino, fundyrbx"
CreditsLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Center

-- =========================================================
-- TOGGLE KEY LABEL
-- =========================================================
local ToggleKeyLabel = Instance.new("TextLabel", MainFrame)
ToggleKeyLabel.Size = UDim2.new(0.88, 0, 0, 20)
ToggleKeyLabel.Position = UDim2.new(0.06, 0, 0, 325)
ToggleKeyLabel.BackgroundTransparency = 1
ToggleKeyLabel.Font = Enum.Font.Gotham
ToggleKeyLabel.TextSize = 12
ToggleKeyLabel.Text = "Toggle Menu: " .. toggleKey.Name
ToggleKeyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
ToggleKeyLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Điều chỉnh lại chiều cao frame cho vừa (380 đã đủ)

-- =========================================================
-- HÀM SPAM
-- =========================================================
function startSpamF()
    if spamFThread then return end
    spamFThread = task.spawn(function()
        while SpamFEnabled do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false)
            task.wait(0.07)  -- tổng 0.12s, spam vừa phải
        end
        spamFThread = nil
    end)
end

function stopSpamF()
    SpamFEnabled = false
end

function startSpamE()
    if spamEThread then return end
    spamEThread = task.spawn(function()
        while SpamEEnabled do
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false)
            task.wait(0.07)
        end
        spamEThread = nil
    end)
end

function stopSpamE()
    SpamEEnabled = false
end

function startAutoClick()
    if autoClickThread then return end
    autoClickThread = task.spawn(function()
        while AutoClickEnabled do
            VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, true, false)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 0, false, false)
            task.wait(0.07)
        end
        autoClickThread = nil
    end)
end

function stopAutoClick()
    AutoClickEnabled = false
end

-- =========================================================
-- SỰ KIỆN NÚT
-- =========================================================

-- CHECK KEY
CheckKeyButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == secretKey then
        KeySystemGui.Enabled = false
        MainGui.Enabled = true
        print("[Sinoracketeerin] Key correct, menu opened.")
    else
        KeyInput.Text = "Wrong key!"
        task.delay(1, function()
            KeyInput.Text = ""
        end)
    end
end)

-- CLOSE BUTTON (chỉ ẩn menu, không huỷ)
CloseButton.MouseButton1Click:Connect(function()
    MainGui.Enabled = false
    print("[Sinoracketeerin] Menu hidden.")
end)

-- TELEPORT + SPAM F SAU 0.5s
TeleportButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    -- Teleport lên 20 đơn vị
    local pos = root.Position
    root.CFrame = CFrame.new(pos.X, pos.Y + 20, pos.Z)
    print("[Sinoracketeerin] Teleported up.")
    -- Sau 0.5s bật Spam F
    task.delay(0.5, function()
        SpamFEnabled = true
        startSpamF()
        SpamFButton.Text = "Spam F: ENABLED"
        SpamFButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        print("[Sinoracketeerin] Spam F enabled after teleport.")
    end)
end)

-- SPAM F TOGGLE
SpamFButton.MouseButton1Click:Connect(function()
    SpamFEnabled = not SpamFEnabled
    if SpamFEnabled then
        SpamFButton.Text = "Spam F: ENABLED"
        SpamFButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        startSpamF()
    else
        SpamFButton.Text = "Spam F: DISABLED"
        SpamFButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
        stopSpamF()
    end
end)

-- SPAM E TOGGLE
SpamEButton.MouseButton1Click:Connect(function()
    SpamEEnabled = not SpamEEnabled
    if SpamEEnabled then
        SpamEButton.Text = "Spam E: ENABLED"
        SpamEButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        startSpamE()
    else
        SpamEButton.Text = "Spam E: DISABLED"
        SpamEButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
        stopSpamE()
    end
end)

-- AUTO CLICK TOGGLE
AutoClickButton.MouseButton1Click:Connect(function()
    AutoClickEnabled = not AutoClickEnabled
    if AutoClickEnabled then
        AutoClickButton.Text = "Auto Click: ENABLED"
        AutoClickButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        startAutoClick()
    else
        AutoClickButton.Text = "Auto Click: DISABLED"
        AutoClickButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
        stopAutoClick()
    end
end)

-- =========================================================
-- TOGGLE MENU BẰNG PHÍM NGẪU NHIÊN
-- =========================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        MainGui.Enabled = not MainGui.Enabled
        print("[Sinoracketeerin] Menu toggled to: " .. tostring(MainGui.Enabled))
    end
end)

-- =========================================================
-- KHỞI TẠO HOÀN TẤT
-- =========================================================
print("[Sinoracketeerin] Loaded successfully.")