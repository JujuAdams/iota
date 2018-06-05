iota_set( "x", keyboard_check( vk_right ) - keyboard_check( vk_left ), IOTA_ACCELERATION );
iota_set( "y", keyboard_check( vk_down  ) - keyboard_check( vk_up   ), IOTA_ACCELERATION );

if ( keyboard_check_pressed( vk_subtract ) ) time_factor = max( 0, time_factor - 0.1 );
if ( keyboard_check_pressed( vk_add      ) ) time_factor = min( 3, time_factor + 0.1 );