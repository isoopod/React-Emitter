---
sidebar_position: 4
---

# Imperatives

Passing a function to `useEmitter` or `useEmitters` will return an imperative API table. The imperative API allows you to call the `emit` method on the emitter. Here is an example of how you can use this to make a particle that emits when you click a button:

```lua
local function App()
    local emitter, api = ReactEmitter.useEmitter(function()
        return {
            Size = NumberSequence.new(0.2),
            ShapeDimensions = Vector2.new(50, 50),
            Enabled = false,
        }
    end)

    return e("TextButton", {
        Size = UDim2.fromOffset(50, 50),
        [React.Event.Activated] = function()
            api.emit(1)
        end,
    }, {
        Particles = e(ReactEmitter.ParticleRenderer, {
            Emitter = emitter
        })
    })
end
```

:::info
You cannot switch between declarative and imperative mode after creating the emitter.
:::
