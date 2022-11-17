/// @description Begin Cycle

//Do a basic jump if 1) we're on the groud and 2) the player has pressed space
if ((y >= ystart) && jumpPressedState) velocityY -= 20;

jumpPressedState = false; //Clear this input state as it's an "on press" value