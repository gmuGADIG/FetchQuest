extends Enemy
class_name Dummy

signal dummy_hit(damage_event : DamageEvent)

func _process_roaming(delta: float) -> void:
	pass
	
func _process_agressive(delta: float) -> void:
	pass
	
func hurt(damage_event: DamageEvent) -> void:
	dummy_hit.emit(damage_event)
	hitFlicker()
