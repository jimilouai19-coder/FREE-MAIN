--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--////////////////////////////////////////////////////
-- KEY SYSTEM
--////////////////////////////////////////////////////
local function GenerateKey()
	local prefix = "JINOXX-HTMK-RTG-"
	local cycle = math.floor(os.time() / (48*60*60))
	local num = (cycle * 7357) % 100
	return prefix .. string.format("%02d", num)
end

-- VIP USERS
local VIP_USERS = {
	"jinoxx_back"
}

local function IsVIP(name)
	for _,v in pairs(VIP_USERS) do
		if string.lower(v) == string.lower(name) then
			return true
		end
	end
	return false
end

--////////////////////////////////////////////////////
-- GUI
--////////////////////////////////////////////////////
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- LOGIN
local login = Instance.new("Frame", gui)
login.Size = UDim2.new(0,360,0,230)
login.Position = UDim2.new(0.5,-180,0.5,-115)
login.BackgroundColor3 = Color3.fromRGB(10,10,20)
login.Active = true
login.Draggable = true
Instance.new("UICorner",login).CornerRadius = UDim.new(0,20)

local title = Instance.new("TextLabel",login)
title.Size = UDim2.new(1,0,0,50)
title.Text = "⚡ JINOXX LOGIN ⚡"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.BackgroundTransparency = 1
title.TextScaled = true

local box = Instance.new("TextBox",login)
box.Size = UDim2.new(0.8,0,0,40)
box.Position = UDim2.new(0.1,0,0.4,0)
box.PlaceholderText = "ENTER KEY"
Instance.new("UICorner",box)

-- AUTO KEY VIP
if IsVIP(player.Name) then
	box.Text = GenerateKey()
end

local btn = Instance.new("TextButton",login)
btn.Size = UDim2.new(0.5,0,0,40)
btn.Position = UDim2.new(0.25,0,0.7,0)
btn.Text = "LOGIN"
btn.BackgroundColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner",btn)

--////////////////////////////////////////////////////
-- MAIN
--////////////////////////////////////////////////////
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,600,0,360)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(5,5,10)
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

-- TITLE
local t = Instance.new("TextLabel",main)
t.Size = UDim2.new(1,0,0,40)
t.Text = "⚡ JINOXX XIT PRO ⚡"
t.TextColor3 = Color3.fromRGB(0,200,255)
t.BackgroundTransparency = 1
t.TextScaled = true

-- CLOSE
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0,35,0,35)
closeBtn.Position = UDim2.new(1,-45,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
Instance.new("UICorner", closeBtn)

-- FLOAT BUTTON
local float = Instance.new("TextButton", gui)
float.Size = UDim2.new(0,120,0,40)
float.Position = UDim2.new(0,20,0,200)
float.Text = "OPEN"
float.Visible = false
float.BackgroundColor3 = Color3.fromRGB(0,0,0)
float.TextColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner",float)

-- DRAG OPEN BUTTON
local dragging = false
local dragInput, startPos, startFramePos

float.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startFramePos = float.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

float.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - startPos
		float.Position = UDim2.new(
			startFramePos.X.Scale,
			startFramePos.X.Offset + delta.X,
			startFramePos.Y.Scale,
			startFramePos.Y.Offset + delta.Y
		)
	end
end)

-- BUTTONS
float.MouseButton1Click:Connect(function()
	main.Visible = true
	float.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	float.Visible = true
end)

-- LOGIN SYSTEM
btn.MouseButton1Click:Connect(function()
	if box.Text == GenerateKey() then
		login.Visible = false
		main.Visible = true
	else
		box.Text = "WRONG KEY ❌"
	end
end)

--////////////////////////////////////////////////////
-- SETTINGS
--////////////////////////////////////////////////////
local Settings = {
	God=false,
	NoClip=false,
	InfiniteJump=false,
	Aim=false,
	ESP=false,
	Speed=16,
	Jump=50
}

-- TOGGLE
local function Toggle(text,y,callback)
	local state=false
	
	local lbl = Instance.new("TextLabel",main)
	lbl.Position = UDim2.new(0,20,0,y)
	lbl.Size = UDim2.new(0,200,0,30)
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(0,200,255)
	lbl.BackgroundTransparency = 1
	
	local btn = Instance.new("TextButton",main)
	btn.Size = UDim2.new(0,70,0,30)
	btn.Position = UDim2.new(1,-90,0,y)
	btn.Text = "OFF"
	btn.BackgroundColor3 = Color3.fromRGB(80,0,0)
	Instance.new("UICorner",btn)
	
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(80,0,0)
		callback(state)
	end)
end

-- FEATURES
Toggle("ANTI KILL",60,function(v) Settings.God=v end)
Toggle("NO CLIP",100,function(v) Settings.NoClip=v end)
Toggle("INFINITE JUMP",140,function(v) Settings.InfiniteJump=v end)
Toggle("AIM ASSIST",180,function(v) Settings.Aim=v end)
Toggle("ESP",220,function(v) Settings.ESP=v end)

-- SPEED
local speed = Instance.new("TextButton",main)
speed.Position = UDim2.new(0,20,0,260)
speed.Size = UDim2.new(0,120,0,35)
speed.Text = "Speed +10"
Instance.new("UICorner",speed)

speed.MouseButton1Click:Connect(function()
	Settings.Speed += 10
end)

-- JUMP
local jump = Instance.new("TextButton",main)
jump.Position = UDim2.new(0,160,0,260)
jump.Size = UDim2.new(0,120,0,35)
jump.Text = "Jump +10"
Instance.new("UICorner",jump)

jump.MouseButton1Click:Connect(function()
	Settings.Jump += 10
end)

-- TELEPORT
local boxTP = Instance.new("TextBox",main)
boxTP.Size = UDim2.new(0.5,0,0,35)
boxTP.Position = UDim2.new(0.25,0,0,310)
boxTP.PlaceholderText = "Username"
Instance.new("UICorner",boxTP)

local tp = Instance.new("TextButton",main)
tp.Size = UDim2.new(0.4,0,0,35)
tp.Position = UDim2.new(0.3,0,0,345)
tp.Text = "TELEPORT"
Instance.new("UICorner",tp)

tp.MouseButton1Click:Connect(function()
	for _,plr in pairs(Players:GetPlayers()) do
		if string.find(string.lower(plr.Name), string.lower(boxTP.Text)) then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				player.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
			end
		end
	end
end)

-- SYSTEMS
RunService.RenderStepped:Connect(function()
	local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if h then
		h.WalkSpeed = Settings.Speed
		h.JumpPower = Settings.Jump
		
		if Settings.God then
			h.Health = h.MaxHealth
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if Settings.InfiniteJump then
		player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

RunService.Stepped:Connect(function()
	if Settings.NoClip and player.Character then
		for _,v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)
