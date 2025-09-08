local ReSt = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local configs = {
    nodmg = false,
}

local localplayer = Players.LocalPlayer

local OnServerEvents = ReSt:WaitForChild("OnServerEvents")
local OnClientEvents = ReSt:WaitForChild("OnClientEvents")

local plrdmg = OnServerEvents:WaitForChild("PlrDamaged")
local upgradeselect = OnClientEvents:WaitForChild("UpgradeSelect")

local basicTable = {"Power", "Agility", "Vitality", "Force", "Range"}
local rareTable = {"Greatsword", "Maestro", "Shatter", "Brute force", "Adrenaline", "Riposte", "Fleetfoot", "Survivor", "Healthpack"}
local legendaryTable = {"Reaper", "Blackhole", "Cataclysm", "PerfectDodge", "Shadowstep", "Dismantle", "Assassin", "Giantslayer", "Momentum"}

local function isInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "Purgatory",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Section = MainTab:AddSection({
    Name = "Main"
})

MainTab:AddToggle({
    Name = "No Damage",
    Default = false,
    Callback = function(Value)
        configs.nodmg = Value
        if Value then
            plrdmg.Parent = nil
        else
            plrdmg.Parent = OnServerEvents
        end
    end
})

MainTab:AddDropdown({
    Name = "Select Next Upgrades",
    Default = "Power",
    Options = {
        "Power", "Agility", "Vitality", "Force", "Range",
        "Greatsword", "Maestro", "Shatter", "Brute force",
        "Adrenaline", "Riposte", "Fleetfoot", "Survivor", "Healthpack",
        "Reaper", "Blackhole", "Cataclysm", "PerfectDodge", "Shadowstep",
      "Dismantle", "Assassin", "Giantslayer", "Momentum"
    },
    Callback = function(Value)
        OrionLib:MakeNotification({
            Name = "Upgrade Changed",
            Content = "Next Upgrade has changed to " .. Value .. "!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })

        upgradeselect.OnClientEvent:Wait() -- คงไว้เหมือนเดิม
        local upgradeNum = 1

        if isInTable(basicTable, Value) then
            upgradeNum = 1
        elseif isInTable(rareTable, Value) then
            upgradeNum = 2
        elseif isInTable(legendaryTable, Value) then
            upgradeNum = 3
        end

        OnServerEvents.UpgradeSelected:FireServer(Value, {}, upgradeNum, false)
    end
})

OrionLib:Init()
