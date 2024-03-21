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
            var _func = __func;
            switch(__IotaScopeExists(__scope, __iotaID))
            {
                case 1: //Alive instance
                    with(__scope) _func();
                break;
                
                case 2: //Alive struct
                    with(__scope.ref) _func();
                break;
                
                case -1:
                case -2:
                case -3:
                    __IotaTrace("Warning! Scope for alarm no longer exists, alarm cannot execute (stack = ", debug_get_callstack(), ")");
                break;
                
                case 0:
                    __IotaTrace("Warning! Scope for alarm has been deactivated, alarm cannot execute (stack = ", debug_get_callstack(), ")");
                break;
            }
            
            return true;
        }
        
        return false;
    }
    
    #endregion
}