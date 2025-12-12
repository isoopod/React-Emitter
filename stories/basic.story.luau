local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.roblox_packages.React)
-- local ReactEmitter = require(ReplicatedStorage.Packages.ReactEmitter)
local ReactRoblox = require(ReplicatedStorage.Packages.roblox_packages.React)
local UI_Labs = require(ReplicatedStorage.Packages.roblox_packages.UI_Labs)

local story = UI_Labs.CreateReactStory({
	react = React,
	reactRoblox = ReactRoblox,
}, function()
	-- local emitter = ReactEmitter.useEmitter({})

	return React.createElement(
		"Frame",
		{
			Size = UDim2.fromOffset(200, 100),
		}
		-- }, {
		-- 	-- Emitter = React.createElement(ReactEmitter.ParticleRenderer, {
		-- 	-- 	Emitter = emitter,
		-- 	-- }),
		-- }
	)
end)

return story
