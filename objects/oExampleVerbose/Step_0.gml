#region Set deltatime and time factor

//Work out the deltatime factor, and then limit it
//GameMaker likes to freak out if running in debug mode and this (mostly) solves the problem
//Production code would probably do something a bit smarter
deltatime_factor = delta_time/16667;
deltatime_factor = min( 3, deltatime_factor );

//The subtract/add keys adjust the time factor between 0x (paused) and 2x (double speed)
if ( keyboard_check_pressed( vk_subtract ) ) time_factor = max( 0, time_factor - 0.1 );
if ( keyboard_check_pressed( vk_add      ) ) time_factor = min( 2, time_factor + 0.1 );

#endregion



#region Input and Iota update

//Clear out the acceleration values from the last frame
//Allowing acceleration values to roll over will break deltatiming
iota_set( "x", 0, IOTA_ACCELERATION );
iota_set( "y", 0, IOTA_ACCELERATION );

//Add horizontal motion if the player presses the left/right arrow keys
iota_add( "x", keyboard_check( vk_right ) - keyboard_check( vk_left ), IOTA_ACCELERATION );

//Add a little bit of gravity
iota_add( "y", 1, IOTA_ACCELERATION );

//If the player presses the spacebar and we're standing on a block...
if ( keyboard_check_pressed( vk_space ) && place_meeting( x, y+1, oBlock ) ) {
    
    //...then work out the acceleration needed to have a y-velocity of exactly 20...
    var _new_acceleration = iota_solve( "y", time_factor*deltatime_factor, IOTA_ACCELERATION, -20, IOTA_VELOCITY );
    
    //...and then set the y-acceleration to be this value
    iota_set( "y", _new_acceleration, IOTA_ACCELERATION );
}

//Update all the variable families!
iota_update( time_factor*deltatime_factor );

#endregion



#region Movement handling
//This movement scheme is the traditional GameMaker method, adjusted to work with Iota

//Work out how far we have to move from out current position to where Iota says we should be
var _dx = iota_get( "x", IOTA_POSITION ) - x;
var _dy = iota_get( "y", IOTA_POSITION ) - y;

if ( !place_meeting( x + _dx, y, oBlock ) ) {
    
    //If there's no collision between our current position and our new position, just move to the new position
    x += _dx;
    
} else {
    
    //If there is, however, a collision between us and where we should be, step pixel by pixel until we reach our collision
    repeat( ceil( abs( _dx ) ) ) {
        
        if ( !place_meeting( x + sign( _dx ), y, oBlock ) ) {
            
            x += sign( _dx );
            
        } else {
            
            //If we find a collision, tell Iota that we have a new position and velocity
            iota_set( "x", x, IOTA_POSITION );
            iota_set( "x", 0, IOTA_VELOCITY );
            break;
            
        }
        
    }
    
}

if ( !place_meeting( x, y + _dy, oBlock ) ) {
    
    //If there's no collision between our current position and our new position, just move to the new position
    y += _dy;
    
} else {
    
    //If there is, however, a collision between us and where we should be, step pixel by pixel until we reach our collision
    repeat( ceil( abs( _dy ) ) ) {
        
        if ( !place_meeting( x, y + sign( _dy ), oBlock ) ) {
            
            y += sign( _dy );
            
        } else {
            
            //If we find a collision, tell Iota that we have a new position and velocity
            iota_set( "y", y, IOTA_POSITION );
            iota_set( "y", 0, IOTA_VELOCITY );
            break;
        }
        
    }

}

#endregion