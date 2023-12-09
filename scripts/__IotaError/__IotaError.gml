// Feather disable all

function __IotaError()
{
    var _string = "iota " + string(__IOTA_VERSION) + ":\n";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_error(_string + "\n ", true);
}