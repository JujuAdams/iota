clock.Tick();

//Cycle through iota target framerates
if (keyboard_check_pressed(ord("I")))
{
    switch(clock.GetUpdateFrequency())
    {
        case 30:  clock.SetUpdateFrequency( 60); break;
        case 60:  clock.SetUpdateFrequency( 75); break;
        case 75:  clock.SetUpdateFrequency(120); break;
        case 120: clock.SetUpdateFrequency(144); break;
        case 144: clock.SetUpdateFrequency( 30); break;
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

//Cycle through time dilation multipliersa
if (keyboard_check_pressed(ord("D")))
{
    switch(clock.GetTimeDilation())
    {
        case 0.27: clock.SetTimeDilation(0.50); break;
        case 0.50: clock.SetTimeDilation(1.00); break;
        case 1.00: clock.SetTimeDilation(2.00); break;
        case 2.00: clock.SetTimeDilation(3.33); break;
        case 3.33: clock.SetTimeDilation(0.27); break;
    }
}

//Pause toggle
if (keyboard_check_pressed(ord("P")))
{
    clock.SetPause(!clock.GetPause());
}

//Swap between player objects
if (keyboard_check_pressed(ord("A")))
{
    if (instance_exists(oPlayer))
    {
        instance_create_layer(oPlayer.xstart, oPlayer.ystart, oPlayer.layer, oPlayerInterpolated);
        instance_destroy(oPlayer);
    }
    else if (instance_exists(oPlayerInterpolated))
    {
        instance_create_layer(oPlayerInterpolated.xstart, oPlayerInterpolated.ystart, oPlayerInterpolated.layer, oPlayer);
        instance_destroy(oPlayerInterpolated);
    }
}

//Cheeky extra test case
if (keyboard_check_pressed(ord("R"))) room_restart();