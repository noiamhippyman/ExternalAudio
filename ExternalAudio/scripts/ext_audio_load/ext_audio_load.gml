/// @desc ext_audio_load(filename);
/// @arg filename
var filename = argument0;
if (!file_exists(filename)) {
	show_error(filename + " could not be found. Make sure you're looking in the right place",true);
}
var ext = filename_ext(filename);
switch (ext) {
	case ".wav":
		return __ext_audio_import_wave(filename);
	break;
	
	default:
		show_message(ext + " is not a supported file format.");
		return noone;
	break;
}