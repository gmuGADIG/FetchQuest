class_name KingDeadState extends KingState

func enter() -> void:
	king.teleport_timer.stop()
	king.animated_sprite.play("dead")
