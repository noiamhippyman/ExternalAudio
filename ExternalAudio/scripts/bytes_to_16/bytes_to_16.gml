/// @desc bytes_to_16(isBigEndian,b1,b2);
/// @arg isBigEndian,b1,b2
var isBigEndian = argument0;
var b1 = argument1;
var b2 = argument2;
if (isBigEndian) {
	//big
	return b1 << 8 | b2;
} else {
	//little
	return b2 << 8 | b1;
}