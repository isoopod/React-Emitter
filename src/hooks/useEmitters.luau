local Emitter = require("../core/Emitter")
local EmitterType = require("../core/EmitterType")
local React = require("../../roblox_packages/React")

export type props = { EmitterType.Emitter } | (index: number) -> EmitterType.Emitter

export type api = {
	emit: (callback: (index: number) -> number) -> (),
}

local function resolveProps(spec: props, index: number): EmitterType.Emitter?
	if type(spec) == "function" then
		return spec(index)
	else
		-- If spec is a table of props per index, prefer spec[index], otherwise treat spec as the props table
		if type(spec) == "table" and spec[index] ~= nil and type(spec[index]) == "table" then
			return spec[index]
		else
			return spec :: any
		end
	end
end

--[=[
    @function useEmitters
    @within ReactEmitter
    @param count number -- The number of emitters to create
    @param props {EmitterType.Emitter} | (index: number) -> EmitterType.Emitter -- The properties for each emitter, either as a table or a function that returns a table given the index
    @param deps {unknown}? -- Optional dependencies array to control when emitters are recreated
    @return {Emitter} -- An array of created emitters
    @return API? -- Imperative API created when passing a function as props
    A hook that creates and manages multiple particle emitters. The `props` parameter can be either a table of emitter properties or a function that returns emitter properties based on the index. The optional `deps` array can be used to control when the emitters are recreated.
]=]
return function(count: number, props: props, deps: { unknown }?)
	local isImperative = React.useRef(nil :: boolean?)

	if type(props) == "function" then
		assert(isImperative.current == nil or isImperative.current == true, "Cannot switch between imperative and declarative props.")
		isImperative.current = true
	else
		assert(isImperative.current == nil or isImperative.current == false, "Cannot switch between imperative and declarative props.")
		isImperative.current = false
	end

	local ref = React.useRef(nil :: any)
	if not ref.current then
		local emitters, lastProps = {}, {}

		for i = 1, count do
			local initProps = resolveProps(props, i) or {}
			emitters[i] = Emitter.new(initProps)
			lastProps[i] = table.clone(initProps)
		end

		ref.current = {
			emitters = emitters,
			lastProps = lastProps,
		}
	end

	React.useEffect(function()
		local emitters = ref.current.emitters
		local lastProps = ref.current.lastProps

		for i = 1, count do
			local newProps = resolveProps(props, i) or {} :: any
			for key, newValue in newProps do
				local oldValue = lastProps[i][key]
				if newValue ~= oldValue then Emitter.Set(emitters[i], key, newValue) end
			end
			lastProps[i] = table.clone(newProps)
		end
	end, deps)

	local api = React.useMemo(function(): api?
		if isImperative.current then
			return {
				emit = function(callback: (index: number) -> number)
					local emitters = ref.current.emitters
					for i = 1, count do
						local numToEmit = callback(i)
						for _ = 1, numToEmit do
							Emitter.Emit(emitters[i])
						end
					end
				end,
			}
		end
		return
	end, deps or {})

	-- Handle cleanup
	React.useEffect(function()
		return function()
			for _, emitter in ref.current.emitters do
				Emitter.Destroy(emitter)
			end
		end
	end, {})

	return ref.current.emitters, api
end
