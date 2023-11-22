local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.Packages.roact)

local app = Roact.createElement("ScreenGui", {}, {
    HelloButton = Roact.createElement("TextButton", {
        Size = UDim2.new(0, 150, 0, 40),
        Text = "Upgrade Jump (5 coins)",
        [Roact.Event.Activated] = function()
            print("Hello, Roact!")
        end
    })
})

Roact.mount(app, Players.LocalPlayer.PlayerGui)
