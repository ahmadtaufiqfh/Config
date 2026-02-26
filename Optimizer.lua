-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V10 (VISUAL BAREBONE)
-- Target: RAM minimalis, Bentuk Terlihat, Radius 30m
-- =========================================================

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 📊 UI MONITORING (UPDATE 10 DETIK)
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
    lbl.Font = Enum.Font.Code; lbl.TextSize = 9; lbl.Text = "V10 Loading..."

    task.spawn(function()
        while task.wait(10) do
            local ram = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            lbl.Text = ram .. "MB | " .. ping .. "ms | 10"
        end
    end)
end)

-- ==========================================
-- 🛠️ PENGHANCUR GRAFIK & RADIUS (ULTRA BURIK)
-- ==========================================
local function optimizeObject(v, rootPos)
    pcall(function()
        if v:IsA("BasePart") then
            -- Cek Jarak (Radius 30)
            if v.Position and rootPos then
                local dist = (v.Position - rootPos).Magnitude
                if dist > 30 and not v:IsDescendantOf(LocalPlayer.Character) and v.Name ~= "Terrain" then
                    v:Destroy() -- Hapus total jika di luar radius
                    return
                end
            end
            
            -- Jika di dalam radius, buat jadi "Burik"
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
            v.CanTouch = false
            v.CanQuery = false
            
            if v:IsA("MeshPart") then
                v.TextureID = ""
                v.RenderFidelity = Enum.RenderFidelity.Performance
                v.InitialSize = Vector3.new(1,1,1) -- Mengecilkan beban kalkulasi mesh
            end
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v:Destroy()
        elseif v:IsA("Sound") or v:IsA("Animation") then
            v:Destroy()
        end
    end)
end

-- Eksekusi Utama
task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local pos = root.Position

    -- Sapu bersih awal
    for _, v in pairs(Workspace:GetDescendants()) do
        optimizeObject(v, pos)
    end
    
    -- Radar untuk objek baru yang muncul
    Workspace.DescendantAdded:Connect(function(v)
        optimizeObject(v, pos)
    end)
end)

-- ==========================================
-- 🔒 LIGHTING & RENDER (BAREBONE VISUAL)
-- ==========================================
pcall(function()
    if setfpscap then setfpscap(10) end
    
    -- Pastikan Rendering 3D AKTIF (Agar tidak hitam/putih)
    RunService:Set3dRenderingEnabled(true) 
    
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    sethiddenproperty(Lighting, "Technology", 2) -- Compatibility Mode (Paling ringan)
    
    settings().Rendering.QualityLevel = 1
end)

-- Sembunyikan UI Roblox agar tidak makan RAM teks
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

-- Garbage Collector
task.spawn(function()
    while task.wait(20) do
        collectgarbage("collect")
        game:GetService("LogService"):ClearOutput()
    end
end)

print("💀 V10 VISUAL BAREBONE ACTIVE: Shapes Visible, Radius 30m.")
