alarm1 = oController.clock.AddAlarm(300, function() { show_debug_message("alarm1"); });
alarm2 = oController.clock.AddAlarm(450, function() { show_debug_message("alarm2"); });

struct = {};
with(struct)
{
    alarm3 = oController.clock.AddAlarm(600, function() { show_debug_message("alarm3"); });
}