# `IotaGetInput(inputName)`

_Returns:_ Any, the value set for the defined input

|Name       |Datatype|Purpose                               |
|-----------|--------|--------------------------------------|
|`inputName`|string  |Name of the input to get the value for|

Returns the value for a named user input to the clock. This user input should be defined first by calling the `.DefineInput()` or `.DefineInputMomentary()` method on the clock. This function can only be called in a clock method (either begin, normal, or end method).