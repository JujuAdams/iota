function test_class_player(_x, _y, _clock) constructor
{
    x = _x;
    y = _y;
    
    obj_controller.clock.variable_interpolate("x", "iota_x", self);
    obj_controller.clock.variable_interpolate("y", "iota_y", self);
    
    obj_controller.clock.add_cycle_method(function()
    {
        if (keyboard_check(vk_up)) y -= 4;
        if (keyboard_check(vk_down)) y += 4;
        if (keyboard_check(vk_left)) x -= 4;
        if (keyboard_check(vk_right)) x += 4;
    });
    
    static draw = function()
    {
        draw_circle(iota_x, iota_y, 20, false);
    }
}