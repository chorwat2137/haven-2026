extends Node
var highscore:int = 0
const SAVE_PATH = "user://save.cfg"
# Called when the node enters the scene tree for the first time.
func save_game():
	var config = ConfigFile.new()
	config.set_value("player", "highscore", highscore)
	config.save(SAVE_PATH)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func load_game():
	var config = ConfigFile.new()

	if config.load(SAVE_PATH) == OK:
		highscore = config.get_value("player", "highscore", 0)
