# `IotaClock([identifier])` ***constructor***

**Constructor returns:** `IotaClock` struct

|Name          |Datatype|Purpose                                                                                                                                                        |
|--------------|--------|---------------------------------------------------------------------------------------------------------------------------------------------------------------|
|`[identifier]`|any     |Unique id that will be passed into `IOTA_CURRENT_CLOCK` when the clock's `.Tick()` method is executed. If not specified, this value will default to `undefined`|

iota's clocks are the time-keeping and code execution centre of the library. They are responsible for executing updates at the required frequency in realtime and, if so desired, will handle certain operations on variables. You can have as many clocks as you want, for example [The Swords of Ditto](https://store.steampowered.com/app/619780/The_Swords_of_Ditto_Mormos_Curse/) used three main clocks: one for gameplay, one for weather and particle effects, and one for the UI. Clocks can be paused individually and can update at different rates if so desired.

&nbsp;

The created struct has the following methods (click to expand):

<details><summary><code>.Tick()</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

Updates the clock and executes methods that have been added to the clock (using `.AddCycleMethod()` etc.). A clock will execute enough cycles to match its realtime update frequency: this means a clock may execute zero cycles per tick, or sometimes multiple cycles per tick.

A clock's `.Tick()` should be called once every frame, probably in a persistent control instance of some sort.

&nbsp;
</details>

<details><summary><code>.AddCycleMethod(function)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                  |
|--------|--------|---------------------------------------------------------|
|function|function|Function to add to the clock for execution for each cycle|

Adds a function to be executed each cycle. The scope of the method passed into this function will persist, and only one cycle method can be defined per instance/struct.

&nbsp;
</details>

<details><summary><code>.AddBeginMethod(function)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                          |
|--------|--------|-----------------------------------------------------------------|
|function|function|Function to add to the clock for execution at the start of a tick|

Adds a function to be executed at the start of a tick, before any cycle methods. Begin methods will *not* be executed if the clock doesn't need to execute any cycles at all. The scope of the method passed into this function will persist, and only one begin method can be defined per instance/struct.

&nbsp;
</details>

<details><summary><code>.AddEndMethod(function)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name    |Datatype|Purpose                                                        |
|--------|--------|---------------------------------------------------------------|
|function|function|Function to add to the clock for execution at the end of a tick|

Adds a function to be executed at the end of a tick, after all cycle methods. End methods will *not* be executed if the clock doesn't need to execute any cycles at all. The scope of the method passed into this function will persist, and only one end method can be defined per instance/struct.

&nbsp;
</details>

<details><summary><code>.VariableMomentary(variableName, resetValue, [scope])</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name        |Datatype       |Purpose                       |
|------------|---------------|------------------------------|
|variableName|string         |Name of the variable to reset |
|resetValue  |any            |Value to reset the variable to|
|[scope]     |instance/struct|Scope to target when managing the variable. If no scope is specified, the instance/struct that called this function will be chosen as the scope|

Adds a variable to be automatically reset at the end of the first cycle per tick. A momentary variable will only be reset if the clock needs to execute one or more cycles. The variable's scope is typically determined by who calls `.VariableMomentary()`, though for structs you may need to specify the optional `[scope]` argument.

&nbsp;
</details>

<details><summary><code>.VariableInterpolate(inputVariableName, outputVariableName, [scope])</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name              |Datatype       |Purpose                                              |
|------------------|---------------|-----------------------------------------------------|
|inputVariableName |string         |Name of the variable to interpolate                  |
|outputVariableName|string         |Name of the variable to set to the interpolated value|
|[scope]           |instance/struct|Scope to target when managing the variable. If no scope is specified, the instance/struct that called this function will be chosen as the scope|

Adds a variable to be smoothly interpolated between ticks. The interpolated value is passed to the given output variable name. Interpolated variables are always updated every time `.tick()` is called, even if the clock does not need to execute any cycles. The variables' scope is typically determined by who calls `.VariableInterpolate()`, though for structs you may need to specify the optional `[scope]` argument.

**Please note** that interpolated variables will always be (at most) a frame behind the actual value of the input variable. Most of this time this makes no difference but it's not ideal if you're looking for frame-perfect gameplay.

&nbsp;
</details>

<details><summary><code>.VariableInterpolateAngle(inputVariableName, outputVariableName, [scope])</code></summary>
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



<details><summary><code>.AddAlarm(milliseconds, method)</code></summary>
&nbsp;

**Returns:** Struct, an instance of `__IotaClassAlarm`

|Name        |Datatype|Purpose                               |
|------------|--------|--------------------------------------|
|milliseconds|real    |Time delay before executing the method|
|method      |function|Method to execute                     |

Adds a method to be executed after the given number of milliseconds have passed for this clock. The scope of the method is maintained. If the instance/struct attached to the method is removed, the method will not execute. iota alarms respect time dilation and pausing.

The returned struct has a public method called `.Cancel()` which, when executed, will cancel the alarm and prevent it from ever being executed.

**N.B.** Changing a clock's update frequency will cause alarms to desynchronise.

&nbsp;
</details>

<details><summary><code>.AddAlarmCycles(cycles, method)</code></summary>
&nbsp;

**Returns:** Struct, an instance of `__IotaClassAlarm`

|Name  |Datatype|Purpose                                                   |
|------|--------|----------------------------------------------------------|
|cycles|real    |Number of cycles to count down before executing the method|
|method|function|Method to execute                                         |

Adds a method to be executed after the given number of cycles have passed for this clock. The scope of the method is maintained. If the instance/struct attached to the method is removed, the method will not execute. iota alarms respect time dilation and pausing.

The returned struct has a public method called `.Cancel()` which, when executed, will cancel the alarm and prevent it from ever being executed.

**N.B.** Changing a clock's update frequency will cause alarms to desynchronise.

&nbsp;
</details>



<details><summary><code>.SetPause(state)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name |Datatype|Purpose                          |
|-----|--------|---------------------------------|
|state|boolean |Whether to pause the clock or not|

Sets whether the clock is paused. A paused clock will execute no methods nor modify any variables.

&nbsp;
</details>

<details><summary><code>.GetPause()</code></summary>
&nbsp;

**Returns:** Boolean, whether the clock is paused

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>

<details><summary><code>.SetUpdateFrequency(frequency)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name     |Datatype|Purpose                                  |
|---------|--------|-----------------------------------------|
|frequency|real    |Rate at which to execute cycles, in Hertz|

Sets the update frequency for the clock. This value should generally not change once you've set it. This value will default to matching your game's target framerate at the time that the clock was instantiated.

&nbsp;
</details>

<details><summary><code>.GetUpdateFrequency()</code></summary>
&nbsp;

**Returns:** Real, the update frequency of the clock, in Hertz

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>

<details><summary><code>.SetTimeDilation(multiplier)</code></summary>
&nbsp;

**Returns:** N/A (`undefined`)

|Name      |Datatype|Purpose                          |
|----------|--------|---------------------------------|
|multiplier|real    |Whether to pause the clock or not|

Sets the time dilation multiplier. A value of `1.0` is no time dilation, `0.5` is half speed, `2.0` is double speed. Time dilation values cannot be set lower than `0.0`.

&nbsp;
</details>

<details><summary><code>.GetTimeDilation()</code></summary>
&nbsp;

**Returns:** Real, the time dilation multiplier

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>

<details><summary><code>.GetRemainder()</code></summary>
&nbsp;

**Returns:** Real, the time remainding on the accumulator, as a fraction of a frame

|Name|Datatype|Purpose|
|----|--------|-------|
|None|        |       |

&nbsp;
</details>