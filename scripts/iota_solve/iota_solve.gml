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
                _list[| __E_IOTA_DATA.VELOCITY ] = ( _trg_value - _list[| __E_IOTA_DATA.POSITION ] ) / _timestep;
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
                
            } else if ( _trg_order == IOTA_VELOCITY ) {
                _list[| __E_IOTA_DATA.VELOCITY ] = ( _trg_value - _list[| __E_IOTA_DATA.VELOCITY ] ) / _timestep;
            } else {
                //Unsupported
            }
        } else if ( _src_order == IOTA_VELOCITY ) {
            if ( _trg_order == IOTA_POSITION ) {
                
            } else {
                //Unsupported
            }
        } else {
            //Unsupported
        }
    break;
        
    case E_IOTA_FAMILY.VELOCITY_ACCELERATION_DAMPING:
        if ( _src_order == IOTA_ACCELERATION ) {
            if ( _trg_order == IOTA_POSITION ) {
                
            } else if ( _trg_order == IOTA_VELOCITY ) {
                
            } else {
                //Unsupported
            }
        } else if ( _src_order == IOTA_VELOCITY ) {
            if ( _trg_order == IOTA_POSITION ) {
                
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