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

--////////////////////////////////////////////////////
-- GUI
--////////////////////////////////////////////////////
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- LOGIN
local login = Instance.new("Frame", gui)
login.Size = UDim2.new(0,360,0,230)
login.Position = UDim2.new(0.5,-180,0.5,-115)
login.BackgroundColor3 = Color3.fromRGB(10,10,20)
login.Active = true
login.Draggable = true
Instance.new("UICorner",login).CornerRadius = UDim.new(0,25)

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

-- قائمة اليوزرات المسموح لهم
local VIP_USERS = {
	"jinoxx_back",
	"chirox_a"
}

-- دالة تتحقق هل اللاعب VIP
local function IsVIP(name)
	for _,v in pairs(VIP_USERS) do
		if string.lower(v) == string.lower(name) then
			return true
		end
	end
	return false
end

-- AUTO KEY
if IsVIP(player.Name) then
	box.Text = GenerateKey()
end

local btn = Instance.new("TextButton",login)
btn.Size = UDim2.new(0.5,0,0,40)
btn.Position = UDim2.new(0.25,0,0.7,0)
btn.Text = "LOGIN"
btn.BackgroundColor3 = Color3.fromRGB(0,200,255)
Instance.new("UICorner",btn)

-- MAIN GUI
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,600,0,360)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(5,5,10)
main.Visible = true -- تظهر عند التشغيل لأول مرة
main.Active = true
main.Draggable = true
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,20)

-- FLOAT BUTTON (OPEN)
local float = Instance.new("TextButton", gui)
float.Size = UDim2.new(0,120,0,40)
float.Position = UDim2.new(0,20,0,200)
float.Text = "OPEN"
float.Visible = false -- يكون مخفيًا عند ظهور Main
float.BackgroundColor3 = Color3.fromRGB(0,0,0)
float.TextColor3 = Color3.fromRGB(0,0,255)
float.Font = Enum.Font.GothamBold
float.TextScaled = true
local floatCorner = Instance.new("UICorner", float)
floatCorner.CornerRadius = UDim.new(0,15)

--// سحب وتحريك الزر
local dragging = false
local dragInput, mousePos, framePos

float.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = float.Position

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

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		float.Position = UDim2.new(
			framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y
		)
	end
end)

--// عند الضغط على الزر، تظهر القائمة الرئيسية وتختفي الزر
float.MouseButton1Click:Connect(function()
	main.Visible = true
	float.Visible = false
end)

-- مثال لإخفاء القائمة وإظهار الزر
-- يمكنك وضعه عند زر CLOSE داخل Main
local closeBtn = Instance.new("TextButton", main)
closeBtn.Size = UDim2.new(0,35,0,35)
closeBtn.Position = UDim2.new(1,-45,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(0,0,255)
closeBtn.BackgroundColor3 = Color3.fromRGB(20,0,0)
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0,12)

closeBtn.MouseButton1Click:Connect(function()
	main.Visible = false
	float.Visible = true
end)
-- TITLE
local t = Instance.new("TextLabel",main)
t.Size = UDim2.new(1,0,0,40)
t.Text = "⚡ JINOXX XIT PRO MAX ⚡"
t.TextColor3 = Color3.fromRGB(0,200,255)
t.BackgroundTransparency = 1
t.TextScaled = true

-- HIDE
local hide = Instance.new("TextButton",main)
hide.Size = UDim2.new(0,30,0,30)
hide.Position = UDim2.new(1,-35,0,5)
hide.Text = "-"
Instance.new("UICorner",hide)

hide.MouseButton1Click:Connect(function()
	main.Visible = false
	float.Visible = true
end)

float.MouseButton1Click:Connect(function()
	main.Visible = true
	float.Visible = false
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

--////////////////////////////////////////////////////
-- TOGGLE
--////////////////////////////////////////////////////
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

--////////////////////////////////////////////////////
-- ESP SYSTEM
--////////////////////////////////////////////////////
local function CreateESP(m)
	if not m:FindFirstChild("Head") then return end
	
	local bill = Instance.new("BillboardGui", m.Head)
	bill.Size = UDim2.new(0,120,0,50)
	bill.AlwaysOnTop = true
	
	local txt = Instance.new("TextLabel",bill)
	txt.Size = UDim2.new(1,0,1,0)
	txt.BackgroundTransparency = 1
	txt.TextColor3 = Color3.fromRGB(0,255,255)
	txt.TextScaled = true
	
	RunService.RenderStepped:Connect(function()
		if Settings.ESP and m:FindFirstChild("HumanoidRootPart") then
			local dist = (player.Character.HumanoidRootPart.Position - m.HumanoidRootPart.Position).Magnitude
			txt.Text = m.Name.." ["..math.floor(dist).."]"
			bill.Enabled = true
		else
			bill.Enabled = false
		end
	end)
end

for _,v in pairs(workspace:GetChildren()) do
	if v:IsA("Model") then CreateESP(v) end
end

-- يعمل فقط في Brookhaven
if game.PlaceId ~= 4924922222 then
	warn("This script works only in Brookhaven!")
	return
end

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- قائمة رقصات (Animation IDs)
local Dances = {
	["Dance1"] = "rbxassetid://507771019",
	["Dance2"] = "rbxassetid://507776043",
	["Dance3"] = "rbxassetid://507777268",
	["Dance4"] = "rbxassetid://507780384",
	["Dance5"] = "rbxassetid://507784897",
}

local currentAnim = nil

-- تشغيل رقصة
local function PlayDance(id)
	if currentAnim then
		currentAnim:Stop()
	end
	local anim = Instance.new("Animation")
	anim.AnimationId = id
	currentAnim = hum:LoadAnimation(anim)
	currentAnim:Play()
end

-- إيقاف الرقصة
local function StopDance()
	if currentAnim then
		currentAnim:Stop()
	end
end

-- UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,300)
frame.Position = UDim2.new(0,50,0,150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local UIcorner = Instance.new("UICorner", frame)
UIcorner.CornerRadius = UDim.new(0,15)

-- عنوان
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "DANCES"
title.TextColor3 = Color3.fromRGB(0,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- أزرار الرقص
local y = 40
for name,id in pairs(Dances) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9,0,0,30)
	btn.Position = UDim2.new(0.05,0,0,y)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	
	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0,10)
	
	btn.MouseButton1Click:Connect(function()
		PlayDance(id)
	end)
	
	y = y + 35
end

-- زر إيقاف الرقصة
local stop = Instance.new("TextButton", frame)
stop.Size = UDim2.new(0.9,0,0,35)
stop.Position = UDim2.new(0.05,0,1,-40)
stop.Text = "STOP"
stop.BackgroundColor3 = Color3.fromRGB(200,0,0)
stop.TextColor3 = Color3.fromRGB(255,255,255)
stop.Font = Enum.Font.GothamBold
stop.TextScaled = true

local stopCorner = Instance.new("UICorner", stop)
stopCorner.CornerRadius = UDim.new(0,12)

stop.MouseButton1Click:Connect(function()
	StopDance()
end)

--// سحب القائمة بالكامل
local dragging = false
local dragInput, mousePos, framePos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = frame.Position

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
		local delta = input.Position - mousePos
		frame.Position = UDim2.new(
			framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y
		)
	end
end)

--////////////////////////////////////////////////////
-- SYSTEMS
--////////////////////////////////////////////////////
RunService.RenderStepped:Connect(function()

	local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if h then
		h.WalkSpeed = Settings.Speed
		h.JumpPower = Settings.Jump
	end
	
	if Settings.God and h then
		h.Health = h.MaxHealth
	end
	
	if Settings.Aim then
		local closest,dist=nil,150
		for _,m in pairs(workspace:GetChildren()) do
			if m:IsA("Model") and m:FindFirstChild("Head") then
				local pos,vis=camera:WorldToViewportPoint(m.Head.Position)
				if vis then
					local mag=(Vector2.new(pos.X,pos.Y)-camera.ViewportSize/2).Magnitude
					if mag<dist then dist=mag closest=m end
				end
			end
		end
		if closest then
			camera.CFrame=camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position,closest.Head.Position),0.2)
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
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

-- LOGIN
btn.MouseButton1Click:Connect(function()
	if box.Text == GenerateKey() then
		login.Visible = false
		main.Visible = true
	end
end)

-- يعمل فقط في Brookhaven
if game.PlaceId ~= 4924922222 then
	warn("Brookhaven only!")
	return
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,300)
frame.Position = UDim2.new(0,20,0,150)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "SKINS"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.BackgroundTransparency = 1
title.TextScaled = true

-- 📌 سكينات (UserIds)
local Skins = {
	["Noob"] = 1,
	["Cool Boy"] = 261,
	["Girl Style"] = 485,
	["Rich Style"] = 156,
	["Tryhard"] = 577,
}

-- تطبيق السكن
local function ApplySkin(userId)
	local success, desc = pcall(function()
		return Players:GetHumanoidDescriptionFromUserId(userId)
	end)

	if success and desc then
		local char = player.Character
		if char and char:FindFirstChildOfClass("Humanoid") then
			char:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
		end
	end
end

-- أزرار
local y = 40
for name, id in pairs(Skins) do
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9,0,0,35)
	btn.Position = UDim2.new(0.05,0,0,y)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.TextScaled = true
	Instance.new("UICorner", btn)

	btn.MouseButton1Click:Connect(function()
		ApplySkin(id)
	end)

	y = y + 40
end
