-- Dull Hub by minihodari12 (GitHub)
-- Key: MinihodariDeveloper

local correctKey = "MinihodariDeveloper"

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DullHub"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 250)
frame.Position = UDim2.new(0.5, -160, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "🔐 Dull Hub"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local textbox = Instance.new("TextBox", frame)
textbox.PlaceholderText = "Enter Key"
textbox.Size = UDim2.new(1, -20, 0, 30)
textbox.Position = UDim2.new(0, 10, 0, 40)
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local submit = Instance.new("TextButton", frame)
submit.Text = "Submit"
submit.Size = UDim2.new(1, -20, 0, 30)
submit.Position = UDim2.new(0, 10, 0, 80)
submit.TextColor3 = Color3.new(1, 1, 1)
submit.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local function showMenu()
	textbox.Visible = false
	submit.Visible = false

	local buttons = {}

	local function createButton(text, posY, callback)
		local btn = Instance.new("TextButton", frame)
		btn.Text = text
		btn.Size = UDim2.new(1, -20, 0, 30)
		btn.Position = UDim2.new(0, 10, 0, posY)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.MouseButton1Click:Connect(callback)
		table.insert(buttons, btn)
	end

	createButton("📝 Update Log", 40, function()
		frame.Title.Text = "Update Log: Added Fly & Speed"
	end)

	createButton("🎮 Cheats", 80, function()
		for _, b in pairs(buttons) do b.Visible = false end
		createButton("Fly", 40, function()
			local flying = false
			local UIS = game:GetService("UserInputService")
			local BP = Instance.new("BodyPosition")
			local BG = Instance.new("BodyGyro")
			local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			BP.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			BP.P = 10000
			BP.Position = HRP.Position
			BG.CFrame = HRP.CFrame

			BP.Parent = HRP
			BG.Parent = HRP
			flying = true

			game:GetService("RunService").RenderStepped:Connect(function()
				if flying then
					BP.Position = HRP.Position + Vector3.new(0, 5, 0)
					BG.CFrame = workspace.CurrentCamera.CFrame
				end
			end)

			UIS.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode.F then
					BP:Destroy()
					BG:Destroy()
					flying = false
				end
			end)
		end)

		createButton("Speed Boost", 80, function()
			LocalPlayer.Character.Humanoid.WalkSpeed = 100
		end)

		createButton("Set Speed", 120, function()
			local speed = tonumber(game:GetService("StarterGui"):PromptInput("Set your speed (number):", "Enter speed value"))
			if speed then
				LocalPlayer.Character.Humanoid.WalkSpeed = speed
			end
		end)

		createButton("← Back", 160, function()
			for _, b in pairs(buttons) do b:Destroy() end
			showMenu()
		end)
	end)

	createButton("🙏 Credits", 120, function()
		frame.Title.Text = "Made by: minihodari12 (GitHub)"
	end)
end

submit.MouseButton1Click:Connect(function()
	if textbox.Text == correctKey then
		showMenu()
	else
		LocalPlayer:Kick("Wrong key. Ask correct key from the owner!")
	end
end)
