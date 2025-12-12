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
}

export type _Emitter = Emitter & {
	-- INTERNAL
	_seed: number,
	_emitAcc: number,
	_center: Vector2,
	-- Only exist when flipbook layout is not None
	_frames: number,
	-- Need to cache frame rects and frame size for flipbook particles
}

export type Particle = {
	Emitter: _Emitter, -- Internal and only exists for runtime use

	-- Derived from emitter properties
	Direction: Vector2, -- Only for runtime
	FlipbookFrame: number, -- Only present if flipbook enabled
	FlipbookFrameAlpha: number, -- 0..1 Only in Random Mode
	FlipbookFramerate: number, -- Only for runtime
	FlipbookFrameTarget: number, -- Only in Random mode
	Speed: number, -- Only for runtime
	Lifetime: number,
	Position: Vector2, -- Only for runtime
	Rotation: number,
	RotSpeed: number, -- Only for runtime

	Color: Color3,
	Size: number,
	Squash: number,
	Transparency: number,

	Age: number, -- Only for runtime

	_id: number,
}

return nil
