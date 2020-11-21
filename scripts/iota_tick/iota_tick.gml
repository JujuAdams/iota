function iota_tick()
{
    var _delta = min(1/IOTA_MINIMUM_FRAMERATE, delta_time/1000000);
    
    var _timer = 0;
    repeat(IOTA_TIMER_COUNT)
    {
        var _count = 0;
        
        if (!global.__iota_pause[_timer])
        {
            var _framerate = global.__iota_target_framerate[_timer];
            
            _count = floor(_framerate*global.__iota_accumulator[_timer]);
            global.__iota_accumulator[@ _timer] += _delta - (_count / _framerate);
        }
        
        global.__iota_tick_count[@ _timer] = _count;
        
        if (_count > 0)
        {
            var _methods_list = global.__iota_methods[_timer];
            var _scopes_list = global.__iota_scopes[_timer];
            repeat(_count)
            {
                var _i = 0;
                repeat(ds_list_size(_methods_list))
                {
                    var _scope = _scopes_list[| _i];
                    if (is_real(_scope))
                    {
                        var _exists = instance_exists(_scope);
                        var _deactivated = false;
                    
                        if (IOTA_CHECK_FOR_DEACTIVATION)
                        {
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
                            if (!_deactivated) with(_scope) _methods_list[| _i]();
                        }
                        else
                        {
                            ds_list_delete(_methods_list, _i);
                            ds_list_delete(_scopes_list, _i);
                            --_i;
                        }
                    }
                    else
                    {
                        if (weak_ref_alive(_scope))
                        {
                            with(_scope.ref) _methods_list[| _i]();
                        }
                        else
                        {
                            ds_list_delete(_methods_list, _i);
                            ds_list_delete(_scopes_list, _i);
                            --_i;
                        }
                    }
                    
                    ++_i;
                }
            }
        }
        
        ++_timer;
    }
}



#region System Definitions

#macro __IOTA_VERSION  "1.0.0"
#macro __IOTA_DATE     "2020-11-21"

show_debug_message("Iota: Welcome to Iota by @jujuadams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);

global.__iota_methods          = array_create(IOTA_TIMER_COUNT, undefined);
global.__iota_scopes           = array_create(IOTA_TIMER_COUNT, undefined);
global.__iota_accumulator      = array_create(IOTA_TIMER_COUNT, 0);
global.__iota_tick_count       = array_create(IOTA_TIMER_COUNT, 1);
global.__iota_target_framerate = array_create(IOTA_TIMER_COUNT, game_get_speed(gamespeed_fps));
global.__iota_pause            = array_create(IOTA_TIMER_COUNT, false);

var _timer = 0;
repeat(IOTA_TIMER_COUNT)
{
    global.__iota_methods[@ _timer] = ds_list_create();
    global.__iota_scopes[@  _timer] = ds_list_create();
    ++_timer;
}

#endregion