/// @param [timerIndex]

function iota_pause_get()
{
    var _timer = (argument_count > 0)? argument[0] : 0;
    
    return global.__iota_pause[@ _timer];
}