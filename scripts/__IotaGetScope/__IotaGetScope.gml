// Feather disable all

function __IotaGetScope(_scope)
{
    var _isInstance = false;
    var _isStruct   = false;
    var _id         = undefined;
    
    //If the scope is a real number then presume it's an instance ID
    if (is_numeric(_scope))
    {
        //We found a valid instance ID so let's set some variables based on that
        //Changing scope here works around some bugs in GameMaker that I don't think exist any more?
        with(_scope)
        {
            _scope = self;
            _isInstance = true;
            _id = id;
            break;
        }
    }
    else
    {
        //Sooooometimes we might get given a struct which is actually an instance
        //Despite being able to read struct variable, it doesn't report as a struct... which is weird
        //Anyway, this check works around that!
        var _id = variable_instance_get(_scope, "id");
        if (is_numeric(_id) && !is_struct(_scope))
        {
            if (instance_exists(_id))
            {
                _isInstance = true;
            }
            else
            {
                //Do a deactivation check here too, why not
                if (IOTA_CHECK_FOR_DEACTIVATION)
                {
                    instance_activate_object(_id);
                    if (instance_exists(_id))
                    {
                        _isInstance = true;
                        instance_deactivate_object(_id);
                    }
                }
            }
        }
        else if (is_struct(_scope))
        {
            _isStruct = true;
        }
    }
    
    if (_isInstance || _isStruct)
    {
        return (_isInstance? _id : weak_ref_create(_scope));
    }
}