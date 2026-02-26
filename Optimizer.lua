-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V14 (ZERO-DELETION)
-- Fokus: 100% Aman untuk Bot Fishit
-- Tanpa Destroy(), Hanya Manipulasi Visual
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
    lbl.Font = Enum.Font.Code; lbl.TextSize = 9; lbl.Text = "V14 Safe Engine..."

    task.spawn(function()
        while task.wait(5) do
            local ram = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            lbl.Text = ram .. "MB | " .. ping .. "ms | 10"
        end
    end)
end)

-- ==========================================
-- 🛠️ LOGIKA OPTIMASI GAIB (BOT-SAFE)
-- ==========================================
local function safeOptimize(v)
    pcall(function()
        -- JANGAN ganggu karakter kita atau objek yang sangat penting
        if v:IsDescendantOf(LocalPlayer.Character) then return end
        
        if v:IsA("BasePart") then
            -- JANGAN di-Destroy, cukup buat transparan total agar GPU tidak kerja
            v.Transparency = 1
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
            v.Reflectance = 0
            
            -- Biarkan CanTouch & CanQuery TETAP TRUE agar bot tidak error
            v.CanTouch = true 
            v.CanQuery = true
            
            if v:IsA("MeshPart") then
                v.TextureID = ""
                v.RenderFidelity = Enum.RenderFidelity.Performance
            end
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            -- Efek visual kecil aman untuk dihapus (Opsional: ubah ke Transparency = 1 jika ragu)
            v.Enabled = false 
        elseif v:IsA("Sound") then
            v.Volume = 0
            v:Stop()
        end
    end)
end

-- Eksekusi Utama (Penyisiran bertahap agar tidak lag saat eksekusi)
task.spawn(function()
    local descendants = Workspace:GetDescendants()
    for i = 1, #descendants do
        safeOptimize(descendants[i])
        if i % 100 == 0 then task.wait() end -- Jeda agar Redfinger tidak freeze
    end
end)

-- Pantau objek baru (seperti ikan yang muncul atau efek cuaca)
Workspace.DescendantAdded:Connect(safeOptimize)

-- ==========================================
-- 🔒 SETTING MESIN (PRIORITAS STABILITAS)
-- ==========================================
pcall(function()
    if setfpscap then setfpscap(10) end
    
    -- Rendering harus menyala agar bot bisa mendeteksi kail
    RunService:Set3dRenderingEnabled(true)
    
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    sethiddenproperty(Lighting, "Technology", 2)
    
    -- Turunkan kualitas grafik ke paling rendah
    settings().Rendering.QualityLevel = 1
end)

-- Pengumpul sampah memori berkala
task.spawn(function()
    while task.wait(30) do
        collectgarbage("collect")
        game:GetService("LogService"):ClearOutput()
    end
end)

print("✅ V14 Safe Engine Active: Zero Deletion Mode.")
