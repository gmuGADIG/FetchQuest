class_name KingVulnerableState extends KingState
var target_position:Vector2
var panic_count:int = 0
func enter() -> void:
	target_position = random_move_point(20)
	panic_count = 0
	king.bubble_sprite.visible = false

func update(_delta:float) -> void:
	if abs(king.global_position.distance_to(king.current_lost_scepter.global_position)) < 10:
		state_machine.change_state(self, "Idle")
	handle_target_choices()
	move_towards_target()


func exit() -> void:
	king.current_lost_scepter.queue_free()
	king.current_lost_scepter = null
	king.bubble_sprite.visible = true
func handle_target_choices() -> void:
	if king.current_lost_scepter == null:
		return
	
	if abs(king.global_position.distance_to(target_position)) < 10:
		target_position = random_move_point(king.panic_distance)
		panic_count += 1
	if panic_count > king.total_panic_points:
		target_position = king.current_lost_scepter.global_position

func random_move_point(distance:float) -> Vector2:
	return king.global_position + Vector2(randf_range(-1,1), randf_range(-1,1)).normalized() * distance

func move_towards_target() -> void:
	king.velocity = (target_position - king.global_position).normalized() * king.panic_speed
	king.move_and_slide()
