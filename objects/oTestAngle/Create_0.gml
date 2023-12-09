angle = 45;
outAngle = angle;

oController.clock.VariableInterpolateAngle("angle", "outAngle");
oController.clock.DefineInputMomentary("left pressed",  false);
oController.clock.DefineInputMomentary("right pressed", false);

oController.clock.AddCycleMethod(function()
{
    angle = (angle + 90*(IotaGetInput("left pressed") - IotaGetInput("right pressed"))) mod 360;
});