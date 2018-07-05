/// @desc __ext_audio_import_wave(filename);
/// @arg filename
var filename = argument0;
var waveBuffer = buffer_load(filename);

//Used to search for the next required chunk
//so we can skip unneccesary chunks
var chunkSeekQueue = ds_queue_create();
ds_queue_enqueue(chunkSeekQueue,
				0x52,//"RIFF"
				//0x57,//"WAVE"
				0x66,//"fmt "
				0x64//"data"
				);

buffer_seek(waveBuffer,buffer_seek_start,0);

//Retain byteIndex between queue entries
var byteIndex = 0;
var byteMax = buffer_get_size(waveBuffer);

var chunkID,chunkSize,format;
var subchunk1ID,subchunk1Size,audioFormat,numChannels,sampleRate,byteRate,blockAlign,bitsPerSample;
var subchunk2ID,subchunk2Size;
//Loop through queue entries
while (!ds_queue_empty(chunkSeekQueue)) {
	var b1 = -1;
	var b2 = -1;
	var b3 = -1;
	var b4 = -1;
	var firstByteNeeded = ds_queue_head(chunkSeekQueue);
	
	//Find first byte of current chunk
	while (b1 != firstByteNeeded) {
		b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
		if (byteIndex == byteMax) {
			show_error("Invalid file",true);
		}
	}
	//Get last three bytes needed
	b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
	b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
	b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
	var combined = bytes_to_32(true,b1,b2,b3,b4);
	
	switch (combined) {
		case 0x52494646://"RIFF"
			chunkID = combined;
			
			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			chunkSize = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			format = bytes_to_32(true,b1,b2,b3,b4);//"WAVE"
			
			ds_queue_dequeue(chunkSeekQueue);
		break;
		
		case 0x666d7420://"fmt "
			subchunk1ID = combined;
		
			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			subchunk1Size = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			audioFormat = bytes_to_16(false,b1,b2);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			numChannels = bytes_to_16(false,b1,b2);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			sampleRate = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			byteRate = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			blockAlign = bytes_to_16(false,b1,b2);

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			bitsPerSample = bytes_to_16(false,b1,b2);
			
			ds_queue_dequeue(chunkSeekQueue);
		break;
		
		case 0x64617461://"data"
			subchunk2ID = combined;

			b1 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b2 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b3 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			b4 = buffer_peek(waveBuffer,byteIndex++,buffer_u8);
			subchunk2Size = bytes_to_32(false,b1,b2,b3,b4);
			
			ds_queue_dequeue(chunkSeekQueue);
		break;
		
		default:
			show_error("Something isn't right here",true);
		break;
	}
	
	
	
}

var audioBuffer = audio_create_buffer_sound(
	waveBuffer,
	audioFormat == 8 ? buffer_u8 : buffer_s16,
	sampleRate,
	byteIndex,
	subchunk2Size,
	numChannels == 1 ? audio_mono : audio_stereo
);

var filenameNoExt = string_replace(filename_name(filename),filename_ext(filename),"");

/*
var debugStr = "";
debugStr += "ChunkID: " + assert(chunkID == 0x52494646);
debugStr += "\nChunkSize: " + assert(chunkSize == 4 + (8 + subchunk1Size) + (8 + subchunk2Size));
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
*/


return __ExternalAudio(filenameNoExt,waveBuffer,audioBuffer);