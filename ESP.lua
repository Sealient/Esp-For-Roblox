--// ESP Module
local ESP = {}

--// Settings
ESP.Settings = {
    Enabled = false,
    ShowTeam = false,
    ShowEnemies = true,
    EnemyColor = Color3.new(1, 0, 0),
    TeamColor = Color3.new(0, 1, 0),
    LineThickness = 1,
    Transparency = 0.7
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Helper Functions
local function CreateESP(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    -- Create a BillboardGui for the player
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character.HumanoidRootPart
    billboard.Size = UDim2.new(4, 0, 4, 0)
    billboard.AlwaysOnTop = true

    -- Create a Frame inside the BillboardGui
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = ESP.Settings.Transparency
    frame.BorderSizePixel = 0

    if player.Team == Players.LocalPlayer.Team and ESP.Settings.ShowTeam then
        frame.BackgroundColor3 = ESP.Settings.TeamColor
    elseif ESP.Settings.ShowEnemies then
        frame.BackgroundColor3 = ESP.Settings.EnemyColor
    else
        frame:Destroy()
        return
    end

    frame.Parent = billboard
    billboard.Parent = player.Character
end

local function RemoveESP(player)
    if player.Character then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("BillboardGui") then
                v:Destroy()
            end
        end
    end
end

--// Main Loop
function ESP.Initialize()
    if not ESP.Settings.Enabled then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            CreateESP(player)
        end
    end

    -- Update ESP when players join or leave
    Players.PlayerAdded:Connect(CreateESP)
    Players.PlayerRemoving:Connect(RemoveESP)

    -- Update ESP every frame
    RunService.RenderStepped:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                CreateESP(player)
            end
        end
    end)
end

return ESP
