// Feather disable all

function __IotaEnsureChildID(_scope)
{
    var _child_id = variable_instance_get(_scope, IOTA_ID_VARIABLE_NAME);
    if (_child_id == undefined)
    {
        global.__iotaUniqueID++;
        
        _child_id = global.__iotaUniqueID;
        variable_instance_set(_scope, IOTA_ID_VARIABLE_NAME, _child_id);
    }
    
    return _child_id;
}
