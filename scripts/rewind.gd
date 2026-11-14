
extends AudioStreamPlayer

@export var rewind_speed: float = 3.0

var original_stream: AudioStreamWAV
var original_data: PackedByteArray

var sample_rate: float
var channels: int
var current_sample: float = 0.0

var rewinding: bool = false
var playback: AudioStreamGeneratorPlayback


func _ready() -> void:
	# This implementation expects an uncompressed WAV.
	original_stream = stream as AudioStreamWAV

	if original_stream == null:
		push_error("Please use an AudioStreamWAV resource.")
		return

	original_data = original_stream.data
	sample_rate = original_stream.mix_rate
	channels = 2 if original_stream.stereo else 1

	stream = AudioStreamGenerator.new()
	stream.mix_rate = sample_rate
	stream.buffer_length = 0.2

	play()

	playback = get_stream_playback() as AudioStreamGeneratorPlayback


func _process(_delta: float) -> void:
	if playback == null:
		return

	if Input.is_action_just_pressed("rewind"):
		rewinding = true

	if Input.is_action_just_released("rewind"):
		rewinding = false

	fill_audio_buffer()


func fill_audio_buffer() -> void:
	var frames = playback.get_frames_available()

	for i in range(frames):
		if rewinding:
			current_sample -= rewind_speed
		else:
			current_sample += 1.0

		current_sample = clampf(
			current_sample,
			0.0,
			float(original_data.size() / (channels * 2) - 1)
		)

		var left = get_sample(int(current_sample), 0)
		var right = left

		if channels == 2:
			right = get_sample(int(current_sample), 1)

		playback.push_frame(Vector2(left, right))


func get_sample(index: int, channel: int) -> float:
	var offset = (index * channels + channel) * 2

	var value = original_data.decode_s16(offset)

	return float(value) / 32768.0

func start_rewind() -> void:
	rewinding = true

func stop_rewind() -> void:
	rewinding = false
