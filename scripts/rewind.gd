
extends AudioStreamPlayer

@export var rewind_speed: float = 3.0

var audio_data: PackedByteArray
var sample_rate: float
var channels: int
var bits_per_sample: int

var sample_position: float = 0.0
var rewinding: bool = false

var playback: AudioStreamGeneratorPlayback
var total_frames: int = 0


func _ready() -> void:
	var wav := stream as AudioStreamWAV

	if wav == null:
		push_error("Audio must be WAV!")
		return

	sample_rate = wav.mix_rate
	channels = 2 if wav.stereo else 1

	match wav.format:
		AudioStreamWAV.FORMAT_8_BITS:
			bits_per_sample = 8

		AudioStreamWAV.FORMAT_16_BITS:
			bits_per_sample = 16

		_:
			push_error("Unsupported WAV format. Use 8-bit or 16-bit PCM.")
			return

	audio_data = wav.data

	var bytes_per_sample = bits_per_sample / 8
	total_frames = audio_data.size() / (channels * bytes_per_sample)

	if total_frames <= 0:
		push_error("WAV contains no audio samples.")
		return

	# Start at the beginning
	sample_position = 0.0

	# Replace stream with generator
	var generator := AudioStreamGenerator.new()
	generator.mix_rate = sample_rate
	generator.buffer_length = 0.2

	stream = generator
	play()

	playback = get_stream_playback() as AudioStreamGeneratorPlayback


func start_rewind() -> void:
	rewinding = true


func stop_rewind() -> void:
	rewinding = false


func _process(_delta: float) -> void:
	if playback == null:
		return

	fill_audio_buffer()


func fill_audio_buffer() -> void:
	var frames := playback.get_frames_available()

	for i in range(frames):

		if rewinding:
			sample_position -= rewind_speed
		else:
			sample_position += 1.0

		sample_position = clampf(
			sample_position,
			0.0,
			float(total_frames - 1)
		)

		var left := read_interpolated(sample_position, 0)
		var right := left

		if channels == 2:
			right = read_interpolated(sample_position, 1)

		playback.push_frame(Vector2(left, right))


func read_interpolated(pos: float, channel: int) -> float:
	var index_a := int(floor(pos))
	var index_b := mini(index_a + 1, total_frames - 1)

	var fraction := pos - index_a

	var a := read_sample(index_a, channel)
	var b := read_sample(index_b, channel)

	return lerpf(a, b, fraction)


func read_sample(index: int, channel: int) -> float:
	var bytes_per_sample := bits_per_sample / 8
	var offset := (index * channels + channel) * bytes_per_sample

	if bits_per_sample == 8:
		# WAV 8-bit PCM is unsigned
		return (float(audio_data.decode_u8(offset)) - 128.0) / 128.0

	if bits_per_sample == 16:
		return float(audio_data.decode_s16(offset)) / 32768.0

	return 0.0
