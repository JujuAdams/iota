velocityX = 0;
velocityY = 0;

leftState = false;
rightState = false;
jumpPressedState = false;



//Reset jumpPressedState at the end of the first cycle
oController.clock.VariableMomentary("jumpPressedState", false);
//Set iotaX/iotaY to the interpolated value of x/y
oController.clock.VariableInterpolate("x", "iotaX");
oController.clock.VariableInterpolate("y", "iotaY");



oController.clock.AddCycleMethod(function()
{
    //Move left/right
    //This is continuous input so we don't want to clear these states
    if (leftState) velocityX -= 2;
    if (rightState) velocityX += 2;
    
    //Do a basic jump if 1) we're on the groud and 2) the player has pressed space
    if ((y >= ystart) && jumpPressedState) velocityY -= 20;
    
    //Apply friction and gravity
    velocityX *= 0.8;
    velocityY += 0.8;
    
    //Move the player
    x += velocityX;
    y += velocityY;
    
    //Clamp the player's position
    x = clamp(x, 0, room_width);
    
    if (y > ystart)
    {
        y = ystart;
        velocityY = 0;
    }
});