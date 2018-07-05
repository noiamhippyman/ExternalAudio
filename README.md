# PGEA?
## GameMaker Studio 2 Pure GML External Audio
This is a pure GML extension that enables loading external audio during runtime.

## Super Simple API
- ext_audio_load(filename) - Returns ExternalAudio data structure with loaded audio data
- ext_audio_free(externalAudio) - Frees ExternalAudio data structure along with audio data
- ext_audio_get_id(externalAudio) - Returns actual sound ID to use with GM audio functions
- ext_audio_get_name(externalAudio)	- Returns name of file without the path or extension

Check out the internal scripts if you want to see how everything else is done in more depth.

## Planned/Supported Formats
- [x] WAVE		
- [ ] OGG Vorbis

## Won't/Can't Support
- MP3 - OGG is the better open-source option anyways. MP3 is ancient. Get over it.

Feel free to request any other formats.


## Example
```
//First you need to load your external audio file
//This is limited to GameMaker sandbox limitations 
externalAudio = ext_audio_load("path/to/file.wav");

//Then you get the sound id to be used with audio_* functions
externalSoundID = ext_audio_get_id(externalAudio);

//Use GameMaker audio_* functions like you normally would
audio_play_sound(externalSoundID, 10, false);

//This is also perfectly valid
//audio_play_sound(ext_audio_get_id(externalAudio), 10, false);
```