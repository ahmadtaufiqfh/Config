-- =========================================================
-- 🚀 SCRIPT MASTER OPTIMIZER V9 (ATOMIC VOID)
-- Fokus: Penghapusan total objek di luar radius 30m
-- =========================================================

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. LAYAR HITAM TOTAL (PENGHEMAT VRAM)
pcall(function()
    if CoreGui:FindFirstChild("MiniStatsUI") then CoreGui.MiniStatsUI:Destroy() end
    local ui = Instance.new("ScreenGui", CoreGui)
    ui.Name = "MiniStatsUI"
    local bg = Instance.new("Frame", ui)
    bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundColor3 = Color3.new(0,0,0); bg.BorderSizePixel = 0
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(0, 120, 0, 20); lbl.Position = UDim2.new(0.5, -60, 0, 5)
    lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(0, 1, 0)
    lbl.Font = Enum.Font.Code; lbl.TextSize = 10; lbl.Text = "Atomic Cleaning..."

    task.spawn(function()
        while task.wait(10) do
            local ram = math.floor(Stats:GetTotalMemoryUsageMb())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            lbl.Text = ram .. "MB | " .. ping .. "ms | 10"
        end
    end)
end)

-- 2. RADIUS ATOMIK (Hapus Semua Selain Area Pijakan)
-- Radius diset 30 unit (Sangat Sempit)
local function atomicClean()
    pcall(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                -- Jangan hapus karakter sendiri dan jangan hapus Terrain (Air)
                if not v:IsDescendantOf(char) and not v:IsA("Terrain") then
                    local dist = (v.Position - root.Position).Magnitude
                    if dist > 30 then
                        v:Destroy() -- Hapus total dari RAM
                    else
                        -- Objek di dalam radius dijadikan kotak plastik polos
                        v.Material = Enum.Material.SmoothPlastic
                        if v:IsA("MeshPart") then v.TextureID = "" end
                    end
                end
            elseif v:IsA("Sound") or v:IsA("ParticleEmitter") or v:IsA("Decal") then
                v:Destroy()
            end
        end
    end)
end

-- Eksekusi penghapusan atomik
task.spawn(atomicClean)

-- 3. KUNCI SISTEM
pcall(function()
    if setfpscap then setfpscap(10) end
    RunService:Set3dRenderingEnabled(false) -- Matikan render 3D
    game:GetService("Lighting").Brightness = 0
end)

-- 4. PENGURAS SAMPAH MEMORI (TIAP 15 DETIK)
task.spawn(function()
    while task.wait(15) do
        collectgarbage("collect")
        game:GetService("LogService"):ClearOutput()
    end
end)

print("💀 V9 ATOMIC VOID ACTIVE: Radius 30m Lock.")
