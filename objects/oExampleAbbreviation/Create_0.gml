//For comments, please see oExampleVerbose

#region Deltatime and time factor setup

time_factor = 1;
deltatime_factor = 1;

#endregion



#region Iota setup

iota_setup_vad( "x", x, 0, 0, 0.15 ); //VAD = Velocity & Acceleration & Damping
iota_setup_vad( "y", y, 0, 0, 0.05 );

#endregion