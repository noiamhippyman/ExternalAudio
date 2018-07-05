/// @desc __ext_audio_import_wave(filename);
/// @arg filename

var filename = argument0;

var waveBuffer = buffer_load(filename);

//Used to search for the next required chunk
//so we can skip unneccesary chunks
var chunkSeekQueue = ds_queue_create();
ds_queue_enqueue(chunkSeekQueue,
				0x52,//"RIFF"
				0x66,//"fmt "
				0x64//"data"
				);

var chunkID,chunkSize,format;
var subchunk1ID,subchunk1Size,audioFormat,numChannels,sampleRate,byteRate,blockAlign,bitsPerSample;
var subchunk2ID,subchunk2Size;

//Loop through queue entries
buffer_seek(waveBuffer,buffer_seek_start,0);
while (!ds_queue_empty(chunkSeekQueue)) {
	var b1 = -1;
	var b2 = -1;
	var b3 = -1;
	var b4 = -1;
	var firstByteNeeded = ds_queue_head(chunkSeekQueue);
	var byteMax = buffer_get_size(waveBuffer);
	//Find first byte of current chunk
	while (b1 != firstByteNeeded) {
		b1 = buffer_read(waveBuffer,buffer_u8);
		if (buffer_tell(waveBuffer) == byteMax) {
			show_error("Invalid file",true);
		}
	}
	//Get last three bytes needed
	b2 = buffer_read(waveBuffer,buffer_u8);
	b3 = buffer_read(waveBuffer,buffer_u8);
	b4 = buffer_read(waveBuffer,buffer_u8);
	var combined = bytes_to_32(true,b1,b2,b3,b4);
	
	switch (combined) {
		case 0x52494646://"RIFF"
			chunkID = combined;
			
			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			b3 = buffer_read(waveBuffer,buffer_u8);
			b4 = buffer_read(waveBuffer,buffer_u8);
			chunkSize = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			b3 = buffer_read(waveBuffer,buffer_u8);
			b4 = buffer_read(waveBuffer,buffer_u8);
			format = bytes_to_32(true,b1,b2,b3,b4);//"WAVE"
			
			ds_queue_dequeue(chunkSeekQueue);
		break;
		
		case 0x666d7420://"fmt "
			subchunk1ID = combined;
		
			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			b3 = buffer_read(waveBuffer,buffer_u8);
			b4 = buffer_read(waveBuffer,buffer_u8);
			subchunk1Size = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			audioFormat = bytes_to_16(false,b1,b2);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			numChannels = bytes_to_16(false,b1,b2);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			b3 = buffer_read(waveBuffer,buffer_u8);
			b4 = buffer_read(waveBuffer,buffer_u8);
			sampleRate = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			b3 = buffer_read(waveBuffer,buffer_u8);
			b4 = buffer_read(waveBuffer,buffer_u8);
			byteRate = bytes_to_32(false,b1,b2,b3,b4);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			blockAlign = bytes_to_16(false,b1,b2);

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			bitsPerSample = bytes_to_16(false,b1,b2);
			
			ds_queue_dequeue(chunkSeekQueue);
		break;
		
		case 0x64617461://"data"
			subchunk2ID = combined;

			b1 = buffer_read(waveBuffer,buffer_u8);
			b2 = buffer_read(waveBuffer,buffer_u8);
			b3 = buffer_read(waveBuffer,buffer_u8);
			b4 = buffer_read(waveBuffer,buffer_u8);
			subchunk2Size = bytes_to_32(false,b1,b2,b3,b4);
			
			ds_queue_dequeue(chunkSeekQueue);
		break;
		
		default:
			show_error("Something isn't right here",true);
		break;
	}
}
ds_queue_destroy(chunkSeekQueue);

var audioBuffer = audio_create_buffer_sound(
	waveBuffer,
	audioFormat == 8 ? buffer_u8 : buffer_s16,
	sampleRate,
	buffer_tell(waveBuffer),
	subchunk2Size,
	numChannels == 1 ? audio_mono : audio_stereo
);

var filenameNoExt = string_replace(filename_name(filename),filename_ext(filename),"");

return __ExternalAudio(filenameNoExt,waveBuffer,audioBuffer);