/// @param family
/// @param value
/// @param [order]

var _family = argument[0];
var _value  = argument[1];

var _list = __iota_map[? _family ];

if ( argument_count > 2 ) {
    var _order = argument[2];
} else {
    switch( _list[| __E_IOTA_DATA.MODE ] ) {
        case E_IOTA_FAMILY.VELOCITY:
            var _order = IOTA_VELOCITY;
        break;
        case E_IOTA_FAMILY.VELOCITY_ACCELERATION:
        case E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING:
            var _order = IOTA_ACCELERATION;
        break;
        case E_IOTA_FAMILY.TIMER:
            var _order = IOTA_POSITION;
        break;
        default:
            exit;
        break;
    }
}

_list[| _order + __E_IOTA_DATA.POSITION ] += _value;