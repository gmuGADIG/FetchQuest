extends ProgressBar

#Grab Enemy
@export var boss : Enemy 
#grab value

func _on_boss_health_changed() -> void:
	value = boss.health
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = boss.max_health
	value = boss.health
	boss.health_changed.connect(_on_boss_health_changed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss == null:
		queue_free()
		is_queued_for_deletion()
	pass

#on value change

#reset value to enemy health
