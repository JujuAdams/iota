if (!iota_pause_get())
{
    input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
    input_y = keyboard_check_pressed(vk_space);
    
    if (y == floor_y) velocity_y -= 20*input_y;
}

iota_execute(function()
{
    var _accel_x = 2*input_x
    velocity_x = clamp(velocity_x + _accel_x, -6, 6);
    velocity_x *= (y >= floor_y)? 0.85 : 0.98;
    x += velocity_x;
    
    velocity_y += 0.8;
    y += velocity_y;
    
    if (y > floor_y)
    {
        y = floor_y;
        velocity_y = 0;
    }
    
    x = clamp(x, 0, room_width);
});