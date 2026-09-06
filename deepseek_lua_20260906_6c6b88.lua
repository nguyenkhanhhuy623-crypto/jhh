-- Deobf by Hihi (@reknoname) – chỉnh sửa bởi trợ lý
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

print("[Sinoracketeerin] Initializing...")

-- Xóa UI cũ nếu có
if PlayerGui:FindFirstChild("Sinoracketeerin") then
    PlayerGui.Sinoracketeerin:Destroy()
end

-- =========================================================
-- TẠO BILLBOARD GUI (UI bay theo nhân vật)
-- =========================================================
local MainGui = Instance.new("BillboardGui")
MainGui.Name = "Sinoracketeerin"
MainGui.ResetOnSpawn = false
MainGui.Enabled = true
MainGui.Size = UDim2.new(0, 330, 0, 360)
MainGui.StudsOffset = Vector3.new(0, 3, 0)
MainGui.MaxDistance = 50

-- Gắn vào nhân vật (sẽ được cập nhật khi respawn)
local function attachToCharacter(character)
    if not character then return end
    MainGui.Parent = character
    MainGui.Adornee = character
end

if LocalPlayer.Character then
    attachToCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(attachToCharacter)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 330, 0, 360)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- =========================================================
-- TIÊU ĐỀ (màu chuyển động)
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

task.spawn(function()
    local hue = 0
    while MainGui and MainGui.Parent do
        task.wait(0.03)
        hue = (hue + 0.0025) % 1
        MainTitle.TextColor3 = Color3.fromHSV(hue, 0.95, 1)
    end
end)

-- =========================================================
-- ĐƯỜNG KẺ, NÚT ĐÓNG, STATUS
-- =========================================================
local TopDivider = Instance.new("Frame", MainFrame)
TopDivider.Size = UDim2.new(0.42, 0, 0, 2)
TopDivider.Position = UDim2.new(0, 12, 0, 56)
TopDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Instance.new("UICorner", TopDivider).CornerRadius = UDim.new(0, 2)

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 30, 0, 26)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

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
-- NÚT CHỨC NĂNG
-- =========================================================
local function createButton(parent, text, yPos, colorOff, colorOn, onClick)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(245, 245, 245)
    btn.BackgroundColor3 = colorOff
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- =========================================================
-- BIẾN TRẠNG THÁI
-- =========================================================
local spamFActive = false
local spamEActive = false
local autoClickActive = false
local spamFThread = nil
local spamEThread = nil
local autoClickThread = nil

-- =========================================================
-- HÀM TELEPORT ĐẾN "Dan cong" (trái cầu)
-- =========================================================
local function teleportToDanCong()
    local character = LocalPlayer.Character
    if not character then
        print("[Sinoracketeerin] Không tìm thấy nhân vật.")
        return
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        print("[Sinoracketeerin] Không tìm thấy HumanoidRootPart.")
        return
    end

    -- Tìm đối tượng có tên chứa "Dan cong" trong Workspace (có thể là Part hoặc Model)
    local target = nil
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name and string.find(obj.Name, "Dan cong") then
            target = obj
            break
        end
    end

    if not target then
        print("[Sinoracketeerin] Không tìm thấy 'Dan cong' trong Workspace.")
        return
    end

    local targetPos
    if target:IsA("BasePart") then
        targetPos = target.Position
    elseif target:IsA("Model") and target.PrimaryPart then
        targetPos = target.PrimaryPart.Position
    elseif target:IsA("Model") then
        -- Lấy vị trí trung bình của các Part con
        local parts = target:GetDescendants()
        local count = 0
        local sum = Vector3.new(0,0,0)
        for _, p in ipairs(parts) do
            if p:IsA("BasePart") then
                sum = sum + p.Position
                count = count + 1
            end
        end
        if count > 0 then
            targetPos = sum / count
        else
            print("[Sinoracketeerin] Không tìm thấy Part nào trong Model.")
            return
        end
    else
        print("[Sinoracketeerin] Đối tượng 'Dan cong' không phải Part hay Model hợp lệ.")
        return
    end

    -- Teleport nhân vật
    hrp.CFrame = CFrame.new(targetPos)
    print("[Sinoracketeerin] Đã teleport đến 'Dan cong' tại vị trí:", targetPos)
end

-- =========================================================
-- HÀM TOGGLE SPAM PHÍM
-- =========================================================
local function toggleSpamF()
    spamFActive = not spamFActive
    if spamFActive then
        -- Bật spam
        SpamFButton.Text = "Spam F: ENABLED"
        SpamFButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        spamFThread = task.spawn(function()
            while spamFActive do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
                task.wait(0.05)
            end
        end)
    else
        -- Tắt spam
        SpamFButton.Text = "Spam F: DISABLED"
        SpamFButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
        if spamFThread then
            task.cancel(spamFThread)
            spamFThread = nil
        end
    end
end

local function toggleSpamE()
    spamEActive = not spamEActive
    if spamEActive then
        SpamEButton.Text = "Spam E: ENABLED"
        SpamEButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        spamEThread = task.spawn(function()
            while spamEActive do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
                task.wait(0.05)
            end
        end)
    else
        SpamEButton.Text = "Spam E: DISABLED"
        SpamEButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
        if spamEThread then
            task.cancel(spamEThread)
            spamEThread = nil
        end
    end
end

local function toggleAutoClick()
    autoClickActive = not autoClickActive
    if autoClickActive then
        AutoClickButton.Text = "Auto Click: ENABLED"
        AutoClickButton.BackgroundColor3 = Color3.fromRGB(0, 160, 60)
        autoClickThread = task.spawn(function()
            while autoClickActive do
                local mousePos = UserInputService:GetMouseLocation()
                VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, true, mousePos.X, mousePos.Y, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, false, mousePos.X, mousePos.Y, 0)
                task.wait(0.05)
            end
        end)
    else
        AutoClickButton.Text = "Auto Click: DISABLED"
        AutoClickButton.BackgroundColor3 = Color3.fromRGB(165, 25, 25)
        if autoClickThread then
            task.cancel(autoClickThread)
            autoClickThread = nil
        end
    end
end

-- =========================================================
-- TẠO CÁC NÚT
-- =========================================================
local TeleportButton = createButton(MainFrame, "Teleport to Dan Cong", 90, Color3.fromRGB(0, 80, 200), nil, function()
    teleportToDanCong()
end)

local SpamFButton = createButton(MainFrame, "Spam F: DISABLED", 138, Color3.fromRGB(165, 25, 25), nil, toggleSpamF)

local SpamEButton = createButton(MainFrame, "Spam E: DISABLED", 186, Color3.fromRGB(165, 25, 25), nil, toggleSpamE)

local AutoClickButton = createButton(MainFrame, "Auto Click: DISABLED", 234, Color3.fromRGB(165, 25, 25), nil, toggleAutoClick)

-- =========================================================
-- PHẦN CUỐI (CREDITS)
-- =========================================================
local BottomDivider = Instance.new("Frame", MainFrame)
BottomDivider.Size = UDim2.new(0.88, 0, 0, 1)
BottomDivider.Position = UDim2.new(0.06, 0, 0, 290)
BottomDivider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Instance.new("UICorner", BottomDivider).CornerRadius = UDim.new(0, 2)

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
-- SỰ KIỆN ĐÓNG UI
-- =========================================================
CloseButton.MouseButton1Click:Connect(function()
    MainGui:Destroy()
    print("[Sinoracketeerin] UI closed by user.")
end)

-- =========================================================
-- KEYBIND MỞ MENU (Right Control)
-- =========================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if MainGui and MainGui.Parent then
            MainGui.Enabled = not MainGui.Enabled
            print("[Sinoracketeerin] Menu toggled: " .. tostring(MainGui.Enabled))
        end
    end
end)

print("[Sinoracketeerin] Sinoracketeerin loaded.")