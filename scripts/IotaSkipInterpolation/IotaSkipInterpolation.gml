/// @param outName
/// @param [scope]

function IotaSkipInterpolation()
{
    if (global.__iota_current_clock == undefined) __IotaError("Cannot use IotaSkipInterpolation() outside of a clock method");
    
    var _out_name = argument[0];
    var _scope    = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : self;
    
    global.__iota_current_clock.__VariableSkipInterpolation(_out_name, _scope);
}