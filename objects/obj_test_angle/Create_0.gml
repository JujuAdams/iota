angle = 45;
left_pressed_state = false;
right_pressed_state = false;

obj_controller.clock.variable_interpolate_angle("angle", "out_angle");
obj_controller.clock.variable_momentary("left_pressed_state", false);
obj_controller.clock.variable_momentary("right_pressed_state", false);

obj_controller.clock.add_cycle_method(function()
{
    angle = (angle + 90*(left_pressed_state - right_pressed_state)) mod 360;
});