/// @description Cycle

//Move left/right
//This is continuous input so we don't want to clear these states
if (leftState) velocityX -= 2;
if (rightState) velocityX += 2;

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