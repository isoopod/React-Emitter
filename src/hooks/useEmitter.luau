local React = require("../../roblox_packages/React")
local useEmitters = require("./useEmitters")

return function(props: useEmitters.props, deps: { unknown }?)
	local emitters, parentApi = useEmitters(1, props, deps)

	local api = React.useMemo(function(): { emit: (number) -> () }?
		if parentApi then return {
			emit = function(numToEmit: number)
				parentApi.emit(function()
					return numToEmit
				end)
			end,
		} end
		return
	end, deps or {})

	return emitters[1], api
end
