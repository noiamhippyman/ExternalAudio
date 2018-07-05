/// @desc Play/Stop sound instance
if (!audio_is_playing(externalSoundInstance)) {
	externalSoundInstance = audio_play_sound(externalSoundID,10,true);
} else {
	audio_stop_sound(externalSoundInstance);
}