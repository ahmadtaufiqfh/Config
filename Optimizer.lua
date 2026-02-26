-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V13 (HYBRID RADIUS)
-- Fokus: Hapus objek > 50m, Transparan untuk objek vital
-- Solusi agar Bot Fishit tetap bisa memancing (Safe Mode)
-- =========================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 📊 UI MONITORING (Update 5 Detik)
-- ==========================================
pcall(function()
    if CoreGui:FindFirstChild("MiniStatsUI") then CoreGui.MiniStatsUI:Destroy() end
    local ui = Instance.new("ScreenGui", CoreGui)
    ui.Name = "MiniStatsUI"
    local bg = Instance.new("Frame", ui)
    bg.Size = UDim2.new(0, 120, 0, 15); bg.Position = UDim2.new(0.5, -60, 0, 0)
    bg.BackgroundColor3 = Color3.new(0,0,0); bg.BackgroundTransparency = 0.8
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(0, 1, 0)
    lbl.Font = Enum.Font.Code; lbl.TextSize = 9; lbl.Text = "V13 Hybrid..."

    task.spawn(function()
        while task.wait(5) do
            local ram = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            lbl.Text = ram .. "MB | " .. ping .. "ms | 10"
        end
    end)
end)

-- ==========================================
-- 🛠️ LOGIKA RADIUS & WHITELIST (SAFE CULLING)
-- ==========================================
local function isCritical(obj)
    local name = obj.Name:lower()
    -- Daftar objek yang TIDAK BOLEH dihancurkan agar bot tidak error
    if name:find("water") or name:find("sea") or name:find("ocean") or name:find("liquid") then return true end
    if obj:IsA("Terrain") then return true end
    return false
end

local function hybridOptimize(v, rootPos)
    pcall(function()
        if v:IsA("BasePart") then
            -- JANGAN ganggu karakter kita sendiri
            if v:IsDescendantOf(LocalPlayer.Character) then return end
            
            local dist = (v.Position - rootPos).Magnitude
            
            if dist > 50 then
                if isCritical(v) then
                    -- Jika itu AIR tapi jauh, JANGAN hapus, cukup buat GAIB
                    v.Transparency = 1
                else
                    -- Jika benda biasa (pohon/gedung) > 50m, HAPUS TOTAL
                    v:Destroy()
                    return
                end
            else
                -- Jika di dalam radius 50m, buat jadi burik (transparan 1)
                v.Transparency = 1
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
                if v:IsA("MeshPart") then v.TextureID = "" end
            end
            
            -- Pastikan Fisika tetap aktif agar kail pancing bisa mendarat
            v.CanTouch = true
            v.CanQuery = true
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then
            v:Destroy()
        end
    end)
end

-- Eksekusi Utama
task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- Sapu bersih awal
    for _, v in pairs(Workspace:GetDescendants()) do
        hybridOptimize(v, root.Position)
    end
    
    -- Radar untuk objek baru
    Workspace.DescendantAdded:Connect(function(v)
        hybridOptimize(v, root.Position)
    end)
end)

-- ==========================================
-- 🔒 SISTEM LOCK (BOT SAFE)
-- ==========================================
pcall(function()
    if setfpscap then setfpscap(10) end
    RunService:Set3dRenderingEnabled(true) -- Wajib TRUE untuk bot Fishit
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    sethiddenproperty(Lighting, "Technology", 2)
    settings().Rendering.QualityLevel = 1
end)

-- Garbage Collector
task.spawn(function()
    while task.wait(20) do
        collectgarbage("collect")
        game:GetService("LogService"):ClearOutput()
    end
end)

print("💀 V13 HYBRID VOID ACTIVE: Radius 50m + Water Protected.")
