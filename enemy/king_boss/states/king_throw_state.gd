class_name KingThrowState extends KingState

## The currently thrown scepter
var current_scepter:KingThrownScepter = null

func enter() -> void:
	# Wait until king teleports
	await king.teleport_timer.timeout
	
	# Throw all scepters, waiting until it returns to throw the next one
	for i in range(king.total_scepter_throws):
		if state_machine.current_state != self:
			return
		king.animated_sprite.play("scepter_throw")
		await king.animated_sprite.animation_finished
		throw()
		await current_scepter.scepter_returned
		king.animated_sprite.play("scepter_catch")
		await king.animated_sprite.animation_finished
	# Switch to idle if king hasnt been forced into vulnerable state
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")

func throw() -> void:
	# Instantiate scepter and set parameters
	current_scepter = king.thrown_scepter_scene.instantiate()
	current_scepter.thrower = king
	current_scepter.global_position = king.global_position
	# Throw scepter at player
	current_scepter.throw((Player.instance.global_position - king.global_position).normalized())
	current_scepter.scepter_barked.connect(_on_scepter_barked)
	# Add scepter to the scene
	king.add_sibling(current_scepter)

func create_lost_scepter(pos:Vector2) -> void:
	var lost_scepter:Node2D = king.lost_scepter_scene.instantiate()
	lost_scepter.global_position = pos
	king.add_sibling(lost_scepter)
	king.current_lost_scepter = lost_scepter

func _on_scepter_barked(position:Vector2) -> void:
	create_lost_scepter(position)
	state_machine.change_state(self, "Vulnerable")
