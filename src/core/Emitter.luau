export type Emitter = {
	Acceleration: Vector2, -- Deviation: Vector2 instead of Vector3
	Brightness: number,
	Color: ColorSequence,
	Drag: number,
	EmissionDirection: number, -- Deviation: NormalId2D
	Enabled: boolean,
	FlipbookFramerate: NumberRange,
	FlipbookImageSize: Vector2, -- Deviation: Need to provide the resolution of the image, dft 1024,1024
	-- Deviation: Not handling FlipbookIncompatible error string
	FlipbookLayout: Enum.ParticleFlipbookLayout,
	FlipbookMode: Enum.ParticleFlipbookMode,
	FlipbookSizeX: number,
	FlipbookSizeY: number,
	FlipbookStartRandom: boolean,
	Lifetime: NumberRange,
	-- Deviation: LightEmission is not applicable, particle will behave as if both emission and influence are 0
	-- Deviation: LightInfluence is not applicable
	-- Deviation: LocalTransparencyModifier is handled on ParticleRenderer
	-- Deviation: Will always be "LockedToPart" (the ParticleRenderer component)
	-- Deviation: Orientation is not applicable in 2D
	Rate: number,
	Rotation: NumberRange,
	RotSpeed: NumberRange,
	Shape: number, -- Deviation: ParticleEmitterShape2D
	ShapeDimensions: Vector2, -- Deviation: For Shape support, dimensions need to be specified to the emitter
	ShapeInOut: Enum.ParticleEmitterShapeInOut,
	ShapePartial: number,
	ShapeStyle: number, -- Deviation: ParticleEmitterShapeStyle2D
	Size: NumberSequence,
	Speed: NumberRange,
	SpreadAngle: number, -- Deviation: Single number instead of Vector2
	Squash: NumberSequence,
	Texture: Content, -- Deviation: Dropped support for strings
	TimeScale: number,
	Transparency: NumberSequence,
	-- Deviation: VelocityInheritance not supported
	-- Deviation: WindAffectsDrag not applicable
	-- Deviation: ZOffset is handled by the ParticleRenderer component

	-- INTERNAL
	_seed: number,
	_center: Vector2,
	-- Only exist when flipbook layout is not None
	_frames: number,
}

if not script:GetActor() then
	local Emitter = {}

	local seed = 0
	local function nextSeed(): number
		seed += 1
		return seed
	end

	function Emitter.new(init: Emitter | any)
		local emitter: Emitter = {
			Acceleration = init.Acceleration or Vector2.zero,
			Brightness = init.Brightness or 0,
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
			_center = (init.ShapeDimensions or Vector2.one) * 0.5,
			_frames = (function(): number?
				if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Grid2x2 then return 4 end
				if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Grid4x4 then return 16 end
				if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Grid8x8 then return 64 end
				if init.FlipbookLayout == Enum.ParticleFlipbookLayout.Custom then return (init.FlipbookSizeX or 1) * (init.FlipbookSizeY or 1) end
				return
			end)() :: any,
		}
		return emitter
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

	return Emitter
end

return nil :: any
