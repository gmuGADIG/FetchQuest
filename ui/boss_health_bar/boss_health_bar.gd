extends CanvasLayer

#Grab Enemy
@onready var progress_bar: ProgressBar = %ProgressBar
@export var boss : Enemy 
#grab value

func _on_boss_health_changed() -> void:
	progress_bar.value = boss.health

func _ready() -> void:
	progress_bar.max_value = boss.max_health
	progress_bar.value = boss.max_health
	boss.health_changed.connect(_on_boss_health_changed)

func _process(_delta: float) -> void:
	if boss == null:
		queue_free()
		is_queued_for_deletion()

#on value change

#reset value to enemy health
