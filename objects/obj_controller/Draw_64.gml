var _string  = "";
_string += "iota " + string(__IOTA_VERSION) + " (" + string(__IOTA_DATE) + ") by @jujuadams\n";
_string += "Miniature Fixed Timestep Library\n";
_string += "\n";
_string += "Game target framerate: " + string(game_get_speed(gamespeed_fps)) + "FPS (actual = " + string(fps) + ")\n";
_string += "iota update frequency: " + string(clock.get_update_frequency()) + "hz\n";
_string += "iota time dilation: x" + string(clock.get_time_dilation()) + "\n";
_string += "\n";
_string += "Arrow Keys/Space: Move/Jump\n";
_string += "G: Change game framerate\n";
_string += "I: Change iota update frequency\n";
_string += "D: Change time dilation\n";
_string += "P: Toggle pause (=" + string(clock.get_pause()) + ")\n";

if (instance_exists(obj_player))
{
    _string += "A: Swap to interpolated motion\n";
}
else if (instance_exists(obj_player_interpolated))
{
    _string += "A: Swap to non-interpolated motion\n";
}

draw_set_colour(c_black);
draw_set_alpha(0.5);
draw_text(10, 13, _string);
draw_set_colour(c_black);
draw_set_alpha(1.0);
draw_text( 9, 10, _string);
draw_text(11, 10, _string);
draw_text(10,  9, _string);
draw_text(10, 11, _string);
draw_set_colour(c_white);
draw_text(10, 10, _string);