#region Deltatime and time factor setup

//Define two variables that'll control the timestep for Iota
time_factor = 1;
deltatime_factor = 1;

#endregion



#region Iota setup

//Set up two variable families that we'll use to hand delta timing

//This variable family will be used for the x-axis velocity, acceleration, and position
//A different mode can be used for simpler motion
iota_setup( "x", E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING );
iota_set(   "x",    x, IOTA_POSITION );
iota_set(   "x", 0.15, IOTA_DAMPING  );

//This variable family will be used for the y-axis velocity, acceleration, and position
iota_setup( "y", E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING );
iota_set(   "y",    y, IOTA_POSITION );
iota_set(   "y", 0.05, IOTA_DAMPING  );

#endregion