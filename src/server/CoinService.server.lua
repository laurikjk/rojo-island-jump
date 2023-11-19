-- Initializing services and variables
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

-- Modules
local Leaderboard = require(ServerStorage.Leaderboard)
local PlayerData = require(ServerStorage.PlayerData)

local coinsFolder = Workspace.World.Coins
local coins = coinsFolder:GetChildren()

local COIN_KEY_NAME = PlayerData.COIN_KEY_NAME
local COOLDOWN = 10
local COIN_AMOUNT_TO_ADD = 1

local function updatePlayerCoins(player, updateFunction)
  -- Update the coin table
  local newCoinAmount = PlayerData.updateValue(player, COIN_KEY_NAME, updateFunction)

  -- Update the coin leaderboard
  Leaderboard.setStat(player, COIN_KEY_NAME, newCoinAmount)
end

-- Defining the event handler
local function onCoinTouched(otherPart, coin)
  if coin:GetAttribute("Enabled") then
    local character = otherPart.Parent
    local player = Players:GetPlayerFromCharacter(character)
    if player then
      -- Player touched a coin
      coin.Transparency = 1
      coin:SetAttribute("Enabled", false)
      updatePlayerCoins(player, function(oldCoinAmount)
        oldCoinAmount = oldCoinAmount or 0
        return oldCoinAmount + COIN_AMOUNT_TO_ADD
      end)

      task.wait(COOLDOWN)
      coin.Transparency = 0
      coin:SetAttribute("Enabled", true)
    end
  end
end

-- Setting up event listeners
for _, coin in ipairs(coins) do
  coin:SetAttribute("Enabled", true)
  coin.Touched:Connect(function(otherPart)
    onCoinTouched(otherPart, coin)
  end)
end

local function onPlayerAdded(player)
  -- Reset player coins to 0
  updatePlayerCoins(player, function(_)
    return 0
  end)

  player.CharacterAdded:Connect(function(character)
    -- WaitForChild would stop the player loop, so below should be done in a separate thread
    task.spawn(function()
      -- When a player dies
      character:WaitForChild("Humanoid").Died:Connect(function()
        -- Reset player coins to 0
        updatePlayerCoins(player, function(_)
          return 0
        end)
      end)
    end)
  end)
end

-- Initialize any players added before connecting to PlayerAdded event
for _, player in Players:GetPlayers() do
  onPlayerAdded(player)
end

local function onPlayerRemoved(player)
  updatePlayerCoins(player, function(_)
    return nil
  end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoved)