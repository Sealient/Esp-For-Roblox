--// ESP Module
local ESP = {}

--// Default Settings (ensure it's always defined)
ESP.Settings = {
    Enabled = false,
    ShowTeam = false,
    ShowEnemies = true,
    EnemyColor = Color3.new(1, 0, 0),
    TeamColor = Color3.new(0, 1, 0),
    LineThickness = 1,
    Transparency = 0.7
}

-- Roblox Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Helper Functions
local function CreateESP(player)
    -- Check if player has a character and a HumanoidRootPart
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- Create a BillboardGui for the ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character.HumanoidRootPart
    billboard.Size = UDim2.new(4, 0, 4, 0)
    billboard.AlwaysOnTop = true

    -- Create the ESP frame inside the BillboardGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = ESP.Settings.Transparency
    frame.BorderSizePixel = 0

    -- Apply color based on the player's team and settings
    if player.Team == Players.LocalPlayer.Team and ESP.Settings.ShowTeam then
        frame.BackgroundColor3 = ESP.Settings.TeamColor
    elseif ESP.Settings.ShowEnemies then
        frame.BackgroundColor3 = ESP.Settings.EnemyColor
    else
        frame:Destroy()  -- Remove ESP if not showing
        return
    end

    -- Parent the frame to the BillboardGui and the BillboardGui to the player's character
    frame.Parent = billboard
    billboard.Parent = player.Character
end

--// Remove ESP for a player
local function RemoveESP(player)
    if player.Character then
        -- Remove all BillboardGuis attached to the player's character
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("BillboardGui") then
                v:Destroy()
            end
        end
    end
end

--// Main Function to Initialize ESP
function ESP.Initialize()
    if ESP.Settings.Enabled then
        -- Add ESP to all players when they first appear
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                CreateESP(player)
            end
        end

        -- Event listeners for players joining or leaving
        Players.PlayerAdded:Connect(function(player)
            if player ~= Players.LocalPlayer then
                CreateESP(player)
            end
        end)

        Players.PlayerRemoving:Connect(function(player)
            RemoveESP(player)
        end)

        -- Update ESP each frame to ensure it's active
        RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    CreateESP(player)
                end
            end
        end)
    end
end

-- Return ESP Module
return ESP
