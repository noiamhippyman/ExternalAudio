/// @desc ext_audio_load(filename);
/// @arg filename
var filename = argument0;

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