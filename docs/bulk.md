---
sidebar_position: 5
---

# useEmitters

The useEmitters hook allows you to create and manage multiple Emitters at once.

## Usage

`useEmitters` takes the following arguments:

* `count` — number of emitters to create.
* `props` — either:

  * A **table** of `EmitterProps` (declarative), or
  * A **function** that takes **index** and returns `EmitterProps` (imperative).

When using the declarative version, all `Emitters` will share the same `EmitterProps`.

## Example: Declarative

```lua
local emitters = ReactEmitter.useEmitters(3, {
    Size = NumberSequence.new(0.2),
    ShapeDimensions = Vector2.new(32, 32),
})
```

This creates 3 emitters using the same config.

---

## Example: Imperative API

```lua
local emitters, api = ReactEmitter.useEmitters(5, function(index)
    return {
        Size = NumberSequence.new(0.1 + (index * 0.02)),
        ShapeDimensions = Vector2.new(16, 16),
        Enabled = false,
    }
end)

-- Emit a burst from each emitter
api.emit(function(index)
    return index * 2 -- Number of particles to emit per emitter
end)

-- Staggered emit
for i = 1, 5 do
    api.emit(function(index)
        if index == i then
            return 1
        end
        return 0
    end)

    task.wait(0.25)
end
```

### `api.emit(callback)`

* `callback(index)` must return a **number** of particles to emit for that emitter.
* Emitters are processed in order from `1 → count`.
