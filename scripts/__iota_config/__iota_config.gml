/// iota can run multiple timers to track different parts of your game
/// This is useful when you want to pause certain system, such as pausing gameplay whilst a menu is open

#macro IOTA_TIMER_COUNT  3                //How many timers iota should track. Timers are processed in ascending order
#macro IOTA_CHECK_FOR_DEACTIVATION  true  //Whether to check if instances have been deactivated. This incurs a slight performance penalty
#macro IOTA_MINIMUM_FRAMERATE   15        //The minimum framerate that iota will run at