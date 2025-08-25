extends Node2D

enum Clip {
	JELLY_DEATH,
}

## Let each key in audio_sources hold an array, such that we
##  can easily choose random sounds for each event that
##  plays that source.
var audio_sources: Dictionary[Clip, Array] = {
	Clip.JELLY_DEATH: [
		"res://assets/audio/Invader_Death/01 Poly Grid.wav",
		"res://assets/audio/Invader_Death/02 Poly Grid.wav",
		"res://assets/audio/Invader_Death/03 Poly Grid.wav",
		"res://assets/audio/Invader_Death/04 Poly Grid.wav",
		"res://assets/audio/Invader_Death/05 Poly Grid.wav",
		"res://assets/audio/Invader_Death/06 Poly Grid.wav",
		"res://assets/audio/Invader_Death/07 Poly Grid.wav",
		"res://assets/audio/Invader_Death/08 Poly Grid.wav",
		"res://assets/audio/Invader_Death/09 Poly Grid.wav",
		"res://assets/audio/Invader_Death/10 Poly Grid.wav",
	],
}

var audio_clips: Dictionary[Clip, Array] = {}
var audio_streams: Array[AudioStreamPlayer] = []

func _ready() -> void:
	# Load each audio source path into an AudioStream
	for key in audio_sources.keys():
		audio_clips[key] = []
		for source in audio_sources[key]:
			audio_clips[key].push_back(
				ResourceLoader.load(source) as AudioStream
			)

func _process(_delta: float) -> void:
	# Find any completed AudioPlayer's and cull them
	var streams_to_cull: Array[int]

	for i in len(audio_streams):
		if !audio_streams[i].playing:
			streams_to_cull.push_front(i)
	
	for idx in streams_to_cull:
		audio_streams[idx].queue_free()
		audio_streams.remove_at(idx)

## Creates an independent `AudioStreamPlayer` for the
##  sound and manages its lifetime. Allows us to easily
##  play multiple sounds from an arbitrary number of
##  events.
func play_clip(clip: Clip):
	match clip:
		Clip.JELLY_DEATH:
			var stream := AudioStreamPlayer.new()
			add_child(stream)
			var clip_idx = randi() % len(audio_clips[clip])
			stream.stream = audio_clips[clip][clip_idx]
			stream.volume_db = -30.0
			stream.play()
			audio_streams.push_back(stream)
