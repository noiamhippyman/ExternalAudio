/// @desc - Simple GUI
var str = "Playing: ";
if (audio_is_playing(externalSoundInstance)) {
	
	str += ext_audio_get_name(externalAudio)
	str += "\nSpace:";
	if (audio_is_paused(externalSoundInstance)) {
		str += "Unpause";
	} else {
		str += "Pause";
	}
	
	str += "\nEnter: Stop"
	
} else {
	str += "Nothing";
	str += "\nEnter: Play"

}

draw_set_font(font0);
draw_set_halign(1);
draw_set_valign(1);
draw_text(room_width/2,room_height/2,str);
draw_set_halign(0);
draw_set_valign(0);