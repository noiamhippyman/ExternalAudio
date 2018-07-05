/// @desc assert(expression,succeed,fail);
/// @arg expression,succeed,fail
var expression = argument[0];
var succeed = argument_count > 1 ? argument[1] : "succeed";
var fail = argument_count > 2 ? argument[2] : "fail";
if (expression) return succeed;
return fail;