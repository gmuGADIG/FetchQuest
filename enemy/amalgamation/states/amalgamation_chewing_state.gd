class_name AmalgamationChewingState extends AmalgamationState

## The distance that the player is spat out
@onready var spitting_distance:float = amalgamation.spitting_distance

func enter() -> void:
	amalgamation.animation_player.play("Chewing")
	print("amalgamation_chewing_state.gd: nom nom nom nom nom")
	Player.instance.modulate.a = 0
	# Chew for 3 seconds, then idle
	await get_tree().create_timer(3).timeout
	if amalgamation.state_machine.current_state != self:
		return
	amalgamation.state_machine.change_state(self, "Idle")
	
func update(_delta:float) -> void:
	# Trap the player in the mouth
	Player.instance.global_position = %MouthArea.global_position

func exit() -> void:
	# Spit the player out
	var tween:Tween = create_tween()
	tween.tween_property(Player.instance,"global_position",%MouthArea.global_position + Vector2(0, spitting_distance), .25)
	Player.instance.modulate.a = 1
