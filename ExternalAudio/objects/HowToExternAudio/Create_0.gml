/// @desc Loading .wav files

//drag a wave file into "Included Files" and replace text with filename including extension
externalAudio = ext_audio_load("filenamehere.wav");
externalSoundID = ext_audio_get_id(externalAudio);
externalSoundInstance = audio_play_sound(externalSoundID,10,true);