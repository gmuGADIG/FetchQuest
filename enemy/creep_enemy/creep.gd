extends Area2D
## The amount of damge that the creep does per tick
@export var damage:int = 1
## The time that the creep will stay alive after reaching full size
@export var sustain_time:float = 2
## How much the creep grows per tick
@export var growth:float = 1

# State machine ish variables 
var growth_over:bool = false
var sustain_over:bool = false

# The variable that contains the player if it is in the creep
var found_player:Player = null

func _ready() -> void:
	$SustainTimer.wait_time = sustain_time
	$SustainTimer.start()

func _physics_process(delta: float) -> void:
	# Grow if we arent done growing
	if not growth_over:
		scale += Vector2(growth * delta, growth * delta)

	# Shrink if we have stayed alive for long enough
	elif sustain_over:
		scale -= Vector2(growth * delta, growth * delta)
		scale = scale.max(Vector2.ZERO)
		# Kill creep if it is too small
		if scale < Vector2.ZERO:
			queue_free()
	# If the player is in the creep and not rolling, hurt the player
	if found_player:
		if not found_player.rolling:
			found_player.hurt(DamageEvent.new(damage))

func _on_sustain_timer_timeout() -> void:
	# Switch to sustaining
	if not growth_over:
		growth_over = true
		$SustainTimer.start()
	
	# Switch to shrinking
	elif not sustain_over:
		sustain_over = true

func _on_body_entered(body: Node2D) -> void:
	# Show the player is in the creep
	if body is Player:
		found_player = body


func _on_body_exited(body: Node2D) -> void:
	# Show the player is not in the creep
	if body is Player:
		found_player = null
