/// Constructor that instantiates an iota clock
/// 
/// @param [identifier]   Unique name for this clock. IOTA_CURRENT_CLOCK will be set to this value when the clock's .tick() method is called
/// 
/// 
/// 
/// iota clocks have the following public methods:
/// 
///   .tick()
///     Updates the clock and executes methods
///     A clock will execute enough cycles to match the target framerate to the actual framerate
///     This means a clock may execute zero cycles per tick, or sometimes multiple cycles per tick
///   
///   
///   
///   .add_cycle_method(function)
///     Adds a function to be executed for each cycle
///     The scope of the function added is determined by who calls .add_method()
///   
///   .add_begin_method(function)
///     Adds a function to be executed at the start of a tick, before any cycle methods
///     Begin methods will *not* be executed if the clock doesn't need to execute any cycles at all
///     The scope of the function added is determined by who calls .add_begin_method()
///   
///   .add_end_method(function)
///     Adds a function to be executed at the end of a tick, after all cycle methods
///     End methods will *not* be executed if the clock doesn't need to execute any cycles at all
///     The scope of the function added is determined by who calls .add_end_method()
///   
///   
///   
///   .variable_momentary(variableName, resetValue)
///     Adds a variable to be automatically reset at the end of the first cycle (per tick)
///     A momentary variable will only be reset if the clock needs to execute one or more cycles
///     The variable's scope is determined by who calls .variable_momentary()
///   
///   .variable_interpolate(inputVariableName, outputVariableName)
///     Adds a variable to be smoothly interpolated between iota ticks. The interpolated value is passed to the given output variable name
///     Interpolated variables are always updated every time .tick() is called, even if the clock does not need to execute any cycles
///     The variable's scope is determined by who calls .variable_interpolate()
///       N.B. Interpolated variables will always be (at most) a frame behind the actual value of the input variable
///            Most of this time this makes no difference but it's not ideal if you're looking for frame-perfect gameplay
///   
///   
///   
///   .set_pause(state)
///     Sets whether the clock is paused
///     
///   .get_pause(state)
///     Returns whether the clock is paused
///     
///   .set_update_frequency(frequency)
///     Sets the update frequency. This value should generally not change once you've set it
///     This value will default to matching your game's target framerate at the time that the clock was instantiated
///     
///   .get_update_frequency()
///     Returns the update frequency for the clock
///   
///   .set_time_dilation(multiplier)
///     Sets the time dilation multiplier. A value of 1 is no time dilation, 0.5 is half speed, 2.0 is double speed
///     Time dilation values cannot be set lower than 0
///     
///   .get_time_dilation(state)
///     Returns the time dilation multiplier
///     
///   .get_remainder()
///     Returns the remainder on the accumulator



function iota_clock() constructor
{
    var _identifier = (argument_count > 0)? argument[0] : undefined;
    
    __identifier       = _identifier
    __update_frequency = game_get_speed(gamespeed_fps);
    __paused           = false;
    __dilation         = 1.0;
    __accumulator      = 0;
    
    __children_struct       = {};
    __begin_method_array    = [];
    __cycle_method_array    = [];
    __end_method_array      = [];
    __var_momentary_array   = [];
    __var_interpolate_array = [];
    
    #region Tick
    
    static tick = function()
    {
        IOTA_CURRENT_CLOCK = __identifier;
        
        //Get the clamped delta time value for this GameMaker frame
        //We clamp the bottom end to ensure that games still chug along even if the device is really grinding
        var _delta = min(1/IOTA_MINIMUM_FRAMERATE, delta_time/1000000);
        
        //Start off assuming this clock isn't going to want to process any cycles whatsoever
        IOTA_CYCLES_FOR_CLOCK = 0;
        
        //If we're not paused, figure out how many full cycles this clock requires based the accumulator and the clock's framerate
        if (!__paused)
        {
            __accumulator += _delta;
            IOTA_CYCLES_FOR_CLOCK = floor(__dilation * __update_frequency * __accumulator);
            __accumulator -= IOTA_CYCLES_FOR_CLOCK / (__dilation*__update_frequency);
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
                //Capture interpolated variable state before the final cycle
                if (IOTA_CYCLE_INDEX == IOTA_CYCLES_FOR_CLOCK-1) __variables_interpolate_refresh();
                
                __execute_methods(__IOTA_CHILD.CYCLE_METHOD);
                
                //Reset momentary variables after the first cycle
                if (IOTA_CYCLE_INDEX == 0) __variables_momentary_reset();
                
                IOTA_CYCLE_INDEX++;
            }
            
            IOTA_CYCLE_INDEX = IOTA_CYCLES_FOR_CLOCK;
            __execute_methods(__IOTA_CHILD.END_METHOD);
        }
        
        //Update our output interpolated variables
        if (!__paused) __variables_interpolate_update();
    
        //Make sure to reset these macros so they can't be accessed outside of iota methods
        IOTA_CURRENT_CLOCK    = undefined;
        IOTA_CYCLES_FOR_CLOCK = undefined;
        IOTA_CYCLE_INDEX      = undefined;
    }
    
    #endregion
    
    #region Methods Adders
    
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
    
    #endregion
    
    #region Variables
    
    static variable_momentary = function(_name, _reset)
    {
        var _child_data = __get_child_data(other);
        var _array = _child_data[__IOTA_CHILD.VARIABLES_MOMENTARY];
        
        if (_array == undefined)
        {
            _array = [];
            _child_data[@ __IOTA_CHILD.VARIABLES_MOMENTARY] = _array;
            array_push(__var_momentary_array, _child_data);
        }
        
        var _i = 0;
        repeat(array_length(_array) div 2)
        {
            if (_array[_i] == _name)
            {
                //This variable already exists
                return undefined;
            }
            
            _i += 2;
        }
        
        array_push(_array, _name, _reset);
    }
    
    static variable_interpolate = function(_in_name, _out_name)
    {
        var _child_data = __get_child_data(other);
        var _array = _child_data[__IOTA_CHILD.VARIABLES_INTERPOLATE];
        
        if (_array == undefined)
        {
            _array = [];
            _child_data[@ __IOTA_CHILD.VARIABLES_INTERPOLATE] = _array;
            array_push(__var_interpolate_array, _child_data);
        }
        
        var _i = 0;
        repeat(array_length(_array) div 3)
        {
            if (_array[_i] == _in_name)
            {
                //This variable already exists
                return undefined;
            }
            
            _i += 3;
        }
        
        array_push(_array, _in_name, _out_name, variable_instance_get(other, _in_name));
        variable_instance_set(other, _out_name, variable_instance_get(other, _in_name));
    }
    
    #endregion
    
    #region Pause / Target Framerate / Time Dilation
    
    static set_pause = function(_state)
    {
        __paused = _state;
    }
    
    static get_pause = function()
    {
        return __paused;
    }
    
    static set_update_frequency = function(_frequency)
    {
        __update_frequency = _frequency;
    }
    
    static get_update_frequency = function()
    {
        return __update_frequency;
    }
    
    static set_time_dilation = function(_multiplier)
    {
        __dilation = max(0, _multiplier);
    }
    
    static get_time_dilation = function()
    {
        return __dilation;
    }
    
    static get_remainder = function()
    {
        return __dilation*__update_frequency*__accumulator;
    }
    
    #endregion
    
    #region (Private Methods)
    
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
            var _child_data = _array[_i];
            
            //If another process found that this child no longer exists, remove it from this array too
            if (_child_data[__IOTA_CHILD.DEAD])
            {
                array_delete(_array, _i, 1);
                continue;
            }
            
            var _scope = _child_data[__IOTA_CHILD.SCOPE];
            switch(__scope_exists(_scope))
            {
                case 1: //Alive instance
                    with(_scope) _child_data[_method_type]();
                break;
                
                case 2: //Alive struct
                    with(_scope.ref) _child_data[_method_type]();
                break;
                
                case -1: //Dead instance
                case -2: //Dead struct
                    array_delete(_array, _i, 1);
                    __mark_child_as_dead(_child_data);
                    continue;
                break;
                
                case 0: //Deactivated instance
                break;
            }
            
            ++_i;
        }
    }
    
    static __mark_child_as_dead = function(_child_data)
    {
        variable_struct_remove(__children_struct, _child_data[__IOTA_CHILD.IOTA_ID]);
        _child_data[@ __IOTA_CHILD.DEAD] = true;
    }
    
    /// Returns:
    ///    -2 = Dead struct
    ///    -1 = Dead instance
    ///     0 = Deactivated instance
    ///     1 = Alive instance
    ///     2 = Alive struct
    static __scope_exists = function(_scope)
    {
        //If this scope is a real number then it's an instance ID
        if (is_real(_scope))
        {
            if (instance_exists(_scope)) return 1;
            
            //Bonus check for deactivation
            if (IOTA_CHECK_FOR_DEACTIVATION)
            {
                instance_activate_object(_scope);
                if (instance_exists(_scope))
                {
                    instance_deactivate_object(_scope);
                    return 0;
                }
            }
            
            return -1;
        }
        else
        {
            //If the scope wasn't a real number then presumably it's a weak reference to a struct
            if (weak_ref_alive(_scope))
            {
                return 2;
            }
            else
            {
                return -2;
            }
        }
    }
    
    static __add_method_generic = function(_scope, _function, _method_type)
    {
        switch(_method_type)
        {
            case __IOTA_CHILD.BEGIN_METHOD: var _array = __begin_method_array; break;
            case __IOTA_CHILD.CYCLE_METHOD: var _array = __cycle_method_array; break;
            case __IOTA_CHILD.END_METHOD:   var _array = __end_method_array;   break;
        }
        
        var _child_data = __get_child_data(_scope);
        
        //If we haven't seen this method type before for this child, add the child to the relevant array
        if (_child_data[_method_type] == undefined) array_push(_array, _child_data);
        
        //Set the relevant element in the data packet
        //We strip the scope off the method so we don't accidentally keep structs alive
        _child_data[@ _method_type] = method(undefined, _function);
    }
    
    static __get_child_data = function(_scope)
    {
        var _is_instance = false;
        var _is_struct   = false;
        var _id          = undefined;
        
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
            var _child_data = array_create(__IOTA_CHILD.__SIZE, undefined);
            _child_data[@ __IOTA_CHILD.IOTA_ID] = global.__iota_unique_id;
            _child_data[@ __IOTA_CHILD.SCOPE  ] = (_is_instance? _id : weak_ref_create(_scope));
            _child_data[@ __IOTA_CHILD.DEAD   ] = false;
        
            //Then slot this data packet into the clock's data struct + array
            __children_struct[$ global.__iota_unique_id] = _child_data;
        }
        else
        {
            //Fetch the data packet from the clock's data struct
            _child_data = __children_struct[$ _child_id];
        }
        
        return _child_data;
    }
    
    static __variables_momentary_reset = function()
    {
        var _array = __var_momentary_array;
        
        var _i = 0;
        repeat(array_length(_array))
        {
            var _child_data = _array[_i];
            
            //If another process found that this child no longer exists, remove it from this array too
            if (_child_data[__IOTA_CHILD.DEAD])
            {
                array_delete(_array, _i, 1);
                continue;
            }
            
            var _scope = _child_data[__IOTA_CHILD.SCOPE];
            switch(__scope_exists(_scope))
            {
                case 1: //Alive instance
                case 2: //Alive struct
                    var _variables = _child_data[__IOTA_CHILD.VARIABLES_MOMENTARY];
                    var _j = 0;
                    repeat(array_length(_variables) div 2)
                    {
                        variable_instance_set(_scope, _variables[_i], _variables[_i+1]);
                        _j += 2;
                    }
                break;
                
                case -1: //Dead instance
                case -2: //Dead struct
                    array_delete(_array, _i, 1);
                    __mark_child_as_dead(_child_data);
                    continue;
                break;
                
                case 0: //Deactivated instance
                break;
            }
            
            ++_i;
        }
    }
    
    static __variables_interpolate_refresh = function()
    {
        var _array = __var_interpolate_array;
        
        var _i = 0;
        repeat(array_length(_array))
        {
            var _child_data = _array[_i];
            
            //If another process found that this child no longer exists, remove it from this array too
            if (_child_data[__IOTA_CHILD.DEAD])
            {
                array_delete(_array, _i, 1);
                continue;
            }
            
            var _scope = _child_data[__IOTA_CHILD.SCOPE];
            switch(__scope_exists(_scope))
            {
                case 1: //Alive instance
                case 2: //Alive struct
                    var _variables = _child_data[__IOTA_CHILD.VARIABLES_INTERPOLATE];
                    var _j = 0;
                    repeat(array_length(_variables) div 3)
                    {
                        _variables[@ _j+2] = variable_instance_get(_scope, _variables[_j]);
                        _j += 3;
                    }
                break;
                
                case -1: //Dead instance
                case -2: //Dead struct
                    array_delete(_array, _i, 1);
                    __mark_child_as_dead(_child_data);
                    continue;
                break;
                
                case 0: //Deactivated instance
                break;
            }
            
            ++_i;
        }
    }
    
    static __variables_interpolate_update = function()
    {
        var _remainder = get_remainder();
        var _array = __var_interpolate_array;
        
        var _i = 0;
        repeat(array_length(_array))
        {
            var _child_data = _array[_i];
            
            //If another process found that this child no longer exists, remove it from this array too
            if (_child_data[__IOTA_CHILD.DEAD])
            {
                array_delete(_array, _i, 1);
                continue;
            }
            
            var _scope = _child_data[__IOTA_CHILD.SCOPE];
            switch(__scope_exists(_scope))
            {
                case 1: //Alive instance
                case 2: //Alive struct
                    var _variables = _child_data[__IOTA_CHILD.VARIABLES_INTERPOLATE];
                    var _j = 0;
                    repeat(array_length(_variables) div 3)
                    {
                        variable_instance_set(_scope, _variables[_j+1], lerp(_variables[_j+2], variable_instance_get(_scope, _variables[_j]), _remainder));
                        _j += 3;
                    }
                break;
                
                case -1: //Dead instance
                case -2: //Dead struct
                    array_delete(_array, _i, 1);
                    __mark_child_as_dead(_child_data);
                    continue;
                break;
                
                case 0: //Deactivated instance
                break;
            }
            
            ++_i;
        }
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
    VARIABLES_MOMENTARY,
    VARIABLES_INTERPOLATE,
    __SIZE
}

#endregion