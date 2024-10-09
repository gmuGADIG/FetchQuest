extends CharacterBody2D

@export var time_till_explode: int = 2
@export var damage: int = 10
@export var knockback: float = 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var explode_timer := Timer.new()
	add_child(explode_timer)
	explode_timer.wait_time = time_till_explode
	explode_timer.one_shot = true
	explode_timer.timeout.connect(explode)
	explode_timer.start()
	
	
	

func explode() -> void:
	var damaged_area := get_node("ExplosionArea")
	var damaged_things :Array[Node2D]= damaged_area.get_overlapping_bodies()
	print(damaged_things)
	for thing in damaged_things:
		if thing is Enemy or thing is Player:
			thing.hurt(DamageEvent.new(damage, velocity.normalized() * knockback)) 
			
	#TODO: change animation
	get_node("BombSprite").scale.x *= 4
	get_node("BombSprite").scale.y *= 4
	await get_tree().create_timer(0.1).timeout
	print("KABOOM")

	queue_free()

func hurt(_damage_event: DamageEvent) -> void:
	explode()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	velocity *= 0.9
	move_and_slide()
	
