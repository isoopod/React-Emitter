---
sidebar_position: 1
---

# Intro

## Installation

ReactEmitter is only available on [pesde](https://docs.pesde.dev). Add ReactEmitter with the following command:

```sh
pesde add isoopod/react_emitter -a ReactEmitter
```

## Getting Started

ReactEmitter provides two hooks, one component, and a few enums. **Class components are not supported.**  
The basic use case is to use [useEmitter](/api/ReactEmitter#useEmitters), to which you set up the properties like you would a Particle Emitter.

```lua
local React = require(Packages.React)
local ReactEmitter = require(Packages.ReactEmitter)

local e = React.createElement

local function App()
    local emitter = ReactEmitter.useEmitter({
        Size = NumberSequence.new(0.2),
        ShapeDimensions = Vector2.new(50, 50),
    })

    return e("Frame", {
        Size = UDim2.fromOffset(50, 50),
    }, {
        Particles = e(ReactEmitter.ParticleRenderer, {
            Emitter = emitter
        })
    })
end
```

The default properties for an `Emitter` are based off the defaults for Particle Emitters. An important deviation is the introduction of `ShapeDimensions`, which sets the spawn area for particles. This is also used as the size of the `ParticleRenderer` by default, but this can be overridden through the `native` field. Do note that this only goes one way, and the `ShapeDimensions` of the `Emitter` will not be influenced by a custom size on a `ParticleRenderer`. The size of the particles is relative to the size of the `ParticleRenderer`, so there are cases where you would want the `ShapeDimensions` of the `Emitter` to be different to the Size of the `ParticleRenderer`.

Because emitters are completely separate to the particle renderers, you will often need a way to set `ShapeDimensions` to the absolute size of the intended `ParticleRenderer`. Here is a simple way to do that:

```lua
local function App()
    local containerSize, setContainerSize = React.useState(Vector2.zero)

    local emitter = ReactEmitter.useEmitter({
        Size = NumberSequence.new(0.2),
        ShapeDimensions = containerSize,
    })

    return e("Frame", {
        Size = UDim2.fromOffset(50, 50),
        [React.Change.AbsoluteSize] = function(rbx: Frame)
            setContainerSize(rbx.AbsoluteSize)
        end,
    }, {
        Particles = e(ReactEmitter.ParticleRenderer, {
            Emitter = emitter
        })
    })
end
```
