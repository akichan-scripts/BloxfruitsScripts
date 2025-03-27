-- 🏴‍☠️ Blox Fruits - Ultimate Anti-Ban & Auto Farming Script
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits - Safe Mode", "DarkTheme")

local Player = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")

_G.AntiBan = true
_G.FakeMovements = true
_G.AutoChest = false
_G.AutoBounty = false
_G.GodMode = false
_G.AutoEliteHunter = false
_G.AutoAwakening = false
_G.AutoFruitSniper = false
_G.AutoRaid = false

-- 🔒 **ANTI-BAN SYSTEM**
function AntiBan()
    -- Hide from detection logs
    setfflag("AbuseReportScreenshot", "false")
    setfflag("AbuseReportScreenshotPercentage", "0")
    setfflag("ScreenshotListener", "false")

    -- Prevent Server Checks
    local meta = getrawmetatable(game)
    local oldIndex = meta.__index
    setreadonly(meta, false)
    meta.__index = function(t, k)
        if k == "Kick" then
            return function() warn("[Anti-Ban] Kick Blocked!") end
        end
        return oldIndex(t, k)
    end
    setreadonly(meta, true)

    print("[Anti-Ban] Protection Enabled ✅")
end

-- 🔄 **AUTO RECONNECT IF KICKED**
game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" then
        warn("[Anti-Ban] Reconnecting...")
        wait(2)
        TeleportService:Teleport(game.PlaceId, Player)
    end
end)

-- 🕵️ **STEALTH MODE**
function StealthMode()
    wait(math.random(1, 5)) -- Random delay for human-like execution

    -- Hide execution traces
    for _, v in pairs(getgc(true)) do
        if type(v) == "function" and not is_synapse_function(v) then
            setfenv(v, setmetatable({}, { __index = getfenv(0) }))
        end
    end
    print("[Anti-Ban] Stealth Mode Active 🕵️")
end

-- 🎭 **FAKE MOVEMENTS (Simulates Human Actions)**
function FakeMovements()
    while _G.FakeMovements do
        wait(math.random(5, 15)) -- Random movement every few seconds

        -- Simulate walking
        VirtualInputManager:SendKeyEvent(true, "W", false, game)
        wait(math.random(1, 3))
        VirtualInputManager:SendKeyEvent(false, "W", false, game)

        -- Random jump
        if math.random(1, 5) == 3 then
            VirtualInputManager:SendKeyEvent(true, "Space", false, game)
            wait(0.2)
            VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        end

        -- Random turn
        if math.random(1, 4) == 2 then
            VirtualInputManager:SendMouseMoveEvent(math.random(-500, 500), math.random(-200, 200))
        end

        print("[Fake Movements] Simulated Player Action 🎭")
    end
end

-- 💰 Auto Chest Collector (Stops on Fist of Darkness/God’s Chalice)
function collectChests()
    while _G.AutoChest do
        for _, chest in pairs(game.Workspace:GetChildren()) do
            if not _G.AutoChest then break end
            if chest:IsA("Model") and chest:FindFirstChild("Chest") then
                Player.Character.HumanoidRootPart.CFrame = chest.Chest.CFrame
                wait(0.2)

                for _, item in pairs(Player.Backpack:GetChildren()) do
                    if item:IsA("Tool") and (item.Name == "Fist of Darkness" or item.Name == "God's Chalice") then
                        _G.AutoChest = false
                        print("Rare item found! Stopping Auto Chest Collector.")
                        return
                    end
                end
            end
        end
        wait(2)
    end
end

-- 🛡️ God Mode (No Hit)
function enableGodMode()
    while _G.GodMode do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid:SetAttribute("Health", math.huge)
        end
        wait(1)
    end
end

-- 🏹 Auto Elite Hunter
function huntEliteBosses()
    while _G.AutoEliteHunter do
        for _, boss in pairs(game.Workspace:GetChildren()) do
            if boss:IsA("Model") and boss:FindFirstChild("HumanoidRootPart") and boss.Name:match("Diablo|Deandre|Urban") then
                Player.Character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame
                wait(0.2)

                repeat
                    if boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        game:GetService("VirtualUser"):CaptureController()
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                    end
                    wait(0.5)
                until not boss:FindFirstChild("Humanoid") or boss.Humanoid.Health <= 0
            end
        end
        wait(5)
    end
end

-- ⚡ Auto Raid System
function startRaid()
    while _G.AutoRaid do
        local Remote = game:GetService("ReplicatedStorage").Remotes.CommF_
        local hasChip = Remote:InvokeServer("Raids", "Check")
        if not hasChip then
            Remote:InvokeServer("Raids", "Buy")
        end
        Remote:InvokeServer("Raids", "Start")
        wait(5)

        while _G.AutoRaid and game.Workspace.Enemies:FindFirstChildWhichIsA("Model") do
            for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
                    wait(0.2)
                    repeat
                        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                        end
                        wait(0.5)
                    until not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0
                end
            end
            wait(1)
        end
    end
end

-- **Activate Anti-Ban and Fake Movements**
if _G.AntiBan then
    AntiBan()
    StealthMode()
end

if _G.FakeMovements then
    spawn(FakeMovements)
end
