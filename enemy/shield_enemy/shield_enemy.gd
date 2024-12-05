class_name ShieldEnemy extends Enemy

## The size of the shield in degrees (360 is a full shield and 0 is no shield)
@export_range(0, 360, 0.025) var shield_size:float = 60

var idle_path:String = "uid://crpi8s5u67ra5"
var walking_path:String = "uid://dsqmxhv5w2k1o"

# NOTE 	This movement code is taken from the test_enemy 
#   	and will probably not stay like this forever
func _ready() -> void:
	# Wait a single frame in case our _ready was called before the player's
	await get_tree().process_frame

func _physics_process(_delta: float) -> void:
	if Player.instance == null: 
		return

	# Move towards and look at the player 
	var movement_direction := (Player.instance.global_position - global_position).normalized()
	velocity = movement_direction * 300#movement speed
	look_at(Player.instance.global_position)
	move_and_slide()

## Called when something gets close to the enemy
func _on_shield_body_entered(body: Node2D) -> void:
	# Angle between the enemy and the object near the enemy
	var angle_to_body:float = rad_to_deg(get_angle_to(body.global_position))

	# Variable showing if the shield was hit (ignored by some objects like the bomb)
	var hit_shield:bool = (-shield_size / 2) < angle_to_body and angle_to_body < (shield_size / 2)
	
	# Deflect ThrownSwords
	if body is ThrownSword and hit_shield:
		print("shield_enemy.gd: hit shield")
		body.return_sword()

	#NOTE Any other things to deflect should follow similar logic
