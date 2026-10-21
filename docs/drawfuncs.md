---
title: Drawfuncs | The Mirin Template
---
[Back to main page](..)
# Drawfuncs
A drawfunction is a function that is called every frame by an ActorFrame. It is usually used to tell the Actors inside of it how to be displayed on the screen.

When you define an ActorFrame:
```xml
<Layer Type = "ActorFrame" Name = "my_actorframe"><children>
	<Layer File = "image.png" Name = "my_image" />
</children></Layer>
```

Under the hood, a drawfunction is set for the ActorFrame as such:
```lua
my_actorframe:SetDrawFunction(function(self) -- Replace "my_actorframe" with the name of your actorframe
	my_image:Draw() -- Tell your Actors to draw
end)
```
Of course, if you do not use `Draw()` on Actors inside your ActorFrame, they will not appear on the screen.

Inside the draw function, you can use loops, logic, and variables to manipulate how the ActorFrame draws its actors onto the screen. For example, this code will draw a row of clones of the actor:
```lua
my_image:y(scy) -- Center actor along y-axis
my_actorframe:SetDrawFunction(function(self)
	for i = -5, 5 do -- Use a loop to draw many actors
		my_image:x(scx + i*50) -- Add an x-offset based off the loop index, centering with scx 
		my_image:Draw() -- Make sure the actor draws inside the loop!
	end
end)
```
In retrospect, this is a very simple example. Draw functions are usually a lot more complicated than this example! If you want to get detailed and complex effects out of draw functions, you'll need to put the effort, thinking, and lua knowledge in to execute your ideas. For those who are just learning, the examples provided in this page may serve as a good starting point. 

For multiple actors, your draw function will start to look more something like this:
```lua
my_actorframe:SetDrawFunction(function(self)
	for i = 0, 9 do -- Loop ten times 
		local pos = i*40 -- We use this value a lot, so it's better to put it in a variable.
		
		if i%2 == 0 then -- "i%2 == 0" asks "if the loop index is an even number"
			my_image1:xy(pos, pos)
			my_image1:Draw() -- Draw the first image in this case
		else -- If the loop index is not even, perform this code.
			my_image2:xy(pos, pos)
			my_image2:Draw() -- Draw the second image in this case
		end

		-- my_image1 and my_image2 will draw alternating along a diagonal.
	end
end)
```
For draw functions, if your actors are not using `zbuffer`, the order of which actors are drawn on the screen are determined by what `Actor:Draw()` is executed first. In the case of the above example, every preceding Actor will draw on top of the last, since `my_image1:Draw()` is executed, then `my_image2:Draw()` is executed, and so on... It's important to keep this in mind as you can end up with Actors placed on top of each other in ways you do not wish for.

It is also important to keep in mind that the `my_image1:xy(pos, pos)` and `my_image2:xy(pos, pos)` do not reset. If you executed another `Draw()` to the Actors after the for-loop, the Actor will draw at the end of the diagonal. You'll need to reset the changes you made to your Actor.

One more thing to consider; outside of your draw function, if you attempt to modify the Actors in ways that the draw function already do, nothing will happen. For example, if you added `my_image:xy(100, 500)` in a `func` or after the draw function in the previous example, it will do nothing since the draw function sets the `xy` every frame.
# Animations with Drawfuncs
Using `GAMESTATE:SetSongBeat()`, you can provide a variable to your draw functions that changes over time, allowing you to create animations. For example:
```lua
my_image:y(scy) -- Center actor along y-axis
my_actorframe:SetDrawFunction(function(self)
	local b = GAMESTATE:GetSongBeat() -- Store song beat in a variable, this is a decimal, not an integer!

	my_image:x(b*10) -- Starting at beat 0, the Actor will slowly move to the right before going off-screen
	my_image:Draw() -- Don't forget to tell the Actor to draw!
end)
```
You probably don't want your Actors to go off-screen though! So let's use math to do cooler things.
Circular motion is a common effect in graphics. These use the trigonometric functions `math.sin` and `math.cos`. Here's an example of how you could use them:
```lua
my_actorframe:SetDrawFunction(function(self)
	local b = GAMESTATE:GetSongBeat() -- Store song beat in a variable

	for i = 0, 3 do -- Loop 4 times for 4 clones
		-- math.sin and math.cos will complete a full revolution every ~6.28 beats unchanged,
		-- so I multiply it by math.pi to make it every 2 beats. It's better to work in beats!
		local t = b * math.pi

		-- That's actually still pretty fast, so I will divide it by 4.
		t = t / 4
		
		-- Since we have 4 clones we want to show, we need phase shift for each one.
		-- In all cases for this example, it will be i * math.pi*2 / <amount of clones>.
		t = t + i * math.pi*2 / 4

		-- As b grows, math.sin(b) and math.cos(b) will trace a circle along the x and y axis
		local x = math.sin(t)*100 -- "*100" is the amplitude
		local y = math.cos(t)*100

		-- Add scx and scy respectively to rotate around center of screen
		my_image:x(scx + x)
		my_image:y(scy + y)

		-- Finally, draw the actor.
		my_image:Draw()
	end
end)
``` 

If you want your effect to not be beat-dependant, being affected by BPM changes, then you can alternatively use
`GAMESTATE:GetSongTime()` instead of `GAMESTATE:GetSongBeat()`. This will return seconds into the song instead of the beat.
# Modulo
The "holy grail" function for draw functions. Whilst `%` exists in lua, it is not friendly with negative numbers. So, we define it as this:
```lua
local function modulo(a, b)
	return a - math.floor(a/b)*b
end
```

The Modulo function is essentially produces sawtooth waves. As `a` grows, everytime it touches `b` it goes back to zero. This is very useful for producing seemingly infinite effects in draw functions. Here's an example:
```lua
my_image:y(scy) -- Center actor along y-axis
my_actorframe:SetDrawFunction(function(self)
	local b = GAMESTATE:GetSongBeat() / 4 -- Divide by 4 here to slow the effect down
	
	-- Make 10 clones
	for i = 0, 9 do
		my_image:x(
			-100 -- Start out of frame
			+ modulo(b + i/10, 1) -- Every beat, move to the right linearlly then warp back to the start.
			-- Also add equal phase shift for clones to b!
			* (sw + 200) -- Then, multiply by the end point. This is at the other end of the screen.
		)
        my_image:Draw() -- Finally, tell the actor to draw
	end
end)
```

# Definemod and Drawfunc
You probably want to have more control over your draw function, rather than it doing the same thing forever. In the case of the circular motion example, perhaps what if you wanted to change the amplitude, or the amount of clones?

[`definemod`](definemod.md) is perfect for this, as it allows you to control values inside the draw function using [`ease`](ease.md), [`set`](set.md), [`add`](ease.md), etc.

Let's take that circular motion example and expand on it. 
```lua
-- First, define your variables across the entire mods.lua.
local circular_amp, circular_amnt

-- Then, make a definemod that simply maps a mod to the variables.
definemod {'circularamp', 'circularamnt', function(c_amp, c_amnt)
	circular_amp = c_amp
	circular_amnt = c_amnt
end}

-- These values default to 0, which may not be what we want! Let's change them with setdefault.
setdefault {100, 'circularamp', 4, 'circularamnt'}

-- Now we can set the draw function
my_actorframe:SetDrawFunction(function(self)
	local b = GAMESTATE:GetSongBeat() -- Store song beat in a variable

	-- Replace the loop amount with our variable (minus 1 since loop condition is inclusive)
	for i = 0, circular_amnt do
	
		-- As mentioned earlier, since phase shift is i * math.pi*2 / <amount of clones>,
		-- we simply replace the math.pi*2 / 4 with math.pi*2 / <our amount variable>
		local t = b * math.pi / 4 + i * math.pi*2 / circular_amnt

		-- We have a variable for amplitude now, so replace 100 with it.
		local x = math.sin(t)*circular_amp
		local y = math.cos(t)*circular_amp

		-- Add scx and scy respectively to rotate around center of screen
		my_image:x(scx + x)
		my_image:y(scy + y)

		-- Finally, draw the actor.
		my_image:Draw()
	end
end)

-- Now, we can manipulate the draw function mid-file to our liking!

-- Increase the size of the circle to 200 over 4 beats starting at beat 4
ease {4, 4, outCubic, 200, 'circularamp'}

-- Set the amount of clones in the circle to 8 at beat 16
set {16, 8, 'circularamnt'}
``` 

# Proxywall Example
A very popular effect in NotITG is what's known as the "proxywall". It is an effect where multiple playfields fill the screen horizontally and often move along the screen seemingly infinitely. Using what we know, we can create a simple primative proxywall:

```xml
<!-- Encapsulate PP[1] in an actorframe -->
<Layer Type = "ActorFrame" Name = "proxywall"><children>
    <Layer Type = "ActorProxy" Name = "PP[1]" />
</children></Layer>
```

```lua
-- Start with our definemods, for this example I'll add modifiers for the spread and scroll
local proxywall_spread, proxywall_scroll
definemod {'proxywallspread', 'proxywallscroll', function(spread, scroll)
    proxywall_spread = spread*2.56 -- 256 equals one playfield, so lets make it in terms of 100
    proxywall_scroll = scroll/100 -- Divide by 100 for mod amount consistency
end}
-- These are fine at 0, so I won't bother using setdefault

proxywall:SetDrawFunction(function(self)
    -- The effect isn't active at 0 spread, so to save resources, don't draw the wall.
    if proxywall_spread ~= 0 then

        -- Create clones, 6 in this case
        -- Since we draw left to right, we want an extra one on the left
        for i = -3, 2 do

            -- Do the same thing as the modulo example but with the players
            -- Also replace some variables with our definemod'd ones
            PP[1]:x(
                (modulo(proxywall_scroll, 1) + i) * proxywall_spread
            )

            -- Then draw the player
            PP[1]:Draw()
        end

    else -- Even if the wall isn't being drawn, we still need to draw our player.
        PP[1]:Draw()
    end
end)

-- Here we didn't use P2, so let's hide it.
PP[2]:hidden(1)

-- Let's also center our player.
P1:x(scx)

-- From here, you can mess around with the spread and scroll to your liking
ease {8, 8, outCubic, 100, 'proxywallspread'}
ease {16, 8, inOutCubic, 1000, 'proxywallscroll'}
```