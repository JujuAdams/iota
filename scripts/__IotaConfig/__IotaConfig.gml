// Feather disable all

//Whether to check if instances have been deactivated when cleaning up clock child data
//This incurs a slight performance penalty but should be left set to <true>
//If you do need the performance boost, make sure you're not using deactivation or things will break!
#macro  IOTA_CHECK_FOR_DEACTIVATION  true

//The minimum framerate that iota will run at
//This ensures that *some* gameplay happens even if the engine is struggling along
#macro  IOTA_MINIMUM_FRAMERATE  15

//Variable to set in structs/instances to record their unique iota ID
//This allows iota to disambiguate clock children across multiple method types
#macro  IOTA_ID_VARIABLE_NAME  "__iotaUniqueID__"

//These four macros are also available for use inside iota methods
//Outside of iota methods they will return <undefined>
//    IOTA_CURRENT_CLOCK    = Identifier for the clock that's currently being handled
//    IOTA_TICKS_FOR_CLOCK  = Total number of ticks that will be processed this update for the current clock
//    IOTA_TICK_INDEX       = Current tick for the current clock (0-indexed)
//    IOTA_SECONDS_PER_TICK = How long each tick is, in seconds
