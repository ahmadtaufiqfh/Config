-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V11 (FISHIT-SAFE)
-- Fokus: Radius 100m + Whitelist Air agar Bot tidak Error
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
    lbl.Font = Enum.Font.Code; lbl.TextSize = 9; lbl.Text = "V11 Safe Mode..."

    task.spawn(function()
        while task.wait(10) do
            local ram = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            lbl.Text = ram .. "MB | " .. ping .. "ms | 10"
        end
    end)
end)

-- ==========================================
-- 🛠️ RADIUS DENGAN WHITELIST AIR
-- ==========================================
local function isSafe(obj)
    local name = obj.Name:lower()
    -- Daftar kata kunci yang TIDAK BOLEH dihapus agar bot pancing jalan
    if name:find("water") or name:find("sea") or name:find("ocean") or name:find("liquid") or name:find("pool") then
        return true
    end
    if obj:IsA("Terrain") then return true end
    return false
end

local function optimize(v, rootPos)
    pcall(function()
        if v:IsA("BasePart") then
            -- JIKA objek di luar radius DAN bukan air/terrain DAN bukan karakter kita
            if v.Position and rootPos then
                local dist = (v.Position - rootPos).Magnitude
                if dist > 100 and not isSafe(v) and not v:IsDescendantOf(LocalPlayer.Character) then
                    v:Destroy()
                    return
                end
            end
            
            -- Optimasi visual objek yang tersisa
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
            if v:IsA("MeshPart") then
                v.TextureID = ""
                v.RenderFidelity = Enum.RenderFidelity.Performance
            end
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then
            v:Destroy()
        end
    end)
end

-- Menjalankan sistem pembersihan
task.spawn(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- Pembersihan awal
    for _, v in pairs(Workspace:GetDescendants()) do
        optimize(v, root.Position)
    end
    
    -- Radar untuk objek baru
    Workspace.DescendantAdded:Connect(function(v)
        optimize(v, root.Position)
    end)
end)

-- ==========================================
-- 🔒 SISTEM PENDUKUNG
-- ==========================================
pcall(function()
    if setfpscap then setfpscap(10) end
    RunService:Set3dRenderingEnabled(true) -- HARUS TRUE agar bot bisa mendeteksi objek pancing
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    sethiddenproperty(Lighting, "Technology", 2)
    settings().Rendering.QualityLevel = 1
end)

-- Garbage Collector & Log Clear
task.spawn(function()
    while task.wait(20) do
        collectgarbage("collect")
        game:GetService("LogService"):ClearOutput()
    end
end)
