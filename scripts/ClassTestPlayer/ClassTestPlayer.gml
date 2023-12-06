// Feather disable all

function ClassTestPlayer(_x, _y) constructor
{
    x = _x;
    y = _y;
    
    oController.clock.VariableInterpolate("x", "iotaX", self);
    oController.clock.VariableInterpolate("y", "iotaY", self);
    
    oController.clock.AddCycleMethod(function()
    {
        if (keyboard_check(vk_up)) y -= 4;
        if (keyboard_check(vk_down)) y += 4;
        if (keyboard_check(vk_left)) x -= 4;
        if (keyboard_check(vk_right)) x += 4;
    });
    
    static Draw = function()
    {
        draw_circle(iotaX, iotaY, 20, false);
    }
}
