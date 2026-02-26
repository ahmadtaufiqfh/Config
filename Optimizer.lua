-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V5 (FINAL)
-- Fitur: T-Pose, RAM Sweeper, UI Nuke, 10 FPS, & Mini Stats UI
-- =========================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Terrain = Workspace.Terrain

-- ==========================================
-- 📊 PEMBUATAN UI KOTAK KECIL (RAM | PING | FPS)
-- ==========================================
pcall(function()
    -- Hapus UI lama jika script dieksekusi ulang
    if CoreGui:FindFirstChild("MiniStatsUI") then CoreGui.MiniStatsUI:Destroy() end
    if LocalPlayer.PlayerGui:FindFirstChild("MiniStatsUI") then LocalPlayer.PlayerGui.MiniStatsUI:Destroy() end

    local ui = Instance.new("ScreenGui")
    ui.Name = "MiniStatsUI"
    ui.ResetOnSpawn = false
    
    -- Gunakan CoreGui agar tidak tertutup menu game, jika gagal pakai PlayerGui
    local success = pcall(function() ui.Parent = CoreGui end)
    if not success then ui.Parent = LocalPlayer.PlayerGui end

    local bg = Instance.new("Frame", ui)
    bg.Size = UDim2.new(0, 150, 0, 20)
    bg.Position = UDim2.new(0.5, -75, 0, 5) -- Posisi di atas tengah
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    bg.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(0, 1, 0) -- Warna Hijau Terang
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 12
    lbl.Text = "Memuat..."

    -- Loop untuk memperbarui angka setiap frame
    RunService.RenderStepped:Connect(function(deltaTime)
        local fps = math.floor(1 / deltaTime)
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local ram = math.floor(Stats:GetTotalMemoryUsageMb())
        
        lbl.Text = ram .. "MB | " .. ping .. "ms | " .. fps
    end)
end)

-- ==========================================
-- 1. PEMBUNUH FISIKA & SAPUAN AWAL
-- ==========================================
pcall(function()
    Lighting.GlobalShadows = false
    sethiddenproperty(Lighting, "Technology", 2) -- Teknologi jadul
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.Decoration = false

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
            if v.Name ~= "HumanoidRootPart" then
                v.CanTouch = false
                v.CanQuery = false
            end
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)

-- ==========================================
-- 2. RADAR CUACA 0% CPU
-- ==========================================
local function radarKill(v)
    pcall(function()
        if v:IsA("Cloud") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("PostEffect") or v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v:Destroy()
        end
    end)
end

for _, v in pairs(game:GetDescendants()) do radarKill(v) end
Workspace.DescendantAdded:Connect(radarKill)
Lighting.DescendantAdded:Connect(radarKill)

Lighting.Ambient = Color3.new(0, 0, 0)
Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
Lighting.Brightness = 0
Lighting.ClockTime = 0 

-- ==========================================
-- 3. PEMUSNAH SUARA, UI, & KUNCI 10 FPS
-- ==========================================
pcall(function()
    if setfpscap then setfpscap(10) end -- Kunci di 10 FPS (Aman & Ringan)
    UserSettings().GameSettings.MasterVolume = 0
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then
            v:Stop()
            v.SoundId = ""
            v.Volume = 0
        end
    end
end)

-- ==========================================
-- 4. MODE HANTU + PEMUSNAH ANIMASI (T-POSE)
-- ==========================================
pcall(function()
    local function hideAndFreeze(character)
        if not character then return end
        task.wait(0.5) 
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") or v:IsA("ShirtGraphic") then
                v:Destroy()
            elseif v:IsA("Animator") or v:IsA("Animation") or v:IsA("AnimationTrack") then
                v:Destroy()
            elseif v:IsA("BasePart") then
                pcall(function() v.Transparency = 1; v.CanCollide = false; v.CastShadow = false; v.CanTouch = false end)
            end
        end
    end

    local function handlePlayer(player)
        if player ~= LocalPlayer then
            if player.Character then hideAndFreeze(player.Character) end
            player.CharacterAdded:Connect(function(newChar) hideAndFreeze(newChar) end)
        end
    end
    for _, player in pairs(Players:GetPlayers()) do handlePlayer(player) end
    Players.PlayerAdded:Connect(handlePlayer)
    
    if LocalPlayer.Character then hideAndFreeze(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(function(newChar) hideAndFreeze(newChar) end)
end)

-- ==========================================
-- 5. AGGRESSIVE RAM SWEEPER (PENGURAS MEMORI)
-- ==========================================
task.spawn(function()
    while task.wait(10) do
        pcall(function()
            collectgarbage("collect")
        end)
    end
end)

-- ==========================================
-- 6. DISABLE 3D RENDER TINGKAT AKAR
-- ==========================================
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    RunService:BindToRenderStep("Hentikan3D", Enum.RenderPriority.Camera.Value, function()
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    end)
end)

print("✅ V5 Final Selesai! UI pemantau aktif di atas layar.")
