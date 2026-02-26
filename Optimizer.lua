-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER + ULTRA BURIK (ALL-IN-ONE)
-- Versi Final: UI Notification, Ghost Mode, Audio Nuke,
-- Skybox Nuke, 10 FPS Capper, No Camera Alteration.
-- =========================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Terrain = Workspace.Terrain

-- 📢 Fungsi Notifikasi UI untuk memantau progres di layar
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3
        })
    end)
end

notify("🚀 Optimizer Dimulai", "Menyiapkan optimasi tingkat ekstrem...")
task.wait(2)

-- ==========================================
-- TAHAP 1: EXTREME FPS & ULTIMATE PERFORMANCE
-- ==========================================
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.ShadowSoftness = 0

    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Terrain.Decoration = false

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false -- Mematikan bayangan individual
        elseif v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then 
            v:Destroy() 
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)
notify("✅ Tahap 1 Selesai", "Dunia plastik polos dan tanpa tekstur!")
task.wait(2)

-- ==========================================
-- TAHAP 2: ULTRA BURIK (LANGIT, SUARA, & FPS)
-- ==========================================
pcall(function()
    -- 1. Penghancur Langit & Cahaya
    Lighting.Ambient = Color3.new(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
    Lighting.Brightness = 0
    Lighting.ClockTime = 0 
    
    -- 2. Pemusnah Suara
    UserSettings().GameSettings.MasterVolume = 0
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Sound") then
            v:Stop()
            v.SoundId = ""
            v.Volume = 0
        end
    end
    
    -- 3. Pembatas Kecepatan (10 FPS)
    if setfpscap then
        setfpscap(10)
    end
end)
notify("📉 Tahap 2 Selesai", "Langit gelap, game bisu, dan dilock 10 FPS!")
task.wait(2)

-- ==========================================
-- TAHAP 3: AUTO REMOVE PLAYER (GHOST MODE)
-- ==========================================
pcall(function()
    local function hideCharacter(character)
        if not character then return end
        task.wait(0.5) 
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("CharacterMesh") or v:IsA("ShirtGraphic") then
                v:Destroy()
            elseif v:IsA("BasePart") then
                pcall(function()
                    v.Transparency = 1
                    v.CanCollide = false
                    v.CastShadow = false
                end)
            end
        end
    end

    local function handlePlayer(player)
        if player ~= LocalPlayer then
            if player.Character then hideCharacter(player.Character) end
            player.CharacterAdded:Connect(function(newChar) hideCharacter(newChar) end)
        end
    end

    for _, player in pairs(Players:GetPlayers()) do handlePlayer(player) end
    Players.PlayerAdded:Connect(handlePlayer)
end)
notify("👻 Tahap 3 Selesai", "Mode Hantu aktif! Pemain lain disembunyikan.")
task.wait(2)

-- ==========================================
-- TAHAP 4: DISABLE 3D RENDER (ANTI-CRASH)
-- ==========================================
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    RunService:BindToRenderStep("Hentikan3D", Enum.RenderPriority.Camera.Value, function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
    end)
end)
notify("✅ Tahap 4 Selesai", "Render 3D ditekan. RAM dihemat maksimal!")

-- Kesimpulan akhir
task.wait(2)
notify("🎉 OPTIMASI TOTAL SELESAI!", "Redfinger Anda sekarang dalam mode Ultra Hemat.")
