class_name AmalgamationVulnerableState extends AmalgamationState

func enter() -> void:
	# Enable taking damage for 5 seconds
	%VulnerableHitArea.set_process(true)
	await get_tree().create_timer(5).timeout
	state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	# Disable taking damage
	%VulnerableHitArea.set_process(false)

# Called when the amalgamation is hit by the player's attacks
func _on_vulnerable_hit_area_body_entered(body: Node2D) -> void:
	if state_machine.current_state != self:
		return
	
	# The amount of damage that the amalgamation will take
	var damage:int = 0

	# Sword case
	if body is ThrownSword:
		damage = 1
	# Bomb case
	else:
		damage = body.damage
		body.hurt(DamageEvent.new(0))
	print("amalgamation_vulnerable_state.gd: Amalgamation takes " + str(damage) + " damage")
	
