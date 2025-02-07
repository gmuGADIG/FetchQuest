extends Container
# song really starts at 1.65 and really "ends" at 107 due to daniel's export settings
const song_start := 1.65
const song_duration := 107 - song_start
# we want to compute the speed such that the bottom of the conveyor reaches the
# top of the screen in time
@onready var speed := (global_position.y + size.y) / song_duration
@onready var clock := song_start

func _process(delta: float) -> void:
	clock -= delta
	if clock > 0: return
	
	position.y -= delta * speed
