# `IotaSkipInterpolation(_outName, [scope])`

_Returns:_ N/A (`undefined`)

|Name     |Datatype       |Purpose           |
|---------|---------------|------------------|
|`outName`|string         |The value to check|
|`[scope]`|instance/struct|Scope to target when managing the variable. If no scope is specified, the instance/struct that called this function will be chosen as the scope|

Disables interpolation for a given variable in a clock method for a single clock tick. This function can only be called in a clock method (either begin, normal, or end method). The scope is determined by who calls `IotaSkipInterpolation()`. Occasionally you may need to force the scope, and this can be done by setting the scope argument when calling this function.