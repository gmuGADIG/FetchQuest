extends Node2D
#path_follow: The path the target follows
#target_node: The rigid body that is the target
#target_collision: The collison bodu for the target
#timer: Countdown timer for the targets
@onready var path_follow : PathFollow2D = $Path2D/PathFollow2D
@onready var target_node: Node2D = $"."
@onready var target_collision: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = Timer.new()

#Speed: The speed the targets move
#collision_zone: The area in which the player must be in for the targets to move
#sprite The spride that the target has taken shape of
#timeStart: The Start of the coutdown timer
#timeScale: The "flash" value for the target
#flashStart: The time at which the flash will start
#Generally you would want the start, scale, flashStart to be the same throughout
#the targets. This will keep them "in sync" and not have any offsets on when they finish
#or when then start
@export var speed:= 100
@export var collision_zone: Area2D
@export var sprite: Sprite2D
@export var timeStart: int
@export var timeScale: float
@export var flashStart: int

#dir: A bool for the direction of which way the target should be moving (left or right)
#go: Condition to start moving the targers
var dir: bool = false
var go: bool = false

#This fucntion creates the main timer for the targers
#this also connects the timer, on entered and exit signals
func _ready() -> 	void:
	
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	collision_zone.connect("body_shape_entered", Callable(self, "_on_body_shape_entered"))
	collision_zone.connect("body_shape_exited", Callable(self, "_on_body_shape_exited"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_target_move(delta)

#This function is what makes the targets move
#Progress ratio conditional makes sures the target doesn't skip back to the start
#The skipping is possible to occur if the speed is high
#This function also has the targets flash, and plays that animation
func _target_move(delta:float) -> void:
	target_collision.global_position = sprite.global_position
	if go == true && timeStart != 0:
		if dir == false:
			path_follow.progress += speed * delta
			if path_follow.progress_ratio > .95:
				dir = true
		else:	
			path_follow.progress -= speed * delta
			if path_follow.progress < 10:
				dir = false
	if (timer.time_left < flashStart && timer.time_left > 0):
		$"AnimationPlayer".play("TargetFlash")
	else:
		$"AnimationPlayer".pause()
		$"AnimationPlayer".play("RESET")

#This function does as it says, it shuts down everything when the timer is done
#or if the player exits the area and resets any neccesary values
func _shutdown() -> void:
	go = false
	dir = false
	path_follow.progress = 0.0
	timer.stop()
	$"AnimationPlayer".speed_scale = 1
	$"AnimationPlayer".play("RESET")
#This function starts the timer for the targets, ultimatly starting the target movements
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	timer.start(timeStart)
	go = true
#This function calls the shutdown method to shutdown everything when the player exits the area
func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	#shutdown method yet to be implemeted to reset everything upon exited area
	_shutdown()

#This function calls the shutdown method when the timer runs out
func _on_timer_timeout() -> void:
	_shutdown()

#The hard coded int is how fast the flash animation can run, max is around 60-64, I have it limited to 34
#This function increases the rates of the flash animation by the timeScale variable
func _timescale() -> void:
	if($"AnimationPlayer".speed_scale + timeScale <=34):
		$"AnimationPlayer".speed_scale += timeScale
	
