class_name AmalgamationChewingState extends AmalgamationState

## The distance that the player is spat out
@onready var spitting_distance:float = amalgamation.spitting_distance
## The duration of this state
@onready var duration:float = amalgamation.chewing_state_duration;

func enter() -> void:
	# Play animation
	amalgamation.animation_player.play("Chewing")
	
	print("amalgamation_chewing_state.gd: nom nom nom nom nom")
	
	# Hide the player while chewing
	Player.instance.modulate.a = 0
	
	# Chew for 'duration' seconds, then idle
	await get_tree().create_timer(duration).timeout
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
