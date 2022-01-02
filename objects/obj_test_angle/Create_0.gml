angle = 45;
left_pressed_state = false;
right_pressed_state = false;

obj_controller.clock.VariableInterpolateAngle("angle", "out_angle");
obj_controller.clock.VariableMomentary("left_pressed_state", false);
obj_controller.clock.VariableMomentary("right_pressed_state", false);

obj_controller.clock.AddCycleMethod(function()
{
    angle = (angle + 90*(left_pressed_state - right_pressed_state)) mod 360;
});