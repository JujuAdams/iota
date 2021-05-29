velocity_x = 0;
velocity_y = 0;

left_state = false;
right_state = false;
jump_pressed_state = false;

iota_add_method(function()
{
    //Move left/right
    if (left_state) velocity_x -= 2;
    if (right_state) velocity_x += 2;
    
    //Apply friction
    velocity_x *= 0.8;
    x += velocity_x;
    
    //Do a basic jump
    if ((y >= ystart) && jump_pressed_state)
    {
        velocity_y = -20;
        jump_pressed_state = false; //Clear this input state as it's an "on press" value
    }
    
    //Apply gravity
    velocity_y += 0.8;
    y += velocity_y;
    
    //Clamp the player's position
    x = clamp(x, 0, room_width);
    
    if (y > ystart)
    {
        y = ystart;
        velocity_y = 0;
    }
});