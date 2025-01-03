class_name Bomb extends CharacterBody2D

@export var time_till_explode: int = 2
@export var damage: int = 10
@export var damage_to_player: int = 1
@export var knockback: float = 10

@onready var explosion_area: Area2D = %ExplosionArea
@onready var animator: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	await get_tree().create_timer(time_till_explode).timeout
	explode()

var exploded := false
func explode() -> void:
	if exploded: return
	exploded = true

	var damaged_things := explosion_area.get_overlapping_bodies()

	for thing in damaged_things:
		if thing.has_method("hurt") and !(thing is Bomb):
			var hurt_damage := damage_to_player if thing is Player else damage
			thing.hurt(DamageEvent.new(hurt_damage, velocity.normalized() * knockback, DamageEvent.DamageType.Bomb)) 

	MainCam.shake(35, 0.06)
	$Explosion.visible = true
	$BombSprite.visible = false
	animator.play("explode")
	await animator.animation_finished

	queue_free()

#Only will be called when the bomb is hit by the players' sword, and will only explode if the bomb is stopped.
#This change was made in response to the bomb immediately exploding if it was hit by the sword, which caused the player
#to have a chance if damaging themselves as soon as they threw the bomb.
func hurt(_damage_event: DamageEvent) -> void:
	const STILL_SPEED := 50.0 # bomb is considered stationary of below this speed
	if velocity.length() < STILL_SPEED:
		explode()

#Updates the velocity of the bomb, and ensures that after the bomb has reached a small enough velocity it stops
func _physics_process(_delta: float) -> void:
	velocity *= 0.9
	
	print("speed = ", velocity.length())
		
	move_and_slide()
