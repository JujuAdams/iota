angle = 45;
leftPressedState = false;
rightPressedState = false;

oController.clock.VariableInterpolateAngle("angle", "outAngle");
oController.clock.VariableMomentary("leftPressedState", false);
oController.clock.VariableMomentary("rightPressedState", false);

oController.clock.AddCycleMethod(function()
{
    angle = (angle + 90*(leftPressedState - rightPressedState)) mod 360;
});