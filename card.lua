-- ==========================================
-- ARSY CONSOLE V2.1 (MOBILE EXECUTOR FIX)
-- ==========================================
local Players = game:GetService("Players")
while not Players.LocalPlayer do task.wait(0.5) end
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local guiName = "ArsyFlexCards_Fixed"

if getgenv().Arsy_V2_Cleanup then pcall(getgenv().Arsy_V2_Cleanup) end
local targetParent = gethui and gethui() or CoreGui
if pcall(function() return targetParent.Name end) == false then targetParent = LocalPlayer:WaitForChild("PlayerGui", 5) end
if targetParent and targetParent:FindFirstChild(guiName) then targetParent[guiName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui", targetParent)
ScreenGui.Name = guiName; ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local TI_Fast = TweenInfo.new(0.2)
local TI_Med = TweenInfo.new(0.3)
local TI_Expand = TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- DATABASE STATES
local states = { 
	AAFK = false, Ping = false, Opt = false, 
	HideUSN = false, HideOthers = false, FishNotif = false,
	Webhook = "", KwToggle = false, Keywords = {"", "", "", "", "", ""},
	AutoSave = false, AutoLoad = false,
	F1 = {Toggle = false, Fish = "All", Mut = "None"},
	F2 = {Toggle = false, Fish = "All", Mut = "None"},
	F3 = {Toggle = false, Fish = "All", Mut = "None"}
}

-- UI VARIABLES
local ColorContentBG = Color3.fromHex("#151515")
local ColorMenu = Color3.fromHex("#1E1E1E")
local ColorTitleBG = Color3.fromHex("#282828")
local ColorStroke = Color3.fromHex("#353535")
local ColorAccent = Color3.fromHex("#FFFFFF")
local ColorTextDim = Color3.fromHex("#B0B0B0")
local ColorToggleOn = Color3.fromRGB(46, 204, 113)
local ColorDarker = Color3.fromHex("#0A0A0A")

local scriptConnections = {}
local function addConnection(conn) table.insert(scriptConnections, conn); return conn end

-- MASTER FRAME
local MasterFrame = Instance.new("Frame", ScreenGui)
MasterFrame.Size = UDim2.new(0, 550, 0, 320)
MasterFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MasterFrame.Position = UDim2.new(0.5, 0, 0.5, -10)
MasterFrame.BackgroundTransparency = 1
MasterFrame.Visible = false
local MenuScale = Instance.new("UIScale", MasterFrame); MenuScale.Scale = 0

local FlexRow = Instance.new("Frame", MasterFrame)
FlexRow.Size = UDim2.new(1, 0, 1, 0); FlexRow.BackgroundTransparency = 1
local FlexLayout = Instance.new("UIListLayout", FlexRow)
FlexLayout.FillDirection = Enum.FillDirection.Horizontal
FlexLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
FlexLayout.Padding = UDim.new(0, 5)

-- TOGGLE WIDGET
local ToggleWidget = Instance.new("TextButton", ScreenGui)
ToggleWidget.Size = UDim2.new(0, 45, 0, 45); ToggleWidget.AnchorPoint = Vector2.new(1, 0.5)
ToggleWidget.Position = UDim2.new(1, -20, 0.5, 0); ToggleWidget.BackgroundColor3 = ColorMenu; ToggleWidget.Text = ""
Instance.new("UICorner", ToggleWidget).CornerRadius = UDim.new(0, 12)
local WidgetStroke = Instance.new("UIStroke", ToggleWidget); WidgetStroke.Color = ColorStroke; WidgetStroke.Thickness = 1.5
local ToggleIcon = Instance.new("TextLabel", ToggleWidget)
ToggleIcon.Size = UDim2.new(1, 0, 1, 0); ToggleIcon.BackgroundTransparency = 1; ToggleIcon.Text = "V"; ToggleIcon.Rotation = 180; ToggleIcon.TextColor3 = ColorAccent; ToggleIcon.Font = Enum.Font.GothamBlack; ToggleIcon.TextSize = 22

local isMenuOpen = false
addConnection(ToggleWidget.MouseButton1Click:Connect(function()
	isMenuOpen = not isMenuOpen
	if isMenuOpen then
		MasterFrame.Visible = true; TweenService:Create(MenuScale, TI_Expand, {Scale = 1}):Play()
		TweenService:Create(ToggleIcon, TI_Med, {TextColor3 = ColorToggleOn}):Play()
	else
		TweenService:Create(ToggleIcon, TI_Med, {TextColor3 = ColorAccent}):Play()
		local t = TweenService:Create(MenuScale, TI_Med, {Scale = 0}); t:Play()
		addConnection(t.Completed:Connect(function() if not isMenuOpen then MasterFrame.Visible = false end end))
	end
end))

-- UI CREATORS (FIXED FOR MOBILE NO AUTOMATIC SIZE)
local function CreateLabel(parent, text, isBold)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 25); f.BackgroundTransparency = 1
	local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 1, 0); l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = isBold and ColorAccent or ColorTextDim; l.Font = isBold and Enum.Font.GothamBold or Enum.Font.Gotham; l.TextSize = isBold and 14 or 12; l.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(parent, text, defaultState, indentLevel, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
	local pLeft = indentLevel and (indentLevel * 15) or 0
	local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -50 - pLeft, 1, 0); l.Position = UDim2.new(0, pLeft, 0, 0); l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = ColorAccent; l.Font = Enum.Font.GothamBold; l.TextSize = 12; l.TextXAlignment = Enum.TextXAlignment.Left
	
	local sbg = Instance.new("TextButton", f); sbg.Size = UDim2.new(0, 35, 0, 18); sbg.AnchorPoint = Vector2.new(1, 0.5); sbg.Position = UDim2.new(1, 0, 0.5, 0); sbg.BackgroundColor3 = defaultState and ColorToggleOn or ColorContentBG; sbg.Text = ""; Instance.new("UICorner", sbg).CornerRadius = UDim.new(1, 0); Instance.new("UIStroke", sbg).Color = ColorStroke
	local c = Instance.new("Frame", sbg); c.Size = UDim2.new(0, 14, 0, 14); c.AnchorPoint = Vector2.new(0, 0.5); c.Position = defaultState and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0); c.BackgroundColor3 = defaultState and ColorAccent or ColorTextDim; Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

	local isOn = defaultState
	addConnection(sbg.MouseButton1Click:Connect(function()
		isOn = not isOn
		TweenService:Create(sbg, TI_Fast, {BackgroundColor3 = isOn and ColorToggleOn or ColorContentBG}):Play()
		TweenService:Create(c, TI_Fast, {Position = isOn and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = isOn and ColorAccent or ColorTextDim}):Play()
		if callback then callback(isOn) end
	end))
end

local function CreateButton(parent, text, colorOverride, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
	local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = colorOverride or ColorContentBG; btn.Text = text; btn.TextColor3 = ColorAccent; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", btn).Color = ColorStroke
	addConnection(btn.MouseButton1Click:Connect(function() if callback then callback(btn) end end))
end

-- CARDS
local flexCards, activeIndex = {}, 1
local function createFlexCard(title, index)
	local isInit = (index == activeIndex)
	local cCont = Instance.new("Frame", FlexRow); cCont.Size = isInit and UDim2.new(0.5, 0, 1, 0) or UDim2.new(0.1, 0, 1, 0); cCont.BackgroundTransparency = 1; cCont.LayoutOrder = index
	local cBtn = Instance.new("TextButton", cCont); cBtn.Size = UDim2.new(1, 0, 1, 0); cBtn.BackgroundColor3 = ColorMenu; cBtn.Text = ""; Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", cBtn).Color = isInit and ColorAccent or ColorStroke
	
	local tBg = Instance.new("Frame", cBtn); tBg.Size = UDim2.new(1, 0, 0, 30); tBg.BackgroundColor3 = ColorTitleBG; tBg.BackgroundTransparency = isInit and 0 or 1; Instance.new("UICorner", tBg).CornerRadius = UDim.new(0, 8)
	local tOp = Instance.new("TextLabel", tBg); tOp.Size = UDim2.new(1, -10, 1, 0); tOp.Position = UDim2.new(0, 10, 0, 0); tOp.BackgroundTransparency = 1; tOp.Text = title; tOp.TextColor3 = ColorAccent; tOp.Font = Enum.Font.GothamBold; tOp.TextSize = 13; tOp.TextXAlignment = Enum.TextXAlignment.Left; tOp.Visible = isInit
	local tCl = Instance.new("TextLabel", cBtn); tCl.Size = UDim2.new(0, 200, 1, 0); tCl.AnchorPoint = Vector2.new(0.5, 0.5); tCl.Position = UDim2.new(0.5, 0, 0.5, 0); tCl.Rotation = 90; tCl.BackgroundTransparency = 1; tCl.Text = title; tCl.TextColor3 = ColorTextDim; tCl.Font = Enum.Font.GothamBold; tCl.TextSize = 13; tCl.Visible = not isInit

	local scr = Instance.new("ScrollingFrame", cBtn); scr.Size = UDim2.new(1, -20, 1, -45); scr.Position = UDim2.new(0, 10, 0, 40); scr.BackgroundTransparency = 1; scr.BorderSizePixel = 0; scr.ScrollBarThickness = 2; scr.Visible = isInit
	local list = Instance.new("UIListLayout", scr); list.Padding = UDim.new(0, 8); list.SortOrder = Enum.SortOrder.LayoutOrder
	
	-- FIXED CANVAS SIZE
	addConnection(list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scr.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 20)
	end))

	flexCards[index] = {Cont = cCont, TBg = tBg, TOp = tOp, TCl = tCl, Scr = scr}

	addConnection(cBtn.MouseButton1Click:Connect(function()
		if activeIndex == index then return end; activeIndex = index
		for i, v in pairs(flexCards) do
			local s = (i == activeIndex)
			v.Scr.Visible = s; v.TOp.Visible = s; v.TCl.Visible = not s
			TweenService:Create(v.Cont, TI_Expand, {Size = s and UDim2.new(0.65, 0, 1, 0) or UDim2.new(0.15, 0, 1, 0)}):Play()
			TweenService:Create(v.TBg, TI_Med, {BackgroundTransparency = s and 0 or 1}):Play()
		end
	end))
	return scr 
end

-- INIT CLEANUP
getgenv().Arsy_V2_Cleanup = function()
	for _, conn in ipairs(scriptConnections) do if conn.Connected then conn:Disconnect() end end
	if ScreenGui then ScreenGui:Destroy() end
end

-- POPULATE MENU
local c1 = createFlexCard("DASHBOARD", 1)
CreateLabel(c1, "Main Features", true)
CreateToggle(c1, "Anti AFK", false, 0, function(s) print("AFK", s) end)
CreateToggle(c1, "Ping & FPS Overlay", false, 0, function(s) print("Ping", s) end)
CreateToggle(c1, "Normal Optimizer", false, 0, function(s) print("Opt", s) end)
CreateToggle(c1, "Hide USN", false, 0, function(s) print("Hide Usn", s) end)
CreateToggle(c1, "Hide Other Players", false, 0, function(s) print("Hide Others", s) end)

local c2 = createFlexCard("WEBHOOK", 2)
CreateLabel(c2, "Discord Status", true)
CreateButton(c2, "Check Webhook Connection", nil, function() print("Checking...") end)
CreateToggle(c2, "Filter 1 Active", false, 0, function(s) print("F1", s) end)
CreateToggle(c2, "Filter 2 Active", false, 0, function(s) print("F2", s) end)

local c3 = createFlexCard("SETTINGS", 3)
CreateLabel(c3, "Misc", true)
CreateButton(c3, "Save Config", nil, function() print("Saved") end)
CreateButton(c3, "Destroy Script", Color3.fromHex("#5a1e1e"), function() getgenv().Arsy_V2_Cleanup() end)

print("Arsy V2.1 Mobile Patched Loaded!")
