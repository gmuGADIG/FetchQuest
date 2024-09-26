extends HBoxContainer

var player : Player

@export var heart : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Player.instance
	assert(player != null, "Player does not exist in the scene!")
	update_heart_display()
	player.player_hurt.connect(update_heart_display)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_heart_display() -> void:
	for _child in get_children():
		remove_child(_child)
		_child.queue_free()
	for h in player.health:
		add_child(heart.instantiate())
