/// @param timerIndex
/// @param selfScope
/// @param method

function iota_add_method_ext(_timer, _scope, _method)
{
    var _is_instance = false;
    var _is_struct   = false;
    var _id          = undefined;
    
    if (is_real(_scope))
    {
        if (_scope < 100000)
        {
            throw "iota method scope must be an instance or a struct, object indexes are not permitted";
        }
        else
        {
            with(_scope)
            {
                _scope = self;
                _is_instance = true;
                _id = id;
                break;
            }
        }
    }
    else
    {
        var _id = variable_instance_get(_scope, "id");
        if (is_real(_id) && !is_struct(_scope))
        {
            if (instance_exists(_id))
            {
                _is_instance = true;
            }
            else
            {
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
        else
        {
            _is_struct = true;
        }
    }
    
    if (!_is_instance && !_is_struct)
    {
        return undefined;
    }
    
    //Strip the scope off the method so we don't accidentally keep structs alive
    ds_list_add(global.__iota_methods[_timer], method(undefined, _method));
    
    //Add our scope as an instance ID if we're an instance, other add a weak reference pointing to the scoped struct
    ds_list_add(global.__iota_scopes[_timer], _is_instance? _id : weak_ref_create(_scope));
}