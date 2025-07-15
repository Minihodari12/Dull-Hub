local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Luo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DullHubGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Luo musta taustakehys keskelle
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 150)
frame.Position = UDim2.new(0.5, -200, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Parent = screenGui

-- Tekstikenttä ilmoitukselle
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -40, 1, -40)
label.Position = UDim2.new(0, 20, 0, 20)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 120, 120)
label.Font = Enum.Font.GothamBold
label.TextSize = 24
label.TextWrapped = true
label.Text = "We are currently on maintenance.\nDull Hub is not available at the moment."
label.Parent = frame
