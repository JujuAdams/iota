var _string  = "";
_string += "iota " + string(__IOTA_VERSION) + " (" + string(__IOTA_DATE) + ")\n"
_string += "Miniature Fixed Timestep Library\n"
_string += "@jujuadams\n\n";
_string += "Game target framerate: " + string(game_get_speed(gamespeed_fps)) + "FPS (actual = " + string(fps) + ")\n";
_string += "iota target framerate: " + string(iota_target_framerate_get()) + "FPS\n\n";
_string += "Arrow Keys/Space: Move/Jump\n"
_string += "G: Change game framerate\n"
_string += "I: Change iota target framerate\n"
_string += "P: Toggle pause\n"

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