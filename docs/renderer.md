---
sidebar_position: 3
---

# Particle Renderer

`ParticleRenderer` is the React Component that is responsible for rendering an `Emitter`.

## Usage

```lua
e(ReactEmitter.ParticleRenderer, {
    Emitter = emitter, -- Some emitter from useEmitter or useEmitters
    -- Other props
})
```

## Props

### `Emitter: Emitter`

The `Emitter` this `ParticleRenderer` is rendering.  
Note: An `Emitter` can be used in multiple Particle Renderers.

---

### `LocalTransparencyModifier: number?`

A local offset to particles' transparency for this `ParticleRenderer`.

---

### `ResampleMode: Enum.ResamplerMode?`

Allows for changing the resampler to pixelated mode for pixel art particles.

---

### `ZOffset: number?`

The `ZOffset` given to particles from this `ParticleRenderer`.

---

### `native: { [any]: any }?`

The native table is used to style the container frame, which by default is invisible and the size of the `Emitter`'s `ShapeDimensions`.

```lua
e(ReactEmitter.ParticleRenderer, {
    Emitter = emitter,
    native = {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
    }
})
```

---

### `children: ReactNode?`

This is the children to the component, and you do write this through props:

```lua
e(ReactEmitter.ParticleRenderer, {
    Emitter = emitter,
    -- Do NOT set children in here
}, {
    -- This table will be turned into props.children by React
    child = e("Frame", {
        BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    })
})
```
