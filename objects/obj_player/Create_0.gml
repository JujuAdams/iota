velocity_x = 0;
velocity_y = 0;

input_x = 0;
input_y = 0;

iota_add_method(function()
{
    velocity_x += 2*input_x;
    velocity_x *= 0.8;
    x += velocity_x;
    
    if (y <= ystart) velocity_y -= 20*input_y;
    velocity_y += 0.8;
    y += velocity_y;
    
    if (y > ystart)
    {
        y = ystart;
        velocity_y = 0;
    }
    
    x = clamp(x, 0, room_width);
});