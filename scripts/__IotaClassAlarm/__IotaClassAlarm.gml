// Feather disable all

function __IotaClassAlarm(_clock, _ticks, _method) constructor
{
    __clock     = undefined;
    __total     = undefined;
    __remaining = undefined;
    __func      = undefined;
    __scope     = undefined;
	__iotaID    = undefined;
    
    var _scope = __IotaGetScope(method_get_self(_method));
    if (_scope != undefined)
    {
        __clock     = _clock;
        __total     = _ticks;
        __remaining = _ticks;
        __func      = method(undefined, _method);
        __scope     = _scope;
		__iotaID    = __IotaEnsureChildID(_scope);
        
        array_push(__clock.__alarmArray, self);
    }
    else
    {
        __IotaTrace("Warning! Scope was <undefined>, alarm will never execute (stack = ", debug_get_callstack(), ")");
    }
    
    
    
    static Cancel = function()
    {
        __clock = undefined;
    }
    
    
    
    #region (Private Methods)
    
    static __Tick = function()
    {
        if (__clock == undefined) return true;
        
        __remaining--;
        if (__remaining <= 0)
        {
            if (__IotaScopeExists(__scope, __iotaID))
            {
                var _func = __func;
                with(__scope) _func();
            }
            else
            {
                __IotaTrace("Warning! Scope was for alarm no longer exists, alarm will never execute (stack = ", debug_get_callstack(), ")");
            }
            
            return true;
        }
        
        return false;
    }
    
    #endregion
}