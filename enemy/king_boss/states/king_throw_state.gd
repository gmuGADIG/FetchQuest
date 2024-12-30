class_name KingThrowState extends KingState

var current_scepter:KingThrownScepter = null
func enter() -> void:
	for i in range(king.total_scepter_throws):
		if state_machine.current_state != self:
			return
		throw()
		await current_scepter.scepter_returned
	if state_machine.current_state != self:
		return
	state_machine.change_state(self, "Idle")

func update(_delta:float) -> void:
	pass

func exit() -> void:
	pass

func throw() -> void:
	current_scepter = king.thrown_scepter_scene.instantiate()
	current_scepter.thrower = king
	current_scepter.global_position = king.global_position
	current_scepter.throw((Player.instance.global_position - king.global_position).normalized())
	current_scepter.scepter_barked.connect(_on_scepter_barked)
	king.add_sibling(current_scepter)

func create_lost_scepter(pos:Vector2) -> void:
	var lost_scepter:KingDroppedScepter = king.lost_scepter_scene.instantiate()
	lost_scepter.global_position = pos
	king.add_sibling(lost_scepter)
	king.current_lost_scepter = lost_scepter

func _on_scepter_barked(position:Vector2) -> void:
	create_lost_scepter(position)
	state_machine.change_state(self, "Vulnerable")
