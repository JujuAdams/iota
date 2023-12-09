if (!oController.clock.GetPause())
{
    oController.clock.SetInput("left",  keyboard_check(vk_left));
    oController.clock.SetInput("right", keyboard_check(vk_right));
}