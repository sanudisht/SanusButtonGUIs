local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AvatarGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = lp:WaitForChild("PlayerGui")

local splashFrame = Instance.new("Frame")
splashFrame.Size = UDim2.new(0.4, 0, 0.1, 0)
splashFrame.Position = UDim2.new(0.3, 0, 0.45, 0)
splashFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
splashFrame.BackgroundTransparency = 1
splashFrame.Parent = screenGui

local splashCorner = Instance.new("UICorner")
splashCorner.CornerRadius = UDim.new(0, 10)
splashCorner.Parent = splashFrame

local splashText = Instance.new("TextLabel")
splashText.Size = UDim2.new(1, 0, 1, 0)
splashText.Position = UDim2.new(0, 0, 0, 0)
splashText.BackgroundTransparency = 1
splashText.Text = "Morph GUI Beta V1"
splashText.TextColor3 = Color3.fromRGB(255, 255, 255)
splashText.Font = Enum.Font.GothamBold
splashText.TextScaled = true
splashText.TextTransparency = 1
splashText.Parent = splashFrame

TweenService:Create(splashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
TweenService:Create(splashText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
task.wait(2)
TweenService:Create(splashFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(splashText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
task.wait(0.6)
splashFrame:Destroy()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.6, 0, 0, 100)
frame.Position = UDim2.new(0.2, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.ClipsDescendants = true

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = frame

TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Enter Username"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.65, 0, 0, 36)
textBox.Position = UDim2.new(0.025, 0, 0.5, -18)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.PlaceholderText = "Username"
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.Text = ""
textBox.TextSize = 18
textBox.Font = Enum.Font.Gotham
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 8)
boxCorner.Parent = textBox

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(0.65, 0, 0, 14)
errorLabel.Position = UDim2.new(0.025, 0, 1, 2)
errorLabel.BackgroundTransparency = 1
errorLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
errorLabel.Text = ""
errorLabel.TextSize = 12
errorLabel.Font = Enum.Font.Gotham
errorLabel.TextXAlignment = Enum.TextXAlignment.Left
errorLabel.Parent = textBox

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0.275, 0, 0, 36)
confirmBtn.Position = UDim2.new(0.7, 0, 0.5, -18)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
confirmBtn.Text = "Confirm"
confirmBtn.TextSize = 18
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.AutoButtonColor = true
confirmBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = confirmBtn

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
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function morphToUsername(username)
	local success, userId = pcall(function()
		return Players:GetUserIdFromNameAsync(username)
	end)
	if not success then return false end
	local clone = Players:CreateHumanoidModelFromUserId(userId)
	if not clone then return false end
	local root = clone:FindFirstChild("HumanoidRootPart") or clone.PrimaryPart
	local curRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if curRoot and root then
		clone:PivotTo(curRoot.CFrame)
	end
	if lp.Character then
		lp.Character:Destroy()
	end
	clone.Parent = workspace
	lp.Character = clone
	task.wait(0.1)
	local cam = workspace.CurrentCamera
	local hum = clone:FindFirstChildOfClass("Humanoid")
	if hum then
		cam.CameraSubject = hum
		cam.CameraType = Enum.CameraType.Custom
	end
	return true
end

confirmBtn.MouseButton1Click:Connect(function()
	local user = textBox.Text:match("^%s*(.-)%s*$")
	errorLabel.Text = ""

	local originalSize = confirmBtn.Size
	local shrinkTween = TweenService:Create(confirmBtn, TweenInfo.new(0.05), {Size = originalSize - UDim2.new(0.02, 0, 0.02, 0)})
	local growTween = TweenService:Create(confirmBtn, TweenInfo.new(0.1), {Size = originalSize})
	shrinkTween:Play()
	shrinkTween.Completed:Wait()
	growTween:Play()

	if user ~= "" then
		local success = morphToUsername(user)
		if success then
			screenGui:Destroy()
		else
			errorLabel.Text = "Invalid Username"
		end
	else
		errorLabel.Text = "Invalid Username"
	end
end)