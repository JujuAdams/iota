# Configuration & Macros

`__IotaConfig()` holds a few macros that customise the behaviour of iota. This script never needs to be directly called in code, but the script and the macros it contains must be present in a project for iota to work.

?> You should edit `__IotaConfig()` to customise iota for your own purposes.

&nbsp;

### `IOTA_CHECK_FOR_DEACTIVATION`

*Typical value:* `true`

Whether to check if instances have been deactivated when cleaning up clock child data. This incurs a slight performance penalty but should be left set to `true`. If you do need the performance boost, make sure you're not using deactivation or things will break!

&nbsp;

### `IOTA_MINIMUM_FRAMERATE`

*Typical value:* `15`

The minimum framerate that iota will run at. This ensures that *some* gameplay happens even if the engine is struggling along.

&nbsp;

### `IOTA_ID_VARIABLE_NAME`

*Typical value:* `"__IotaUniqueID__"`

Variable to set in structs/instances to record their unique iota ID. This allows iota to disambiguate clock children across multiple method types.

&nbsp;

# Macros

There are four additional macros that are available for use inside iota methods. Outside of iota methods they will return `undefined`.

&nbsp;

### `IOTA_CURRENT_CLOCK`

Identifier for the clock that's currently being handled.

&nbsp;

### `IOTA_TICKS_FOR_CLOCK`

Total number of ticks that will be processed this update for the current clock.

&nbsp;

### `IOTA_TICK_INDEX`

Current tick for the current clock (0-indexed).

&nbsp;

### `IOTA_SECONDS_PER_TICK`

How long each tick is, in seconds, for the current clock.