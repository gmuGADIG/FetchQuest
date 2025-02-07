class_name AmalgamationVulnerableState extends AmalgamationState

## How long the boss stays vulnerable after it is triggered
@onready var duration:float = amalgamation.vulnerable_state_duration

func enter() -> void:
	# Play animation
	amalgamation.anim_sprite.play("vuln")
	amalgamation.shader.set_shader_parameter("enabled", true)

	# Enable taking damage for 'duration' seconds, then idle
	%VulnerableHurtArea.set_process(true)
	await get_tree().create_timer(duration).timeout
	if amalgamation.state_machine.current_state != self:
		return
	amalgamation.state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	# Disable taking damage
	%VulnerableHurtArea.set_process(false)
	amalgamation.shader.set_shader_parameter("enabled", false)

# Called when the amalgamation is hit by the player's attacks
func _on_vulnerable_hit_area_body_entered(body: Node2D) -> void:
	if amalgamation.state_machine.current_state != self:
		return
	
	# The amount of damage that the amalgamation will take
	var damage:int = 0

	# Sword case
	if body is ThrownSword:
		damage = 1
	# Bomb case
	elif body is Bomb:
	# Wait for the bomb's timer to go off
		for child in body.get_children():
			if child is Timer:
				await child.timeout
				damage = body.damage
				break

	# Hurt the boss if still vulnerable (necessary check due to waiting on the bomb timer)
	if amalgamation.state_machine.current_state == self:
		amalgamation.hurt(DamageEvent.new(damage))
