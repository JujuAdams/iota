if (!obj_controller.clock.get_pause())
{
    left_state = keyboard_check(vk_left);
    right_state = keyboard_check(vk_right);
    
    //The jump state needs to persist until the next iota tick
    //We don't want to update it every frame because keyboard_check_pressed() is momentary
    //If we *did* update it every frame and the game was running fast then we might miss inputs
    if (keyboard_check_pressed(vk_space)) jump_pressed_state = true;
}