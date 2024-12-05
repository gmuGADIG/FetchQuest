extends Node2D

signal tongue_stuck(position: Vector2)

@export var tongue_speed: float = 1000.0    # Speed at which the tongue extends
@export var tongue_texture: Texture2D       # Texture for the tongue

var target_position: Vector2
var moving: bool = false
var total_distance: float = 0.0
var distance_traveled: float = 0.0

var tongue_sprite: Sprite2D

func _ready() -> void:
	# Create and set up the tongue sprite
	tongue_sprite = Sprite2D.new()
	tongue_sprite.texture = tongue_texture
	tongue_sprite.centered = false      # Important for stretching from the origin
	tongue_sprite.position = Vector2.ZERO
	tongue_sprite.scale = Vector2.ZERO  # Start with zero length
	add_child(tongue_sprite)

func move_to(target_pos: Vector2) -> void:
	target_position = target_pos
	moving = true
	distance_traveled = 0.0
	
	# Calculate direction and rotation
	var direction: Vector2 = target_position - global_position
	total_distance = direction.length()
	rotation = direction.angle()
	
	tongue_sprite.scale.x = 0.0  # Reset tongue length

func _process(delta: float) -> void:
	if moving:
		# Calculate the distance to extend this frame
		var move_distance: float = tongue_speed * delta
		distance_traveled += move_distance
		
		if distance_traveled >= total_distance:
			distance_traveled = total_distance
			moving = false
			tongue_stuck.emit(target_position)
		
		# Adjust the scale of the tongue sprite to simulate stretching
		var texture_width: float = tongue_sprite.texture.get_width()
		if texture_width > 0:
			var scale_x: float = distance_traveled / texture_width
			tongue_sprite.scale.x = scale_x
