# NOTE: This script exists for testing enemy interactions, as well as to
# give an idea how an enemy might be programmed. Once higher quality enemies
# are made, they should be in their own scripts, and this should be ignored.

class_name TestEnemy extends Enemy

func _ready() -> void:
	# All enemy subclasses must call super._ready().
	super._ready()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	approach(Player.instance.global_position)

func _on_hitting_area_body_entered(body: Node2D) -> void:
	var player := body as Player
	if player != null:
		player.hurt(1)
