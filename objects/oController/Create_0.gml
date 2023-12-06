clock = new IotaClock();

//Set up continuous inputs for left/right movement
clock.DefineInput("left", false);
clock.DefineInput("right", false);

//Set up a special momentary value for jumping. If an input is going to be given momentary values,
//in this case "jump" is set to <true> when pressing the space bar, then the input should be
//defined accordingly. Momentary inputs have special behaviour internally to fix edge cases where
//momentary inputs are lost if the application is running significantly faster than the clock.
clock.DefineInputMomentary("jump", false);

room_goto_next();