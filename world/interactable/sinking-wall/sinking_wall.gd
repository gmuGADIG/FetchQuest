extends StaticBody2D

@onready var notSunk := get_node("unsunkWall")
@onready var sunk := get_node("sunkenWall")
@onready var hitbox := get_node("hitBox")

#current wall timer is on 8 seconds
var wallTime : float = 8.00

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raiseWall()

#Called when wall timer ends 
func raiseWall() -> void:
	notSunk.show()
	sunk.hide()
	set_collision_layer_value(1,true)
	set_collision_layer_value(3,true)
	
	
func hurt(_damage_event: DamageEvent) -> void:
	notSunk.hide()
	sunk.show()
	set_collision_layer_value(1,false)
	set_collision_layer_value(3,false)
	$wallTimer.start(wallTime)
