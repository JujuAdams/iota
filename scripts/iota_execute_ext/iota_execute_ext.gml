/// @param timerIndex
/// @param method

function iota_execute_ext(_timer, _method)
{
    var _count = global.__iota_tick_count[_timer];
    repeat(_count) _method(_count);
}