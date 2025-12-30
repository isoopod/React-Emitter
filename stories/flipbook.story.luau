local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.roblox_packages.React)
local ReactEmitter = require(ReplicatedStorage.Packages.ReactEmitter)
local ReactRoblox = require(ReplicatedStorage.Packages.roblox_packages.ReactRoblox)
local UI_Labs = require(ReplicatedStorage.Packages.roblox_packages.UI_Labs)

local story = UI_Labs.CreateReactStory({
	react = React,
	reactRoblox = ReactRoblox,
}, function()
	local emitter = ReactEmitter.useEmitter({
		Brightness = 5,
		Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.99, 0.99), NumberSequenceKeypoint.new(0.105, 8.06, 0.99), NumberSequenceKeypoint.new(1, 10) }),
		ShapeDimensions = Vector2.new(25, 25),
		Texture = Content.fromUri("rbxassetid://15194500627"),
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.266, 0), NumberSequenceKeypoint.new(1, 1) }),
		Lifetime = NumberRange.new(0.8, 1.5),
		Rotation = NumberRange.new(-180, 180),
		Speed = NumberRange.new(0, 2),
		SpreadAngle = 180,
		FlipbookImageSize = Vector2.new(1024, 1024),
		FlipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8,
		FlipbookMode = Enum.ParticleFlipbookMode.OneShot,
		Drag = 1,
	})

	return React.createElement("Frame", {
		Size = UDim2.fromOffset(200, 100),
		Transparency = 0.85,
	}, {
		Emitter = React.createElement(ReactEmitter.ParticleRenderer, {
			Emitter = emitter,
			native = {
				-- Size = UDim2.fromOffset(25, 25),
			},
		}),
	})
end)

return story
