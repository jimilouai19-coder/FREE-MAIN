--========================================
-- SERVICES
--========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function GetChar()
	return player.Character or player.CharacterAdded:Wait()
end

--========================================
-- KEY SYSTEM
--========================================
local function GenerateKey()
	return "JINOXX-"..math.floor(os.time()/1000)%999
end

local VIP = {
	["jinoxx_back"]=true,
	["chirox_a"]=true
}

--========================================
-- GUI
--========================================
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- LOGIN
local login = Instance.new("Frame", gui)
login.Size = UDim2.new(0,300,0,200)
login.Position = UDim2.new(0.5,-150,0.5,-100)
login.BackgroundColor3 = Color3.fromRGB(15,15,20)
login.Active = true
login.Draggable = true
Instance.new("UICorner",login)

local box = Instance.new("TextBox", login)
box.Size = UDim2.new(0.8,0,0,40)
box.Position = UDim2.new(0.1,0,0.4,0)
box.PlaceholderText = "ENTER KEY"
Instance.new("UICorner",box)

if VIP[string.lower(player.Name)] then
	box.Text = GenerateKey()
end

local loginBtn = Instance.new("TextButton", login)
loginBtn.Size = UDim2.new(0.6,0,0,40)
loginBtn.Position = UDim2.new(0.2,0,0.7,0)
loginBtn.Text = "LOGIN"
Instance.new("UICorner",loginBtn)

-- MAIN
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,650,0,420)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(10,10,15)
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner",main)

-- FLOAT BUTTON
local float = Instance.new("TextButton", gui)
float.Size = UDim2.new(0,120,0,40)
float.Position = UDim2.new(0,20,0,200)
float.Text = "OPEN"
float.Visible = false
Instance.new("UICorner",float)

-- DRAG FLOAT
local dragging=false
local dragInput,mousePos,framePos

float.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		mousePos=i.Position
		framePos=float.Position
	end
end)

float.InputChanged:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseMovement then
		dragInput=i
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i==dragInput then
		local delta=i.Position-mousePos
		float.Position=UDim2.new(framePos.X.Scale,framePos.X.Offset+delta.X,framePos.Y.Scale,framePos.Y.Offset+delta.Y)
	end
end)

-- LOGIN BUTTON
loginBtn.MouseButton1Click:Connect(function()
	if box.Text == GenerateKey() then
		login.Visible = false
		main.Visible = true
	end
end)

-- CLOSE
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
	main.Visible=false
	float.Visible=true
end)

float.MouseButton1Click:Connect(function()
	main.Visible=true
	float.Visible=false
end)

--========================================
-- SETTINGS
--========================================
local Settings = {
	God=false,
	NoClip=false,
	InfiniteJump=false,
	Aim=false,
	ESP=false,
	Speed=16,
	Jump=50
}

--========================================
-- TOGGLE FUNCTION
--========================================
local function Toggle(text,y,callback)
	local state=false
	
	local lbl = Instance.new("TextLabel", main)
	lbl.Position = UDim2.new(0,20,0,y)
	lbl.Size = UDim2.new(0,200,0,30)
	lbl.Text = text
	lbl.BackgroundTransparency = 1
	
	local btn = Instance.new("TextButton", main)
	btn.Position = UDim2.new(1,-90,0,y)
	btn.Size = UDim2.new(0,70,0,30)
	btn.Text = "OFF"
	Instance.new("UICorner",btn)
	
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		callback(state)
	end)
end

-- FEATURES
Toggle("GOD",60,function(v) Settings.God=v end)
Toggle("NOCLIP",100,function(v) Settings.NoClip=v end)
Toggle("INF JUMP",140,function(v) Settings.InfiniteJump=v end)
Toggle("AIM",180,function(v) Settings.Aim=v end)
Toggle("ESP",220,function(v) Settings.ESP=v end)

-- SPEED
local speedBtn = Instance.new("TextButton", main)
speedBtn.Position = UDim2.new(0,20,0,260)
speedBtn.Size = UDim2.new(0,120,0,35)
speedBtn.Text = "Speed +10"
Instance.new("UICorner",speedBtn)

speedBtn.MouseButton1Click:Connect(function()
	Settings.Speed += 10
end)

-- JUMP
local jumpBtn = Instance.new("TextButton", main)
jumpBtn.Position = UDim2.new(0,160,0,260)
jumpBtn.Size = UDim2.new(0,120,0,35)
jumpBtn.Text = "Jump +10"
Instance.new("UICorner",jumpBtn)

jumpBtn.MouseButton1Click:Connect(function()
	Settings.Jump += 10
end)

-- TELEPORT
local boxTP = Instance.new("TextBox", main)
boxTP.Size = UDim2.new(0.5,0,0,35)
boxTP.Position = UDim2.new(0.25,0,0,310)
boxTP.PlaceholderText = "Username"
Instance.new("UICorner",boxTP)

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0.4,0,0,35)
tpBtn.Position = UDim2.new(0.3,0,0,350)
tpBtn.Text = "TELEPORT"
Instance.new("UICorner",tpBtn)

tpBtn.MouseButton1Click:Connect(function()
	for _,plr in pairs(Players:GetPlayers()) do
		if string.find(string.lower(plr.Name), string.lower(boxTP.Text)) then
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				GetChar():MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
			end
		end
	end
end)

--========================================
-- SYSTEMS
--========================================
RunService.RenderStepped:Connect(function()
	local char = GetChar()
	local h = char:FindFirstChildOfClass("Humanoid")
	if not h then return end

	h.WalkSpeed = Settings.Speed
	h.JumpPower = Settings.Jump

	if Settings.God then
		h.Health = h.MaxHealth
	end
end)

UIS.JumpRequest:Connect(function()
	if Settings.InfiniteJump then
		local h = GetChar():FindFirstChildOfClass("Humanoid")
		if h then h:ChangeState("Jumping") end
	end
end)

RunService.Stepped:Connect(function()
	if Settings.NoClip then
		for _,v in pairs(GetChar():GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)
--========================================
-- ADVANCED BRING BRAINROT 🧠🔥
--========================================

local function normalize(txt)
	return string.lower(txt):gsub("%s+", "")
end

bringBtn.MouseButton1Click:Connect(function()
	local input = normalize(animalBox.Text)
	local char = player.Character
	
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	
	local myPos = char.HumanoidRootPart.Position

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
			
			local modelName = normalize(v.Name)
			
			-- مقارنة ذكية
			if string.find(modelName, input) then
				
				pcall(function()
					v:PivotTo(CFrame.new(myPos + Vector3.new(0,3,0)))
				end)
				
				print("FOUND:", v.Name)
			end
		end
	end
end)
