// Feather disable all

/// Returns the value for a named user input to the clock. This user input should be defined first
/// by calling the .DefineInput() or .DefineInputMomentary() method on the clock.
/// 
/// This function can only be called in a clock method (either begin, normal, or end method).
/// 
/// @param inputName  Name of the input to get the value for

function IotaGetInput(_inputName)
{
    if (global.__iotaCurrentClock == undefined) __IotaError("Cannot use IotaGetInput() outside of a clock method");
    
    return global.__iotaCurrentClock.__GetInput(_inputName);
}
