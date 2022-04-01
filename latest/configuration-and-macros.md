### `__iota_config()`

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

This script holds a few macros that customise the behaviour of iota. `__iota_config()` never needs to be directly called in code, but the script and the macros it contains must be present in a project for iota to work.

**You should edit this script to customise iota for your own purposes.**

&nbsp;

|Macro                        |Typical value         |Purpose                                                                                                                                                                                                                                                             |
|-----------------------------|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`IOTA_CHECK_FOR_DEACTIVATION`|`true`                |Whether to check if instances have been deactivated when cleaning up clock child data. his incurs a slight performance penalty but should be left set to `true`. If you do need the performance boost, make sure you're not using deactivation or things will break!|
|`IOTA_MINIMUM_FRAMERATE`     |`15`                  |The minimum framerate that iota will run at. This ensures that *some* gameplay happens even if the engine is struggling along                                                                                                                                       |
|`IOTA_ID_VARIABLE_NAME`      |`"__iota_unique_id__"`|Variable to set in structs/instances to record their unique iota ID. This allows iota to disambiguate clock children across multiple method types                                                                                                                   |

&nbsp;

Are three additional macros that are available for use inside iota methods. Outside of iota methods they will return `undefined`.

|Macro                  |Purpose                                                                                                                                  |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
|`IOTA_CURRENT_CLOCK`   |Identifier for the clock that's currently being handled (0-indexed)                                                                      |
|`IOTA_CYCLES_FOR_CLOCK`|Total number of cycles that will be processed this frame for the current clock                                                           |
|`IOTA_CYCLE_INDEX`     |Current cycle for the current clock (0-indexed). This will be `-1` for begin methods and equal to `IOTA_CYCLES_FOR_CLOCK` for end methods|