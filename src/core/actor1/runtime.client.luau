--!optimize 2

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Modules
local EmitterType = require(ReplicatedStorage.Packages.ReactEmitter.core.EmitterType)
local Particle = require(ReplicatedStorage.Packages.ReactEmitter.core.Particle)

local actor = script:GetActor()
local evt: BindableEvent = actor.Parent:WaitForChild("Completed")
local complete = evt.Fire

local emitters: { [number]: EmitterType._Emitter } = {}
local particles: { [number]: { EmitterType.Particle } } = {}

actor:BindToMessage("register", function(emitter: EmitterType._Emitter)
	emitters[emitter._seed] = emitter
	particles[emitter._seed] = {}
end)

actor:BindToMessage("unregister", function(seed: number)
	particles[seed] = nil
	emitters[seed] = nil
end)

actor:BindToMessage("setProperty", function(seed: number, property: string, value: any)
	local emitter = emitters[seed]
	if emitter then
		-- We need to keep the old emitter for the existing particles
		local new = table.clone(emitter)
		new[property] = value
		emitters[seed] = new :: EmitterType._Emitter
	end
end)

actor:BindToMessageParallel("emit", function(seed: number)
	local emitter = emitters[seed]
	if emitter then
		local particle = Particle.new(emitter)
		task.synchronize()
		table.insert(particles[seed], particle)
	end
end)

actor:BindToMessageParallel("dispatch", function(dt: number)
	for seed in emitters do
		local emitterParticles = particles[seed]

		local count = #emitterParticles

		-- Reverse iteration with fast removal
		for i = count, 1, -1 do
			local particle = emitterParticles[i]
			Particle.Update(particle, dt)

			if particle.Age >= particle.Lifetime then
				-- Fast removal: swap last into current and shrink
				local lastIndex = #emitterParticles
				emitterParticles[i] = emitterParticles[lastIndex]
				emitterParticles[lastIndex] = nil
			end
		end
	end

	local out = table.clone(particles)
	for _, emitter in out do
		for _, particle in emitter do
			particle.Emitter = nil :: any
			particle.Direction = nil :: any
			particle.FlipbookFramerate = nil :: any
			particle.RotSpeed = nil :: any
			particle.Speed = nil :: any
			particle.Age = nil :: any
		end
	end

	complete(evt, out)
end)
