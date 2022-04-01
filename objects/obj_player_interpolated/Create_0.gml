velocity_x = 0;
velocity_y = 0;

left_state = false;
right_state = false;
jump_pressed_state = false;



//Reset jump_pressed_state at the end of the first cycle
obj_controller.clock.variable_momentary("jump_pressed_state", false);
//Set iota_x/iota_y to the interpolated value of x/y
obj_controller.clock.variable_interpolate("x", "iota_x");
obj_controller.clock.variable_interpolate("y", "iota_y");



obj_controller.clock.add_cycle_method(function()
{
    //Move left/right
    //This is continuous input so we don't want to clear these states
    if (left_state) velocity_x -= 2;
    if (right_state) velocity_x += 2;
    
    //Do a basic jump if 1) we're on the groud and 2) the player has pressed space
    if ((y >= ystart) && jump_pressed_state) velocity_y -= 20;
    
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