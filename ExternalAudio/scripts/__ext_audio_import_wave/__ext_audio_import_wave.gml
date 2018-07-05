/// @desc __ext_audio_import_wave(filename);
/// @arg filename
var filename = argument0;
var waveBuffer = buffer_load(filename);

var b1,b2,b3,b4;
b1 = buffer_peek(waveBuffer,0,buffer_u8);
b2 = buffer_peek(waveBuffer,1,buffer_u8);
b3 = buffer_peek(waveBuffer,2,buffer_u8);
b4 = buffer_peek(waveBuffer,3,buffer_u8);
var chunkID = bytes_to_32(true,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,4,buffer_u8);
b2 = buffer_peek(waveBuffer,5,buffer_u8);
b3 = buffer_peek(waveBuffer,6,buffer_u8);
b4 = buffer_peek(waveBuffer,7,buffer_u8);
var chunkSize = bytes_to_32(false,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer, 8,buffer_u8);
b2 = buffer_peek(waveBuffer, 9,buffer_u8);
b3 = buffer_peek(waveBuffer,10,buffer_u8);
b4 = buffer_peek(waveBuffer,11,buffer_u8);
var format = bytes_to_32(true,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,12,buffer_u8);
b2 = buffer_peek(waveBuffer,13,buffer_u8);
b3 = buffer_peek(waveBuffer,14,buffer_u8);
b4 = buffer_peek(waveBuffer,15,buffer_u8);
var subchunk1ID = bytes_to_32(true,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,16,buffer_u8);
b2 = buffer_peek(waveBuffer,17,buffer_u8);
b3 = buffer_peek(waveBuffer,18,buffer_u8);
b4 = buffer_peek(waveBuffer,19,buffer_u8);
var subchunk1Size = bytes_to_32(false,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,20,buffer_u8);
b2 = buffer_peek(waveBuffer,21,buffer_u8);
var audioFormat = bytes_to_16(false,b1,b2);

b1 = buffer_peek(waveBuffer,22,buffer_u8);
b2 = buffer_peek(waveBuffer,23,buffer_u8);
var numChannels = bytes_to_16(false,b1,b2);

b1 = buffer_peek(waveBuffer,24,buffer_u8);
b2 = buffer_peek(waveBuffer,25,buffer_u8);
b3 = buffer_peek(waveBuffer,26,buffer_u8);
b4 = buffer_peek(waveBuffer,27,buffer_u8);
var sampleRate = bytes_to_32(false,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,28,buffer_u8);
b2 = buffer_peek(waveBuffer,29,buffer_u8);
b3 = buffer_peek(waveBuffer,30,buffer_u8);
b4 = buffer_peek(waveBuffer,31,buffer_u8);
var byteRate = bytes_to_32(false,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,32,buffer_u8);
b2 = buffer_peek(waveBuffer,33,buffer_u8);
var blockAlign = bytes_to_16(false,b1,b2);

b1 = buffer_peek(waveBuffer,34,buffer_u8);
b2 = buffer_peek(waveBuffer,35,buffer_u8);
var bitsPerSample = bytes_to_16(false,b1,b2);

b1 = buffer_peek(waveBuffer,36,buffer_u8);
b2 = buffer_peek(waveBuffer,37,buffer_u8);
b3 = buffer_peek(waveBuffer,38,buffer_u8);
b4 = buffer_peek(waveBuffer,39,buffer_u8);
var subchunk2ID = bytes_to_32(true,b1,b2,b3,b4);

b1 = buffer_peek(waveBuffer,40,buffer_u8);
b2 = buffer_peek(waveBuffer,41,buffer_u8);
b3 = buffer_peek(waveBuffer,42,buffer_u8);
b4 = buffer_peek(waveBuffer,43,buffer_u8);
var subchunk2Size = bytes_to_32(false,b1,b2,b3,b4);

var audioBuffer = audio_create_buffer_sound(
	waveBuffer,
	audioFormat == 8 ? buffer_u8 : buffer_s16,
	sampleRate,
	44,
	subchunk2Size,
	numChannels == 1 ? audio_mono : audio_stereo
);

var filenameNoExt = string_replace(filename_name(filename),filename_ext(filename),"");


var debugStr = "";
debugStr += "ChunkID: " + assert(chunkID == 0x52494646);
debugStr += "\nChunkSize: " + assert(chunkSize == 36 + subchunk2Size);
debugStr += "\nFormat: " + assert(format == 0x57415645 );
debugStr += "\nSubchunk1ID: " + assert(subchunk1ID == 0x666d7420);
debugStr += "\nSubchunk1Size: " + assert(subchunk1Size == 16,"PCM","Other");
debugStr += "\nAudioFormat: " + assert(audioFormat == 1,"PCM","Other");
debugStr += "\nNumChannels: " + assert(numChannels == 1,"Mono",assert(numChannels == 2, "Stereo","Unknown:"+string(numChannels)));
debugStr += "\nSampleRate: " + string(sampleRate);
debugStr += "\nByteRate: " + assert(byteRate == sampleRate * numChannels * bitsPerSample / 8);
debugStr += "\nBlockAlign: " + assert(blockAlign == numChannels * bitsPerSample / 8);
debugStr += "\nBitsPerSample: " + string(bitsPerSample);
debugStr += "\nSubchunk2ID: " + assert(subchunk2ID == 0x64617461);
debugStr += "\nSubchunk2Size: " + string(subchunk2Size);
show_message(debugStr);

return __ExternalAudio(filenameNoExt,waveBuffer,audioBuffer);