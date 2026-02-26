-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER (ALL-IN-ONE + UI NOTIFICATION)
-- Eksekusi berurutan: 1 per 1 dengan laporan di layar
-- =========================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Terrain = Workspace.Terrain

-- 📢 Fungsi pembuat notifikasi UI di pojok kanan bawah layar
local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3 -- Notifikasi akan muncul selama 3 detik
        })
    end)
end

notify("🚀 Optimizer Dimulai", "Menyiapkan eksekusi tahap 1...")
task.wait(2) -- Jeda 2 detik sebelum mulai

-- ==========================================
-- TAHAP 1: EXTREME FPS BOOST
-- ==========================================
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.ShadowSoftness = 0

    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") then v:Destroy() end
    end

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("Terrain") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    end
end)
notify("✅ Tahap 1 Selesai", "Extreme FPS Boost (Plastik Polos) aktif!")
task.wait(2)

-- ==========================================
-- TAHAP 2: ULTIMATE PERFORMANCE
-- ==========================================
pcall(function()
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0
    Terrain.Decoration = false

    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end)
notify("✅ Tahap 2 Selesai", "Ultimate Performance (Hapus Tekstur & Air) aktif!")
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
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
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
notify("✅ Tahap 4 Selesai", "Render 3D ditekan. RAM berhasil dihemat!")

-- Kesimpulan akhir
task.wait(2)
notify("🎉 OPTIMASI SELESAI!", "Redfinger Anda sekarang sangat ringan untuk AFK.")
