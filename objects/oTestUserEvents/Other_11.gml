/// @description Normal Tick

x += 8.7*(IotaGetInput("right") - IotaGetInput("left"));
x = clamp(x, 0, room_width);