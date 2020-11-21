//Tick Iota, and execute any added methods
iota_tick();

//Cycle through Iota target framerates
if (keyboard_check_pressed(ord("I")))
{
    switch(iota_target_framerate_get())
    {
        case 30:  iota_target_framerate_set( 60); break;
        case 60:  iota_target_framerate_set( 75); break;
        case 75:  iota_target_framerate_set(120); break;
        case 120: iota_target_framerate_set(144); break;
        case 144: iota_target_framerate_set( 30); break;
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
    iota_pause_set(!iota_pause_get());
}

if (keyboard_check_pressed(ord("D")))
{
    instance_destroy(obj_player);
}