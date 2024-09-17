extends Node2D
class_name Switch

@export var on_texture: Resource
@export var off_texture: Resource
@export var interact_action: String
@onready var sprite: Sprite2D = $Sprite2D
@onready var toggle_area: TriggerArea = $ToggleArea

var is_on: bool = false
var player_in_range: bool = false
signal toggled(new_value: bool)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_area.touched_by.connect(toggle_enter)
	toggle_area.object_left.connect(toggle_exit)
	set_texture(is_on)
	
func toggle_enter(body: Node2D) -> void:
	if body is ThrownSword:
		toggle()
	if body is Player:
		player_in_range = true
		
func toggle() -> void:
	is_on = not is_on
	set_texture(is_on)
	toggled.emit(is_on)
		
func toggle_exit(body: Node2D) -> void:
	if body is Player:
		player_in_range = false
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(interact_action):
		if player_in_range:
			toggle()

func set_texture(on: bool) -> void:
	sprite.texture = on_texture if on else off_texture
