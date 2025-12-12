-- IMPLEMENTATION NODE:
-- Flipbook particles on random mode will need two images per particle to fade between

-- IMPLEMENTATION NOTE:
-- Brightness will be multiplied to the current color

--!strict

-- Services
local RunService = game:GetService("RunService")
-- Modules
local Emitter = require("../core/Emitter")
local EmitterType = require("../core/EmitterType")
local React = require("../../roblox_packages/React")

local e = React.createElement

local function yoink(thunk: () -> ()): (...any) -> ...any
	local yoinked
	xpcall(thunk, function()
		yoinked = debug.info(2, "f")
	end)
	return yoinked
end

-- Directly set the properties on the particle instances for performance
local set: (Instance, string, any) -> () = yoink(function()
	(game :: any)["not_a_real_property"] = nil
end)

local create = Instance.new

export type props = {
	Emitter: EmitterType.Emitter,
	LocalTransparencyModifier: number?, -- Additive modifier for particle transparency from this renderer
	ZOffset: number?, -- ZOffset of particles
	native: { [any]: any }?,
	children: React.ReactNode?,
}

local registry = {} :: {
	[Frame]: {
		props: props,
		instances: { [number]: { ImageLabel } },
		-- Instances are stored per-renderer, per-particle (lookup by particle _id)
		-- There is usually one instance per particle, but flipbook random mode requires two
	},
}

RunService.PreRender:Connect(function()
	for frame, renderer in registry do
		local props = renderer.props
		local instances = renderer.instances
		local emitter = props.Emitter
		local particles = Emitter.Particles[emitter :: EmitterType._Emitter]

		local seen = {}

		for _, particle in particles do
			local id = particle._id
			seen[id] = true
			local existing, new = instances[id], false
			if not existing then
				existing = {}
				instances[id] = existing
				new = true

				-- Create new instance(s)
				local img1 = create("ImageLabel")
				set(img1, "BackgroundTransparency", 1)
				local img2
				if particle.FlipbookFrameTarget then
					img2 = create("ImageLabel")
					set(img2, "BackgroundTransparency", 1)
				end
			end

			-- Update instance(s)
			for _, v in existing do
				local position = particle.Position
				set(v, "Position", UDim2.fromOffset(position.X, position.Y))
				local size = particle.Size
				set(v, "Size", UDim2.fromScale(size, size * (1 - particle.Squash)))
				set(v, "Rotation", particle.Rotation)
				set(v, "ImageColor3", particle.Color)
				set(v, "Transparency", math.clamp(particle.Transparency + (props.LocalTransparencyModifier or 0), 0, 1))
				set(v, "ImageContent", emitter.Texture)
				set(v, "ZIndex", props.ZOffset or 1)
				--TODO Flipbook support
			end

			if new then
				for _, v in existing do
					set(v, "Parent", frame)
				end
			end
		end
	end
end)

return function(props: props)
	local container = React.useRef(nil :: Frame?)

	React.useEffect(function()
		if not container.current then return end

		registry[container.current] = { props = props, instances = {} }
		return function()
			for _, v in registry[container.current].instances do
				for _, instance in v do
					instance:Destroy()
				end
			end
			registry[container.current] = nil
		end
	end, { props.Emitter, container.current } :: { unknown })

	local native: any = props.native or {}
	native.ref = container

	return e("Frame", native, props.children)
end
