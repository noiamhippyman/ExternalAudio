/// @desc Loading .wav files
var time = current_time;
externalAudio = ext_audio_load("BeemBoomBaaBoom-normalized.wav");
show_message(string((current_time - time)) + " ms");
externalSoundID = ext_audio_get_id(externalAudio);
externalSoundInstance = audio_play_sound(externalSoundID,10,true);