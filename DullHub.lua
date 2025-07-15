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
    creditsLabel.Size = UDim2.new(1, -40, 
