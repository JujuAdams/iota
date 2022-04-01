# GML Functions

&nbsp;

### `iota_clock([identifier])` ***constructor***

**Constructor returns:** `iota_clock` struct

|Name          |Datatype|Purpose                                                                                                                                                        |
|--------------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[identifier]`|any     |Unique id that will be passed into `IOTA_CURRENT_CLOCK` when the clock's `.tick()` method is executed. If not specified, this value will default to `undefined`|

iota's clocks are the time-keeping and code execution centre of the library. They are responsible for executing updates at the required frequency in realtime and, if so desired, will handle certain operations on variables. You can have as many clocks as you want, for example [The Swords of Ditto](https://store.steampowered.com/app/619780/The_Swords_of_Ditto_Mormos_Curse/) used three main clocks: one for gameplay, one for weather and particle effects, and one for the UI. Clocks can be paused individually and can update at different rates if so desired.

&nbsp;

The created struct has the following methods (click to expand):

<details><summary><code>.tick()</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Updates the clock and executes methods that have been added to the clock (using `.add_cycle_method()` etc.). A clock will execute enough cycles to match its realtime update frequency: this means a clock may execute zero cycles per tick, or sometimes multiple cycles per tick.

A clock's `.tick()` should be called once every frame, probably in a persistent control instance of some sort.

&nbsp;
</details>

<details><summary><code>.add_cycle_method(function)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                  |
|--------|--------|---------------------------------------------------------|
|function|function|Function to add to the clock for execution for each cycle|

Adds a function to be executed each cycle. The scope of the method passed into this function will persist, and only one cycle method can be defined per instance/struct.

&nbsp;
</details>

<details><summary><code>.add_begin_method(function)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                          |
|--------|--------|-----------------------------------------------------------------|
|function|function|Function to add to the clock for execution at the start of a tick|

Adds a function to be executed at the start of a tick, before any cycle methods. Begin methods will *not* be executed if the clock doesn't need to execute any cycles at all. The scope of the method passed into this function will persist, and only one begin method can be defined per instance/struct.

&nbsp;
</details>

<details><summary><code>.add_end_method(function)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                        |
|--------|--------|---------------------------------------------------------------|
|function|function|Function to add to the clock for execution at the end of a tick|

Adds a function to be executed at the end of a tick, after all cycle methods. End methods will *not* be executed if the clock doesn't need to execute any cycles at all. The scope of the method passed into this function will persist, and only one end method can be defined per instance/struct.

&nbsp;
</details>

<details><summary><code>.variable_momentary(variableName, resetValue, [scope])</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name        |Datatype       |Purpose                       |
|------------|---------------|------------------------------|
|variableName|string         |Name of the variable to reset |
|resetValue  |any            |Value to reset the variable to|
|[scope]     |instance/struct|Scope to target when managing the variable. If no scope is specified, the instance/struct that called this function will be chosen as the scope|

Adds a variable to be automatically reset at the end of the first cycle per tick. A momentary variable will only be reset if the clock needs to execute one or more cycles. The variable's scope is typically determined by who calls `.variable_momentary()`, though for structs you may need to specify the optional `[scope]` argument.

&nbsp;
</details>

<details><summary><code>.variable_interpolate(inputVariableName, outputVariableName, [scope])</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name              |Datatype       |Purpose                                              |
|------------------|---------------|-----------------------------------------------------|
|inputVariableName |string         |Name of the variable to interpolate                  |
|outputVariableName|string         |Name of the variable to set to the interpolated value|
|[scope]           |instance/struct|Scope to target when managing the variable. If no scope is specified, the instance/struct that called this function will be chosen as the scope|

Adds a variable to be smoothly interpolated between ticks. The interpolated value is passed to the given output variable name. Interpolated variables are always updated every time `.tick()` is called, even if the clock does not need to execute any cycles. The variables' scope is typically determined by who calls `.variable_interpolate()`, though for structs you may need to specify the optional `[scope]` argument.

**Please note** that interpolated variables will always be (at most) a frame behind the actual value of the input variable. Most of this time this makes no difference but it's not ideal if you're looking for frame-perfect gameplay.

&nbsp;
</details>

<details><summary><code>.variable_interpolate_angle(inputVariableName, outputVariableName, [scope])</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name              |Datatype       |Purpose                                              |
|------------------|---------------|-----------------------------------------------------|
|inputVariableName |string         |Name of the variable to interpolate                  |
|outputVariableName|string         |Name of the variable to set to the interpolated value|
|[scope]           |instance/struct|Scope to target when managing the variable. If no scope is specified, the instance/struct that called this function will be chosen as the scope|

As above, but the value is interpolated as an angle measured in degrees. The output value will be an angle from -360 to +360.

&nbsp;
</details>



<details><summary><code>.add_alarm(milliseconds, method)</code></summary>
&nbsp;

**Returns:** Struct, an instance of `__iot_class_alarm`

|Name        |Datatype|Purpose                               |
|------------|--------|--------------------------------------|
|milliseconds|real    |Time delay before executing the method|
|method      |function|Method to execute                     |

Adds a method to be executed after the given number of milliseconds have passed for this clock. The scope of the method is maintained. If the instance/struct attached to the method is removed, the method will not execute. iota alarms respect time dilation and pausing.

The returned struct has a public method called `.Cancel()` which, when executed, will cancel the alarm and prevent it from ever being executed.

**N.B.** Changing a clock's update frequency will cause alarms to desynchronise.

&nbsp;
</details>

<details><summary><code>.add_alarm_cycles(cycles, method)</code></summary>
&nbsp;

**Returns:** Struct, an instance of `__iot_class_alarm`

|Name  |Datatype|Purpose                                                   |
|------|--------|----------------------------------------------------------|
|cycles|real    |Number of cycles to count down before executing the method|
|method|function|Method to execute                                         |

Adds a method to be executed after the given number of cycles have passed for this clock. The scope of the method is maintained. If the instance/struct attached to the method is removed, the method will not execute. iota alarms respect time dilation and pausing.

The returned struct has a public method called `.Cancel()` which, when executed, will cancel the alarm and prevent it from ever being executed.

**N.B.** Changing a clock's update frequency will cause alarms to desynchronise.

&nbsp;
</details>



<details><summary><code>.set_pause(state)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name |Datatype|Purpose                          |
|-----|--------|---------------------------------|
|state|boolean |Whether to pause the clock or not|

Sets whether the clock is paused. A paused clock will execute no methods nor modify any variables.

&nbsp;
</details>

<details><summary><code>.get_pause()</code></summary>
&nbsp;

**Returns:** Boolean, whether the clock is paused

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>

<details><summary><code>.set_update_frequency(frequency)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name     |Datatype|Purpose                                  |
|---------|--------|-----------------------------------------|
|frequency|real    |Rate at which to execute cycles, in Hertz|

Sets the update frequency for the clock. This value should generally not change once you've set it. This value will default to matching your game's target framerate at the time that the clock was instantiated.

&nbsp;
</details>

<details><summary><code>.get_update_frequency()</code></summary>
&nbsp;

**Returns:** Real, the update frequency of the clock, in Hertz

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>

<details><summary><code>.set_time_dilation(multiplier)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                          |
|----------|--------|---------------------------------|
|multiplier|real    |Whether to pause the clock or not|

Sets the time dilation multiplier. A value of `1.0` is no time dilation, `0.5` is half speed, `2.0` is double speed. Time dilation values cannot be set lower than `0.0`.

&nbsp;
</details>

<details><summary><code>.get_time_dilation()</code></summary>
&nbsp;

**Returns:** Real, the time dilation multiplier

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>

<details><summary><code>.get_remainder()</code></summary>
&nbsp;

**Returns:** Real, the time remainding on the accumulator, as a fraction of a frame

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>