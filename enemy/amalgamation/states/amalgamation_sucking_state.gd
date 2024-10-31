class_name AmalgamationSuckingState extends AmalgamationState

## The particle effect that will be triggered when the boss is sucking
@onready var sucking_effect:CPUParticles2D = $"../../SuckingEffect"
## The speed in pixels per second that the amalgamation everything in at
@onready var sucking_speed:float = amalgamation.sucking_speed

func enter() -> void:
	amalgamation.animation_player.play("Sucking")
	print("amalgamation_sucking_state.gd: vacuum noises")
	# Turn on the particles
	sucking_effect.emitting = true
	 
	# Idle after sucking for 10 seconds
	await get_tree().create_timer(10).timeout
	if amalgamation.state_machine.current_state != self:
		return
	amalgamation.state_machine.change_state(self, "Idle")
	pass

func update(_delta:float) -> void:
	# NOTE Theres gotta be a better way than checking every frame
	# mayhaps keep var holding all in area and update as they enter/exit
	# but for now its prototyping so dont tell anyone :3
	
	# Add to the position
	for body:Node2D in %SuckingArea.get_overlapping_bodies():
		# Move every node2d (on the sucking area mask layers) towards the mouth area
		var direction_to_mouth:Vector2 = body.global_position.direction_to(%SuckingArea.global_position)
		body.position += direction_to_mouth * _delta * sucking_speed

func exit() -> void:
	# Turn off the particles
	sucking_effect.emitting = false

# Called when a bomb or player enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if amalgamation.state_machine.current_state != self:
		return
	if body is Player:
		# Eat the player 
		amalgamation.state_machine.change_state(self, "Chewing")
	elif body is Bomb:
		# Wait for the bomb to explode
		for child in body.get_children():
			if child is Timer:
				await child.timeout
				break;
		# Switch to vulnerable state after explosion
		if amalgamation.state_machine.current_state == self:
			amalgamation.state_machine.change_state(self, "Vulnerable")
