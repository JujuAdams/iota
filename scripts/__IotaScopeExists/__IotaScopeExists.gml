// Feather disable all

/// Returns:
///    -3 = Instance has different child ID
///    -2 = Dead struct
///    -1 = Dead instance
///     0 = Deactivated instance
///     1 = Alive instance
///     2 = Alive struct

function __IotaScopeExists(_scope, _expectedChildID) //Does do deactivation check
{
    if (is_numeric(_scope))
    {
        //If this scope is a real number then it's an instance ID
        if (instance_exists(_scope))
		{
            if ((_expectedChildID != undefined) && (variable_instance_get(_scope, IOTA_ID_VARIABLE_NAME) != _expectedChildID))
            {
                return -3;
            }
            else
            {
                return 1;
            }
		}
            
        if (IOTA_CHECK_FOR_DEACTIVATION)
        {
            //Bonus check for deactivation
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
        if (weak_ref_alive(_scope)) return 2;
        return -2;
    }
}