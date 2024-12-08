# NOTE: This script exists for testing enemy interactions, as well as to
# give an idea how an enemy might be programmed. Once higher quality enemies
# are made, they should be in their own scripts, and this should be ignored.

class_name TestEnemy extends Enemy

func _ready() -> void:
	# All enemy subclasses must call super._ready().
	super._ready()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if velocity == Vector2.ZERO: return
	var best: Vector2
	var best_dot := -INF

	for v: Vector2 in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
		if velocity.dot(v) > best_dot:
			best_dot = velocity.dot(v)
			best = v
	
	var anim: String
	match best:
		Vector2.LEFT:
			anim = "fly_left"
		Vector2.RIGHT:
			anim = "fly_right"
		Vector2.UP:
			anim = "fly_up"
		Vector2.DOWN:
			anim = "fly_down"
	
	if $AnimatedSprite2D.animation != anim or not $AnimatedSprite2D.is_playing():
		$AnimatedSprite2D.play(anim)

func _on_hitting_area_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		player.hurt(DamageEvent.new(1))
