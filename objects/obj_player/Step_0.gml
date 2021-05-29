if (!iota_pause_get())
{
    left_state = keyboard_check(vk_left);
    right_state = keyboard_check(vk_right);
    if (keyboard_check_pressed(vk_space)) jump_pressed_state = true;
}