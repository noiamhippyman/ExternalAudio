/// @desc bytes_to_32(isBigEndian,b1,b2,b3,b4);
/// @arg isBigEndian,b1,b2,b3,b4
var isBigEndian = argument0;
var b1 = argument1;
var b2 = argument2;
var b3 = argument3;
var b4 = argument4;
if (isBigEndian) {
	//big
	return b1 << 24 | b2 << 16 | b3 << 8 | b4;
} else {
	//little
	return b4 << 24 | b3 << 16 | b2 << 8 | b1;
}