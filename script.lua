local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
   Name = "⚡NerixusHub⚡",
   Icon = 0,
   LoadingTitle = "NerixusHub",
   LoadingSubtitle = "by Nerixus",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "NerixusHub"
   },

   Discord = {
      Enabled = true,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "NerixusHub Key",
      Subtitle = "link in discord",
      Note = "Join Server",
      FileName = "NerixusHub Key",
      SaveKey = true,
      GrabKeyFromSite = true,
      Key = {"https://pastebin.com/raw/pinedSa4"}
   }
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local mouse = LocalPlayer:GetMouse()

-- === MAIN TAB ===
local MainTab = Window:CreateTab("Main", nil)
local MainSection = MainTab:CreateSection("Main Features")

-- Infinite Jump
local InfiniteJumpEnabled = false
MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
      InfiniteJumpEnabled = not InfiniteJumpEnabled
      UIS.JumpRequest:Connect(function()
         if InfiniteJumpEnabled then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
               humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
         end
      end)
      Rayfield:Notify({
         Title = "Infinite Jump",
         Content = "Toggled " .. (InfiniteJumpEnabled and "On" or "Off"),
         Duration = 3.5
      })
   end
})

-- WalkSpeed Slider
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 300},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Dropdown
MainTab:CreateDropdown({
   Name = "Teleport Options",
   Options = {"Carpet", "Base"},
   CurrentOption = {"Base"},
   MultipleOptions = false,
   Flag = "Teleport",
   Callback = function(Option)
      print("Selected:", Option)
   end,
})

-- === TELEPORT TAB ===
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local TeleportSection = TeleportTab:CreateSection("Places")

TeleportTab:CreateButton({
   Name = "Teleport to Base",
   Callback = function()
      print("Teleported to Base")
      -- Add actual teleport logic
   end,
})

TeleportTab:CreateButton({
   Name = "Teleport to Carpet",
   Callback = function()
      print("Teleported to Carpet")
      -- Add actual teleport logic
   end,
})

-- === MISC TAB ===
local MiscTab = Window:CreateTab("Misc", 4483362458)
local MiscSection = MiscTab:CreateSection("Extras")

-- Auto Farm Toggle
MiscTab:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      print("Auto Farm is", Value and "Enabled" or "Disabled")
   end,
})

-- Tap to Teleport Toggle
local TapToTeleportEnabled = false

MiscTab:CreateToggle({
   Name = "Tap to Teleport",
   CurrentValue = false,
   Flag = "TapTeleport",
   Callback = function(Value)
      TapToTeleportEnabled = Value
      Rayfield:Notify({
         Title = "Tap Teleport",
         Content = TapToTeleportEnabled and "Tap anywhere in the world to teleport." or "Tap Teleport is OFF.",
         Duration = 4
      })
   end,
})

mouse.Button1Down:Connect(function()
   if not TapToTeleportEnabled then return end
   local targetPos = mouse.Hit and mouse.Hit.Position
   if targetPos then
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("HumanoidRootPart") then
         char:MoveTo(targetPos + Vector3.new(0, 5, 0))
      end
   end
end)

-- === FLING FEATURE ===

-- Dropdown to select target
local selectedTarget = nil

MiscTab:CreateDropdown({
   Name = "Fling Target",
   Options = {},
   CurrentOption = {},
   Flag = "FlingTarget",
   Callback = function(Option)
      selectedTarget = Option
      Rayfield:Notify({
         Title = "Target Selected",
         Content = "Fling target: " .. Option,
         Duration = 3
      })
   end,
})

-- Update dropdown with players
task.spawn(function()
   while true do
      local names = {}
      for _, player in pairs(Players:GetPlayers()) do
         if player ~= LocalPlayer then
            table.insert(names, player.Name)
         end
      end
      Rayfield.Flags["FlingTarget"]:SetOptions(names)
      task.wait(5)
   end
end)

-- Fling Toggle
local flingEnabled = false
local flingLoop = nil

MiscTab:CreateToggle({
   Name = "Fling Selected Player",
   CurrentValue = false,
   Flag = "FlingToggle",
   Callback = function(Value)
      flingEnabled = Value

      if flingEnabled then
         if not selectedTarget then
            Rayfield:Notify({
               Title = "Fling Failed",
               Content = "Select a player first.",
               Duration = 3
            })
            return
         end

         Rayfield:Notify({
            Title = "Fling Enabled",
            Content = "Attempting to fling " .. selectedTarget,
            Duration = 3.5
         })

         flingLoop = RunService.Heartbeat:Connect(function()
            local targetPlayer = Players:FindFirstChild(selectedTarget)
            local character = LocalPlayer.Character
            local targetChar = targetPlayer and targetPlayer.Character

            if character and targetChar and character:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
               local hrp = character.HumanoidRootPart
               local targetHRP = targetChar.HumanoidRootPart

               -- Move close to target
               hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)

               -- Apply fling force
               hrp.AssemblyAngularVelocity = Vector3.new(999999, 999999, 999999)
               hrp.RotVelocity = Vector3.new(999999, 999999, 999999)
               hrp.Velocity = Vector3.new(100, 100, 100)
               hrp.CanCollide = true
            end
         end)
      else
         if flingLoop then flingLoop:Disconnect() end
         local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
         if hrp then
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            hrp.Velocity = Vector3.zero
         end

         Rayfield:Notify({
            Title = "Fling Disabled",
            Content = "Stopped fling.",
            Duration = 3
         })
      end
   end,
})
