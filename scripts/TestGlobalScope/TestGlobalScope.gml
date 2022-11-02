global.value = 0;

global.someFunction = function()
{
    global.value++;
}

function someOtherFunction()
{
    global.value++;
}