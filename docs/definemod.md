---
title: Define Mods | The Mirin Template
---
[Back to main page](..)
# Defining Mods
```lua
definemod {modname, function(percent)
    -- implementation
end}
```
The function `definemod` can be used to define custom auxiliary mods. Whenever `modname` is eased, the callback function will be called with the updated `percent`. `definemod` is useful because it lets the ease engine be used to control arbitrary non-mod behavior.

Arguments:

| ----- | ----- |
| `modname: string` | The name of the mod to define |
| `function` | the function that is called every time the mod is changed |

Example:
```lua
definemod {'rotatebg', function(p)
    -- rotates the actor `my_bg_actor`
    my_bg_actor:rotationz(p)
end}
```
This example ties the angle of an actor to a mod named `'rotatebg'`. 

# Multiple Mods
```lua
definemod {mod1, mod2, mod3, ..., function(mod1, mod2, mod3, ...)
    -- implementation
end}
```
If an implementation needs to access multiple ease values simultaneously, then multiple mods can be listed. The function arguments match the order that the mods are listed.

Example:
```lua
definemod {'actorradius', 'actorangle', function(r, a)
    my_actor:xy(math.cos(a) * r, math.sin(a) * r)
end}
```
This example moves an actor using multiple input mods simultaneously.

# Player Specific
```lua
definemod {mymod, function(percent, pn)
    -- implementation
end}
```
Although it is rare, there are sometimes cases when a defined mod to be player specific: ie, it behaves differently depending on which player it's been applied to. To accomplish this, the callback function can take in an extra argument, which is the player number. Keep in mind this will iterate for **all eight players**, including non-awake ones, so restrict any calls that wouldn't work on non-awake players to currently-active ones with an `if` block.

# Write to mods
Sometimes, mod definitions need to write back to other mods. This can be done by adding return values to the function. Here's an example that implements blacksphere in terms of `invert`, `alternate`, and `reverse`.
```lua
definemod {
    'blacksphereoffset',
    function(offset)
        local invert = 50 - 50 * math.cos(blacksphereoffset * math.pi / 180)
        local alternate = 25 * math.sin(blacksphereoffset * math.pi / 180)
        local reverse = -12.5 * math.sin(blacksphereoffset * math.pi / 180)
        return invert, alternate, reverse
    end,
    'invert', 'alternate', 'reverse',
}
```
If you merely want to create a shorthand for writing to other mods, use a set-style table with each target mod amount as the value when your newly-defined mod is at 100.
```lua
definemod {'mods', 100, 'brake', 100, 'drunk'}
```
