-- Dependencies are different on wally and pesde, with pesde putting them inside a roblox_packages folder.

local dependencies = script.Parent.Parent.Parent:FindFirstChild("roblox_packages") or script.Parent.Parent.Parent

local _, React = pcall(require, dependencies.React)

return {
	React = React,
}
