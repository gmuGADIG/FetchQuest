extends Area2D

@export var speed : float = 500.0
@export var damage : int = 1
@export var knockback_strength: float = 250

var direction: Vector2:
	get: 
		return Vector2.RIGHT.rotated(rotation)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hurt(DamageEvent.new(damage, direction * knockback_strength))
		queue_free()
	elif body is SpeakAura:
		deflect(body)

func _on_despawn_timer_timeout() -> void:
	queue_free()

func hurt(damage: DamageEvent) -> void: pass

func deflect(source: SpeakAura) -> void:
	# Deflect projectiles on bark
	print("i have seen dog deflect bullet")
	rotation = source.position.angle_to_point(position)
	
