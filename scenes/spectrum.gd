extends PanelContainer

const BAR_COUNT: int = 20
const FREQ_MAX: float = 11050.0
const MIN_DB: int = 60

var spectrum: AudioEffectSpectrumAnalyzerInstance
var heights: Array[Height] = []
var bar_width: float = 0.0
	 
func _ready() -> void:
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	
func _process(_delta: float) -> void:
	_update_spectrum_data()
	_draw()
	
func _draw() -> void:
	pass
	
func _on_resized() -> void:
	bar_width = size.x / BAR_COUNT
	
func _update_spectrum_data() -> void:
	pass
	
class Height:
	var high: float
	var low: float
	var actual: float
	
