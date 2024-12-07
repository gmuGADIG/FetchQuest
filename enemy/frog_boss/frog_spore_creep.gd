extends Node2D

@export var max_scale: float = 2.0      # Maximum scale the puddle will grow to
@export var grow_time: float = 1.0      # Time it takes to grow to max scale
@export var shrink_time: float = 3.0    # Time it takes to shrink from max scale to zero
@export var puddle_texture: Texture2D   # Texture for the puddle

var sprite: Sprite2D

func _ready() -> void:
	# Create and set up the sprite
	sprite = Sprite2D.new()
	sprite.texture = puddle_texture
	sprite.centered = true
	sprite.scale = Vector2.ZERO   # Start at zero scale
	add_child(sprite)
	
	# Start the growing process
	start_growing()

func start_growing() -> void:
	# Use a Tween to smoothly scale the puddle up to max_scale
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2.ONE * max_scale, grow_time)
	tween.tween_callback(start_shrinking)

func start_shrinking() -> void:
	# After growing, start shrinking back to zero scale
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2.ZERO, shrink_time)
	tween.tween_callback(queue_free)
