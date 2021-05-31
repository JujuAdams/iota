clock.tick();

//Cycle through iota target framerates
if (keyboard_check_pressed(ord("I")))
{
    switch(clock.get_target_framerate())
    {
        case 30:  clock.set_target_framerate( 60); break;
        case 60:  clock.set_target_framerate( 75); break;
        case 75:  clock.set_target_framerate(120); break;
        case 120: clock.set_target_framerate(144); break;
        case 144: clock.set_target_framerate( 30); break;
    }
}

//Cycle through game speeds
if (keyboard_check_pressed(ord("G")))
{
    switch(game_get_speed(gamespeed_fps))
    {
        case 15:  game_set_speed( 30, gamespeed_fps); break;
        case 30:  game_set_speed( 60, gamespeed_fps); break;
        case 60:  game_set_speed(120, gamespeed_fps); break;
        case 75:  game_set_speed(120, gamespeed_fps); break;
        case 120: game_set_speed(144, gamespeed_fps); break;
        case 144: game_set_speed( 15, gamespeed_fps); break;
    }
}

//Pause toggle
if (keyboard_check_pressed(ord("P")))
{
    clock.set_pause(!clock.get_pause());
}