extends Sprite2D

@export var can_be_blue := true
@export var can_be_purple := true

func _ready() -> void:
	update_color()

func update_color() -> void:
	var seed := abs(global_position.dot(Vector2(67, 83))) as int # pick "random" number based on position. each component is multiplied by an arbitrary prime number
	if can_be_blue and can_be_purple:
		frame = seed % 8
	elif can_be_blue and not can_be_purple:
		frame = seed % 4
	elif not can_be_blue and can_be_purple:
		frame = seed % 4 + 4
	else:
		pass
	
