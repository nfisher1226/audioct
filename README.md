Audioct: Audio conversion tools
===============================

Some basic shell scripts for converting from one audio format to another
with tagging support. In general, tag your source files first and the
output files will be tagged appropriately.

ape2mp3.sh: Converts a directory of ape files to mp3 (calls ape2wav and
	wav2mp3 in succession)
ape2ogg.sh: Converts a directory of ape files to mp3 (calls ape2wav and
	wav2ogg in succession)
ape2wav.sh: Converts a directory of ape files to wav
flac2mp3.sh: Converts a directory of flac files to mp3
flac2ogg.sh: Converts a directory of flac files to ogg
m4a2mp3.sh: Converts a directory of m4a files to mp3
wav2mp3.sh: Converts a directory of wav files to mp3
wav2ogg.sh: Converts a directory of wav files to ogg (no tagging)
cue2mp3.sh: Takes a valid cue sheet as an argument and splits it into
	individual mp3 files
cue2ogg.sh: Takes a valid cue sheet as an argument and splits it into
	individual ogg files
set-flac-tags.sh: Automatically tags all flac files in a directory.
	Filename format should be "Track - Title.flac"
set-mp3-tags.sh: Automatically tags all mp3 files in a directory.
	Filename format should be "Track - Title.mp3"
set-ogg-tags.sh: Automatically tags all ogg files in a directory.
	Filename format should be "Track - Title.ogg"
