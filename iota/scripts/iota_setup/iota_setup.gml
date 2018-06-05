/// @param name
/// @param mode

if ( !variable_instance_exists( id, "__iota_map"  ) ) __iota_map  = ds_map_create();
if ( !variable_instance_exists( id, "__iota_list" ) ) __iota_list = ds_list_create();

var _name = argument0;
var _mode = argument1;

var _list = ds_list_create();
_list[| __E_IOTA_DATA.NAME         ] = _name;
_list[| __E_IOTA_DATA.MODE         ] = _mode;
_list[| __E_IOTA_DATA.POSITION     ] = 0;
_list[| __E_IOTA_DATA.VELOCITY     ] = 0;
_list[| __E_IOTA_DATA.ACCELERATION ] = 0;
_list[| __E_IOTA_DATA.DAMPING      ] = 0;

ds_map_add_list( __iota_map, _name, _list );
ds_list_add( __iota_list, _name );