-- Dull Hub by minihodari12 (GitHub)
-- Key: MinihodariDeveloper

local correctKey = "MinihodariDeveloper"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 250)
frame.Position = UDim2.new(0.5, -160, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Dull Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

title.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local closeButton = Instance.new("TextButton", frame)
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)

closeButton.MouseButton1Click:Connect(function()
    local confirm = Instance.new("Frame", gui)
    confirm.Size = UDim2.new(0, 250, 0, 120)
    confirm.Position = UDim2.new(0.5, -125, 0.5, -60)
    confirm.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local label = Instance.new("TextLabel", confirm)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Position = UDim2.new(0, 0, 0, 10)
    label.Text = "Are you sure you want to close Dull Hub?"
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextWrapped = true

    local yes = Instance.new("TextButton", confirm)
    yes.Text = "Yes"
    yes.Size = UDim2.new(0.45, 0, 0, 30)
    yes.Position = UDim2.new(0.05, 0, 0.6, 0)
    yes.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    yes.TextColor3 = Color3.new(1,1,1)

    local no = Instance.new("TextButton", confirm)
    no.Text = "No"
    no.Size = UDim2.new(0.45, 0, 0, 30)
    no.Position = UDim2.new(0.5, 0, 0.6, 0)
    no.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    no.TextColor3 = Color3.new(1,1,1)

    yes.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    no.MouseButton1Click:Connect(function()
        confirm:Destroy()
    end)
end)

-- Ask for key
local keyBox = Instance.new("TextBox", frame)
keyBox.Size = UDim2.new(0.8, 0, 0, 30)
keyBox.Position = UDim2.new(0.1, 0, 0.3, 0)
keyBox.PlaceholderText = "Enter Key Here"
keyBox.Text = ""

local confirmButton = Instance.new("TextButton", frame)
confirmButton.Size = UDim2.new(0.8, 0, 0, 30)
confirmButton.Position = UDim2.new(0.1, 0, 0.5, 0)
confirmButton.Text = "Submit"

confirmButton.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        keyBox:Destroy()
        confirmButton:Destroy()
        showMainMenu()
    else
        LocalPlayer:Kick("Wrong key. Ask correct key from the owner!")
    end
end)

function showMainMenu()
    for _, child in pairs(frame:GetChildren()) do
        if not child:IsA("TextLabel") and child ~= closeButton then
            child:Destroy()
        end
    end

    local function createButton(txt, yPos, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Text = txt
        btn.Size = UDim2.new(0.8, 0, 0, 30)
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(callback)
    end

    createButton("Update Log", 50, function()
        showSubMenu("Latest update: Fly toggle, speed, anti-die, close confirm")
    end)

    createButton("Cheats", 90, function()
        showCheatMenu()
    end)

    createButton("Credits", 130, function()
        showSubMenu("Made by minihodari12 (GitHub)")
    end)
end

function showSubMenu(text)
    for _, child in pairs(frame:GetChildren()) do
        if not child:IsA("TextLabel") and child ~= closeButton then
            child:Destroy()
        end
    end
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.9, 0, 0.6, 0)
    lbl.Position = UDim2.new(0.05, 0, 0.2, 0)
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.BackgroundTransparency = 1
    lbl.TextWrapped = true

    local back = Instance.new("TextButton", frame)
    back.Text = "← Back"
    back.Size = UDim2.new(0.8, 0, 0, 30)
    back.Position = UDim2.new(0.1, 0, 0.8, 0)
    back.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    back.TextColor3 = Color3.new(1, 1, 1)
    back.MouseButton1Click:Connect(showMainMenu)
end

function showCheatMenu()
    for _, child in pairs(frame:GetChildren()) do
        if not child:IsA("TextLabel") and child ~= closeButton then
            child:Destroy()
        end
    end

    local flying = false
    local BP, BG

    local function enableFly()
        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not HRP then return end
        BP = Instance.new("BodyPosition", HRP)
        BP.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BP.Position = HRP.Position
        BG = Instance.new("BodyGyro", HRP)
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = workspace.CurrentCamera.CFrame

        RS.RenderStepped:Connect(function()
            if flying and HRP and BP and BG then
                BP.Position = HRP.Position + Vector3.new(0, 5, 0)
                BG.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
    end

    local function disableFly()
        if BP then BP:Destroy() end
        if BG then BG:Destroy() end
        BP, BG = nil, nil
    end

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.F then
            flying = not flying
            if flying then enableFly() else disableFly() end
        end
    end)

    local function createButton(txt, yPos, callback)
        local btn = Instance.new("TextButton", frame)
        btn.Text = txt
        btn.Size = UDim2.new(0.8, 0, 0, 30)
        btn.Position = UDim2.new(0.1, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(callback)
    end

    createButton("Fly (Toggle)", 50, function()
        flying = not flying
        if flying then enableFly() else disableFly() end
    end)

    createButton("Speed Boost", 90, function()
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end)

    createButton("Set Speed", 130, function()
        local spd = tonumber(game:GetService("StarterGui"):PromptInput("Set Speed (number):"))
        if spd then
            LocalPlayer.Character.Humanoid.WalkSpeed = spd
        end
    end)

    createButton("← Back", 170, showMainMenu)

    -- Anti-die
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(function()
            wait(1)
            LocalPlayer:LoadCharacter()
        end)
    end)
end
