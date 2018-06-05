deltatime_factor = delta_time/16667;
iota_update( time_factor*deltatime_factor );
x = iota_get( "x", IOTA_POSITION );
y = iota_get( "y", IOTA_POSITION );