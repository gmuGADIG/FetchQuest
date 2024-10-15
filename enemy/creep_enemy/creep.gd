extends Area2D
@export var damage:int = 1
@export var sustain_time:float = 2
@export var growth:float = 1

var growth_over:bool = false
var sustain_over:bool = false
var found_player:Player = null

func _ready() -> void:
	$SustainTimer.wait_time = sustain_time
	$SustainTimer.start()

func _physics_process(delta: float) -> void:
	if not growth_over:
		scale += Vector2(growth * delta, growth * delta)
	
	elif not sustain_over:
		pass
	
	elif sustain_over:
		scale -= Vector2(growth * delta, growth * delta)
		scale = scale.max(Vector2.ZERO)
		if scale == Vector2.ZERO:
			queue_free()

	if found_player:
		if not found_player.rolling:
			found_player.hurt(DamageEvent.new(damage))

func _on_sustain_timer_timeout() -> void:
	if not growth_over:
		growth_over = true
		$SustainTimer.start()
	elif not sustain_over:
		sustain_over = true

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		found_player = body


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		found_player = null
