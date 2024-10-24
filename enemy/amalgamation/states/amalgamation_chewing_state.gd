class_name AmalgamationChewingState extends AmalgamationState

func enter() -> void:
	print("amalgamation_chewing_state.gd: nom nom nom nom nom")
	# Chew for 3 seconds, then idle
	await get_tree().create_timer(3).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")
	
func update(_delta:float) -> void:
	# Trap the player in the mouth
	Player.instance.global_position = %MouthArea.global_position

func exit() -> void:
	# Hurt the player and spit it out
	Player.instance.hurt(DamageEvent.new(1))
	var tween:Tween = create_tween()
	tween.tween_property(Player.instance,"global_position",%MouthArea.global_position + Vector2(0,300), .25)
