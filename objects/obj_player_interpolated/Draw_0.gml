//Some extra spice to interpolate frames to get smooth motion even when the clock framerate is low
//This is entirely optional but can be useful for time dilation effects

var _remainder = obj_controller.clock.get_remainder();
var _x = lerp(prev_x, x, _remainder);
var _y = lerp(prev_y, y, _remainder);
draw_circle(_x, _y, 20, false);