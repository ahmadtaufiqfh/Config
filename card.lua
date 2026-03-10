-- ==========================================
-- ARSY CONSOLE V2.0 : THE REAL ULTIMATE MERGE
-- FlexCards UI + 100% V4.6 FINAL EDITION LOGIC
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local guiName = "ArsyFlexCards_WidgetVersion"

-- [ CLEANUP PREVIOUS INJECTION ] --
if getgenv().Arsy_V2_Cleanup then pcall(getgenv().Arsy_V2_Cleanup) end

local targetParent
if gethui then targetParent = gethui() elseif pcall(function() return CoreGui.Name end) then targetParent = CoreGui else targetParent = LocalPlayer:WaitForChild("PlayerGui", 5) end
if targetParent and targetParent:FindFirstChild(guiName) then targetParent[guiName]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName; ScreenGui.ResetOnSpawn = false; ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; ScreenGui.Parent = targetParent

-- ==========================================
-- 💾 1. DATABASE & CONFIGURATION
-- ==========================================
local CONFIG_FILE = "ArsyV2_Config.json"
local states = { 
	AAFK = false, Ping = false, Opt = false, 
	HideUSN = false, HideOthers = false, FishNotif = false,
	Webhook = "", KwToggle = false, Keywords = {"", "", "", "", "", ""},
	AutoSave = false, AutoLoad = false,
	F1 = {Toggle = false, Fish = "All", Mut = "None"},
	F2 = {Toggle = false, Fish = "All", Mut = "None"},
	F3 = {Toggle = false, Fish = "All", Mut = "None"}
}

local function saveConfig() pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(states)) end) end
local function loadConfig()
	pcall(function()
		if isfile(CONFIG_FILE) then
			local saved = HttpService:JSONDecode(readfile(CONFIG_FILE))
			if saved then
				for k, v in pairs(saved) do
					if type(v) == "table" and type(states[k]) == "table" then
						for subK, subV in pairs(v) do states[k][subK] = subV end
					else
						states[k] = v
					end
				end
			end
		end
	end)
end

loadConfig()
local function triggerAutoSave() if states.AutoSave then saveConfig() end end

-- ==========================================
-- ⚙️ 2. ORIGINAL LOGIC V4.6 FINAL EDITION
-- ==========================================

local function destroyAudio()
	pcall(function() for _, v in pairs(Workspace:GetDescendants()) do if v:IsA("Sound") then v:Destroy() end end end)
	pcall(function() for _, v in pairs(SoundService:GetDescendants()) do if v:IsA("Sound") then v:Destroy() end end end)
end
task.spawn(destroyAudio)
local cleanerThread = task.spawn(function()
	while task.wait(600) do 
		pcall(function() if clearconsole then clearconsole() elseif rconsoleclear then rconsoleclear() elseif consoleclear then consoleclear() end; destroyAudio(); collectgarbage("collect") end)
	end
end)

local afkConnections = {}
local function applyAAFK()
	if states.AAFK then
		pcall(function() if getconnections then for _, connection in pairs(getconnections(LocalPlayer.Idled)) do table.insert(afkConnections, connection); connection:Disable() end end end)
	else
		for _, connection in ipairs(afkConnections) do pcall(function() connection:Enable() end) end; afkConnections = {}
	end
end

local PingLabel = Instance.new("TextLabel", ScreenGui)
PingLabel.Size = UDim2.new(0, 100, 0, 20); PingLabel.Position = UDim2.new(0.5, -50, 0, 10); PingLabel.BackgroundTransparency = 1; PingLabel.TextColor3 = Color3.fromRGB(0, 255, 0); PingLabel.Font = Enum.Font.GothamBold; PingLabel.TextSize = 12; PingLabel.Visible = false
local pingFpsConnection, frameCount, lastUpdate = nil, 0, os.clock()
local function applyPing()
	PingLabel.Visible = states.Ping
	if states.Ping then
		if not pingFpsConnection then
			pingFpsConnection = RunService.RenderStepped:Connect(function()
				frameCount = frameCount + 1; local currentTime = os.clock()
				if currentTime - lastUpdate >= 1 then
					local ping = 0; pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
					PingLabel.Text = "FPS: " .. frameCount .. " | Ping: " .. ping .. "ms"; frameCount = 0; lastUpdate = currentTime
				end
			end)
		end
	else
		if pingFpsConnection then pingFpsConnection:Disconnect(); pingFpsConnection = nil end
	end
end

-- [ PATCHED ] NORMAL MODE V6 (OPTIMIZATION)
local origVisuals, hasCapturedOriginals, optConnections = {}, false, {}
local function applyOpt()
	if not hasCapturedOriginals then 
		hasCapturedOriginals = true; 
		pcall(function() 
			origVisuals.GlobalShadows = Lighting.GlobalShadows; 
			origVisuals.Brightness = Lighting.Brightness; 
			local Terrain = Workspace.Terrain
			if Terrain then 
				pcall(function() origVisuals.Decoration = Terrain.Decoration end)
				pcall(function() origVisuals.WaterWaveSize = Terrain.WaterWaveSize end)
			end 
		end) 
	end
	if states.Opt then
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01; Lighting.GlobalShadows = false; Lighting.Brightness = 0; for _, effect in ipairs(Lighting:GetChildren()) do if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") or effect:IsA("Clouds") then if effect:GetAttribute("OrigEnabled") == nil then pcall(function() effect:SetAttribute("OrigEnabled", effect.Enabled) end) end; pcall(function() effect.Enabled = false end) end end end)
		local Terrain = Workspace.Terrain
		if Terrain then 
			pcall(function() Terrain.Decoration = false end)
			pcall(function() Terrain.WaterWaveSize = 0 end)
			pcall(function() Terrain.WaterReflectance = 0 end)
			local conn1 = Terrain:GetPropertyChangedSignal("WaterWaveSize"):Connect(function() pcall(function() if Terrain.WaterWaveSize > 0 then Terrain.WaterWaveSize = 0 end end) end)
			table.insert(optConnections, conn1) 
		end
	else
		for _, conn in ipairs(optConnections) do if conn.Connected then conn:Disconnect() end end; table.clear(optConnections)
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic; Lighting.GlobalShadows = origVisuals.GlobalShadows; Lighting.Brightness = origVisuals.Brightness; for _, effect in ipairs(Lighting:GetChildren()) do if effect:GetAttribute("OrigEnabled") ~= nil then pcall(function() effect.Enabled = effect:GetAttribute("OrigEnabled") end) end end end)
		local Terrain = Workspace.Terrain
		if Terrain then 
			pcall(function() Terrain.Decoration = origVisuals.Decoration end)
			pcall(function() Terrain.WaterWaveSize = origVisuals.WaterWaveSize end)
		end
	end
end

-- [ PATCHED ] BRUTE MODE LOGIC
local function executeBrute()
	for _, obj in pairs(Workspace:GetDescendants()) do 
		pcall(function()
			if obj:IsA("BasePart") and not obj:IsA("Terrain") then 
				obj.Material = Enum.Material.SmoothPlastic; obj.CastShadow = false; 
				if obj:IsA("MeshPart") then obj.TextureID = "" end 
			end
		end)
	end
end

-- EXACT HIDE USN LOGIC (V4.6 FINAL EDITION)
local hideUsnConnections = {} 
local function isTargetText(text)
	if not text then return false end
	if string.match(text, "^[Ll][Vv]%.?%s*%d+") then return true end
	for _, p in pairs(Players:GetPlayers()) do if text == p.Name or text == p.DisplayName then return true end end
	return false
end
local function hideBillboard(gui)
	if not gui:GetAttribute("WasEnabled") then gui:SetAttribute("WasEnabled", gui.Enabled) end; gui.Enabled = false
end
local function processCharacterUsn(character)
	for _, desc in pairs(character:GetDescendants()) do
		if desc:IsA("TextLabel") then
			local billboard = desc:FindFirstAncestorWhichIsA("BillboardGui")
			if billboard and isTargetText(desc.Text) then hideBillboard(billboard) end
		end
	end
	local conn = character.DescendantAdded:Connect(function(desc)
		task.defer(function()
			if desc:IsA("TextLabel") then
				local billboard = desc:FindFirstAncestorWhichIsA("BillboardGui")
				if billboard and isTargetText(desc.Text) then hideBillboard(billboard) end
			end
		end)
	end)
	table.insert(hideUsnConnections, conn)
end
local function applyHideUSN()
	if states.HideUSN then
		pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false); StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end)
		for _, player in pairs(Players:GetPlayers()) do if player.Character then processCharacterUsn(player.Character) end end
		local conn = Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(processCharacterUsn) end)
		table.insert(hideUsnConnections, conn)
	else
		pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true); StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
		for _, conn in ipairs(hideUsnConnections) do if conn.Connected then conn:Disconnect() end end; table.clear(hideUsnConnections)
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character then
				for _, desc in pairs(player.Character:GetDescendants()) do if desc:IsA("BillboardGui") and desc:GetAttribute("WasEnabled") ~= nil then desc.Enabled = desc:GetAttribute("WasEnabled") end end
			end
		end
	end
end

-- EXACT HIDE OTHERS LOGIC (V4.6 FINAL EDITION)
local hideOthersConnections = {}
local function updateCharacterVisibility(character, isHidden)
	if not character then return end
	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			if not part:GetAttribute("OrigTrans") then part:SetAttribute("OrigTrans", part.Transparency) end
			part.Transparency = isHidden and 1 or part:GetAttribute("OrigTrans")
		elseif part:IsA("Decal") or part:IsA("Texture") or part:IsA("Accessory") then
			if part:IsA("BasePart") then part.LocalTransparencyModifier = isHidden and 1 or 0
			elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then part.Handle.LocalTransparencyModifier = isHidden and 1 or 0 end
		end
	end
end
local function applyHideOthers()
	if states.HideOthers then
		for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then updateCharacterVisibility(player.Character, true) end end
		local conn = Players.PlayerAdded:Connect(function(player)
			if player ~= LocalPlayer then
				local charConn = player.CharacterAdded:Connect(function(char) task.wait(0.1); if states.HideOthers then updateCharacterVisibility(char, true) end end)
				table.insert(hideOthersConnections, charConn)
			end
		end)
		table.insert(hideOthersConnections, conn)
	else
		for _, conn in ipairs(hideOthersConnections) do if conn.Connected then conn:Disconnect() end end; table.clear(hideOthersConnections)
		for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character then updateCharacterVisibility(player.Character, false) end end
	end
end

-- EXACT FISH NOTIF LOGIC (V4.6 FINAL EDITION)
local fishNotifConns = {}
local function applyFishNotif()
	local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not PlayerGui then return end
	local notifUI = PlayerGui:FindFirstChild("Small Notification")
	if states.FishNotif then
		if notifUI then
			notifUI.Enabled = false
			local conn = notifUI:GetPropertyChangedSignal("Enabled"):Connect(function() if notifUI.Enabled then notifUI.Enabled = false end end)
			table.insert(fishNotifConns, conn)
		end
	else
		for _, conn in ipairs(fishNotifConns) do if conn.Connected then conn:Disconnect() end end; table.clear(fishNotifConns)
		if notifUI then notifUI.Enabled = true end
	end
end

-- RADAR / WEBHOOK LOGIC
local connectionTCS, connectionLegacy, lastMsg = nil, nil, ""
local function sendToDiscord(cleanMsg)
	if not req or states.Webhook == "" or states.Webhook == "Webhook link" then return end
	local formattedMsg = cleanMsg; local prefix, username, rest = string.match(cleanMsg, "(.*%[Server%]%:?%s*)(%S+)(.*)")
	if prefix and username and rest then formattedMsg = prefix .. "||" .. username .. "||" .. rest end
	
	-- FORMAT WAKTU WIB (GMT+7)
	local wibTime = os.time() + (7 * 3600)
	local timestamp = os.date("![%d/%m/%y %H:%M]", wibTime)

	local finalMessage = timestamp .. " " .. formattedMsg
	if finalMessage == lastMsg then return end; lastMsg = finalMessage
	
	task.spawn(function() req({Url = string.gsub(states.Webhook, "%?wait=true", ""), Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode({ content = finalMessage, username = "Server Notification" })}) end)
end

local function checkMessage(rawMsg)
	local cleanMsg = string.gsub(rawMsg, "<[^>]+>", ""); local lowerMsg = string.lower(cleanMsg); local isTargetFound = false
	if states.KwToggle then
		for _, boxText in ipairs(states.Keywords) do
			if boxText ~= "" then
				local textLower = string.lower(boxText)
				if string.find(textLower, "+") then
					local allWordsFound = true; for word in string.gmatch(textLower, "[^+]+") do local cleanWord = string.match(word, "^%s*(.-)%s*$"); if cleanWord ~= "" and not string.find(lowerMsg, cleanWord, 1, true) then allWordsFound = false; break end end
					if allWordsFound then isTargetFound = true; break end
				else
					if string.find(lowerMsg, textLower, 1, true) then isTargetFound = true; break end
				end
			end
		end
	end
	local function checkFilter(fState)
		if not fState.Toggle then return false end
		local fFish, fMut = string.lower(fState.Fish), string.lower(fState.Mut)
		local matchFish = (fFish == "all" or string.find(lowerMsg, fFish, 1, true))
		local matchMut = (fMut == "none" or string.find(lowerMsg, fMut, 1, true))
		return (matchFish and matchMut)
	end
	if not isTargetFound then if checkFilter(states.F1) or checkFilter(states.F2) or checkFilter(states.F3) then isTargetFound = true end end
	if isTargetFound then sendToDiscord(cleanMsg) end
end

local function updateRadarStatus()
	if connectionTCS then connectionTCS:Disconnect(); connectionTCS = nil end
	if connectionLegacy then connectionLegacy:Disconnect(); connectionLegacy = nil end
	if states.KwToggle or states.F1.Toggle or states.F2.Toggle or states.F3.Toggle then
		pcall(function() connectionTCS = game:GetService("TextChatService").MessageReceived:Connect(function(t) checkMessage((t.PrefixText or "") .. " " .. (t.Text or "")) end) end)
		pcall(function() local ce = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents", 5); if ce then connectionLegacy = ce:WaitForChild("OnMessageDoneFiltering", 5).OnClientEvent:Connect(function(d) checkMessage((d.FromSpeaker or "")=="" and ("["..d.OriginalChannel.."] "..d.Message) or ("["..d.OriginalChannel.."] "..d.FromSpeaker..": "..d.Message)) end) end end)
	end
end

-- ==========================================
-- 🌐 3. AUTO FETCH ITEMS & VARIANTS
-- ==========================================
local fishNames = {"All"}
local mutations = {"None"}
task.spawn(function()
	local itemsFolder = ReplicatedStorage:WaitForChild("Items", 3)
	if itemsFolder then
		local temp = {}
		for _, v in ipairs(itemsFolder:GetChildren()) do table.insert(temp, tostring(v.Name)) end
		table.sort(temp); for _, name in ipairs(temp) do table.insert(fishNames, name) end
	end
	local variantsFolder = ReplicatedStorage:WaitForChild("Variants", 3)
	if variantsFolder then
		local temp = {}
		for _, v in ipairs(variantsFolder:GetChildren()) do table.insert(temp, tostring(v.Name)) end
		table.sort(temp); for _, name in ipairs(temp) do table.insert(mutations, name) end
	end
end)

-- ==========================================
-- 🎨 4. DESAIN UI & WIDGET (FRONTEND)
-- ==========================================
local ColorContentBG, ColorMenu, ColorTitleBG, ColorStroke, ColorAccent, ColorTextDim, ColorToggleOn = Color3.fromHex("#151515"), Color3.fromHex("#1E1E1E"), Color3.fromHex("#282828"), Color3.fromHex("#353535"), Color3.fromHex("#FFFFFF"), Color3.fromHex("#B0B0B0"), Color3.fromRGB(46, 204, 113)
local ColorDarker = Color3.fromHex("#0A0A0A")
local flexCards, scriptConnections = {}, {}
local function addConnection(connection) table.insert(scriptConnections, connection); return connection end

local MasterFrame = Instance.new("Frame", ScreenGui)
MasterFrame.Size = UDim2.new(0, 600, 0, 360); MasterFrame.AnchorPoint = Vector2.new(0.5, 0.5); MasterFrame.Position = UDim2.new(0.5, 0, 0.5, -10); MasterFrame.BackgroundTransparency = 1; MasterFrame.Visible = false
local MenuScale = Instance.new("UIScale", MasterFrame); MenuScale.Scale = 0
local FlexRow = Instance.new("Frame", MasterFrame)
FlexRow.Size = UDim2.new(1, 0, 1, -6); FlexRow.BackgroundTransparency = 1
local FlexLayout = Instance.new("UIListLayout", FlexRow)
FlexLayout.FillDirection = Enum.FillDirection.Horizontal; FlexLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; FlexLayout.Padding = UDim.new(0, 5); FlexLayout.SortOrder = Enum.SortOrder.LayoutOrder

local expandedWidth, shrunkWidth = UDim.new(0.51, -4), UDim.new(0.07, -4)

local ToggleWidget = Instance.new("TextButton", ScreenGui)
ToggleWidget.Size = UDim2.new(0, 45, 0, 45); ToggleWidget.AnchorPoint = Vector2.new(1, 0.5); ToggleWidget.Position = UDim2.new(1, -20, 0.5, 0); ToggleWidget.BackgroundColor3 = ColorMenu; ToggleWidget.Text = ""
Instance.new("UICorner", ToggleWidget).CornerRadius = UDim.new(0, 12); local WidgetStroke = Instance.new("UIStroke", ToggleWidget); WidgetStroke.Color = ColorStroke; WidgetStroke.Thickness = 1.5
local ToggleIcon = Instance.new("TextLabel", ToggleWidget)
ToggleIcon.Size = UDim2.new(1, 0, 1, 0); ToggleIcon.BackgroundTransparency = 1; ToggleIcon.Text = "V"; ToggleIcon.Rotation = 180; ToggleIcon.TextColor3 = ColorAccent; ToggleIcon.Font = Enum.Font.GothamBlack; ToggleIcon.TextSize = 22

local isMenuOpen = false
addConnection(ToggleWidget.MouseButton1Click:Connect(function()
	isMenuOpen = not isMenuOpen
	if isMenuOpen then
		MasterFrame.Visible = true; TweenService:Create(ToggleIcon, TweenInfo.new(0.3), {TextColor3 = ColorToggleOn}):Play(); TweenService:Create(WidgetStroke, TweenInfo.new(0.3), {Color = ColorToggleOn}):Play(); TweenService:Create(MenuScale, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 1}):Play()
	else
		TweenService:Create(ToggleIcon, TweenInfo.new(0.3), {TextColor3 = ColorAccent}):Play(); TweenService:Create(WidgetStroke, TweenInfo.new(0.3), {Color = ColorStroke}):Play()
		local closeTween = TweenService:Create(MenuScale, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 0}); closeTween:Play()
		addConnection(closeTween.Completed:Connect(function() if not isMenuOpen then MasterFrame.Visible = false end end))
	end
end))

local function CreateLabel(parent, text, isBold)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 0); f.AutomaticSize = Enum.AutomaticSize.Y; f.BackgroundTransparency = 1
	local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 0); l.AutomaticSize = Enum.AutomaticSize.Y; l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = isBold and ColorAccent or ColorTextDim; l.Font = isBold and Enum.Font.GothamBold or Enum.Font.Gotham; l.TextSize = isBold and 14 or 12; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextYAlignment = Enum.TextYAlignment.Top; l.TextWrapped = true
	local pad = Instance.new("UIPadding", l); pad.PaddingBottom = UDim.new(0, 10)
end

local function CreateDescription(parent, text, indentLevel)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 15); f.AutomaticSize = Enum.AutomaticSize.Y; f.BackgroundTransparency = 1
	local pLeft = indentLevel and (indentLevel * 15) or 0
	local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -pLeft, 1, 0); l.Position = UDim2.new(0, pLeft, 0, 0); l.AutomaticSize = Enum.AutomaticSize.Y; l.BackgroundTransparency = 1; l.Text = "<i>" .. text .. "</i>"; l.RichText = true; l.TextColor3 = Color3.fromHex("#7A7A7A"); l.Font = Enum.Font.Gotham; l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left; l.TextYAlignment = Enum.TextYAlignment.Top; l.TextWrapped = true
	local pad = Instance.new("UIPadding", l); pad.PaddingBottom = UDim.new(0, 5)
end

local function CreateToggle(parent, text, defaultState, indentLevel, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
	local isSub = (indentLevel and indentLevel > 0); local pLeft = isSub and (indentLevel * 15) or 0
	local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, -50 - pLeft, 1, 0); l.Position = UDim2.new(0, pLeft, 0, 0); l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = isSub and ColorTextDim or ColorAccent; l.Font = isSub and Enum.Font.Gotham or Enum.Font.GothamBold; l.TextSize = isSub and 11 or 12; l.TextXAlignment = Enum.TextXAlignment.Left
	local sbg = Instance.new("TextButton", f); sbg.Size = UDim2.new(0, 30, 0, 16); sbg.AnchorPoint = Vector2.new(1, 0.5); sbg.Position = UDim2.new(1, 0, 0.5, 0); sbg.BackgroundColor3 = defaultState and ColorToggleOn or ColorContentBG; sbg.Text = ""; sbg.AutoButtonColor = false
	Instance.new("UICorner", sbg).CornerRadius = UDim.new(1, 0); local str = Instance.new("UIStroke", sbg); str.Color = ColorStroke; str.Thickness = 1
	local c = Instance.new("Frame", sbg); c.Size = UDim2.new(0, 12, 0, 12); c.AnchorPoint = Vector2.new(0, 0.5); c.Position = defaultState and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0); c.BackgroundColor3 = defaultState and ColorAccent or ColorTextDim; Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

	local isOn = defaultState
	addConnection(sbg.MouseButton1Click:Connect(function()
		isOn = not isOn
		TweenService:Create(sbg, TweenInfo.new(0.2), {BackgroundColor3 = isOn and ColorToggleOn or ColorContentBG}):Play()
		TweenService:Create(c, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = isOn and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = isOn and ColorAccent or ColorTextDim}):Play()
		if callback then callback(isOn) end
	end))
	return sbg
end

local function CreateCollapsibleSection(parent, title)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1; f.ClipsDescendants = true; f.AutomaticSize = Enum.AutomaticSize.Y
	local list = Instance.new("UIListLayout", f); list.Padding = UDim.new(0, 5); list.SortOrder = Enum.SortOrder.LayoutOrder
	local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundTransparency = 1; btn.Text = title; btn.TextColor3 = ColorAccent; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.LayoutOrder = 1
	local icon = Instance.new("TextLabel", btn); icon.Size = UDim2.new(0, 20, 0, 30); icon.AnchorPoint = Vector2.new(1, 0); icon.Position = UDim2.new(1, 0, 0, 0); icon.BackgroundTransparency = 1; icon.Text = "▶"; icon.TextColor3 = ColorTextDim; icon.Font = Enum.Font.Gotham; icon.TextSize = 10
	local content = Instance.new("Frame", f); content.Size = UDim2.new(1, 0, 0, 0); content.BackgroundTransparency = 1; content.Visible = false; content.AutomaticSize = Enum.AutomaticSize.Y; content.LayoutOrder = 2
	local clist = Instance.new("UIListLayout", content); clist.Padding = UDim.new(0, 5)

	local isOpen = false
	addConnection(btn.MouseButton1Click:Connect(function() isOpen = not isOpen; TweenService:Create(icon, TweenInfo.new(0.2), {Rotation = isOpen and 90 or 0}):Play(); content.Visible = isOpen end))
	return content
end

local function CreateCollapsibleWithToggle(parent, title, defaultState, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1; f.ClipsDescendants = true; f.AutomaticSize = Enum.AutomaticSize.Y
	local list = Instance.new("UIListLayout", f); list.Padding = UDim.new(0, 5); list.SortOrder = Enum.SortOrder.LayoutOrder
	local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 0, 30); btn.BackgroundTransparency = 1; btn.Text = title; btn.TextColor3 = ColorAccent; btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.AutoButtonColor = false; btn.LayoutOrder = 1
	local icon = Instance.new("TextLabel", btn); icon.Size = UDim2.new(0, 20, 0, 30); icon.AnchorPoint = Vector2.new(1, 0); icon.Position = UDim2.new(1, -45, 0, 0); icon.BackgroundTransparency = 1; icon.Text = "▶"; icon.TextColor3 = ColorTextDim; icon.Font = Enum.Font.Gotham; icon.TextSize = 10
	local sbg = Instance.new("TextButton", btn); sbg.Size = UDim2.new(0, 30, 0, 16); sbg.AnchorPoint = Vector2.new(1, 0.5); sbg.Position = UDim2.new(1, 0, 0.5, 0); sbg.BackgroundColor3 = defaultState and ColorToggleOn or ColorContentBG; sbg.Text = ""; sbg.AutoButtonColor = false
	Instance.new("UICorner", sbg).CornerRadius = UDim.new(1, 0); local str = Instance.new("UIStroke", sbg); str.Color = ColorStroke; str.Thickness = 1
	local c = Instance.new("Frame", sbg); c.Size = UDim2.new(0, 12, 0, 12); c.AnchorPoint = Vector2.new(0, 0.5); c.Position = defaultState and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0); c.BackgroundColor3 = defaultState and ColorAccent or ColorTextDim; Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)

	local isOn = defaultState
	addConnection(sbg.MouseButton1Click:Connect(function()
		isOn = not isOn; TweenService:Create(sbg, TweenInfo.new(0.2), {BackgroundColor3 = isOn and ColorToggleOn or ColorContentBG}):Play(); TweenService:Create(c, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = isOn and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = isOn and ColorAccent or ColorTextDim}):Play()
		if callback then callback(isOn) end
	end))

	local content = Instance.new("Frame", f); content.Size = UDim2.new(1, 0, 0, 0); content.BackgroundTransparency = 1; content.Visible = false; content.AutomaticSize = Enum.AutomaticSize.Y; content.LayoutOrder = 2
	local clist = Instance.new("UIListLayout", content); clist.Padding = UDim.new(0, 5)

	local isOpen = false
	addConnection(btn.MouseButton1Click:Connect(function() isOpen = not isOpen; TweenService:Create(icon, TweenInfo.new(0.2), {Rotation = isOpen and 90 or 0}):Play(); content.Visible = isOpen end))
	return content
end

-- SEARCHABLE DROPDOWN
local function CreateSearchableDropdown(parent, title, entries, defaultVal, indentLevel, callback)
	local dropFrame = Instance.new("Frame", parent); dropFrame.Size = UDim2.new(1, 0, 0, 30); dropFrame.BackgroundColor3 = ColorContentBG; dropFrame.ClipsDescendants = true
	Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 4); local str = Instance.new("UIStroke", dropFrame); str.Color = ColorStroke; str.Thickness = 1
	local pLeft = (indentLevel and indentLevel > 0) and (indentLevel * 15) or 0
	
	local inputField = Instance.new("TextBox", dropFrame)
	inputField.Size = UDim2.new(1, -30, 0, 30); inputField.BackgroundTransparency = 1; inputField.Text = title .. ": " .. (defaultVal or entries[1])
	inputField.PlaceholderText = "Search " .. title .. "..."; inputField.TextColor3 = ColorTextDim; inputField.Font = Enum.Font.Gotham; inputField.TextSize = 11; inputField.TextXAlignment = Enum.TextXAlignment.Left; inputField.ClearTextOnFocus = true
	local inPad = Instance.new("UIPadding", inputField); inPad.PaddingLeft = UDim.new(0, pLeft + 10)
	
	local iconBtn = Instance.new("TextButton", dropFrame)
	iconBtn.Size = UDim2.new(0, 30, 0, 30); iconBtn.AnchorPoint = Vector2.new(1, 0); iconBtn.Position = UDim2.new(1, 0, 0, 0); iconBtn.BackgroundTransparency = 1; iconBtn.Text = "▼"; iconBtn.TextColor3 = ColorTextDim; iconBtn.Font = Enum.Font.Gotham; iconBtn.TextSize = 9
	
	local scroll = Instance.new("ScrollingFrame", dropFrame)
	scroll.Size = UDim2.new(1, 0, 1, -30); scroll.Position = UDim2.new(0, 0, 0, 30); scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0; scroll.ScrollBarThickness = 2; scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; scroll.CanvasSize = UDim2.new(0,0,0,0)
	local list = Instance.new("UIListLayout", scroll)
	
	local itemButtons = {}
	for _, entry in pairs(entries) do
		local eBtn = Instance.new("TextButton", scroll); eBtn.Size = UDim2.new(1, 0, 0, 25); eBtn.BackgroundTransparency = 1; eBtn.Text = entry; eBtn.TextColor3 = ColorTextDim; eBtn.Font = Enum.Font.Gotham; eBtn.TextSize = 11; eBtn.TextXAlignment = Enum.TextXAlignment.Left; eBtn.Name = entry
		local pad = Instance.new("UIPadding", eBtn); pad.PaddingLeft = UDim.new(0, pLeft + 20); table.insert(itemButtons, eBtn)
	end
	
	local isOpen = false
	local function updateFilter()
		local txt = string.lower(inputField.Text); local vis = 0; local isSearching = inputField:IsFocused()
		for _, b in ipairs(itemButtons) do
			if not isSearching or txt == "" or string.find(string.lower(b.Name), txt, 1, true) then b.Visible = true; vis = vis + 1 else b.Visible = false end
		end
		if isOpen then TweenService:Create(dropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 30 + math.min(vis * 25, 150))}):Play() end
	end
	
	local function closeDrop()
		isOpen = false; TweenService:Create(iconBtn, TweenInfo.new(0.2), {Rotation = 0}):Play(); TweenService:Create(dropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 30)}):Play()
		if not inputField:IsFocused() then
			local currentMatch = false
			for _, b in ipairs(itemButtons) do if inputField.Text == title .. ": " .. b.Name then currentMatch = true break end end
			if not currentMatch then inputField.Text = title .. ": " .. (defaultVal or entries[1]) end
		end
	end
	
	local function openDrop() isOpen = true; TweenService:Create(iconBtn, TweenInfo.new(0.2), {Rotation = 180}):Play(); updateFilter() end
	
	addConnection(iconBtn.MouseButton1Click:Connect(function() if isOpen then closeDrop() else openDrop() end end))
	addConnection(inputField.Focused:Connect(function() openDrop() end))
	addConnection(inputField:GetPropertyChangedSignal("Text"):Connect(function() if inputField:IsFocused() then updateFilter() end end))
	
	for _, b in ipairs(itemButtons) do
		addConnection(b.MouseButton1Click:Connect(function() defaultVal = b.Name; inputField.Text = title .. ": " .. b.Name; closeDrop(); if callback then callback(b.Name) end end))
	end
	return dropFrame
end

local function CreateInput(parent, placeholder, defaultVal, indentLevel, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
	local pLeft = (indentLevel and indentLevel > 0) and (indentLevel * 15) or 0
	local w = Instance.new("Frame", f); w.Size = UDim2.new(1, -pLeft, 1, 0); w.Position = UDim2.new(0, pLeft, 0, 0); w.BackgroundColor3 = ColorContentBG; Instance.new("UICorner", w).CornerRadius = UDim.new(0, 4); local str = Instance.new("UIStroke", w); str.Color = ColorStroke; str.Thickness = 1
	local box = Instance.new("TextBox", w); box.Size = UDim2.new(1, 0, 1, 0); box.BackgroundTransparency = 1; box.Text = defaultVal or ""; box.PlaceholderText = placeholder; box.TextColor3 = ColorAccent; box.PlaceholderColor3 = ColorTextDim; box.Font = Enum.Font.Gotham; box.TextSize = 11; box.TextXAlignment = Enum.TextXAlignment.Left; box.ClipsDescendants = true; box.ClearTextOnFocus = false
	local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10)
	if callback then addConnection(box.FocusLost:Connect(function() callback(box.Text) end)) end
	return box
end

local function CreateInputWithButton(parent, placeholder, btnText, defaultVal, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
	local w = Instance.new("Frame", f); w.Size = UDim2.new(1, -65, 1, 0); w.BackgroundColor3 = ColorContentBG; Instance.new("UICorner", w).CornerRadius = UDim.new(0, 4); local str = Instance.new("UIStroke", w); str.Color = ColorStroke; str.Thickness = 1
	local box = Instance.new("TextBox", w); box.Size = UDim2.new(1, 0, 1, 0); box.BackgroundTransparency = 1; box.Text = defaultVal or ""; box.PlaceholderText = placeholder; box.TextColor3 = ColorAccent; box.PlaceholderColor3 = ColorTextDim; box.Font = Enum.Font.Gotham; box.TextSize = 11; box.TextXAlignment = Enum.TextXAlignment.Left; box.ClearTextOnFocus = false
	local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0, 10)
	local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(0, 60, 1, 0); btn.Position = UDim2.new(1, -60, 0, 0); btn.BackgroundColor3 = ColorContentBG; btn.Text = btnText; btn.TextColor3 = ColorAccent; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); local bstr = Instance.new("UIStroke", btn); bstr.Color = ColorStroke; bstr.Thickness = 1
	addConnection(btn.MouseButton1Click:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = ColorDarker}):Play(); task.wait(0.1); TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = ColorContentBG}):Play(); if callback then callback(box.Text) end end))
end

local function CreateButton(parent, text, colorOverride, callback)
	local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, 0, 0, 30); f.BackgroundTransparency = 1
	local btn = Instance.new("TextButton", f); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundColor3 = colorOverride or ColorContentBG; btn.Text = text; btn.TextColor3 = ColorAccent; btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4); local str = Instance.new("UIStroke", btn); str.Color = ColorStroke; str.Thickness = 1
	addConnection(btn.MouseButton1Click:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = ColorDarker}):Play(); task.wait(0.1); TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = colorOverride or ColorContentBG}):Play(); if callback then callback(btn) end end))
	return btn
end

local activeIndex, openTitleHeight = 1, 35
local function createFlexCard(title, index)
	local isInit = (index == activeIndex)
	local cCont = Instance.new("Frame", FlexRow); cCont.Size = isInit and UDim2.new(expandedWidth.Scale, expandedWidth.Offset, 1, 0) or UDim2.new(shrunkWidth.Scale, shrunkWidth.Offset, 1, 0); cCont.BackgroundTransparency = 1; cCont.LayoutOrder = index
	local cBtn = Instance.new("TextButton", cCont); cBtn.Size = UDim2.new(1, 0, 1, 0); cBtn.BackgroundColor3 = ColorMenu; cBtn.Text = ""; cBtn.AutoButtonColor = false; Instance.new("UICorner", cBtn).CornerRadius = UDim.new(0, 10); local cStr = Instance.new("UIStroke", cBtn); cStr.Color = isInit and ColorAccent or ColorStroke; cStr.Thickness = 1
	local tBg = Instance.new("Frame", cBtn); tBg.Size = UDim2.new(1, 0, 0, openTitleHeight); tBg.BackgroundColor3 = ColorTitleBG; tBg.BackgroundTransparency = isInit and 0 or 1; tBg.ClipsDescendants = true; Instance.new("UICorner", tBg).CornerRadius = UDim.new(0, 10); local tStr = Instance.new("UIStroke", tBg); tStr.Color = ColorStroke; tStr.Thickness = 1; tStr.Transparency = isInit and 0 or 1
	local bFil = Instance.new("Frame", tBg); bFil.Size = UDim2.new(1, 0, 0, 15); bFil.Position = UDim2.new(0, 0, 1, -15); bFil.BackgroundColor3 = ColorTitleBG; bFil.BorderSizePixel = 0; bFil.Visible = isInit
	local tOp = Instance.new("TextLabel", tBg); tOp.Size = UDim2.new(1, -30, 1, 0); tOp.Position = UDim2.new(0, 15, 0, 0); tOp.BackgroundTransparency = 1; tOp.Text = title; tOp.TextColor3 = ColorAccent; tOp.Font = Enum.Font.GothamBold; tOp.TextSize = 13; tOp.TextXAlignment = Enum.TextXAlignment.Left; tOp.Visible = isInit
	local tCl = Instance.new("TextLabel", cBtn); tCl.Size = UDim2.new(0, 360, 1, 0); tCl.AnchorPoint = Vector2.new(0.5, 0.5); tCl.Position = UDim2.new(0.5, 0, 0.5, 0); tCl.Rotation = 90; tCl.BackgroundTransparency = 1; tCl.Text = title; tCl.TextColor3 = ColorTextDim; tCl.Font = Enum.Font.GothamBold; tCl.TextSize = 13; tCl.TextXAlignment = Enum.TextXAlignment.Left; tCl.Visible = not isInit; local padCl = Instance.new("UIPadding", tCl); padCl.PaddingLeft = UDim.new(0, 15)
	local scr = Instance.new("ScrollingFrame", cBtn); scr.Size = UDim2.new(1, -20, 1, -45); scr.Position = UDim2.new(0, 10, 0, 40); scr.BackgroundTransparency = 1; scr.BorderSizePixel = 0; scr.ScrollBarThickness = 2; scr.AutomaticCanvasSize = Enum.AutomaticSize.Y; scr.CanvasSize = UDim2.new(0,0,0,0); scr.Visible = isInit; local spad = Instance.new("UIPadding", scr); spad.PaddingTop = UDim.new(0, 5); spad.PaddingLeft = UDim.new(0, 5); spad.PaddingRight = UDim.new(0, 5); local list = Instance.new("UIListLayout", scr); list.Padding = UDim.new(0, 8); list.SortOrder = Enum.SortOrder.LayoutOrder
	local fSig = Instance.new("TextLabel", cBtn); fSig.Size = UDim2.new(1, 0, 0, 15); fSig.AnchorPoint = Vector2.new(0, 1); fSig.Position = UDim2.new(0, 0, 1, -5); fSig.BackgroundTransparency = 1; fSig.Text = "ARSY CONSOLE"; fSig.TextColor3 = Color3.fromHex("#4A4A4A"); fSig.Font = Enum.Font.GothamBold; fSig.TextSize = 10; fSig.Visible = isInit

	flexCards[index] = {Cont = cCont, Btn = cBtn, TBg = tBg, TStr = tStr, Fil = bFil, TOp = tOp, TCl = tCl, Sig = fSig, Str = cStr, Scr = scr}

	addConnection(cBtn.MouseButton1Click:Connect(function()
		if activeIndex == index then return end; activeIndex = index
		for i, v in pairs(flexCards) do
			local s = (i == activeIndex)
			if not s then v.Scr.Visible = false; v.Fil.Visible = false else v.Fil.Visible = true end
			v.TOp.Visible = s; v.TCl.Visible = not s; v.Sig.Visible = s
			local tw = TweenService:Create(v.Cont, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = s and UDim2.new(expandedWidth.Scale, expandedWidth.Offset, 1, 0) or UDim2.new(shrunkWidth.Scale, shrunkWidth.Offset, 1, 0)}); tw:Play()
			TweenService:Create(v.TBg, TweenInfo.new(0.3), {BackgroundTransparency = s and 0 or 1}):Play()
			TweenService:Create(v.TStr, TweenInfo.new(0.3), {Transparency = s and 0 or 1}):Play()
			TweenService:Create(v.Str, TweenInfo.new(0.3), {Color = s and ColorAccent or ColorStroke}):Play()
			if s then addConnection(tw.Completed:Connect(function() if activeIndex == i then v.Scr.Visible = true end end)) end
		end
	end))
	return scr 
end

-- ==========================================
-- 🧹 6. GLOBAL CLEANUP
-- ==========================================
local function DestroyScript()
	for _, conn in ipairs(scriptConnections) do if conn.Connected then conn:Disconnect() end end
	table.clear(scriptConnections); if ScreenGui then ScreenGui:Destroy() end; table.clear(flexCards)
	for _, conn in ipairs(afkConnections) do pcall(function() conn:Enable() end) end
	for _, conn in ipairs(optConnections) do if conn.Connected then conn:Disconnect() end end
	for _, conn in ipairs(hideUsnConnections) do if conn.Connected then conn:Disconnect() end end
	for _, conn in ipairs(hideOthersConnections) do if conn.Connected then conn:Disconnect() end end
	for _, conn in ipairs(fishNotifConns) do if conn.Connected then conn:Disconnect() end end
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true); StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
	if pingFpsConnection then pingFpsConnection:Disconnect() end; if connectionTCS then connectionTCS:Disconnect() end; if connectionLegacy then connectionLegacy:Disconnect() end
	task.cancel(cleanerThread)
end
getgenv().Arsy_V2_Cleanup = DestroyScript

-- ==========================================
-- 🚀 7. PERAKITAN MENU (UI MAPPING)
-- ==========================================

-- [ CARD 1 : DASHBOARD ] --
local c1 = createFlexCard("DASHBOARD", 1)
CreateToggle(c1, "Anti AFK", states.AAFK, 0, function(s) states.AAFK = s; applyAAFK(); triggerAutoSave() end)
CreateToggle(c1, "PING | FPS", states.Ping, 0, function(s) states.Ping = s; applyPing(); triggerAutoSave() end)

local perfSec = CreateCollapsibleSection(c1, "Performance")
CreateToggle(perfSec, "Normal Mode", states.Opt, 1, function(s) states.Opt = s; applyOpt(); triggerAutoSave() end)
CreateButton(perfSec, "Execute Brute Mode", Color3.fromHex("#8b2525"), function(btnObj) 
	executeBrute()
	btnObj.Text = "ACTIVE (REJOIN TO RESET)"
	btnObj.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
end)
CreateDescription(perfSec, "After enabling brute mode, reset or rejoin to return to normal", 1)

CreateToggle(c1, "Fish Notification", states.FishNotif, 0, function(s) states.FishNotif = s; applyFishNotif(); triggerAutoSave() end)
CreateToggle(c1, "Hide USN", states.HideUSN, 0, function(s) states.HideUSN = s; applyHideUSN(); triggerAutoSave() end)
CreateToggle(c1, "Hide Other Player", states.HideOthers, 0, function(s) states.HideOthers = s; applyHideOthers(); triggerAutoSave() end)


-- [ CARD 2 : WEBHOOK ] --
local c2 = createFlexCard("WEBHOOK", 2)
CreateLabel(c2, "Server Notification", true)

CreateInputWithButton(c2, "Webhook link", "Check", states.Webhook, function(text) 
	states.Webhook = text; triggerAutoSave()
	if text ~= "" and string.find(text, "discord.com/api/webhooks") then
		task.spawn(function()
			pcall(function() req({Url = string.gsub(text, "%?wait=true", ""), Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode({ content = "✅ **Arsy Console V2.0**\nStatus: Webhook berhasil terhubung dan siap digunakan!", username = "Server Notification" })}) end)
		end)
	end
end)

local f1Sec = CreateCollapsibleWithToggle(c2, "Filter 1", states.F1.Toggle, function(s) states.F1.Toggle = s; updateRadarStatus(); triggerAutoSave() end)
CreateSearchableDropdown(f1Sec, "Fish Name", fishNames, states.F1.Fish, 1, function(val) states.F1.Fish = val; triggerAutoSave() end)
CreateSearchableDropdown(f1Sec, "Mutation", mutations, states.F1.Mut, 1, function(val) states.F1.Mut = val; triggerAutoSave() end)

local f2Sec = CreateCollapsibleWithToggle(c2, "Filter 2", states.F2.Toggle, function(s) states.F2.Toggle = s; updateRadarStatus(); triggerAutoSave() end)
CreateSearchableDropdown(f2Sec, "Fish Name", fishNames, states.F2.Fish, 1, function(val) states.F2.Fish = val; triggerAutoSave() end)
CreateSearchableDropdown(f2Sec, "Mutation", mutations, states.F2.Mut, 1, function(val) states.F2.Mut = val; triggerAutoSave() end)

local f3Sec = CreateCollapsibleWithToggle(c2, "Filter 3", states.F3.Toggle, function(s) states.F3.Toggle = s; updateRadarStatus(); triggerAutoSave() end)
CreateSearchableDropdown(f3Sec, "Fish Name", fishNames, states.F3.Fish, 1, function(val) states.F3.Fish = val; triggerAutoSave() end)
CreateSearchableDropdown(f3Sec, "Mutation", mutations, states.F3.Mut, 1, function(val) states.F3.Mut = val; triggerAutoSave() end)

local kwSec = CreateCollapsibleWithToggle(c2, "Keyword Filter", states.KwToggle, function(s) states.KwToggle = s; updateRadarStatus(); triggerAutoSave() end)
for i = 1, 6 do CreateInput(kwSec, "Keyword " .. i, states.Keywords[i], 1, function(text) states.Keywords[i] = text; triggerAutoSave() end) end


-- [ CARD 3 : CONFIGURATION ] --
local c3 = createFlexCard("CONFIGURATION", 3)
CreateLabel(c3, "Configuration Settings", true)
CreateToggle(c3, "Auto Save", states.AutoSave, 0, function(s) states.AutoSave = s; if s then saveConfig() end end)
CreateToggle(c3, "Auto Load", states.AutoLoad, 0, function(s) states.AutoLoad = s; triggerAutoSave() end)
CreateButton(c3, "Save Configuration", nil, function() saveConfig(); print("Config Saved!") end)
CreateButton(c3, "Load Configuration", nil, function() loadConfig(); print("Config Loaded!") end)

CreateLabel(c3, "", false) 
CreateButton(c3, "🔴 Destroy Script & Close", Color3.fromHex("#5a1e1e"), function() DestroyScript() end)


-- ==========================================
-- ⚡ 8. AUTO-START INJEKSI AWAL
-- ==========================================
task.spawn(function()
	if states.AAFK then applyAAFK() end
	if states.Ping then applyPing() end
	if states.Opt then applyOpt() end
	if states.HideUSN then applyHideUSN() end
	if states.HideOthers then applyHideOthers() end
	if states.FishNotif then applyFishNotif() end
	updateRadarStatus() 
end)

print("[ArsyV2.0] Executed Perfectly.")
