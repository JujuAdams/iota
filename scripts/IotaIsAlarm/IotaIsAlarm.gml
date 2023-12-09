// Feather disable all

/// Returns <true> if the given value is an iota alarm, as returned by .AddAlarm() or .AddAlarmTicks()
/// 
/// @param value   The value to check

function IotaIsAlarm(_value)
{
    if (!is_struct(_value)) return false;
    return (instanceof(_value) == "__IotaClassAlarm");
}
