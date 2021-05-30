//These three macros are only valid inside iota methods and will return <undefined> outside of them
#macro IOTA_CURRENT_TIMER     global.__iota_current_timer //Index of the timer that's currently being handled (0-indexed)
#macro IOTA_CYCLES_FOR_TIMER  global.__iota_total_cycles  //Total number of cycles that will be processed this frame for the current timer
#macro IOTA_CYCLE_INDEX       global.__iota_cycle_index   //Current cycle for the current timer (0-indexed)

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
            //Grab methods and scopes from the relevant lists for this timer
            //These lists are paired so that a value in one corresponds to a value in the other
            var _methods_list = global.__iota_methods[IOTA_CURRENT_TIMER];
            var _scopes_list  = global.__iota_scopes[IOTA_CURRENT_TIMER];
            
            //Execute cycles one at a time
            //Note that we're processing all methods for a cycle, then move onto the next cycle
            //This ensure instances doesn't get out of step with each other
            IOTA_CYCLE_INDEX = 0;
            repeat(IOTA_CYCLES_FOR_TIMER)
            {
                var _i = 0;
                repeat(ds_list_size(_methods_list))
                {
                    var _scope = _scopes_list[| _i];
                    
                    //If this scope is a real number then it's an instance ID
                    if (is_real(_scope))
                    {
                        var _exists = instance_exists(_scope);
                        var _deactivated = false;
                        
                        if (IOTA_CHECK_FOR_DEACTIVATION)
                        {
                            //Bonus check for deactivation
                            if (!_exists)
                            {
                                instance_activate_object(_scope);
                                if (instance_exists(_scope))
                                {
                                    instance_deactivate_object(_scope);
                                    _exists = true;
                                    _deactivated = true;
                                }
                            }
                        }
                        
                        if (_exists)
                        {
                            //If this instance exists and isn't deactivated, execute our method!
                            if (!_deactivated) with(_scope) _methods_list[| _i]();
                        }
                        else
                        {
                            //If this instance doesn't exist then remove it from both the method and scope lists
                            ds_list_delete(_methods_list, _i);
                            ds_list_delete(_scopes_list, _i);
                            --_i;
                        }
                    }
                    else
                    {
                        //If the scope wasn't a real number then presumably it's a weak reference to a struct
                        if (weak_ref_alive(_scope))
                        {
                            //If this struct exists, execute our method!
                            with(_scope.ref) _methods_list[| _i]();
                        }
                        else
                        {
                            //If this struct has died for some reason then remove it from both the method and scope lists
                            ds_list_delete(_methods_list, _i);
                            ds_list_delete(_scopes_list, _i);
                            --_i;
                        }
                    }
                    
                    ++_i;
                }
                
                IOTA_CYCLE_INDEX++;
            }
        }
        
        IOTA_CURRENT_TIMER++;
    }
    
    //Make sure to reset these macros so they can't be accessed outside of iota methods
    IOTA_CURRENT_TIMER    = undefined;
    IOTA_CYCLES_FOR_TIMER = undefined;
    IOTA_CYCLE_INDEX      = undefined;
}



#region System Definitions

#macro __IOTA_VERSION  "1.0.0"
#macro __IOTA_DATE     "2020-11-21"

show_debug_message("iota: Welcome to iota by @jujuadams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);

global.__iota_methods          = array_create(IOTA_TIMER_COUNT, undefined);
global.__iota_scopes           = array_create(IOTA_TIMER_COUNT, undefined);
global.__iota_accumulator      = array_create(IOTA_TIMER_COUNT, 0);
global.__iota_target_framerate = array_create(IOTA_TIMER_COUNT, game_get_speed(gamespeed_fps));
global.__iota_pause            = array_create(IOTA_TIMER_COUNT, false);

IOTA_CURRENT_TIMER    = undefined;
IOTA_CYCLES_FOR_TIMER = undefined;
IOTA_CYCLE_INDEX      = undefined;

var _timer = 0;
repeat(IOTA_TIMER_COUNT)
{
    global.__iota_methods[@ _timer] = ds_list_create();
    global.__iota_scopes[@  _timer] = ds_list_create();
    ++_timer;
}

#endregion