-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V7 (BAREBONE EDITION)
-- Target: RAM 500MB - 700MB (Khusus 32-bit)
-- Fitur: Texture Stripping, Log Clear, 10s UI Update
-- =========================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LogService = game:GetService("LogService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 📊 UI MONITORING (UPDATE SETIAP 10 DETIK)
-- ==========================================
pcall(function()
    if CoreGui:FindFirstChild("MiniStatsUI") then CoreGui.MiniStatsUI:Destroy() end
    local ui = Instance.new("ScreenGui", CoreGui)
    ui.Name = "MiniStatsUI"
    local bg = Instance.new("Frame", ui)
    bg.Size = UDim2.new(0, 120, 0, 15); bg.Position = UDim2.new(0.5, -60, 0, 0)
    bg.BackgroundColor3 = Color3.new(0,0,0); bg.BackgroundTransparency = 0.8; bg.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(0,1,0)
    lbl.Font = Enum.Font.Code; lbl.TextSize = 9; lbl.Text = "Syncing..."

    task.spawn(function()
        while task.wait(10) do -- Update sangat lambat agar RAM tidak bocor
            local ram = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            lbl.Text = ram .. "MB | " .. ping .. "ms | 10"
        end
    end)
end)

-- ==========================================
-- 🛠️ STRIPPING TEKSTUR & MESH (EXTREME)
-- ==========================================
local function strip(v)
    pcall(function()
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
            v.Reflectance = 0
        elseif v:IsA("MeshPart") then
            v.TextureID = "" -- Menghapus gambar pada mesh
            v.MeshId = ""    -- Menjadikan mesh menjadi kotak (Sangat Hemat RAM)
        elseif v:IsA("SpecialMesh") then
            v.TextureId = ""
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("Sound") or v:IsA("Animation") then
            v:Destroy()
        end
    end)
end

-- Sapu awal seluruh map
for _, v in pairs(game:GetDescendants()) do strip(v) end

-- Radar untuk objek baru
game.DescendantAdded:Connect(strip)

-- ==========================================
-- 🧹 LOG & GARBAGE CLEANER
-- ==========================================
task.spawn(function()
    while task.wait(10) do
        pcall(function()
            collectgarbage("collect")
            LogService:ClearOutput() -- Menghapus sampah pesan di console
        end)
    end
end)

-- ==========================================
-- 🔒 PENGUNCI SISTEM (FPS & RENDER)
-- ==========================================
pcall(function()
    if setfpscap then setfpscap(10) end
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    sethiddenproperty(Lighting, "Technology", 2) -- Compatibility Mode
    
    -- Matikan Render 3D total (Jika didukung)
    RunService:Set3dRenderingEnabled(false)
end)

-- Sembunyikan UI Roblox
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

print("💀 V7 BAREBONE ACTIVE: Memory stripping complete.")
