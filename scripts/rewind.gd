
extends AudioStreamPlayer

@export var rewind_speed: float = 3.0

var audio_data: PackedByteArray
var sample_rate: float
var channels: int

var sample_position: float = 0.0
var rewinding: bool = false
var playback: AudioStreamGeneratorPlayback


func _ready() -> void:
	var wav := stream as AudioStreamWAV

	if wav == null:
		push_error("Audio must be WAV!")
		return

	if wav.format != AudioStreamWAV.FORMAT_16_BITS:
		push_error("WAV must use 16-bit PCM!")
		return

	audio_data = wav.data
	sample_rate = wav.mix_rate
	channels = 2 if wav.stereo else 1

	var generator := AudioStreamGenerator.new()
	generator.mix_rate = sample_rate
	generator.buffer_length = 0.2

	stream = generator
	play()

	playback = get_stream_playback()


func start_rewind() -> void:
	rewinding = true


func stop_rewind() -> void:
	rewinding = false


func _process(_delta: float) -> void:
	if playback == null:
		return

	var frames := playback.get_frames_available()

	for i in range(frames):
		if rewinding:
			sample_position -= rewind_speed
		else:
			sample_position += 1.0

		sample_position = clampf(
			sample_position,
			0.0,
			float(audio_data.size() / (channels * 2) - 1)
		)

		var left := read_interpolated(sample_position, 0)
		var right := left

		if channels == 2:
			right = read_interpolated(sample_position, 1)

		playback.push_frame(Vector2(left, right))


func read_interpolated(pos: float, channel: int) -> float:
	var index_a := int(floor(pos))
	var index_b := mini(index_a + 1, audio_data.size() / (channels * 2) - 1)

	var fraction := pos - float(index_a)

	var a := read_sample(index_a, channel)
	var b := read_sample(index_b, channel)

	return lerpf(a, b, fraction)


func read_sample(index: int, channel: int) -> float:
	var offset := (index * channels + channel) * 2
	return float(audio_data.decode_s16(offset)) / 32768.0
