/// @param timestep

var _timestep = argument0;

var _size = ds_list_size( __iota_list );
for( var _family = 0; _family < _size; _family++ ) {
    
    var _name = __iota_list[| _family ];
    var _list = __iota_map[? _name ];
    
    switch( _list[| __E_IOTA_DATA.MODE ] ) {
        
        case E_IOTA_FAMILY.VELOCITY:
            _list[| __E_IOTA_DATA.POSITION ] += _timestep*_list[| __E_IOTA_DATA.VELOCITY ];
        break;
        
        case E_IOTA_FAMILY.VELOCITY_ACCELERATION:
            var _acceleration = _list[| __E_IOTA_DATA.ACCELERATION ];
            _list[| __E_IOTA_DATA.POSITION ] += _timestep*_list[| __E_IOTA_DATA.VELOCITY ] + 0.5*_timestep*_timestep*_acceleration;
            _list[| __E_IOTA_DATA.VELOCITY ] += _timestep*_acceleration;
        break;
        
        case E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING:
            var _velocity     =   _list[| __E_IOTA_DATA.VELOCITY     ];
            var _acceleration =   _list[| __E_IOTA_DATA.ACCELERATION ];
            var _damping      = 1-_list[| __E_IOTA_DATA.DAMPING      ];
            
            _list[| __E_IOTA_DATA.POSITION ] += _timestep*_velocity + 0.5*_timestep*_timestep*_acceleration;
            _list[| __E_IOTA_DATA.VELOCITY ]  = ( _velocity + _timestep*_acceleration )*power( _damping, _timestep );
            
        break;
        
        case E_IOTA_FAMILY.TIMER:
            _list[| __E_IOTA_DATA.POSITION ] += _timestep;
        break;
        
    }
    
}