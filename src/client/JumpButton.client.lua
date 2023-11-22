local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)

local IncreaseJumpPowerFunction = ReplicatedStorage.Instances.IncreaseJumpPowerFunction

local function onButtonClicked()
    local success, purchased = pcall(IncreaseJumpPowerFunction.InvokeServer, IncreaseJumpPowerFunction)
    if not success then
        -- purchased will be the error message if success is false
        error(purchased)
    elseif success and not purchased then
        warn("Not enough coins!")
    end
end


-- Add the JumpPurchaseGui to the player's Gui


local app = Roact.createElement("ScreenGui", {}, {
    HelloButton = Roact.createElement("TextButton", {
        Size = UDim2.new(0, 150, 0, 40),
        Text = "Upgrade Jump (5 coins)",
        [Roact.Event.Activated] = onButtonClicked
    })
})

Roact.mount(app, Players.LocalPlayer.PlayerGui)
