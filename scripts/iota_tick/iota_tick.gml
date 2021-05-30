function iota_tick()
{
    //Get the clamped delta time value for this GameMaker frame
    //We clamp the bottom end to ensure that games still chug along even if the device is really grinding
    var _delta = min(1/IOTA_MINIMUM_FRAMERATE, delta_time/1000000);
    
    //Iterate over every timer
    IOTA_CURRENT_TIMER = 0;
    repeat(IOTA_TIMER_COUNT)
    {
        //Start off assuming this timer isn't going to want to process any cycles whatsoever
        IOTA_CYCLES_FOR_TIMER = 0;
        
        //If this specific timer isn't paused...
        if (!global.__iota_pause[IOTA_CURRENT_TIMER])
        {
            //...figure out how many cycles this timer requires based the accumulator and the timer's framerate
            var _framerate = global.__iota_target_framerate[IOTA_CURRENT_TIMER];
            IOTA_CYCLES_FOR_TIMER = floor(_framerate*global.__iota_accumulator[IOTA_CURRENT_TIMER]);
            
            //Any leftover time that can't fit into a full cycle add back onto the accumulator
            global.__iota_accumulator[@ IOTA_CURRENT_TIMER] += _delta - (IOTA_CYCLES_FOR_TIMER / _framerate);
        }
        
        if (IOTA_CYCLES_FOR_TIMER > 0)
        {
            //Grab an array that contains the timer data
            var _timer_data_struct = global.__iota_data_struct[IOTA_CURRENT_TIMER];
            var _timer_data_array  = global.__iota_data_array[ IOTA_CURRENT_TIMER];
            
            //Iterate over the timer and execute begin methods
            __iota_execute_methods_for_timer(_timer_data_array, _timer_data_struct, __IOTA_DATA.BEGIN_METHOD);
            
            //Execute cycles one at a time
            //Note that we're processing all methods for a cycle, then move onto the next cycle
            //This ensure instances doesn't get out of step with each other
            IOTA_CYCLE_INDEX = 0;
            repeat(IOTA_CYCLES_FOR_TIMER)
            {
                __iota_execute_methods_for_timer(_timer_data_array, _timer_data_struct, __IOTA_DATA.METHOD);
                IOTA_CYCLE_INDEX++;
            }
            
            //Now iterate over the timer for the final time and execute end methods
            __iota_execute_methods_for_timer(_timer_data_array, _timer_data_struct, __IOTA_DATA.END_METHOD);
        }
        
        IOTA_CURRENT_TIMER++;
    }
    
    //Make sure to reset these macros so they can't be accessed outside of iota methods
    IOTA_CURRENT_TIMER    = undefined;
    IOTA_CYCLES_FOR_TIMER = undefined;
    IOTA_CYCLE_INDEX      = undefined;
}