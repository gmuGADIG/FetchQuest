extends Enemy

@onready var sprite_normal: Sprite2D = $TennisBall
@onready var sprite_activated: Sprite2D = $TennisBallAngry
@onready var sprite_stunned: Sprite2D = $TennisBallStunned

func _process(delta: float) -> void:
	enemy_state = EnemyState.AGRESSIVE
	enemy_sprite = sprite_normal

func _ready() -> void:
	super._ready()
