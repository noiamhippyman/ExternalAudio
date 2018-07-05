/// @desc Pausing sound instance
if (!audio_is_paused(externalSoundInstance)) {
	audio_pause_sound(externalSoundInstance);
} else {
	audio_resume_sound(externalSoundInstance);
}