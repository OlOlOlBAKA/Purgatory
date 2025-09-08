local ReSt = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local configs = {
    nodmg = false,
}

local localplayer = Players.LocalPlayer
local character = localplayer.Character
local humanoid = character:WaitForChild("Humanoid")
local rootpart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

local OnServerEvents = ReSt:WaitForChild("OnServerEvents")
local OnClientEvents = ReSt:WaitForChild("OnClientEvents")

local plrdmg = OnServerEvents:WaitForChild("PlrDamaged")
local upgradeselect = OnClientEvents:WaitForChild("UpgradeSelect")

local basicTable = {"Power", "Agility", "Vitality", "Force", "Range"}
local rareTable = {"Greatsword", "Maestro", "Shatter", "Brute force", "Adrenaline", "Riposte", "Fleetfoot", "Survivor", "Healthpack"}
local legendaryTable = {"Reaper", "Blackhole", "Cataclysm", "PerfectDodge", "Shadowstep", "Dismantle", "Assassin", "Giantslayer", "Momentum"}
local ferrymanTable = {"Lag","Speedster","Turtle","Heavy","Vampire","Glasscannon"}

local savedCameraType = camera.CameraType
local savedCFrame = camera.CFrame

local function isInTable(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Purgatory Script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Loading Purgatory Script...",
   LoadingSubtitle = "by Chosen and Sega",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "E", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PurgatoryConfig", -- Create a custom folder for your hub/game
      FileName = "Configuration"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main", 4483362458) -- Title, Image
local MainSection = MainTab:CreateSection("Main")
local PlayerTab = Window:CreateTab("Player", 4483362458) -- Title, Image
local MainSection = PlayerTab:CreateSection("Main")

-- Main Tab

local NoDmgToggle = MainTab:CreateToggle({
   Name = "No Damage",
   CurrentValue = false,
   Flag = "NoDamageToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        configs.nodmg = Value
        if Value then
            plrdmg.Parent = nil
        else
            plrdmg.Parent = OnServerEvents
        end
   end,
})
local UpgradeDropdown = MainTab:CreateDropdown({
   Name = "Select Next Upgrade",
   Options = {"None", "Power", "Agility", "Vitality", "Force", "Range",
        "Greatsword", "Maestro", "Shatter", "Brute force",
        "Adrenaline", "Riposte", "Fleetfoot", "Survivor", "Healthpack",
        "Reaper", "Blackhole", "Cataclysm", "PerfectDodge", "Shadowstep",
      "Dismantle", "Assassin", "Giantslayer", "Momentum",
        "Lag","Speedster","Turtle","Heavy","Vampire","Glasscannon",},
   CurrentOption = {"None"},
   MultipleOptions = false,
   Flag = "UpgradeDropDown",
   Callback = function(Value)
        Value = unpack(Value)
        Rayfield:Notify({
   Title = "Next Upgrade Changed",
   Content = "Next Upgrade Selection Changed To " .. Value .."!",
   Duration = 3,
   Image = 4483362458,
})
upgradeselect.OnClientEvent:Once(function()
        local upgradeNum = 1

        if isInTable(basicTable, Value) then
            upgradeNum = 1
        elseif isInTable(rareTable, Value) then
            upgradeNum = 2
        elseif isInTable(legendaryTable, Value) then
            upgradeNum = 3
        elseif isInTable(ferrymanTable, Value) then
            upgradeNum = 4
        end

        if Value ~= "None" then
            OnServerEvents.UpgradeSelected:FireServer(Value, {}, upgradeNum, false)
        end
end)
   end,
})

-- Player Tab

local WalkSpeedSlider = PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "WalkSpeed",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider", 
   Callback = function(Value)
   humanoid.WalkSpeed = Value
   end,
})


