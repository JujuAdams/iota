// Feather disable all

#macro __IOTA_VERSION  "4.0.1"
#macro __IOTA_DATE     "2024-03-21"

enum __IOTA_CHILD
{
    __IOTA_ID,
    __SCOPE,
    __BEGIN_METHOD,
    __NORMAL_METHOD,
    __END_METHOD,
    __DEAD,
    __VARIABLES_INTERPOLATE,
    __SIZE
}

enum __IOTA_INTERPOLATED_VARIABLE
{
    __IN_NAME,
    __OUT_NAME,
    __PREV_VALUE,
    __IS_ANGLE,
    __SIZE,
}
 
#macro IOTA_CURRENT_CLOCK     __Iota().__currentClockName
#macro IOTA_TICKS_FOR_CLOCK   __Iota().__totalTicks
#macro IOTA_TICK_INDEX        __Iota().__tickIndex
#macro IOTA_SECONDS_PER_TICK  __Iota().__secondsPerTick  

function __Iota()
{
    static _struct = undefined;
    if (_struct != undefined) return _struct;
    
    __IotaTrace("Welcome to iota by Juju Adams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);
    
    _struct = {};
    with(_struct)
    {
        __uniqueID     = 0;
        __currentClock = undefined;
        
        __currentClockName = undefined;
        __totalTicks       = undefined;
        __tickIndex        = undefined;
        __secondsPerTick   = undefined;
    }
    
    return _struct;
}