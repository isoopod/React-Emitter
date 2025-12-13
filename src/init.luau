local Emitter = require("@self/core/Emitter")

return {
	useEmitter = require("@self/hooks/useEmitter"),
	useEmitters = require("@self/hooks/useEmitters"),
	ParticleRenderer = require("@self/components/ParticleRenderer"),
	NormalId2D = Emitter.NormalId2D,
	ParticleEmitterShape2D = Emitter.ParticleEmitterShape2D,
	ParticleEmitterShapeStyle2D = Emitter.ParticleEmitterShapeStyle2D,
}
