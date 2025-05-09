@icon("res://cc3d/assets/optimized/core/class/WorldBackgroundAudio.svg")
@tool
extends Node
class_name WorldBackgroundAudio

@export var loop : bool = true
@export var shuffle : bool = false
@export_group("Songs", "")
@export var songs : Array[AudioStream]
@export_group("Audio Settings", "")
var song_index : int = 0
## Volume of sound, in decibels. This is an offset of the stream's volume.
@export_range(-24.0, 24.0, 0.01) var volume_db : float = 0.0
@export var pitch_scale : float = 0.0
@export var playing : bool = false
@export var autoplay : bool = true
@export var stream_paused : bool = false
## Audio bus
var bus : String = &"Music"
@export_enum("Default:0", "Stream:1", "Sample:2") var playback_type: int = 0 as AudioServer.PlaybackType
## The maximum number of sounds this node can play at a time.
@export_range(1, 999) var max_polyphony: int = 1

var audio_player = AudioStreamPlayer.new()

func _ready() -> void:
	add_child(audio_player)
	audio_player.connect("finished", _shuffle if shuffle else _next)
	if shuffle:
		song_index = randi_range(0, songs.size() - 1)
	
	audio_player.volume_db = self.volume_db
	audio_player.pitch_scale = self.pitch_scale
	audio_player.playing = self.playing
	audio_player.autoplay = self.autoplay
	audio_player.stream_paused = self.stream_paused
	audio_player.bus = self.bus
	audio_player.playback_type = self.playback_type
	
	audio_player.stream = songs[song_index]
	if self.autoplay && !Engine.is_editor_hint():
		audio_player.play()

func _next() -> void:
	if (song_index >= (songs.size() - 1) && loop):
		song_index = 0
	else:
		song_index += 1
	if (song_index < songs.size() || loop):
		audio_player.stream = songs[song_index]
		audio_player.play()

func _shuffle() -> void:
	var r = randi_range(0, songs.size() - 1)
	while (r == song_index):
		r = randi_range(0, songs.size() - 1)
	song_index = r
	if songs.size() == 0:
		return
	else:
		audio_player.stream = songs[song_index]
	audio_player.play()

func _get_property_list() -> Array[Dictionary]:
	var properties:Array[Dictionary] = []
	var buses := AudioServer.get_bus_count()
	var names: PackedStringArray = []
	for i in range(buses):
		names.append(AudioServer.get_bus_name(i))
	properties.push_back({
		"name": "bus",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(names),
		"usage": PROPERTY_USAGE_DEFAULT
	})
	return properties
