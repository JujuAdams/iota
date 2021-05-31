/// Constructor that instantiates an iota clock
/// 
/// @param [identifier]   Unique name for this clock. IOTA_CURRENT_CLOCK will be set to this value when the clock's .tick() method is called
/// 
/// iota clocks have the following public methods:
/// 
///   .tick()
///     Updates the clock and executes methods
///     A clock will execute enough cycles to match the target framerate to the actual framerate
///     This might mean a clock will execute zero cycles, sometimes multiple cycles
///     
///   .add_cycle_method(function)
///     Adds a function to be executed for each cycle
///     The scope of the function added is determined by who calls .add_method()
///     
///   .add_begin_method(function)
///     Adds a function to be executed at the start of a tick
///     Begin methods will *not* be executed if the clock doesn't need to execute cycles at all
///     The scope of the function added is determined by who calls .add_begin_method()
///     
///   .add_end_method(function)
///     Adds a function to be executed at the end of a tick
///     End methods will *not* be executed if the clock doesn't need to execute cycles at all
///     The scope of the function added is determined by who calls .add_end_method()
///     
///   .set_pause(state)
///     Sets whether the clock is paused
///     
///   .get_pause(state)
///     Returns whether the clock is paused
///     
///   .set_target_framerate(fps)
///     Sets the target framerate. If not set, this value will default to your game's target framerate
///     This generally should not change, but you can sort of hack in time dilation effects by manipulating this value
///     
///   .get_target_framerate()
///     Returns the target framerate
///     
///   .get_remainder()
///     Returns the remainder on the accumulator

function iota_clock() constructor
{
    var _identifier = (argument_count > 0)? argument[0] : undefined;
    
    __identifier       = _identifier
    __target_framerate = game_get_speed(gamespeed_fps);
    __paused           = false;
    __accumulator      = 0;
    
    __children_struct    = {};
    __begin_method_array = [];
    __cycle_method_array = [];
    __end_method_array   = [];
    
    #region Tick
    
    static tick = function()
    {
        IOTA_CURRENT_CLOCK = __identifier;
        
        //Get the clamped delta time value for this GameMaker frame
        //We clamp the bottom end to ensure that games still chug along even if the device is really grinding
        var _delta = min(1/IOTA_MINIMUM_FRAMERATE, delta_time/1000000);
        
        //Start off assuming this clock isn't going to want to process any cycles whatsoever
        IOTA_CYCLES_FOR_CLOCK = 0;
        
        if (!__paused)
        {
            ////Figure out how many full cycles this clock requires based the accumulator and the clock's framerate
            //IOTA_CYCLES_FOR_CLOCK = floor(__target_framerate*__accumulator);
            //
            ////Any leftover time that can't fit into a full cycle add back onto the accumulator
            //__accumulator += _delta - (IOTA_CYCLES_FOR_CLOCK / __target_framerate);
            
            __accumulator += _delta;
            IOTA_CYCLES_FOR_CLOCK = floor(__target_framerate*__accumulator);
            __accumulator -= IOTA_CYCLES_FOR_CLOCK/__target_framerate;
        }
        
        if (IOTA_CYCLES_FOR_CLOCK > 0)
        {
            IOTA_CYCLE_INDEX = -1;
            __execute_methods(__IOTA_CHILD.BEGIN_METHOD);
            
            //Execute cycles one at a time
            //Note that we're processing all methods for a cycle, then move onto the next cycle
            //This ensures instances doesn't get out of step with each other
            IOTA_CYCLE_INDEX = 0;
            repeat(IOTA_CYCLES_FOR_CLOCK)
            {
                __execute_methods(__IOTA_CHILD.CYCLE_METHOD);
                IOTA_CYCLE_INDEX++;
            }
            
            IOTA_CYCLE_INDEX = IOTA_CYCLES_FOR_CLOCK;
            __execute_methods(__IOTA_CHILD.END_METHOD);
        }
    
        //Make sure to reset these macros so they can't be accessed outside of iota methods
        IOTA_CURRENT_CLOCK    = undefined;
        IOTA_CYCLES_FOR_CLOCK = undefined;
        IOTA_CYCLE_INDEX      = undefined;
    }
    
    function __execute_methods(_method_type)
    {
        switch(_method_type)
        {
            case __IOTA_CHILD.BEGIN_METHOD: var _array = __begin_method_array; break;
            case __IOTA_CHILD.CYCLE_METHOD: var _array = __cycle_method_array; break;
            case __IOTA_CHILD.END_METHOD:   var _array = __end_method_array;   break;
        }
        
        var _i = 0;
        repeat(array_length(_array))
        {
            var _child = _array[_i];
            
            //If another process found that this child no longer exists, remove it from this array too
            if (_child[__IOTA_CHILD.DEAD])
            {
                array_delete(_array, _i, 1);
                continue;
            }
            
            var _scope = _child[__IOTA_CHILD.SCOPE];
            
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
                    if (!_deactivated) with(_scope) _child[_method_type]();
                }
                else
                {
                    //If this instance doesn't exist then remove it from the clock's data array + struct
                    array_delete(_array, _i, 1);
                    variable_struct_remove(__children_struct, _child[__IOTA_CHILD.IOTA_ID]);
                    _child[@ __IOTA_CHILD.DEAD] = true;
                    continue;
                }
            }
            else
            {
                //If the scope wasn't a real number then presumably it's a weak reference to a struct
                if (weak_ref_alive(_scope))
                {
                    //If this struct exists, execute our method!
                    with(_scope.ref) _child[_method_type]();
                }
                else
                {
                    //If this struct has been garbage collected then remove it from both the method and scope lists
                    array_delete(_array, _i, 1);
                    variable_struct_remove(__children_struct, _child[__IOTA_CHILD.IOTA_ID]);
                    _child[@ __IOTA_CHILD.DEAD] = true;
                    continue;
                }
            }
        
            ++_i;
        }
    }
    
    #endregion
    
    #region Methods
    
    static add_begin_method = function(_function)
    {
        return __add_method_generic(other, _function, __IOTA_CHILD.BEGIN_METHOD);
    }
    
    static add_cycle_method = function(_function)
    {
        return __add_method_generic(other, _function, __IOTA_CHILD.CYCLE_METHOD);
    }
    
    static add_end_method = function(_function)
    {
        return __add_method_generic(other, _function, __IOTA_CHILD.END_METHOD);
    }
    
    static __add_method_generic = function(_scope, _function, _method_type)
    {
        var _is_instance = false;
        var _is_struct   = false;
        var _id          = undefined;
        
        switch(_method_type)
        {
            case __IOTA_CHILD.BEGIN_METHOD: var _array = __begin_method_array; break;
            case __IOTA_CHILD.CYCLE_METHOD: var _array = __cycle_method_array; break;
            case __IOTA_CHILD.END_METHOD:   var _array = __end_method_array;   break;
        }
        
        if (is_real(_scope))
        {
            if (_scope < 100000)
            {
                show_error("iota method scope must be an instance or a struct, object indexes are not permitted", true);
            }
        }
    
        var _child_id = variable_instance_get(_scope, IOTA_ID_VARIABLE_NAME);
        if (_child_id == undefined)
        {
            //If the scope is a real number then presume it's an instance ID
            if (is_real(_scope))
            {
                //We found a valid instance ID so let's set some variables based on that
                //Changing scope here works around some bugs in GameMaker that I don't think exist any more?
                with(_scope)
                {
                    _scope = self;
                    _is_instance = true;
                    _id = id;
                    break;
                }
            }
            else
            {
                //Sooooometimes we might get given a struct which is actually an instance
                //Despite being able to read struct variable, it doesn't report as a struct... which is weird
                //Anyway, this check works around that!
                var _id = variable_instance_get(_scope, "id");
                if (is_real(_id) && !is_struct(_scope))
                {
                    if (instance_exists(_id))
                    {
                        _is_instance = true;
                    }
                    else
                    {
                        //Do a deactivation check here too, why not
                        if (IOTA_CHECK_FOR_DEACTIVATION)
                        {
                            instance_activate_object(_id);
                            if (instance_exists(_id))
                            {
                                _is_instance = true;
                                instance_deactivate_object(_id);
                            }
                        }
                    }
                }
                else if (is_struct(_scope))
                {
                    _is_struct = true;
                }
            }
        
            if (!_is_instance && !_is_struct)
            {
                return undefined;
            }
        
            //Give this scope a unique iota ID
            //This'll save us some pain later if we need to add a different sort of method
            global.__iota_unique_id++;
            variable_instance_set(_scope, IOTA_ID_VARIABLE_NAME, global.__iota_unique_id);
        
            //Create a new data packet and set it up
            var _child = array_create(__IOTA_CHILD.__SIZE, undefined);
            _child[@ __IOTA_CHILD.IOTA_ID] = global.__iota_unique_id;
            _child[@ __IOTA_CHILD.SCOPE  ] = (_is_instance? _id : weak_ref_create(_scope));
            _child[@ __IOTA_CHILD.DEAD   ] = false;
        
            //Then slot this data packet into the clock's data struct + array
            __children_struct[$ global.__iota_unique_id] = _child;
        }
        else
        {
            //Fetch the data packet from the clock's data struct
            _child = __children_struct[$ _child_id];
        }
        
        //If we haven't seen this method type before for this child, add the child to the relevant array
        if (_child[_method_type] == undefined) array_push(_array, _child);
        
        //Set the relevant element in the data packet
        //We strip the scope off the method so we don't accidentally keep structs alive
        _child[@ _method_type] = method(undefined, _function);
    }
    
    #endregion
    
    #region Pause / Target Framerate
    
    static set_pause = function(_state)
    {
        __paused = _state;
    }
    
    static get_pause = function()
    {
        return __paused;
    }
    
    static set_target_framerate = function(_framerate)
    {
        __target_framerate = _framerate;
    }
    
    static get_target_framerate = function()
    {
        return __target_framerate;
    }
    
    static get_remainder = function()
    {
        return __target_framerate*__accumulator;
    }
    
    #endregion
}





#region (System)

#macro __IOTA_VERSION  "2.0.2"
#macro __IOTA_DATE     "2021-05-31"

show_debug_message("iota: Welcome to iota by @jujuadams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);

global.__iota_unique_id = 0;

#macro IOTA_CURRENT_CLOCK     global.__iota_current_clock
#macro IOTA_CYCLES_FOR_CLOCK  global.__iota_total_cycles
#macro IOTA_CYCLE_INDEX       global.__iota_cycle_index

IOTA_CURRENT_CLOCK    = undefined;
IOTA_CYCLES_FOR_CLOCK = undefined;
IOTA_CYCLE_INDEX      = undefined;

enum __IOTA_CHILD
{
    IOTA_ID,
    SCOPE,
    BEGIN_METHOD,
    CYCLE_METHOD,
    END_METHOD,
    DEAD,
    __SIZE
}

#endregion