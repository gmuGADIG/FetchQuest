class_name AmalgamationSuckingState extends AmalgamationState


@export var sucking_speed:float = 200
func enter() -> void:
	await get_tree().create_timer(10).timeout
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")
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
	pass

# Called when a bomb or player enters the mouth of the amalgamation
func _on_mouth_area_body_entered(body: Node2D) -> void:
	if state_machine.current_state != self:
		return
	if body is Player:
		# Eat the player 
		state_machine.change_state(self, "Chewing")
	elif body is not ThrownSword:
		# Blow up the bomb (body must be bomb due to collision mask)
		body.hurt(DamageEvent.new(0))

		# Switch to vulnerable state
		state_machine.change_state(self, "Vulnerable")
