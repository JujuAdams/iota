time_factor = 1;
deltatime_factor = 1;
game_set_speed( 9999, gamespeed_fps );

iota_setup( "x", E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING );
iota_set(   "x",    x, IOTA_POSITION );
iota_set(   "x", 0.05, IOTA_DAMPING  );

iota_setup( "y", E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING );
iota_set(   "y",    y, IOTA_POSITION );
iota_set(   "y", 0.05, IOTA_DAMPING  );