extends Node2D
class_name Switch

@onready var sprite: Sprite2D = $Sprite2D
@onready var toggle_area: TriggerArea = $ToggleArea

@export var on_texture: Resource    # The texture to display when the switch is toggled on
@export var off_texture: Resource   # The texture to display when the switch is toggled off
@export var interact_action: String # The input action the player can use to toggle the switch

@export var is_on: bool = false     # Whether or not the switch is on (off by default)
var player_in_range: bool = false   # Whether or not the player is in range of the switch (calculated at runtime)

signal toggled(new_value: bool)     # Signal emitted when the switch is toggled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_area.touched_by.connect(toggle_enter)
	toggle_area.object_left.connect(toggle_exit)
	set_texture(is_on)
	
# Called when a node enters the trigger area
func toggle_enter(body: Node2D) -> void:
	if body is ThrownSword:
		toggle()
	if body is Player:
		player_in_range = true
		
# Switches the state of the switch
func toggle() -> void:
	is_on = not is_on
	set_texture(is_on)
	toggled.emit(is_on)
		
# Called when a node exits the toggle's area
func toggle_exit(body: Node2D) -> void:
	if body is Player:
		player_in_range = false

# Handles the player input for toggling
func _input(event: InputEvent) -> void:
	if event.is_action_pressed(interact_action):
		if player_in_range:
			toggle()

# Sets the texture of the sprite to reflect the state
func set_texture(on: bool) -> void:
	sprite.texture = on_texture if on else off_texture
