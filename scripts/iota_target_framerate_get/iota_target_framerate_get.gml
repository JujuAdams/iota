/// Gets the target framerate for a timer
///
/// @param [timer]

function iota_target_framerate_get()
{
    var _timer = (argument_count > 0)? argument[0] : 0;
    
    return global.__iota_target_framerate[_timer];
}