floor_y = ystart;

velocity_x = 0;
velocity_y = 0;

input_x = 0;
input_y = 0;

iota_add_method(function()
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