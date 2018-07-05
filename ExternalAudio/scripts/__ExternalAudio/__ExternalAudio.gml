/// @desc __ExternalAudio(name,waveBuffer,audioBuffer);
/// @arg name,waveBuffer,audioBuffer
var name = argument0;
var wavBuff = argument1;
var audioBuff = argument2;

var externalAudio = ds_list_create();

externalAudio[|EExtAudio.Name] = name;
externalAudio[|EExtAudio.WaveBuffer] = wavBuff;
externalAudio[|EExtAudio.AudioBuffer] = audioBuff;

return externalAudio;