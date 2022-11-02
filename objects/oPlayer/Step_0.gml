if (!oController.clock.GetPause())
{
    leftState = keyboard_check(vk_left);
    rightState = keyboard_check(vk_right);
    
    //The jump state needs to persist until the next iota tick
    //We don't want to update it every frame because keyboard_check_pressed() is momentary
    //If we *did* update it every frame and the game was running fast then we might miss inputs
    if (keyboard_check_pressed(vk_space)) jumpPressedState = true;
}