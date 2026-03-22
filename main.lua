--==================================================
-- SERVICES
--==================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--==================================================
-- KEY SYSTEM
--==================================================
local function GenerateKey()
	return "JINOXX-"..tostring(math.floor(os.time()/1000)%999)
end

local VIP = {
	["jinoxx_back"]="JINOXX",
	["chirox_a"]="CHIROX"
}

local function IsVIP(name)
	return VIP[string.lower(name)] ~= nil
end

--==================================================
-- GUI
--==================================================
local gui = Instance.new("ScreenGui",player.PlayerGui)
gui.ResetOnSpawn=false

-- LOGIN
local login = Instance.new("Frame",gui)
login.Size=UDim2.new(0,320,0,200)
login.Position=UDim2.new(0.5,-160,0.5,-100)
login.BackgroundColor3=Color3.fromRGB(10,10,20)
login.Active=true
login.Draggable=true
Instance.new("UICorner",login)

local box=Instance.new("TextBox",login)
box.Size=UDim2.new(0.8,0,0,40)
box.Position=UDim2.new(0.1,0,0.4,0)
box.PlaceholderText="KEY"
Instance.new("UICorner",box)

if IsVIP(player.Name) then
	box.Text=GenerateKey()
end

local btn=Instance.new("TextButton",login)
btn.Size=UDim2.new(0.6,0,0,40)
btn.Position=UDim2.new(0.2,0,0.7,0)
btn.Text="LOGIN"
Instance.new("UICorner",btn)

-- MAIN
local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,650,0,420)
main.Position=UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3=Color3.fromRGB(15,15,20)
main.Visible=false
main.Active=true
main.Draggable=true
Instance.new("UICorner",main)

-- FLOAT BUTTON
local float=Instance.new("TextButton",gui)
float.Size=UDim2.new(0,120,0,40)
float.Position=UDim2.new(0,20,0,200)
float.Text="OPEN"
float.Visible=false
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

-- LOGIN CHECK
btn.MouseButton1Click:Connect(function()
	if box.Text==GenerateKey() then
		login.Visible=false
		main.Visible=true
	end
end)

-- CLOSE
local close=Instance.new("TextButton",main)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-35,0,5)
close.Text="X"
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
	main.Visible=false
	float.Visible=true
end)

float.MouseButton1Click:Connect(function()
	main.Visible=true
	float.Visible=false
end)

--==================================================
-- SETTINGS
--==================================================
local Settings={
	God=false,
	NoClip=false,
	InfiniteJump=false,
	Aim=false,
	ESP=true,
	Speed=16,
	Jump=50
}

--==================================================
-- TABS
--==================================================
local tabs={}
local pages={}

local function CreatePage(name,x)
	local btn=Instance.new("TextButton",main)
	btn.Size=UDim2.new(0,120,0,35)
	btn.Position=UDim2.new(0,x,0,10)
	btn.Text=name
	Instance.new("UICorner",btn)

	local page=Instance.new("Frame",main)
	page.Size=UDim2.new(1,-20,1,-60)
	page.Position=UDim2.new(0,10,0,50)
	page.BackgroundTransparency=1
	page.Visible=false

	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible=false end
		page.Visible=true
	end)

	pages[name]=page
	return page
end

local playerPage=CreatePage("PLAYER",10)
local visualPage=CreatePage("VISUAL",140)
local tpPage=CreatePage("TP",270)
local funPage=CreatePage("FUN",400)

pages["PLAYER"].Visible=true

--==================================================
-- TOGGLE
--==================================================
local function Toggle(parent,text,y,callback)
	local state=false

	local lbl=Instance.new("TextLabel",parent)
	lbl.Position=UDim2.new(0,10,0,y)
	lbl.Size=UDim2.new(0,200,0,30)
	lbl.Text=text
	lbl.BackgroundTransparency=1

	local btn=Instance.new("TextButton",parent)
	btn.Position=UDim2.new(1,-80,0,y)
	btn.Size=UDim2.new(0,70,0,30)
	btn.Text="OFF"
	Instance.new("UICorner",btn)

	btn.MouseButton1Click:Connect(function()
		state=not state
		btn.Text=state and "ON" or "OFF"
		callback(state)
	end)
end

-- PLAYER TAB
Toggle(playerPage,"GOD",20,function(v)Settings.God=v end)
Toggle(playerPage,"NOCLIP",60,function(v)Settings.NoClip=v end)
Toggle(playerPage,"INFINITE JUMP",100,function(v)Settings.InfiniteJump=v end)

-- SPEED
local speed=Instance.new("TextButton",playerPage)
speed.Position=UDim2.new(0,10,0,140)
speed.Size=UDim2.new(0,120,0,30)
speed.Text="Speed +10"
Instance.new("UICorner",speed)

speed.MouseButton1Click:Connect(function()
	Settings.Speed+=10
end)

-- VISUAL TAB
Toggle(visualPage,"ESP",20,function(v)Settings.ESP=v end)
Toggle(visualPage,"AIM",60,function(v)Settings.Aim=v end)

--==================================================
-- ESP PRO
--==================================================
local function ESP(plr)
	if plr==player then return end

	local function create(char)
		local head=char:WaitForChild("Head")

		local bill=Instance.new("BillboardGui",head)
		bill.Size=UDim2.new(0,200,0,50)
		bill.AlwaysOnTop=true

		local txt=Instance.new("TextLabel",bill)
		txt.Size=UDim2.new(1,0,1,0)
		txt.BackgroundTransparency=1
		txt.TextColor3=Color3.fromRGB(255,0,0)
		txt.TextScaled=true

		RunService.RenderStepped:Connect(function()
			if Settings.ESP and char:FindFirstChild("HumanoidRootPart") then
				local dist=(player.Character.HumanoidRootPart.Position-char.HumanoidRootPart.Position).Magnitude
				txt.Text=plr.Name.." ["..math.floor(dist).."]"
				bill.Enabled=true
			else
				bill.Enabled=false
			end
		end)
	end

	if plr.Character then create(plr.Character) end
	plr.CharacterAdded:Connect(create)
end

for _,p in pairs(Players:GetPlayers()) do ESP(p) end
Players.PlayerAdded:Connect(ESP)

--==================================================
-- NAME ABOVE HEAD
--==================================================
local function SetName()
	local tag=VIP[string.lower(player.Name)]
	if not tag then return end

	local head=player.Character:WaitForChild("Head")

	local bill=Instance.new("BillboardGui",head)
	bill.Size=UDim2.new(0,200,0,50)
	bill.AlwaysOnTop=true

	local txt=Instance.new("TextLabel",bill)
	txt.Size=UDim2.new(1,0,1,0)
	txt.BackgroundTransparency=1
	txt.Text=tag
	txt.TextColor3=Color3.fromRGB(255,0,0)
	txt.TextScaled=true
end

player.CharacterAdded:Connect(SetName)
SetName()

--==================================================
-- SYSTEMS
--==================================================
RunService.RenderStepped:Connect(function()
	local h=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not h then return end

	h.WalkSpeed=Settings.Speed
	h.JumpPower=Settings.Jump

	if Settings.God then
		h.Health=h.MaxHealth
	end

	if Settings.Aim then
		local closest=nil
		local dist=150

		for _,m in pairs(workspace:GetChildren()) do
			if m:IsA("Model") and m:FindFirstChild("Head") then
				local pos,vis=camera:WorldToViewportPoint(m.Head.Position)
				if vis then
					local mag=(Vector2.new(pos.X,pos.Y)-camera.ViewportSize/2).Magnitude
					if mag<dist then
						dist=mag
						closest=m
					end
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

--==================================================
-- TELEPORT TAB
--==================================================
local boxTP=Instance.new("TextBox",tpPage)
boxTP.Size=UDim2.new(0.6,0,0,35)
boxTP.Position=UDim2.new(0.2,0,0,30)
Instance.new("UICorner",boxTP)

local tp=Instance.new("TextButton",tpPage)
tp.Size=UDim2.new(0.5,0,0,35)
tp.Position=UDim2.new(0.25,0,0,80)
tp.Text="TP"
Instance.new("UICorner",tp)

tp.MouseButton1Click:Connect(function()
	for _,plr in pairs(Players:GetPlayers()) do
		if string.find(string.lower(plr.Name),string.lower(boxTP.Text)) then
			player.Character:MoveTo(plr.Character.HumanoidRootPart.Position+Vector3.new(0,3,0))
		end
	end
end)

--==================================================
-- FUN (SKINS + DANCES)
--==================================================
local y=20

local Skins={["Noob"]=1,["Rich"]=156,["Girl"]=485}

for n,id in pairs(Skins) do
	local b=Instance.new("TextButton",funPage)
	b.Size=UDim2.new(0,120,0,30)
	b.Position=UDim2.new(0,10,0,y)
	b.Text=n
	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(function()
		local desc=Players:GetHumanoidDescriptionFromUserId(id)
		player.Character:FindFirstChildOfClass("Humanoid"):ApplyDescription(desc)
	end)

	y+=35
end

local Dances={
	["Dance1"]="rbxassetid://507771019",
	["Dance2"]="rbxassetid://507776043"
}

for n,id in pairs(Dances) do
	local b=Instance.new("TextButton",funPage)
	b.Size=UDim2.new(0,120,0,30)
	b.Position=UDim2.new(0,150,0,y)
	b.Text=n
	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(function()
		local anim=Instance.new("Animation")
		anim.AnimationId=id
		local track=player.Character.Humanoid:LoadAnimation(anim)
		track:Play()
	end)

	y+=35
end
