/// @param family
/// @param timestep
/// @param [order]

var _family   = argument0;
var _timestep = argument1;
var _order    = (argument_count > 2)? argument[2] : IOTA_POSITION;

var _list = __iota_map[? _family ];
switch( _list[| __E_IOTA_DATA.MODE ] ) {
        
    case E_IOTA_FAMILY.VELOCITY:
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep*_list[| __E_IOTA_DATA.VELOCITY ];
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION:
        var _acceleration = _list[| __E_IOTA_DATA.ACCELERATION ];
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep*_list[| __E_IOTA_DATA.VELOCITY ] + 0.5*_timestep*_timestep*_acceleration;
        if ( _order == IOTA_VELOCITY ) return _list[| __E_IOTA_DATA.VELOCITY ] + _timestep*_acceleration;
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING:
        var _velocity     = _list[| __E_IOTA_DATA.VELOCITY     ];
        var _acceleration = _list[| __E_IOTA_DATA.ACCELERATION ];
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep*_velocity + 0.5*_timestep*_timestep*_acceleration;
        if ( _order == IOTA_VELOCITY ) return ( _timestep*_acceleration + _velocity )*power( 1-_list[| __E_IOTA_DATA.DAMPING ], _timestep );
    break;
        
    case E_IOTA_FAMILY.TIMER:
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep;
    break;
    
    default:
        exit;
    break;
        
}

return 0;