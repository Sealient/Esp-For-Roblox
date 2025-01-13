-- ESP Logic Functions
local ESPObjects = {} -- Table to store drawn ESP objects

local showNameTags = false
local showHealthBars = false
local outlineThickness = 1
local boxColor = Color3.fromRGB(0, 255, 0) -- Default green
local nameTagColor = Color3.fromRGB(255, 255, 255) -- Default white
local showTeammates = true
local showAliveOnly = true

-- ESP Logic for Player Checks
function updateESP()
-- Clear previous ESP
disableESP()
enableESP()
end

function enableESP()
-- Iterate through all players
for _, player in pairs(game.Players:GetPlayers()) do
if player ~= game.Players.LocalPlayer and player.Character then
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

-- Check if player is alive
if showAliveOnly and (not humanoid or humanoid.Health == 0) then
continue
end

-- Check if player is on the same team (for team check)
if not showTeammates and player.Team == game.Players.LocalPlayer.Team then
continue
end

-- Create ESP objects
local espBox = Drawing.new("Square")
espBox.Visible = true
espBox.Color = boxColor
espBox.Thickness = outlineThickness
espBox.Transparency = 1
espBox.Filled = false

local nameTag = Drawing.new("Text")
nameTag.Visible = false
nameTag.Text = player.Name
nameTag.Color = nameTagColor
nameTag.Size = 20
nameTag.Center = true

local healthBar = Drawing.new("Line")
healthBar.Visible = false
healthBar.Color = Color3.fromRGB(0, 255, 0)
healthBar.Thickness = 2

-- Store ESP objects
ESPObjects[player.Name] = { Box = espBox, NameTag = nameTag, HealthBar = healthBar }

-- Update position on render
game:GetService("RunService").RenderStepped:Connect(function()
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local rootPart = player.Character.HumanoidRootPart
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)

if onScreen then
-- Calculate box size based on distance
local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
local boxSize = math.clamp(1000 / distance, 20, 100)

-- ESP Box
espBox.Size = Vector2.new(boxSize, boxSize * 1.5)
espBox.Position = Vector2.new(screenPos.X - espBox.Size.X / 2, screenPos.Y - espBox.Size.Y / 2)
espBox.Visible = true

-- Name Tag
if showNameTags then
nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - boxSize * 0.9)
nameTag.Visible = true
else
nameTag.Visible = false
end

-- Health Bar
if showHealthBars and humanoid then
local healthPercent = humanoid.Health / humanoid.MaxHealth
healthBar.From = Vector2.new(espBox.Position.X - 5, espBox.Position.Y + espBox.Size.Y)
healthBar.To = Vector2.new(espBox.Position.X - 5, espBox.Position.Y + espBox.Size.Y * (1 - healthPercent))
healthBar.Visible = true
else
healthBar.Visible = false
end
else
espBox.Visible = false
nameTag.Visible = false
healthBar.Visible = false
end
end
end)
end
end
end

function disableESP()
-- Hide and remove all ESP objects
for _, objects in pairs(ESPObjects) do
if objects.Box then objects.Box:Remove() end
if objects.NameTag then objects.NameTag:Remove() end
if objects.HealthBar then objects.HealthBar:Remove() end
end
ESPObjects = {}
end
