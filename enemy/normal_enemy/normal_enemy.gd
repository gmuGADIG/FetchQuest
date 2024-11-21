extends Enemy

@onready var sprite_normal: Sprite2D = $TennisBall
@onready var sprite_activated: Sprite2D = $TennisBallAngry
@onready var sprite_stunned: Sprite2D = $TennisBallStunned

func _ready() -> void:
	super._ready()
	$PlayerDetectionComponent.player_detected.connect(_on_player_detected)
	enemy_state = EnemyState.ROAMING
	enemy_sprite = sprite_normal
	
func _on_player_detected() -> void:
	enemy_state = EnemyState.AGRESSIVE
	enemy_sprite = sprite_activated
	print("AAAAAAAAAAAAAAAAAAAAAAA")
