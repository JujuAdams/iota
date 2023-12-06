if (!oController.clock.GetPause())
{
    //Set input values for the clock based on keyboard input. Note that if we're using a momentary value
    //for an input (such as "jump" below) then the input should be defined on the clock using the
    //.DefineInputMomentary() method. Input values can be picked up in an iota cycle by calling the
    //IotaGetInput() function.
    oController.clock.SetInput("left",  keyboard_check(vk_left));
    oController.clock.SetInput("right", keyboard_check(vk_right));
    oController.clock.SetInput("jump",  keyboard_check_pressed(vk_space));
}