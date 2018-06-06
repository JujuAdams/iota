/// @param family
/// @param timestep
/// @param [order]

var _family   = argument[0];
var _timestep = argument[1];
var _order    = (argument_count > 2)? argument[2] : IOTA_POSITION;

var _list = __iota_map[? _family ];
switch( _list[| __E_IOTA_DATA.MODE ] ) {
        
    case E_IOTA_FAMILY.VELOCITY:
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep*_list[| __E_IOTA_DATA.VELOCITY ];
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION:
        var _velocity     = _list[| __E_IOTA_DATA.VELOCITY     ];
        var _acceleration = _list[| __E_IOTA_DATA.ACCELERATION ];
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep*_velocity + 0.5*_timestep*_timestep*_acceleration;
        if ( _order == IOTA_VELOCITY ) return _velocity + _timestep*_acceleration;
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING:
    
        var _velocity     =   _list[| __E_IOTA_DATA.VELOCITY     ];
        var _acceleration =   _list[| __E_IOTA_DATA.ACCELERATION ];
        var _damping      = 1-_list[| __E_IOTA_DATA.DAMPING      ];
        var _damping_k    = power( _damping, _timestep );
        
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + ( _timestep*_velocity + 0.5*_timestep*_timestep*_acceleration )*_damping_k;
        if ( _order == IOTA_VELOCITY ) return ( _velocity + _timestep*_acceleration )*_damping_k;
        
    break;
        
    case E_IOTA_FAMILY.TIMER:
        if ( _order == IOTA_POSITION ) return _list[| __E_IOTA_DATA.POSITION ] + _timestep;
    break;
    
    default:
        exit;
    break;
        
}

return 0;