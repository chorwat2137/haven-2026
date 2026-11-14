extends Polygon2D

const BAR_COUNT: int = 32
const FREQ_MAX: float = 11050.0
const MIN_DB: int = 60

var spectrum: AudioEffectSpectrumAnalyzerInstance
var heights: Array[Height] = []
var bar_width: float = 0.0
	 
func _ready() -> void:
	spectrum = AudioServer.get_bus_effect_instance(1, 0)
	_on_resized()
	for i: int in BAR_COUNT:
		heights.append(Height.new())
	
func _process(_delta: float) -> void:
	_update_spectrum_data()
	queue_redraw()
	
func _draw() -> void:
	for i: int in BAR_COUNT:
		var l_color: Color = Color.from_hsv((BAR_COUNT * 0.6 + i * 0.5) / BAR_COUNT, 0.5, 0.6)
		var l_rect: Rect2 = Rect2(
			i * bar_width,					#pos x
			size.y - heights[i].actual,			#pos y
			bar_width - 2,			# width
			heights[i].actual # height
		)
		draw_rect(l_rect, l_color)
		
		
func _on_resized() -> void:
	bar_width = size.x / BAR_COUNT
	
func _update_spectrum_data() -> void:
	var l_prev_hz: float = 0.0
	for i: int in BAR_COUNT:
		var l_hz: float = (i + 1) * FREQ_MAX / BAR_COUNT
		var l_magnitude: float = spectrum.get_magnitude_for_frequency_range(l_prev_hz, l_hz).length()
		var l_energy: float = clampf((MIN_DB + linear_to_db(l_magnitude)) / MIN_DB, 0 , 1)
		var l_height: float = l_energy * size.y * 10
		
		if l_height > heights[i].high:
			heights[i].high = l_height
		else:
			heights[i].high	= lerp(heights[i].high, l_height, 0.1)
			
		if l_height <= 0.0:
			heights[i].low = lerp(heights[i].low, l_height, 0.1)
			
		heights[i].actual = lerp(heights[i].low, heights[i].high, 0.1)
		l_prev_hz = l_hz
	
class Height:
	var high: float
	var low: float
	var actual: float
	
