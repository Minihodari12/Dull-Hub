-- Dull Hub Roblox Script by minihodari12 (GitHub)
-- Avaimen pitää olla "MinihodariDeveloper"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Vars
local flying = false
local flySpeed = 50
local noclipEnabled = false
local infiniteJumpEnabled = false
local antiDieEnabled = false
local flyConnection
local infiniteJumpConnection

-- Luodaan ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Draggable Frame funktio
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

-- Luodaan pääframe
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 460)
frame.Position = UDim2.new(0.5, -170, 0.5, -230)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui
makeDraggable(frame)

-- Otsikko
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Dull Hub"
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(170, 220, 255)
title.Parent = frame

-- Apufunktio napin luomiseen
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
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- Tyhjentää frame:n sisällön paitsi otsikon
local function clearFrame()
    for _, child in pairs(frame:GetChildren()) do
        if child ~= title then
            child:Destroy()
        end
    end
end

-- Lentotoiminnallisuus
local function enableFly()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local HRP = character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end

    flyConnection = RS.Heartbeat:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        if moveDir.Magnitude > 0 then
            HRP.Velocity = moveDir.Unit * flySpeed
        else
            HRP.Velocity = Vector3.new(0,0,0)
        end
    end)
    humanoid.PlatformStand = true
end

local function disableFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.PlatformStand = false
    end
end

-- Anti die eli automaattinen respawn
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
    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(onCharacterDied)
    end)
end

-- Noclip
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

-- Infinite jump
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

-- Näytä päävalikko
local function showMainMenu()
    clearFrame()
    createButton("Update Log", 70, showUpdateLog)
    createButton("Cheats", 120, showCheatMenu)
    createButton("Credits", 170, showCredits)

    -- Sulje X-nappi oikeaan yläkulmaan
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
        closeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    end)
    closeBtn.MouseLeave:Connect(function()
        closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        -- Vahvistusikkuna sulkemiselle
        clearFrame()
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -40, 0, 80)
        label.Position = UDim2.new(0, 20, 0, 180)
        label.BackgroundTransparency = 1
        label.Text = "Are you sure you want to close Dull Hub?"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.TextWrapped = true
        label.Parent = frame

        local yesBtn = createButton("Yes, Close", 270, function()
            screenGui:Destroy()
        end)
        local noBtn = createButton("No, Back", 320, showMainMenu)
    end)
end

-- Update Log näkymä
function showUpdateLog()
    clearFrame()
    local logLabel = Instance.new("TextLabel")
    logLabel.Size = UDim2.new(1, -40, 0, 300)
    logLabel.Position = UDim2.new(0, 20, 0, 70)
    logLabel.BackgroundTransparency = 1
    logLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    logLabel.Font = Enum.Font.Gotham
    logLabel.TextSize = 16
    logLabel.TextWrapped = true
    logLabel.Text = [[
Dull Hub Update Log:

v1.0 - Initial release
v1.1 - Added Fly with WASD + Space + Ctrl, toggled with Fly button or F key
v1.2 - Added Speed Boost and Set Speed options
v1.3 - Added Anti Die (auto respawn)
v1.4 - Added Noclip, Infinite Jump, Teleport to Mouse
v1.5 - Added GUI drag and confirmation dialog on close
    ]]
    logLabel.Parent = frame

    createButton("< Back", 380, showMainMenu)
end

-- Credits näkymä
function showCredits()
    clearFrame()
    local creditsLabel = Instance.new("TextLabel")
    creditsLabel.Size = UDim2.new(1, -40, 0, 300)
    creditsLabel.Position = UDim2.new(0, 20, 0, 70)
    creditsLabel.BackgroundTransparency = 1
    creditsLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    creditsLabel.Font = Enum.Font.Gotham
    creditsLabel.TextSize = 18
    creditsLabel.TextWrapped = true
    creditsLabel.Text = [[
Dull Hub

Developer: minihodari12
GitHub: https://github.com/Minihodari12
Thank you for using Dull Hub!
    ]]
    creditsLabel.Parent = frame

    createButton("< Back", 380, showMainMenu)
end

-- Cheat-valikko
function showCheatMenu()
    clearFrame()

    -- Fly nappi
    local flyBtn = createButton("Toggle Fly (F)", 70, function()
        flying = not flying
        if flying then
            enableFly()
            flyBtn.Text = "Disable Fly (F)"
        else
            disableFly()
            flyBtn.Text = "Enable Fly (F)"
        end
    end)
    flyBtn.Text = flying and "Disable Fly (F)" or "Enable Fly (F)"

    -- Speed Boost nappi
    local speedBoostActive = false
    local speedBoostBtn = createButton("Speed Boost", 120, function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if not speedBoostActive then
                humanoid.WalkSpeed = 50
                speedBoostActive = true
                speedBoostBtn.Text = "Speed Boost: ON"
            else
                humanoid.WalkSpeed = 16
                speedBoostActive = false
                speedBoostBtn.Text = "Speed Boost: OFF"
            end
        end
    end)

    -- Set Speed nappi
    local setSpeedBtn = createButton("Set Speed", 170, function()
        -- Popup for speed input
        clearFrame()

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -40, 0, 40)
        label.Position = UDim2.new(0, 20, 0, 100)
        label.BackgroundTransparency = 1
        label.Text = "Enter Speed (default 16):"
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Parent = frame

        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0, 200, 0, 30)
        inputBox.Position = UDim2.new(0, 70, 0, 150)
        inputBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
        inputBox.TextColor3 = Color3.fromRGB(255,255,255)
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 18
        inputBox.ClearTextOnFocus = true
        inputBox.PlaceholderText = "16"
        inputBox.Parent = frame

        local confirmBtn = createButton("Confirm", 200, function()
            local val = tonumber(inputBox.Text)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if val and humanoid then
                humanoid.WalkSpeed = math.clamp(val, 0, 250)
            end
            showCheatMenu()
        end)

        local backBtn = createButton("Cancel", 250, showCheatMenu)
    end)

    -- Anti Die nappi
    local antiDieBtn = createButton("Toggle Anti Die", 220, function()
        antiDieEnabled = not antiDieEnabled
        if antiDieEnabled then
            enableAntiDie()
            antiDieBtn.Text = "Anti Die: ON"
        else
            antiDieBtn.Text = "Anti Die: OFF"
        end
    end)
    antiDieBtn.Text = antiDieEnabled and "Anti Die: ON" or "Anti Die: OFF"

    -- Noclip nappi
    local noclipActive = false
    local noclipBtn = createButton("Toggle Noclip", 270, function()
        noclipActive = not noclipActive
        setNoclip(noclipActive)
        noclipBtn.Text = noclipActive and "Noclip: ON" or "Noclip: OFF"
    end)
    noclipBtn.Text = noclipActive and "Noclip: ON" or "Noclip: OFF"

    -- Infinite Jump nappi
    local infiniteJumpActive = false
    local infiniteJumpBtn = createButton("Toggle Infinite Jump", 320, function()
        infiniteJumpActive = not infiniteJumpActive
        if infiniteJumpActive then
            enableInfiniteJump()
            infiniteJumpBtn.Text = "Infinite Jump: ON"
        else
            disableInfiniteJump()
            infiniteJumpBtn.Text = "Infinite Jump: OFF"
        end
    end)
    infiniteJumpBtn.Text = infiniteJumpActive and "Infinite Jump: ON" or "Infinite Jump: OFF"

    -- Teleport to mouse nappi
    createButton("Teleport To Mouse", 370, teleportToMouse)

    -- Back nappi
    createButton("< Back", 410, showMainMenu)
end

-- Avaimen syöttöikkuna
local function showKeyInput()
    clearFrame()
    frame.Size = UDim2.new(0, 340, 0, 150)
    frame.Position = UDim2.new(0.5, -170, 0.5, -75)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 0, 40)
    label.Position = UDim2.new(0, 20, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = "Enter Key:"
    label.Font = Enum.Font.GothamBold
    label.TextSize = 22
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = frame

    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(0, 300, 0, 35)
    keyInput.Position = UDim2.new(0, 20, 0, 70)
    keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyInput.ClearTextOnFocus = true
    keyInput.PlaceholderText = "Type your key here"
    keyInput.Font = Enum.Font.Gotham
    keyInput.TextSize = 20
    keyInput.Parent = frame

    local submitBtn = createButton("Submit", 110, function()
        if keyInput.Text == "MinihodariDeveloper" then
            frame.Size = UDim2.new(0, 340, 0, 460)
            frame.Position = UDim2.new(0.5, -170, 0.5, -230)
            showMainMenu()
        else
            keyInput.Text = ""
            keyInput.PlaceholderText = "Wrong key! Ask correct key from the owner!"
        end
    end)
    submitBtn.Parent = frame
end

-- Näppäinkomento lentämisen togglelle (F)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        flying = not flying
        if flying then
            enableFly()
        else
            disableFly()
        end
    end
end)

-- Käynnistetään avaimen kyselyllä
showKeyInput()
