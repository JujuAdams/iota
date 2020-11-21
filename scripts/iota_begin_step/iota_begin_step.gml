function iota_begin_step()
{
    var _delta = delta_time/1000000;
    
    var _timer = 0;
    repeat(IOTA_TIMER_COUNT)
    {
        var _count = 0;
        
        if (!global.__iota_pause[_timer])
        {
            var _framerate = global.__iota_target_framerate[_timer];
            
            _count = floor(global.__iota_accumulator[_timer] * _framerate);
            global.__iota_accumulator[@ _timer] += _delta - (_count / _framerate);
        }
        
        global.__iota_tick_count[@ _timer] = _count;
        ++_timer;
    }
}



#region System Definitions

#macro __IOTA_VERSION  "1.0.0"
#macro __IOTA_DATE     "2020-11-21"

show_debug_message("Iota: Welcome to Iota by @jujuadams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);

global.__iota_accumulator      = array_create(IOTA_TIMER_COUNT, 0);
global.__iota_tick_count       = array_create(IOTA_TIMER_COUNT, 1);
global.__iota_target_framerate = array_create(IOTA_TIMER_COUNT, game_get_speed(gamespeed_fps));
global.__iota_pause            = array_create(IOTA_TIMER_COUNT, false);

#endregion