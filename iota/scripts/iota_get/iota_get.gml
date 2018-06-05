/// @param family
/// @param [order]

var _family = argument[0];
var _order = ( argument_count > 1 )? argument[1] : IOTA_POSITION;

var _list = __iota_map[? _family ];

return _list[| _order + __E_IOTA_DATA.POSITION ];