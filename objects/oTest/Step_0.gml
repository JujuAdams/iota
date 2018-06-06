//deltatime_factor = delta_time/16667;

if ( keyboard_check_pressed( vk_subtract ) ) time_factor = max( 0, time_factor - 0.1 );
if ( keyboard_check_pressed( vk_add      ) ) time_factor = min( 3, time_factor + 0.1 );

iota_set( "x", 0, IOTA_ACCELERATION );
iota_set( "y", 0, IOTA_ACCELERATION );

iota_add( "x", 1.2*( keyboard_check( vk_right ) - keyboard_check( vk_left ) ), IOTA_ACCELERATION );
iota_add( "y", 1, IOTA_ACCELERATION );

if ( keyboard_check_pressed( vk_space ) && place_meeting( x, y+1, oBlock ) ) {
    var _new_acceleration = iota_solve( "y", time_factor*deltatime_factor, IOTA_ACCELERATION, -20, IOTA_VELOCITY );
    iota_set( "y", _new_acceleration, IOTA_ACCELERATION );
}

iota_update( time_factor*deltatime_factor );

var _dx = iota_get( "x", IOTA_POSITION ) - x;
var _dy = iota_get( "y", IOTA_POSITION ) - y;

repeat( ceil( abs( _dx ) ) ) {
    if ( !place_meeting( x + sign( _dx ), y, oBlock ) ) {
        x += sign( _dx );
    } else {
        iota_set( "x", x, IOTA_POSITION );
        iota_set( "x", 0, IOTA_VELOCITY );
        break;
    }
}

repeat( ceil( abs( _dy ) ) ) {
    if ( !place_meeting( x, y + sign( _dy ), oBlock ) ) {
        y += sign( _dy );
    } else {
        iota_set( "y", y, IOTA_POSITION );
        iota_set( "y", 0, IOTA_VELOCITY );
        break;
    }
}