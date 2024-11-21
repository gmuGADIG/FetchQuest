class_name Bomb extends CharacterBody2D

@export var time_till_explode: int = 2
@export var damage: int = 10
@export var damage_to_player: int = 1
@export var knockback: float = 10
var explode_timer := Timer.new()

func _ready() -> void:
	add_child(explode_timer)
	explode_timer.wait_time = time_till_explode
	explode_timer.one_shot = true
	explode_timer.timeout.connect(explode)
	explode_timer.start()

func explode() -> void:
	$Explosion.visible = true
	$BombSprite.visible = false
	var damaged_area := get_node("Explosion")
	var damaged_things :Array[Node2D]= damaged_area.get_overlapping_bodies()
	print(damaged_things)
	for thing in damaged_things:
		if thing.has_method("hurt") and !(thing is Bomb):
			if (thing is Player):
				thing.hurt(DamageEvent.new(damage_to_player, velocity.normalized() * knockback)) 
			else:
				thing.hurt(DamageEvent.new(damage, velocity.normalized() * knockback)) 
	
	#TODO: change animation
	#get_node("BombSprite").scale.x *= 4
	#get_node("BombSprite").scale.y *= 4
	await get_tree().create_timer(0.1).timeout
	print("KABOOM")

	queue_free()

#Only will be called when the bomb is hit by the players' sword, and will only explode if the bomb is stopped.
#This change was made in response to the bomb immediately exploding if it was hit by the sword, which caused the player
#to have a chance if damaging themselves as soon as they threw the bomb.
func hurt(_damage_event: DamageEvent) -> void:
	const STILL_SPEED := 50.0 # bomb is considered stationary of below this speed
	if velocity.length() < STILL_SPEED:
		explode_timer.stop()
		explode()

#Updates the velocity of the bomb, and ensures that after the bomb has reached a small enough velocity it stops
func _physics_process(_delta: float) -> void:
	velocity *= 0.9
	
	print("speed = ", velocity.length())
		
	move_and_slide()
