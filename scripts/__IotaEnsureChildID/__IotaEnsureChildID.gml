// Feather disable all

function __IotaEnsureChildID(_scope)
{
    static _iota = __Iota();
    
    var _child_id = variable_instance_get(_scope, IOTA_ID_VARIABLE_NAME);
    if (_child_id == undefined)
    {
        _iota.__uniqueID++;
        
        _child_id = _iota.__uniqueID;
        variable_instance_set(_scope, IOTA_ID_VARIABLE_NAME, _child_id);
    }
    
    return _child_id;
}
