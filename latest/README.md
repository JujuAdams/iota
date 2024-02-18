<p align="center"><img src="https://raw.githubusercontent.com/JujuAdams/iota/master/LOGO.png" style="display:block; margin:auto; width:300px"></p>
<h1 align="center">iota</h1>
<p align="center">Miniature delta time and time dilation library for GameMaker by <a href="https://www.jujuadams.com/" target="_blank">Juju Adams</a></p>
<p align="center"><a href="https://github.com/JujuAdams/iota/releases/">Download the .yymps</a></p>

&nbsp;

## Features

iota implements delta timing and time dilation for GameMaker.

Basic operation can be set up with [four function calls](setting-up) and the techniques required are an extension of GameMaker's Step event paradigm. iota is also useful for handling pausing gameplay as game systems (gameplay, particle effects, UIs etc.) can be attached to specific clocks and paused independently of each other. iota has time dilation built in.

The solution chosen for iota is a "fixed timestep" whereby logic is executed at a constant frequency, independent of what the framerate of the game is. This avoids the [nasty mathematics](https://forum.yoyogames.com/index.php?threads/benefits-of-using-deltatime.46495/) of other framerate-correction solutions and should be very familiar to GameMaker developers in general. This is the method featured in [Gaffer On Games'](https://gafferongames.com/) famous ["Fix Your Timestep!"](https://gafferongames.com/post/fix_your_timestep/) blog post, though the implementation has a few minor differences.

Thanks to features introduced in GameMaker Studio 2.3, iota operates on a simple method-execution system. iota also offers automatic variable state resetting and state interpolation to make common fixed timestep code patterns less of a chore to implement.

iota does have limitations however, and they aren't trivial. iota will not work properly with in-built GameMaker systems such as the `speed`/`hspeed`/`image_speed` variables, alarms won't trigger at the right times, and path-following using the native [`path_start()`](https://manual.yoyogames.com/GameMaker_Language/GML_Reference/Asset_Management/Paths/path_start.htm) function won't behave as intended. Fortunately, it's relatively easy to work around these problems with some custom code but true beginner developers will want to build familiarity with GML first before trying out iota.

## About & Support

iota supports all GameMaker export modules, including consoles, mobile, and Opera GX. iota also works on HTML5 but YoYoGames' lacklustre support for this platform can make bug fixing hard if you run into anything. If you'd like to report a bug or suggest a feature, please use the repo's [Issues page](https://github.com/JujuAdams/iota/issues). iota is constantly being maintained and upgraded; bugs are usually addressed within a few days of being reported.

iota is built and maintained by [@jujuadams](https://twitter.com/jujuadams), whose career started by converting [Hyper Light Drifter to 60FPS](https://www.youtube.com/watch?v=LvL9Rt6JVlk). Juju's worked on several [commercial GameMaker games](http://www.jujuadams.com/).

This library will never truly be finished because contributions and suggestions from new users are always welcome. iota wouldn't be the same without [your](https://tenor.com/search/whos-awesome-gifs) input! Make a suggestion on the repo's [Issues page](https://github.com/JujuAdams/iota/issues) if you'd like a feature to be added.

## License

iota is licensed under the [MIT License](https://github.com/JujuAdams/iota/blob/master/LICENSE).
