#macro __IOTA_VERSION  "1.0.0"
#macro __IOTA_DATE     "2020-11-21"

show_debug_message("iota: Welcome to iota by @jujuadams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);

global.__iota_total_ids = 0;

//TODO - Make timers a class goddammit
global.__iota_data_struct      = array_create(IOTA_TIMER_COUNT, undefined);
global.__iota_data_array       = array_create(IOTA_TIMER_COUNT, undefined);
global.__iota_accumulator      = array_create(IOTA_TIMER_COUNT, 0);
global.__iota_target_framerate = array_create(IOTA_TIMER_COUNT, game_get_speed(gamespeed_fps));
global.__iota_pause            = array_create(IOTA_TIMER_COUNT, false);

//Give each timer a struct + array
var _timer = 0;
repeat(IOTA_TIMER_COUNT)
{
    global.__iota_data_struct[@ _timer] = {};
    global.__iota_data_array[@  _timer] = [];
    ++_timer;
}

//Set up macros
#macro IOTA_CURRENT_TIMER     global.__iota_current_timer
#macro IOTA_CYCLES_FOR_TIMER  global.__iota_total_cycles
#macro IOTA_CYCLE_INDEX       global.__iota_cycle_index

IOTA_CURRENT_TIMER    = undefined;
IOTA_CYCLES_FOR_TIMER = undefined;
IOTA_CYCLE_INDEX      = undefined;

//Enum for data packets
enum __IOTA_DATA
{
    IOTA_ID,
    SCOPE,
    BEGIN_METHOD,
    METHOD,
    END_METHOD,
    __SIZE
}



function __iota_add_method_generic(_timer, _scope, _function, _method_type)
{
    var _is_instance = false;
    var _is_struct   = false;
    var _id          = undefined;
    
    var _timer_data_struct = global.__iota_data_struct[_timer];
    var _timer_data_array  = global.__iota_data_array[ _timer];
    
    if (is_real(_scope))
    {
        if (_scope < 100000)
        {
            throw "iota method scope must be an instance or a struct, object indexes are not permitted";
        }
    }
    
    var _iota_id = variable_instance_get(_scope, IOTA_ID_VARIABLE_NAME);
    
    if (_iota_id == undefined)
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
        global.__iota_total_ids++;
        variable_instance_set(_scope, IOTA_ID_VARIABLE_NAME, global.__iota_total_ids);
        
        //Create a new data packet and set it up
        var _data = array_create(__IOTA_DATA.__SIZE, undefined);
        _data[@ __IOTA_DATA.IOTA_ID] = global.__iota_total_ids;
        _data[@ __IOTA_DATA.SCOPE  ] = _is_instance? _id : weak_ref_create(_scope);
        
        //Then slot this data packet into the timer's data struct + array
        _timer_data_struct[$ global.__iota_total_ids] = _data;
        array_push(_timer_data_array, _data);
    }
    else
    {
        //Fetch the data packet from the timer's data struct
        _data = _timer_data_struct[$ _iota_id];
    }
    
    //Set the relevant element in the data packet
    //We strip the scope off the method so we don't accidentally keep structs alive
    _data[@ _method_type] = method(undefined, _function);
}



function __iota_execute_methods_for_timer(_timer_data_array, _timer_data_struct, _method_type)
{
    var _i = 0;
    repeat(array_length(_timer_data_array))
    {
        var _data = _timer_data_array[_i];
        var _scope  = _data[__IOTA_DATA.SCOPE];
        var _method = _data[_method_type];
        
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
                if (_method != undefined)
                {
                    //If this instance exists and isn't deactivated, execute our method!
                    if (!_deactivated) with(_scope) _method();
                }
            }
            else
            {
                //If this instance doesn't exist then remove it from the timer's data array + struct
                array_delete(_timer_data_array, _i, 1);
                variable_struct_remove(_timer_data_struct, _data[__IOTA_DATA.IOTA_ID]);
                --_i;
            }
        }
        else
        {
            //If the scope wasn't a real number then presumably it's a weak reference to a struct
            if (weak_ref_alive(_scope))
            {
                if (_method != undefined)
                {
                    //If this struct exists, execute our method!
                    with(_scope.ref) with(_scope) _method();
                }
            }
            else
            {
                //If this struct has died for some reason then remove it from both the method and scope lists
                array_delete(_timer_data_array, _i, 1);
                variable_struct_remove(_timer_data_struct, _data[__IOTA_DATA.IOTA_ID]);
                --_i;
            }
        }
        
        ++_i;
    }
}