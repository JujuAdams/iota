# Setting Up

## Basics

The architecture of iota is centred around clocks. A clock is responsible for keeping track of when code should be executed. Instances (and structs) can attach methods to a clock and the clock will execute those methods at a fixed update frequency.

Creating a clock is done using the [`new` keyword](https://www.yoyogames.com/en/blog/gamemaker-studio-2-dot-3-new-gml-features) introduced in GameMaker Studio 2.3:

```GML
///Create Event of the controller object
global.clock = new IotaClock();
global.clock.SetUpdateFrequency(60);
```

These two lines of code create a new clock and stores a reference to it in the variable `global.clock`. We also set the update frequency of the clock to 60hz which matches the default GameMaker framerate of 60FPS. In the Step event of a controller instance we'll call the `.Tick()` method for the clock.

```GML
///Step Event of the controller object
global.clock.Tick();
```

This ensures that the clock will update constantly and, if it needs to, execute code.

Create a new object for the player and, in its Create event, we attach a method to the clock:

```GML
///Create Event of the player

//Attach a basic movement method to the clock
global.clock.AddCycleMethod(function()
{
    if (keyboard_check(vk_up)) y -= 4;
    if (keyboard_check(vk_down)) y += 4;
    if (keyboard_check(vk_left)) x -= 4;
    if (keyboard_check(vk_right)) x += 4;
});
```

This function moves the player instance around depending on what direction the user is pressing on the keyboard. **We don't need to add anything to the Step event** because this function we've attached to the clock will be executed for us. Only one "cycle method" can be attached per instance so if we want to change what logic is being called by the clock then we should add it to this function.

Finally, let's draw the player.

```GML
///Draw Event of the player
draw_circle(x, y, 20, false);
```

And that's it for basic operation! You can now change the framerate of your game to whatever you want and the player's movement speed won't change. If, for any reason, your game slows down then the game logic won't be running at a different rate and gameplay won't be affected (though things might look a bit juddery).

There is a big caveat with iota, however, and that's that many native GameMaker behaviours won't work properly with iota. This includes `speed`, `image_speed`, path-following and so on - anything that GameMaker automatically updates for us between frames. It's not a big deal to write custom code to work around this limitation, but it's a limitation nonetheless.

&nbsp;

## Interpolation

Now, let's say we have a high refresh rate screen. If your framerate is higher than the update frequency (which we set earlier to 60hz) then you might notice that the player doesn't move more smoothly despite the higher framerate. This is because the player's position is still only being updated 60 times a second via the clock.

This problem also occurs when using time dilation, usually slowmo effects. In these cases, our screen's refresh rate hasn't changed _but_ the update frequency has decreased. Same issue, just different numbers changing.

We can solve this juddering problem with some "state interpolation". iota makes setting this up an easy process. Let's change the player code to the following:

```GML
///Create Event of the player

//Set up position interpolation
global.clock.VariableInterpolate("x", "iotaX");
global.clock.VariableInterpolate("y", "iotaY");

//Attach a basic movement method to the clock (this is unchanged from before)
global.clock.AddCycleMethod(function()
{
    if (keyboard_check(vk_up)) y -= 4;
    if (keyboard_check(vk_down)) y += 4;
    if (keyboard_check(vk_left)) x -= 4;
    if (keyboard_check(vk_right)) x += 4;
});
```

```GML
///Draw Event of the player
draw_circle(iotaX, iotaY, 20, false); //Use interpolated values for our position
```

iota will now interpolate player motion between updates so that what we draw to the screen is smoother. Any continuous numeric value can be interpolated, including animation frames.
