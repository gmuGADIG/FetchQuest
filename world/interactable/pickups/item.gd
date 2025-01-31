extends CharacterBody2D
class_name Item

enum ItemPhysicsState {
	## Following the sword
	FOLLOWING,
	## Chillin.
	IDLE,
	## Cannot be interacted with 
	INTANGIBLE,
	## Follow the player
	FOLLOW_PLAYER
}

var physics_state: ItemPhysicsState = ItemPhysicsState.IDLE

@export var acceleration: float = 50.0
@export var speed: float = 20.0

const actual_follow_player_speed := 1800.0
var follow_player_speed := actual_follow_player_speed

## By default, collected items respawn when the scene is loaded.
## If true, this is prevented, making this item only able to be picked up one time.
@export var single_use := false

var target: Node2D

## Array of node paths, each corresponding to the path of a single-use item that's been collected already
static var collected_single_use_items: Array[NodePath] = []

func _ready() -> void:
	if single_use and collected_single_use_items.has(get_path()):
		queue_free()
		return

func _on_pickup_area_body_entered(other: Node2D) -> void:
	if (other.has_method("pickup_item")):
		other.pickup_item(self)

func follow_player() -> void:
	if physics_state == ItemPhysicsState.FOLLOW_PLAYER: return
	physics_state = ItemPhysicsState.FOLLOW_PLAYER
	follow_player_speed = 0.
	create_tween().tween_property(self, "follow_player_speed", actual_follow_player_speed, 1.)

func follow(other: Node2D, follow_speed: float) -> void:
	#When an item is something that should not be movable by the sword.
	if physics_state == ItemPhysicsState.INTANGIBLE:
		return
		
	target = other
	speed = follow_speed
	physics_state = ItemPhysicsState.FOLLOWING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match physics_state:
		ItemPhysicsState.FOLLOWING:
			if (is_instance_valid(target) and global_position.distance_to(target.global_position) <= 100):
				velocity = (target.global_position - global_position) * speed
			else:
				physics_state = ItemPhysicsState.IDLE
				target = null
		ItemPhysicsState.IDLE:
			var cur_speed: float = velocity.length()
			cur_speed = max(cur_speed - acceleration, 0)
			velocity = velocity.normalized() * cur_speed
		ItemPhysicsState.INTANGIBLE:
			velocity = Vector2.ZERO
		ItemPhysicsState.FOLLOW_PLAYER:
			print("[item] follow_player_speed = ", follow_player_speed)
			var dir := global_position.direction_to(Player.instance.global_position)
			velocity = dir * follow_player_speed 
		_:
			assert(false, "Unreachable")
	move_and_slide()

func consume(_consumer: Node2D) -> void:
	if single_use: collected_single_use_items.append(get_path())

## Animate the item when the chest is opened.
func animate() -> void:
	print("[item] animate()")
	physics_state = ItemPhysicsState.INTANGIBLE
	
	const animation_height := 100.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", position.y - animation_height, 0.5)
	
	await tween.finished
	follow_player()
