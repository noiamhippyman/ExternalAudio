/// @desc ext_audio_free(externalAudio);
/// @arg externalAudio
var externalAudio = argument0;
audio_free_buffer_sound(externalAudio[|EExtAudio.AudioBuffer]);
buffer_delete(externalAudio[|EExtAudio.WaveBuffer]);
ds_list_destroy(externalAudio);