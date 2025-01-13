--// ESP Module
local ESP = {}

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Settings
ESP.Settings = {
    Enabled = true,
    ShowTeam = false,
    ShowEnemies = true,
    EnemyColor = Color3.new(1, 0, 0),
    TeamColor = Color3.new(0, 1, 0),
    LineThickness = 1,
    Transparency = 0.7
}

--// Helper Functions
local function CreateESP(player)
    -- Ensure player and character exist
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- Check if ESP already exists
    if player.Character:FindFirstChild("ESP_Billboard") then
        return
    end

    -- Create BillboardGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
    billboard.Size = UDim2.new(4, 0, 4, 0)
    billboard.AlwaysOnTop = true

    -- Create Frame inside BillboardGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = ESP.Settings.Transparency
    frame.BorderSizePixel = 0

    -- Determine color based on team
    if player.Team == Players.LocalPlayer.Team and ESP.Settings.ShowTeam then
        frame.BackgroundColor3 = ESP.Settings.TeamColor
    elseif ESP.Settings.ShowEnemies then
        frame.BackgroundColor3 = ESP.Settings.EnemyColor
    else
        frame:Destroy()
        return
    end

    -- Parent the frame
    frame.Parent = billboard
    billboard.Parent = player.Character
end

local function RemoveESP(player)
    if player.Character and player.Character:FindFirstChild("ESP_Billboard") then
        player.Character.ESP_Billboard:Destroy()
    end
end

--// Main Loop
function ESP.Initialize()
    if not ESP.Settings.Enabled then return end

    -- Create ESP for existing players
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            CreateESP(player)
        end
    end

    -- Handle new players joining
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            CreateESP(player)
        end)
    end)

    -- Handle players leaving
    Players.PlayerRemoving:Connect(RemoveESP)

    -- Update ESP every frame
    RunService.RenderStepped:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESP(player)
                end
            end
        end
    end)
end

return ESP
