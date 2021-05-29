if (!iota_pause_get())
{
    input_x = keyboard_check(vk_right) - keyboard_check(vk_left);
    input_y = keyboard_check(vk_space);
}