-- esp.lua (from your GitHub)

local ESP = {}

ESP.Enabled = true
ESP.ShowTeam = false
ESP.ShowEnemies = true
ESP.EnemyColor = Color3.fromRGB(255, 0, 0)  -- Red
ESP.TeamColor = Color3.fromRGB(0, 255, 0)  -- Green
ESP.LineThickness = 2
ESP.Transparency = 0.5

-- Function to create ESP lines (simple example)
function ESP:DrawESP(player)
    local character = player.Character
    if not character then return end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local screenPos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(humanoidRootPart.Position)

    if onScreen then
        local espLine = Instance.new("Frame")
        espLine.Size = UDim2.new(0, 2, 0, 10)
        espLine.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
        espLine.BackgroundColor3 = ESP.ShowEnemies and ESP.EnemyColor or ESP.TeamColor
        espLine.BackgroundTransparency = ESP.Transparency
        espLine.BorderSizePixel = 0
        espLine.ZIndex = 100

        espLine.Parent = game.CoreGui
        game:GetService("Debris"):AddItem(espLine, 3)  -- Clean up after 3 seconds
    end
end

-- Loop through all players and create ESP if enabled
game:GetService("Players").PlayerAdded:Connect(function(player)
    if ESP.Enabled then
        player.CharacterAdded:Connect(function(character)
            if ESP.Enabled then
                ESP:DrawESP(player)
            end
        end)
    end
end)

return ESP
