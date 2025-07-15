-- Dull Hub by minihodari12 (GitHub)
-- Key: MinihodariDeveloper

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local correctKey = "MinihodariDeveloper"

-- Create main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DullHubGui"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 300)
frame.Position = UDim2.new(0.5, -175, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Dull Hub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Hover effect for buttons function
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = button.BackgroundColor3:Lerp(Color3.fromRGB(60, 60, 60), 0.4)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = button.BackgroundColor3:Lerp(Color3.fromRGB(40, 40, 40), 0.4)
    end)
end

-- Confirmation popup for close
closeBtn.MouseButton1Click:Connect(function()
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0, 280, 0, 130)
    confirmFrame.Position = UDim2.new(0.5, -140, 0.5, -65)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    confirmFrame.BorderSizePixel = 0
    confirmFrame.Parent = gui

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 60)
    msgLabel.Position = UDim2.new(0, 10, 0, 15)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = "Are you sure you want to close Dull Hub?"
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 18
    msgLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    msgLabel.TextWrapped = true
    msgLabel.Parent = confirmFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, 0, 0, 35)
    yesBtn.Position = UDim2.new(0.1, 0, 1, -45)
    yesBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 70)
    yesBtn.Text = "Yes"
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextSize = 18
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.BorderSizePixel = 0
    yesBtn.Parent = confirmFrame
    addHoverEffect(yesBtn)

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, 0, 0, 35)
    noBtn.Position = UDim2.new(0.55, 0, 1, -45)
    noBtn.BackgroundColor3 = Color3.fromRGB(130, 70, 70)
    noBtn.Text = "No"
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextSize = 18
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.BorderSizePixel = 0
    noBtn.Parent = confirmFrame
    addHoverEffect(noBtn)

    yesBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    noBtn.MouseButton1Click:Connect(function()
        confirmFrame:Destroy()
    end)
end)

-- Key input UI
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(1, -40, 0, 40)
keyLabel.Position = UDim2.new(0, 20, 0, 60)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Enter access key:"
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 18
keyLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = frame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0, 30)
keyInput.Position = UDim2.new(0.1, 0, 0, 105)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.ClearTextOnFocus = false
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 18
keyInput.PlaceholderText = "Enter key here..."
keyInput.Parent = frame
keyInput.Text = ""

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.8, 0, 0, 35)
submitBtn.Position = UDim2.new(0.1, 0, 0, 150)
submitBtn.BackgroundColor3 = Color3.fromRGB(55, 110, 220)
submitBtn.Text = "Submit"
submitBtn.Font = Enum.Font.GothamBold
submitBtn.TextSize = 18
submitBtn.TextColor3 = Color3.new(1, 1, 1)
submitBtn.BorderSizePixel = 0
submitBtn.Parent = frame
addHoverEffect(submitBtn)

-- Utility function to clear UI except title and close button
local function clearFrame()
    for _, child in ipairs(frame:GetChildren()) do
        if child ~= titleBar and child ~= closeBtn then
            child:Destroy()
        end
    end
end

-- Main menu UI
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BorderSizePixel = 0
    btn.Parent = frame
    addHoverEffect(btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Show text submenu with back button
local function showTextSubMenu(text)
    clearFrame()
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(0.9, 0, 0.6, 0)
    infoLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextWrapped = true
    infoLabel.Text = text
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 18
    infoLabel.TextColor3 = Color3.fromRGB(230,230,230)
    infoLabel.Parent = frame

    local backBtn = createButton("← Back", 250, function()
        showMainMenu()
    end)
end

-- Fly logic variables
local flying = false
local bodyPosition, bodyGyro
local moveVector = Vector3.new(0,0,0)

local function enableFly()
    local character = LocalPlayer.Character
    local HRP = character and character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyPosition.P = 3000
    bodyPosition.D = 500
    bodyPosition.Position = HRP.Position
    bodyPosition.Parent = HRP

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    bodyGyro.Parent = HRP

    RS:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value, function()
        if flying and HRP and bodyPosition and bodyGyro then
            local camCFrame = workspace.CurrentCamera.CFrame
            local direction = (camCFrame.LookVector * moveVector.Z) + (camCFrame.RightVector * moveVector.X)
            bodyPosition.Position = bodyPosition.Position + direction * 1.5
            bodyGyro.CFrame = camCFrame
        else
            RS:UnbindFromRenderStep("FlyControl")
        end
    end)
end

local function disableFly()
    RS:UnbindFromRenderStep("FlyControl")
    if bodyPosition then bodyPosition:Destroy() bodyPosition = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            moveVector = Vector3.new(0,0,0)
            enableFly()
        else
            disableFly()
        end
    elseif flying then
        if input.KeyCode == Enum.KeyCode.W then
            moveVector = Vector3.new(moveVector.X, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.S then
            moveVector = Vector3.new(moveVector.X, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.A then
            moveVector = Vector3.new(-1, 0, moveVector.Z)
        elseif input.KeyCode == Enum.KeyCode.D then
            moveVector = Vector3.new(1, 0, moveVector.Z)
        end
    end
end)

UIS.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if flying then
        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
            moveVector = Vector3.new(moveVector.X, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
            moveVector = Vector3.new(0, 0, moveVector.Z)
        end
    end
end)

-- Speed variable
local defaultSpeed = 16

-- Anti die function (respawn protection)
local function enableAntiDie()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    humanoid.Died:Connect(function()
        wait(0.5)
        LocalPlayer:LoadCharacter()
    end)
end

-- Cheats menu
local function showCheatMenu()
    clearFrame()

    createButton("Toggle Fly (or press F)", 40, function()
        flying = not flying
        if flying then
            moveVector = Vector3.new(0,0,0)
            enableFly()
        else
            disableFly()
        end
    end)

    createButton("Speed Boost (100 WalkSpeed)", 85, function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100
        end
    end)

    createButton("Set Speed", 130, function()
        clearFrame()

        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(1, -40, 0, 40)
        speedLabel.Position = UDim2.new(0, 20, 0, 30)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Enter speed value (default 16):"
        speedLabel.Font = Enum.Font.Gotham
        speedLabel.TextSize = 18
        speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        speedLabel.TextXAlignment = Enum.TextXAlignment.Left
        speedLabel.Parent = frame

        local speedInput = Instance.new("TextBox")
        speedInput.Size = UDim2.new(0.8, 0, 0, 35)
        speedInput.Position = UDim2.new(0.1, 0, 0, 75)
        speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedInput.ClearTextOnFocus = true
        speedInput.Font = Enum.Font.Gotham
        speedInput.TextSize = 18
        speedInput.PlaceholderText = tostring(defaultSpeed)
        speedInput.Parent = frame
        speedInput.Text = ""

        local applyBtn = createButton("Apply Speed", 130, function()
            local val = tonumber(speedInput.Text)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if val and humanoid and val > 0 and val <= 250 then
                humanoid.WalkSpeed = val
                showCheatMenu()
            else
                speedInput.Text = ""
                speedInput.PlaceholderText = "Enter a valid number (1-250)"
            end
        end)

        local backBtn = createButton("← Back", 180, function()
            showCheatMenu()
        end)
    end)

    createButton("Anti Die (Auto Respawn)", 175, function()
        enableAntiDie()
    end)

    createButton("← Back", 220, function()
        showMainMenu()
    end)
end

-- Main menu after correct key
function showMainMenu()
    clearFrame()

    createButton("Update Log", 50, function()
        showTextSubMenu(
            "- Fly toggle (button or F)\n" ..
            "- Fly movement: W,A,S,D\n" ..
            "- Speed Boost\n" ..
            "- Set custom speed\n" ..
            "- Anti Die (auto respawn)\n" ..
            "- Close confirmation popup"
        )
    end)

    createButton("Cheats", 100, function()
        showCheatMenu()
    end)

    createButton("Credits", 150, function()
        showTextSubMenu("Created by minihodari12\nGitHub: github.com/Minihodari12")
    end)
end

-- Submit key check
submitBtn.MouseButton1Click:Connect(function()
    if keyInput.Text == correctKey then
        keyLabel:Destroy()
        keyInput:Destroy()
        submitBtn:Destroy()
        showMainMenu()
    else
        keyInput.Text = ""
        keyInput.PlaceholderText = "Incorrect key! Try again..."
    end
end)
