//For comments, please see oExampleVerbose

#region Set deltatime and time factor

deltatime_factor = delta_time/16667;
deltatime_factor = min( 3, deltatime_factor );

if ( keyboard_check_pressed( vk_subtract ) ) time_factor = max( 0, time_factor - 0.1 );
if ( keyboard_check_pressed( vk_add      ) ) time_factor = min( 2, time_factor + 0.1 );

#endregion



#region Input and Iota update

iota_set_acl( "x", keyboard_check( vk_right ) - keyboard_check( vk_left ) );
iota_set_acl( "y", 1 );

if ( keyboard_check_pressed( vk_space ) && place_meeting( x, y+1, oBlock ) ) {
    iota_set_acl( "y", iota_solve( "y", time_factor*deltatime_factor, IOTA_ACL, -20, IOTA_VEL ) );
}

iota_update( time_factor*deltatime_factor );

#endregion



#region Movement handling

var _dx = iota_get_pos( "x" ) - x;
var _dy = iota_get_pos( "y" ) - y;

if ( !place_meeting( x + _dx, y, oBlock ) ) {
    
    x += _dx;
    
} else {
    
    repeat( ceil( abs( _dx ) ) ) {
        if ( !place_meeting( x + sign( _dx ), y, oBlock ) ) {
            x += sign( _dx );
        } else {
            iota_set_pos( "x", x );
            iota_set_vel( "x", 0 );
            break;
        }
    }
    
}

if ( !place_meeting( x, y + _dy, oBlock ) ) {
    
    y += _dy;
    
} else {
    
    repeat( ceil( abs( _dy ) ) ) {
        if ( !place_meeting( x, y + sign( _dy ), oBlock ) ) {
            y += sign( _dy );
        } else {
            iota_set_pos( "y", y );
            iota_set_vel( "y", 0 );
            break;
        }
    }

}

#endregion