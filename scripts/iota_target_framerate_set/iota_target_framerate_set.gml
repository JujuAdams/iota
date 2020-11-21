/// @param framerate
/// @param [timerIndex]

function iota_target_framerate_set()
{
    var _framerate = argument[0];
    var _timer     = (argument_count > 1)? argument[1] : 0;
    
    global.__iota_target_framerate[@ _timer] = _framerate;
}