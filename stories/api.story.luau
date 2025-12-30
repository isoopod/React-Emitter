local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.roblox_packages.React)
local ReactEmitter = require(ReplicatedStorage.Packages.ReactEmitter)
local ReactRoblox = require(ReplicatedStorage.Packages.roblox_packages.ReactRoblox)
local UI_Labs = require(ReplicatedStorage.Packages.roblox_packages.UI_Labs)

local story = UI_Labs.CreateReactStory({
	react = React,
	reactRoblox = ReactRoblox,
}, function()
	local color, setColor = React.useState(BrickColor.Random())

	local emitter, api = ReactEmitter.useEmitter(function()
		return {
			Size = NumberSequence.new(0.2),
			ShapeDimensions = Vector2.new(50, 50),
			Rate = 0,
			Enabled = false,
			Color = ColorSequence.new(color.Color),
		}
	end)

	return React.createElement("TextButton", {
		Size = UDim2.fromOffset(200, 100),
		Transparency = 0.85,
		[React.Event.Activated] = function()
			api.emit(1)
			setColor(BrickColor.Random())
		end,
	}, {
		Emitter = React.createElement(ReactEmitter.ParticleRenderer, {
			Emitter = emitter,
		}),
	})
end)

return story
