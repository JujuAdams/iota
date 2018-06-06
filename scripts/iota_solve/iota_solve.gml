/// @param family
/// @param timestep
/// @param source_order
/// @param target_value
/// @param target_order

var _family    = argument0;
var _timestep  = argument1;
var _src_order = argument2;
var _trg_value = argument3;
var _trg_order = argument4;

var _list = __iota_map[? _family ];
switch( _list[| __E_IOTA_DATA.MODE ] ) {
        
    case E_IOTA_FAMILY.VELOCITY:
        if ( _src_order == IOTA_VELOCITY ) {
            if ( _trg_order == IOTA_POSITION ) {
                //p = p(0) + vt
                //v = (p - p(0))/t
                return ( _trg_value - _list[| __E_IOTA_DATA.POSITION ] ) / _timestep;
            } else {
                //Unsupported
            }
        } else {
            //Unsupported
        }
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION:
        
        if ( _src_order == IOTA_ACCELERATION ) {
            if ( _trg_order == IOTA_POSITION ) {
                //p = p(0) + vt + at^2/2
                //a = 2( p - p(0) - vt ) / t^2
                return 2*( _trg_value - _list[| __E_IOTA_DATA.POSITION ] - _timestep*_list[| __E_IOTA_DATA.VELOCITY ] ) / _timestep*_timestep;
            } else if ( _trg_order == IOTA_VELOCITY ) {
                //v = v(0) + at
                //a = (v - v(0))/t
                return ( _trg_value - _list[| __E_IOTA_DATA.VELOCITY ] ) / _timestep;
            } else {
                //Unsupported
            }
        } else if ( _src_order == IOTA_VELOCITY ) {
            if ( _trg_order == IOTA_POSITION ) {
                //p = p(0) + vt + at^2/2
                //v = (p - p(0))/t - at/2
                return ( _trg_value - _list[| __E_IOTA_DATA.POSITION ] )/_timestep - 0.5*_list[| __E_IOTA_DATA.ACCELERATION ]*_timestep;
            } else {
                //Unsupported
            }
        } else {
            //Unsupported
        }
        
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING:
        
        var _damping   = 1-_list[| __E_IOTA_DATA.DAMPING ];
        var _damping_k = power( _damping, _timestep );
        
        if ( _src_order == IOTA_ACCELERATION ) {
            if ( _trg_order == IOTA_POSITION ) {
                //p = p(0) + k(vt + at^2/2)
                //a = 2((p - p(0))/k - vt )/t^2
                return 2*( (_trg_value - _list[| __E_IOTA_DATA.POSITION ])/_damping_k - _timestep*_list[| __E_IOTA_DATA.VELOCITY ] ) / _timestep*_timestep;
            } else if ( _trg_order == IOTA_VELOCITY ) {
                //v = k(v(0) + at)
                //a = (v/k - v(0))/t
                return ( _trg_value/_damping_k - _list[| __E_IOTA_DATA.VELOCITY ] ) / _timestep;
            } else {
                //Unsupported
            }
        } else if ( _src_order == IOTA_VELOCITY ) {
            if ( _trg_order == IOTA_POSITION ) {
                //p = p(0) + k(vt + at^2/2)
                //v = (p - p(0))/kt - at/2
                return ( _trg_value - _list[| __E_IOTA_DATA.POSITION ] ) / (_timestep*_damping_k) - 0.5*_list[| __E_IOTA_DATA.ACCELERATION ]*_timestep;
            } else {
                //Unsupported
            }
        } else {
            //Unsupported
        }
        
    break;
    
    case E_IOTA_FAMILY.TIMER:
        //Unsupported
    break;
    
    default:
        //Unsupported
    break;
        
}

return 0;