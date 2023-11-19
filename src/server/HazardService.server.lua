local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local hazardsFolder = Workspace.World.Hazards
local hazards = hazardsFolder:GetChildren()

local function onHazardTouched(otherPart)
  local character = otherPart.Parent
  local player = Players:GetPlayerFromCharacter(character)
  if player and character.Humanoid then
    character.Humanoid.Health = 0
  end
end

for _, hazard in ipairs(hazards) do
  hazard.Touched:Connect(onHazardTouched)
end