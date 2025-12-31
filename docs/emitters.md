---
sidebar_position: 2
---

# Emitter Props

`EmitterProps` defines the configuration schema for 2D UI particle emitters created via `ReactEmitter.useEmitter` or `ReactEmitter.useEmitters`.

All fields are **optional**. Defaults are applied internally when omitted.

## Usage

`useEmitter` can take either of the follow as props:

* A **table** of `EmitterProps` (declarative), or
* A **function** that returns `EmitterProps` (imperative).

```lua
-- Create an emitter with custom size and dimensions (in pixels)
local emitter = ReactEmitter.useEmitter({
    Size = NumberSequence.new(0.2),
    ShapeDimensions = Vector2.new(50, 50),
})
```

## Deviations from `ParticleEmitter`

* This is a **2D UI particle system**. It does not support lighting properties (`LightEmission`, `LightInfluence`, `WindAffectsDrag`, etc).
* `Acceleration` is a Vector2 since this is a 2D system.
* `SpreadAngle` is a single number instead of a `Vector2` since this is a 2D system.
* `Shape` uses equivalent 2D shapes.
* `EmissionDirection`, `Shape`, `ShapeStyle` use custom 2D enums `ReactEmitter.NormalId2D` `ReactEmitter.ParticleEmitterShape2D` `ReactEmitter.ParticleEmitterShapeStyle2D`
* Flipbooks require full image resolution (`FlipbookImageSize`), default `1024 × 1024` pixels.
* `Texture` must be a `Content` type (`fromAssetId`, `fromUri`). Raw strings are not supported.
* Maximum `Rate` is still **200 particles/sec**. UI particles are significantly more expensive than normal particles, so you should use far less.

## Properties

### `Acceleration: Vector2`

Acceleration applied along the **X and Y axes**.  
Default: `Vector2.zero`  
Deviation: Uses `Vector2` instead of `Vector3`.

---

### `Brightness: number`

Visual intensity multiplier for UI particles.  
Default: `1`  
Deviation: `ImageColor` is effectively clamped to RGB `255, 255, 255`. Values above 1 provide minimal benefit and are **not recommended**.

---

### `Color: ColorSequence`

Colour gradient applied over the particle’s lifetime.  
Default: `ColorSequence.new(Color3.new(1, 1, 1))` (solid white)  
Matches `ParticleEmitter` except constrained to UI rendering limits.

---

### `Drag: number`

Exponential velocity decay factor. Higher values reduce speed faster.  
Default: `0`

---

### `EmissionDirection: NormalId2D`

Emitter face direction when `Shape` is `Rectangle`.  
Default: `NormalId2D.Top`  
Deviation: Uses a **2D enum** rather than `Enum.NormalId`.

---

### `Enabled: boolean`

Whether the emitter automatically spawns particles at `Rate × TimeScale`.  
Default: `true`  
Note: Even when disabled, you may spawn manually via the imperative API.

---

### `FlipbookFramerate: NumberRange`

Animation speed range (frames/sec) for flipbook textures.  
Default: `NumberRange.new(1)`  
Note: Applies only to `Loop` and `Random` flipbook modes.

---

### `FlipbookImageSize: Vector2`

Full resolution of the source flipbook image in **pixels** (`width, height`).  
Default: `Vector2.new(1024, 1024)`  
Deviation: Required for correct UV slicing. Particle Emitters infer this automatically; UI emitters cannot.

---

### `FlipbookLayout: ParticleFlipbookLayout`

Cell layout mode for flipbooks.  
Default: `ParticleFlipbookLayout.None`  
Deviation: No `FlipbookIncompatible` error string, test the flipbook on a Particle Emitter if needed.

---

### `FlipbookMode: ParticleFlipbookMode`

Animation mode for flipbook playback.  
Default: `ParticleFlipbookMode.Loop`  

---

### `FlipbookSizeX: number`

Number of columns when using `FlipbookMode.Custom`.  
Default: `1`  

---

### `FlipbookSizeY: number`

Number of rows when using `FlipbookMode.Custom`.  
Default: `1`  

---

### `FlipbookStartRandom: boolean`

If `true`, each particle begins on a random frame.  
Default: `false`  

---

### `Lifetime: NumberRange`

Random lifespan range for new particles in **seconds**.  
Default: `NumberRange.new(5, 10)`  
Matches `ParticleEmitter` conceptually.

---

### `Rate: number`

Particles emitted per second at `TimeScale = 1`.  
Default: `20`  

---

### `Rotation: NumberRange`

Initial rotation range in **degrees**.  
Default: `NumberRange.new(0)`  
Matches `ParticleEmitter`.

---

### `RotSpeed: NumberRange`

Angular velocity range in **degrees/sec**.  
Default: `NumberRange.new(0)`  
Matches `ParticleEmitter`.

---

### `Shape: ParticleEmitterShape2D`

Emitter shape type. Options: `Rectangle` or `Annulus`.  
Default: `ParticleEmitterShape2D.Rectangle`  
Deviation: Uses 2D shape equivalents to normal Particle Emitters. Currently no proper replacement for `Sphere`, so semicircles are not supported right now.

---

### `ShapeDimensions: Vector2`

Emitter size in **pixels** when spawning in UI space (`width, height`).  
Default: `Vector2.new(1, 1)`  
Deviation: Must be explicitly supplied for shape spawning since Emitters are detached from Particle Renderers.

---

### `ShapeInOut: Enum.ParticleEmitterShapeInOut`

Controls emission direction: `Outward`, `Inward`, or `InAndOut`.  
Default: `Outward`

---

### `ShapePartial: number`

For `Annulus` only. Inner radius multiplier `[0, 1]` relative to outer radius.  
`1` = full disc, `0` = perimeter only.  
Default: `1`

---

### `ShapeStyle: ParticleEmitterShapeStyle2D`

Spawn mode. Options: `Area` or `Perimeter`.  
Default: `ParticleEmitterShapeStyle2D.Area`  
Deviation: These are the 2D equivalents to Volume and Surface.

---

### `Size: NumberSequence`

Relative size curve over the particle lifetime.  
Default: `NumberSequence.new(1)`  
Matches `ParticleEmitter`, but interpreted relative to the larger `ParticleRenderer` dimension.

---

### `Speed: NumberRange`

Initial velocity range  
Default: `NumberRange.new(5)`  
Note: May be negative to emit in reverse direction.

---

### `SpreadAngle: number`

Random directional offset in **degrees** either side of `EmissionDirection`.  
Default: `0`  
Deviation: Single scalar instead of a 2D vector.

---

### `Squash: NumberSequence`

Non-uniform scale curve over lifetime.  
`>0` = taller vertically, `<0` = wider horizontally.  
Default: `NumberSequence.new(0)`

---

### `Texture: Content`

Particle sprite texture source. Must be a `Content` type.  
Default: `Content.fromUri("rbxasset://textures/particles/sparkles_main.dds")`  
Deviation: Raw strings are **not supported**.

---

### `TimeScale: number`

Simulation speed multiplier. Also scales `Rate`.  
Default: `1`  
Deviation: Supports values **outside** `[0, 1]` unlike `ParticleEmitter`.

---

### `Transparency: NumberSequence`

Opacity curve over lifetime.  
Default: `NumberSequence.new(0)` (fully visible)

---

## Notes

* The size of particles is relative to the size of the `ParticleRenderer`.
* Particles are always **locked to the `ParticleRenderer` UI component** (`LockedToPart` behaviour).
* `ZOffset` and `LocalTransparencyModifier` are handled by `ParticleRenderer` instead of Emitters.
* You can also change the `ResampleMode` on the `ParticleRenderer`.
