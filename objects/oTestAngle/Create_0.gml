angle = 45;
left_pressed_state = false;
right_pressed_state = false;

oController.clock.VariableInterpolateAngle("angle", "out_angle");
oController.clock.VariableMomentary("left_pressed_state", false);
oController.clock.VariableMomentary("right_pressed_state", false);

oController.clock.AddCycleMethod(function()
{
    angle = (angle + 90*(left_pressed_state - right_pressed_state)) mod 360;
});