// Feather disable all

#macro __IOTA_VERSION  "3.1.0"
#macro __IOTA_DATE     "2023-12-06"

__IotaTrace("Welcome to iota by Juju Adams! This is version " + __IOTA_VERSION + ", " + __IOTA_DATE);

global.__iotaUniqueID     = 0;
global.__iotaCurrentClock = undefined;

#macro IOTA_CURRENT_CLOCK     global.__iotaCurrentIdentifier
#macro IOTA_TICKS_FOR_CLOCK   global.__iotaTotalTicks
#macro IOTA_TICK_INDEX        global.__iotaTickIndex
#macro IOTA_SECONDS_PER_TICK  global.__iotaSecondsPerTick  

IOTA_CURRENT_CLOCK    = undefined;
IOTA_TICKS_FOR_CLOCK  = undefined;
IOTA_TICK_INDEX       = undefined;
IOTA_SECONDS_PER_TICK = undefined;

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