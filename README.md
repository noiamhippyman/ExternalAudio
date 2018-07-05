This is a pure GML extension that enables loading external audio during runtime.

It's a very simple extension with only three functions.

ext_audio_load(filename) - Returns ExternalAudio data structure with loaded audio data
ext_audio_free(externalAudio) - Frees externalAudio data structure along with audio data
ext_audio_id(externalAudio)	- Returns actual sound ID to use with GM audio functions

Check out the internal scripts if you want to see how everything is done in more depth.