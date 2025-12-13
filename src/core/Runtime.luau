--!optimize 2
--!native

local EmitterType = require("./EmitterType")
local Particle = require("./Particle")

local runtime = {}

local actor = script:GetActor()

local evt: BindableEvent = script.Parent:WaitForChild("Completed")
local complete = evt.Fire

local emitters: { [number]: EmitterType._Emitter } = {}
local particles: { [number]: { EmitterType.Particle } } = {}

function runtime.register(emitter: EmitterType._Emitter)
	emitters[emitter._seed] = emitter
	particles[emitter._seed] = {}
end

function runtime.unregister(seed: number)
	particles[seed] = nil
	emitters[seed] = nil
end

function runtime.setProperty(seed: number, property: string, value: any)
	local emitter = emitters[seed]
	if emitter then
		-- We need to keep the old emitter for the existing particles
		local new = table.clone(emitter)
		new[property] = value
		emitters[seed] = new :: EmitterType._Emitter
	end
end

function runtime.emit(seed: number)
	local emitter = emitters[seed]
	if emitter then
		local particle = Particle.new(emitter)
		if actor then task.synchronize() end
		table.insert(particles[seed], particle)
	end
end

function runtime.dispatch(dt: number)
	for seed in emitters do
		local emitterParticles = particles[seed]

		local count = #emitterParticles

		-- Reverse iteration with fast removal
		for i = count, 1, -1 do
			local particle = emitterParticles[i]
			local alive = Particle.Update(particle, dt)

			if not alive then
				-- Fast removal: swap last into current and shrink
				local lastIndex = #emitterParticles
				emitterParticles[i] = emitterParticles[lastIndex]
				emitterParticles[lastIndex] = nil
			end
		end
	end

	local function deepclone<T>(t: T): T
		if type(t) ~= "table" then return t end
		local out = {}
		for k, v in t do
			out[k] = deepclone(v)
		end
		return out :: any
	end

	local out = deepclone(particles)

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
end

return runtime
