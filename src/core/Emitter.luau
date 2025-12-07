export type Emitter = {
	Acceleration: Vector2, -- Deviation: Vector2 instead of Vector3
	Brightness: number,
	Color: ColorSequence,
	Drag: number,
	EmissionDirection: number, -- Deviation: NormalId2D
	Enabled: boolean,
	FlipbookFramerate: number,
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
	_center: Vector2,
	-- Only exist when flipbook layout is not None
	_frames: number,
	_frameCoordinates: { Rect },
}

if not script:GetActor() then
	local Emitter = {}

	function Emitter.new() end

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
