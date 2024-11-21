extends Area2D
class_name FrogShockwave

@export var cuts: int = 100
@export var width: float = 1
@export var speed: float = 10
@export var max_radius: float = 1000
@export var damage: int = 1

@onready var collider: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D

var radian_vectors: Array = []

var radius: float = 1

func _ready() -> void:
	compute_sines_and_cosines()
	
func _physics_process(delta: float) -> void:
	radius += speed * delta
	sprite.scale.x = radius
	sprite.scale.y = radius
	if (radius > max_radius):
		queue_free()
	draw_ring()
	
func compute_sines_and_cosines() -> void:
	var step: float = (2 * PI) / cuts
	for cut in range(cuts + 1):
		var radian: float = step * cut
		var radian_pos: Vector2 = Vector2(cos(radian), sin(radian))
		radian_vectors.append(radian_pos)

func draw_ring() -> void:
	var pos_list: PackedVector2Array = PackedVector2Array()
	var color_list: PackedColorArray = PackedColorArray()
	var step: float = (2 * PI) / cuts
	for point: Vector2 in radian_vectors:
		var outer_position: Vector2 = point * radius * 30
		pos_list.append(outer_position)
		
	for i in range(cuts + 1):
		var point: Vector2 = radian_vectors[cuts-i]
		var inner_pos: Vector2 = point * (radius-width) * 30
		pos_list.append(inner_pos)
	
	collider.polygon = pos_list

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		var player: Player = body as Player
		var knockback := global_position.direction_to(player.global_position) * 600
		player.hurt(DamageEvent.new(damage, knockback))
