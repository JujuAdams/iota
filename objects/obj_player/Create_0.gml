velocity_x = 0;
velocity_y = 0;

left_state = false;
right_state = false;
jump_pressed_state = false;

iota_add_begin_method(function()
{
    //Do a basic jump if 1) we're on the groud and 2) the player has pressed space
    if ((y >= ystart) && jump_pressed_state) velocity_y -= 20;
    
    jump_pressed_state = false; //Clear this input state as it's an "on press" value
});

iota_add_method(function()
{
    //Move left/right
    //This is continuous input so we don't want to clear these states
    if (left_state) velocity_x -= 2;
    if (right_state) velocity_x += 2;
    
    //Apply friction and gravity
    velocity_x *= 0.8;
    velocity_y += 0.8;
    
    //Move the player
    x += velocity_x;
    y += velocity_y;
    
    //Clamp the player's position
    x = clamp(x, 0, room_width);
    
    if (y > ystart)
    {
        y = ystart;
        velocity_y = 0;
    }
});

iota_add_end_method(function()
{
    //idk what to put here
});