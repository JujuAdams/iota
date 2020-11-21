/// @param state
/// @param [timerIndex]

function iota_pause_set()
{
    var _state = argument[0];
    var _timer = (argument_count > 1)? argument[1] : 0;
    
    global.__iota_pause[@ _timer] = _state;
}