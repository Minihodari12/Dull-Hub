-- Dull Hub Roblox Script by minihodari12 (GitHub)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Variables
local flying = false
local flySpeed = 50
local moveVector = Vector3.new()
local noclipEnabled = false
local infiniteJumpEnabled = false
local antiDieEnabled = false

-- Create main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Utility: Make draggable frame
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                math.clamp(startPos.X.Scale + delta.X / workspace.CurrentCamera.ViewportSize.X, 0, 1),
                startPos.X.Offset + delta.X,
                math.clamp(startPos.Y.Scale + delta.Y / workspace.CurrentCamera.ViewportSize.Y, 0, 1),
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Clear all children of a frame
local function clearFrame()
    for _, child in pairs(frame:GetChildren()) do
        child:Destroy()
    end
end

-- Create a styled button with text and Y position
local function createButton(text, yPos, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 300, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.AutoButtonColor = false
    btn.Parent = frame

    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    btn.MouseButton1Click:Connect(onClick)

    return btn
end

-- Variables for GUI
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 460)
frame.Position = UDim2.new(0.5, -170, 0.5, -230)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui

makeDraggable(frame)

-- TextLabel Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Dull Hub"
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(170, 220, 255)
title.Parent = frame

-- Variables
local flyingConnection

-- Fly related functions
local function enableFly()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local HRP = character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    flyingConnection = RS.Heartbeat:Connect(function(deltaTime)
        if not flying then return end
        local camCFrame = workspace.CurrentCamera.CFrame
        local moveDir = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            HRP.Velocity = moveDir * flySpeed
        else
            HRP.Velocity = Vector3.new(0,0,0)
        end
    end)
    humanoid.PlatformStand = true
end

local function disableFly()
    if flyingConnection then
        flyingConnection:Disconnect()
        flyingConnection = nil
    end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- Anti Die: auto respawn
local function onCharacterDied()
    if antiDieEnabled then
        wait(1)
        LocalPlayer:LoadCharacter()
    end
end

local function enableAntiDie()
    if antiDieEnabled then return end
    antiDieEnabled = true
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Died:Connect(onCharacterDied)
    end
    -- Listen for new characters as well
    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(onCharacterDied)
    end)
end

-- Noclip functions
local function setNoclip(state)
    noclipEnabled = state
    if state then
        RS:BindToRenderStep("Noclip", Enum.RenderPriority.Character.Value, function()
            local character = LocalPlayer.Character
            if not character then return end
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        RS:UnbindFromRenderStep("Noclip")
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Infinite Jump
local infiniteJumpConnection
local function enableInfiniteJump()
    if infiniteJumpEnabled then return end
    infiniteJumpEnabled = true
    infiniteJumpConnection = UIS.JumpRequest:Connect(function()
        if infiniteJumpEnabled then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function disableInfiniteJump()
    infiniteJumpEnabled = false
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
end

-- Teleport to mouse
local function teleportToMouse()
    local mouse = LocalPlayer:GetMouse()
    local character = LocalPlayer.Character
    local HRP = character and character:FindFirstChild("HumanoidRootPart")
    if not HRP or not mouse then return end
    local targetPos = mouse.Hit.p
    HRP.CFrame = CFrame.new(targetPos + Vector3.new(0,3,0))
end

-- Clear frame children
local function clearFrameChildren()
    for _, child in pairs(frame:GetChildren()) do
        if child ~= title then
            child:Destroy()
        end
    end
end

-- GUI menus --

-- Main menu
local function showMainMenu()
    clearFrameChildren()

    createButton("Update Log", 70, function()
        showUpdateLog()
    end)

    createButton("Cheats", 120, function()
        showCheatMenu()
    end)

    createButton("Credits", 170, function()
        showCredits()
    end)

    -- Close button X top-right
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "X"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.Parent = frame

    closeBtn.MouseEnter:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        clearFrameChildren()
        local confirmLabel = Instance.new("TextLabel")
        confirmLabel.Size = UDim2.new(1, -40, 0, 50)
        confirmLabel.Position = UDim2.new(0, 20, 0, 70)
        confirmLabel.BackgroundTransparency = 1
        confirmLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        confirmLabel.Font = Enum.Font.GothamBold
        confirmLabel.TextSize = 20
        confirmLabel.Text = "Are you sure you want to close Dull Hub?"
        confirmLabel.Parent = frame

        createButton("Yes, Close", 130, function()
            screenGui:Destroy()
        end)

        createButton("No, Back", 180, function()
            showMainMenu()
        end)
    end)
end

-- Update Log menu
function showUpdateLog()
    clearFrameChildren()

    local logText = [[
- Added Fly with WASD + Space/Ctrl + F toggle
- Speed Boost & Set Speed options
- Anti Die (auto respawn)
- Jump Boost
- Noclip toggle
- Infinite Jump toggle
- Teleport to mouse
- Reset character
- Draggable GUI and confirmation on close
]]

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 350)
    label.Position = UDim2.new(0, 20, 0, 60)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextWrapped = true
    label.Text = logText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    createButton("← Back", 420, function()
        showMainMenu()
    end)
end

-- Credits menu
function showCredits()
    clearFrameChildren()

    local creditText = [[
Script by minihodari12
GitHub: github.com/Minihodari12
Thanks for using Dull Hub!
]]

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 200)
    label.Position = UDim2.new(0, 20, 0, 80)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 220, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.TextWrapped = true
    label.Text = creditText
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    createButton("← Back", 300, function()
        showMainMenu()
    end)
end

-- Cheat Menu with many options
function showCheatMenu()
    clearFrameChildren()

    createButton(flying and "Disable Fly (or press F)" or "Enable Fly (or press F)", 30, function()
        flying = not flying
        if flying then
            enableFly()
        else
            disableFly()
        end
        showCheatMenu()
    end)

    createButton("Speed Boost (WalkSpeed 100)", 80, function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100
        end
    end)

    createButton("Set Speed", 130, function()
        clearFrameChildren()

        local speedLabel = Instance.new("TextLabel")
        speedLabel.Size = UDim2.new(1, -40, 0, 40)
        speedLabel.Position = UDim2.new(0, 20, 0, 30)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "Enter speed value (1-250):"
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
        speedInput.PlaceholderText = "16"
        speedInput.Parent = frame
        speedInput.Text = ""

        createButton("Apply Speed", 130, function()
            local val = tonumber(speedInput.Text)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if val and humanoid and val > 0 and val <= 250 then
                humanoid.WalkSpeed = val
                showCheatMenu()
            else
                speedInput.Text = ""
                speedInput.PlaceholderText = "Invalid number (1-250)"
            end
        end)

        createButton("← Back", 180, function()
            showCheatMenu()
        end)
    end)

    createButton("Anti Die (Auto Respawn)", 180, function()
        enableAntiDie()
    end)

    createButton("Jump Boost (JumpPower 100)", 230, function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = 100
        end
    end)

    createButton(noclipEnabled and "Disable Noclip" or "Enable Noclip", 280, function()
        setNoclip(not noclipEnabled)
        showCheatMenu()
    end)

    createButton(infiniteJumpEnabled and "Disable Infinite Jump" or "Enable Infinite Jump", 330, function()
        if infiniteJumpEnabled then
            disableInfiniteJump()
        else
            enableInfiniteJump()
        end
        showCheatMenu()
    end)

    createButton("Teleport To Mouse", 380, function()
        teleportToMouse()
    end)

    createButton("Reset Character", 430, function()
        LocalPlayer:LoadCharacter()
    end)

    createButton("← Back", 470, function()
        showMainMenu()
    end)
end

-- Key check UI

local function showKeyInput()
    frame.Position = UDim2.new(0.5, -170, 0.5, -80)
    frame.Size = UDim2.new(0, 340, 0, 160)
    clearFrameChildren()

    local prompt = Instance.new("TextLabel")
    prompt.Size = UDim2.new(1, -40, 0, 50)
    prompt.Position = UDim2.new(0, 20, 0, 20)
    prompt.BackgroundTransparency = 1
    prompt.TextColor3 = Color3.fromRGB(230, 230, 230)
    prompt.Font = Enum.Font.GothamBold
    prompt.TextSize = 22
    prompt.Text = "Enter Access Key:"
    prompt.Parent = frame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 75)
    keyInput.BackgroundColor3 = Color3.fromRGB(30,30,30)
    keyInput.TextColor3 = Color3.fromRGB(255,255,255)
    keyInput.PlaceholderText = "Type your key here"
    keyInput.ClearTextOnFocus = true
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextSize = 20
    keyInput.Parent = frame

    local submitBtn = createButton("Submit", 120, function()
        local key = keyInput.Text
        if key == "MinihodariDeveloper" then
            -- Reset frame size and position
            frame.Size = UDim2.new(0, 340, 0, 460)
            frame.Position = UDim2.new(0.5, -170, 0.5, -230)
            showMainMenu()
        else
            keyInput.Text = ""
            keyInput.PlaceholderText = "Wrong Key! Try again."
        end
    end)
    submitBtn.Parent = frame
end

-- Bind toggle fly to F
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            enableFly()
        else
            disableFly()
        end
        showCheatMenu()
    end
end)

-- Start with key input prompt
showKeyInput()
