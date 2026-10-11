local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- UI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidShowHub"
ScreenGui.Parent = game:CoreGui

-- Intro Screen
local IntroFrame = Instance.new("Frame")
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IntroFrame.BackgroundTransparency = 0
IntroFrame.Parent = ScreenGui

local IntroText = Instance.new("TextLabel")
IntroText.Size = UDim2.new(1, 0, 1, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "VoidShow"
IntroText.TextColor3 = Color3.fromRGB(140, 80, 255)
IntroText.TextSize = 1
IntroText.Font = Enum.Font.GothamBold
IntroText.TextTransparency = 1
IntroText.Parent = IntroFrame

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TitleBar.TextColor3 = Color3.fromRGB(180, 130, 255)
TitleBar.Text = "  VoidShow | MM2"
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.TextSize = 16
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(140, 80, 255)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 220)
Scroll.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.Parent = Scroll

-- Toggle Button Component
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Text = "  " .. name .. ": OFF"
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = Scroll

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = "  " .. name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(100, 50, 200) or Color3.fromRGB(35, 35, 45)
        callback(state)
    end)
end

-- Toggles
local espEnabled = false
createToggle("Role ESP", function(s) espEnabled = s end)

local farmEnabled = false
createToggle("Coin Farm", function(s) farmEnabled = s end)

local noclipEnabled = false
createToggle("Noclip", function(s) noclipEnabled = s end)

-- Feature Logic
RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Highlight") then
                p.Character.Highlight:Destroy()
            end
        end
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChild("Highlight") or Instance.new("Highlight", char)
            local backpack = player:FindFirstChild("Backpack")
            
            local isMurderer = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
            local isSheriff = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")

            if isMurderer then
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
            elseif isSheriff then
                highlight.FillColor = Color3.fromRGB(50, 150, 255)
            else
                highlight.FillColor = Color3.fromRGB(50, 255, 100)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if farmEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local coinContainer = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
            if coinContainer then
                for _, coin in ipairs(coinContainer:GetChildren()) do
                    if farmEnabled and coin:IsA("BasePart") and coin.Name == "Coin" then
                        hrp.CFrame = coin.CFrame
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)

-- Intro Animation Sequence
local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local textTween = TweenService:Create(IntroText, tweenInfo, {TextSize = 48, TextTransparency = 0})
textTween:Play()

task.wait(1.8)

local fadeOutText = TweenService:Create(IntroText, TweenInfo.new(0.5), {TextTransparency = 1})
local fadeOutBg = TweenService:Create(IntroFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1})

fadeOutText:Play()
fadeOutBg:Play()

fadeOutBg.Completed:Connect(function()
    IntroFrame:Destroy()
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openUI = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 260),
        Position = UDim2.new(0.5, -160, 0.5, -130)
    })
    openUI:Play()
end)
