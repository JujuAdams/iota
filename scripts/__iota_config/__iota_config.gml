/// iota can run multiple timers to track different parts of your game
/// This is useful when you want to pause certain system, such as pausing gameplay whilst a menu is open

#macro IOTA_TIMER_COUNT  3                //How many timers iota should track. Timers are processed in ascending order
#macro IOTA_CHECK_FOR_DEACTIVATION  true  //Whether to check if instances have been deactivated. This incurs a slight performance penalty
#macro IOTA_MINIMUM_FRAMERATE   15        //The minimum framerate that iota will run at

//These three macros are also available for use inside iota methods
//Outside of iota methods they will return <undefined>
//    IOTA_CURRENT_TIMER    = Index of the timer that's currently being handled (0-indexed)
//    IOTA_CYCLES_FOR_TIMER = Total number of cycles that will be processed this frame for the current timer
//    IOTA_CYCLE_INDEX      = Current cycle for the current timer (0-indexed)