--!optimize 2

-- Services
local RunService = game:GetService("RunService")
-- Modules
local EmitterType = require("./EmitterType")
local Runtime

local Emitter = {}

local isEdit = not RunService:IsRunning()

local ACTOR_COUNT = 4

local completed: RBXScriptSignal = script.Parent:FindFirstChild("Completed")
if completed then
	completed = (completed :: any).Event
else
	local _completed = Instance.new("BindableEvent")
	_completed.Name = "Completed"
	_completed.Archivable = false
	_completed.Parent = script.Parent
	completed = _completed.Event
end

if isEdit then Runtime = require("./Runtime") end

local actorIndex = 1
local actors = { script.Parent.actor1 }

for i = 2, ACTOR_COUNT do
	local name = `actor{i}`
	local actor = script.Parent:FindFirstChild(name) or actors[1]:Clone()
	actor.Name = name
	actor.Archivable = false
	actor.Parent = script.Parent
	actors[i] = actor
end

local seed = 0
local function nextSeed(): number
	seed += 1
	return seed
end

local emitters = {} :: { [number]: EmitterType._Emitter }
Emitter.Particles = {} :: { [EmitterType._Emitter]: { EmitterType.Particle } }

local IncludedProperties = {
	Acceleration = true,
	Brightness = true,
	Color = true,
	Drag = true,
	EmissionDirection = true,
	FlipbookLayout = true,
	FlipbookStartRandom = true,
	FlipbookMode = true,
	FlipbookFramerate = true,
	Lifetime = true,
	Rotation = true,
	RotSpeed = true,
	Shape = true,
	ShapeStyle = true,
	ShapeDimensions = true,
	ShapeInOut = true,
	ShapePartial = true,
	Size = true,
	Speed = true,
	SpreadAngle = true,
	Squash = true,
	Transparency = true,
	TimeScale = true,
	_seed = true,
	_center = true,
	_frames = true,
}

function Emitter.new(init: EmitterType._Emitter | any)
	local emitter: EmitterType._Emitter = {
		Acceleration = init.Acceleration or Vector2.zero,
		Brightness = init.Brightness or 1,
		Color = init.Color or ColorSequence.new(Color3.new(1, 1, 1)),
		Drag = init.Drag or 0,
		EmissionDirection = init.EmissionDirection or Emitter.NormalId2D.Top,
		Enabled = if init.Enabled ~= nil then init.Enabled else true,
		FlipbookFramerate = init.FlipbookFramerate or NumberRange.new(1),
		FlipbookImageSize = init.FlipbookImageSize or Vector2.new(1024, 1024),
		FlipbookLayout = init.FlipbookLayout or Enum.ParticleFlipbookLayout.None,
		FlipbookMode = init.FlipbookMode or Enum.ParticleFlipbookMode.Loop,
		FlipbookSizeX = init.FlipbookSizeX or 1,
		FlipbookSizeY = init.FlipbookSizeY or 1,
		FlipbookStartRandom = init.FlipbookStartRandom or false,
		Lifetime = init.Lifetime or NumberRange.new(5, 10),
		Rate = init.Rate or 20,
		Rotation = init.Rotation or NumberRange.new(0),
		RotSpeed = init.RotSpeed or NumberRange.new(0),
		Shape = init.Shape or 1,
		ShapeDimensions = init.ShapeDimensions or Vector2.one,
		ShapeInOut = init.ShapeInOut or Enum.ParticleEmitterShapeInOut.Outward,
		ShapePartial = init.ShapePartial or 1,
		ShapeStyle = init.ShapeStyle or 1,
		Size = init.Size or NumberSequence.new(1),
		Speed = init.Speed or NumberRange.new(5),
		SpreadAngle = init.SpreadAngle or 0,
		Squash = init.Squash or NumberSequence.new(0),
		Texture = init.Texture or Content.fromUri("rbxasset://textures/particles/sparkles_main.dds"),
		TimeScale = init.TimeScale or 1,
		Transparency = init.Transparency or NumberSequence.new(0),

		_seed = nextSeed(),
		_emitAcc = 0,
		_center = (init.ShapeDimensions or Vector2.one) * 0.5,
		_frames = (function(): number?
			if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Grid2x2 then return 4 end
			if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Grid4x4 then return 16 end
			if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Grid8x8 then return 64 end
			if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Custom then return (init.FlipbookSizeX or 1) * (init.FlipbookSizeY or 1) end
			return
		end)() :: any,
	}

	local filtered = {}
	for property, value in emitter :: any do
		if IncludedProperties[property] then filtered[property] = value end
	end

	if Runtime then
		Runtime.register(filtered)
	else
		for _, v in actors do
			v:SendMessage("register", filtered)
		end
	end

	emitters[emitter._seed] = emitter

	return emitter
end

local function emit(emitter: EmitterType._Emitter)
	if Runtime then
		Runtime.emit(emitter._seed)
		return
	end

	actors[actorIndex]:SendMessage("emit", emitter._seed)

	actorIndex += 1
	if actorIndex > ACTOR_COUNT then actorIndex = 1 end
end
Emitter.Emit = emit

function Emitter.Set(emitter: EmitterType._Emitter, property: string, value: any)
	emitter[property] = value
	if IncludedProperties[property] then
		if Runtime then
			Runtime.setProperty(emitter._seed, property, value)
			return
		end

		for _, v in actors do
			v:SendMessage("setProperty", emitter._seed, property, value)
		end
	end
end

function Emitter.Destroy(emitter: EmitterType._Emitter)
	if Runtime then
		Runtime.unregister(seed)
	else
		for _, v in actors do
			v:SendMessage("unregister", emitter._seed)
		end
	end
	Emitter.Particles[emitter] = nil
	emitters[emitter._seed] = nil
end

-- Enums
Emitter.NormalId2D = {
	Top = 1,
	Right = 2,
	Bottom = 3,
	Left = 4,
}

Emitter.ParticleEmitterShape2D = {
	-- Deviation: 2D Equivalent of Box
	Rectangle = 1,
	-- Deviation: 2D Equivalent of Disc
	-- Also covers Cylinder/Sphere when ShapePartial is 1
	Annulus = 2,
}

Emitter.ParticleEmitterShapeStyle2D = {
	-- Deviation: 2D Equivalent of Volume
	Area = 1,
	-- Deviation: 2D Equivalent of Surface
	Perimeter = 2,
}

local function step(dt: number)
	for _, emitter in emitters do
		if emitter.Enabled then
			local accumulated = emitter._emitAcc + emitter.Rate * dt
			local emitCount = accumulated // 1
			emitter._emitAcc = accumulated - emitCount

			for _ = 1, emitCount do
				emit(emitter)
			end
		end
	end

	local assembled: any = {}
	for _, emitter in emitters do
		assembled[emitter] = {}
	end

	local completedCount = 0
	local conn
	conn = completed:Connect(function(allParticles)
		-- Merge into assembled, linking seed to emitter
		for s, particleList in allParticles do
			local emitter = emitters[s]
			if emitter then
				for _, p in particleList do
					table.insert(assembled[emitter], p)
				end
			end
		end

		completedCount += 1
		if completedCount >= ACTOR_COUNT then
			conn:Disconnect()
			Emitter.Particles = assembled
		end
	end)

	if Runtime then
		Runtime.dispatch(dt)
		return
	end

	for _, v in actors do
		v:SendMessage("dispatch", dt)
	end
end

-- Avoid multiple bindings in case of tools like UI_Labs
RunService:UnbindFromRenderStep("ReactEmitterCore")
RunService:BindToRenderStep("ReactEmitterCore", Enum.RenderPriority.Last.Value - 1, function(dt)
	if isEdit then
		local success, err = pcall(step :: any, dt)
		if not success then
			RunService:UnbindFromRenderStep("ReactEmitterCore")
			error(err)
		end
	else
		step(dt)
	end
end)

return Emitter
