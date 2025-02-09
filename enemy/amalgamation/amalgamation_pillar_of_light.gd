extends Node2D

## How long the pillar will fall for (set in the amalg pillars state based of amalgamation.gd)
var fall_time:float = 0

var check_for_player:bool = false
func _ready() -> void:
	#TODO use animationplayer possibly
	# Animate the transparency towards 1
	var ring_sprites := $RingSprites as Node2D
	ring_sprites.modulate = Color.TRANSPARENT
	var attack_sprites:= $AttackSprites as Node2D
	attack_sprites.modulate = Color.TRANSPARENT

	var t := 2.8 + randf_range(-.25, .25)
	var tween := create_tween()
	tween.tween_property(ring_sprites, "rotation_degrees", 720 * 2, t)
	tween.parallel().tween_property(ring_sprites, "modulate", Color.WHITE, t)

	tween.tween_property(ring_sprites, "rotation_degrees", 720 * 2.75, 0.6)

	await tween.finished
	attack_sprites.modulate = Color.WHITE
	check_for_player = true
	MainCam.shake(20)
	await get_tree().create_timer(0.5).timeout
	queue_free()


var hit_player := false
func _process(_delta: float) -> void:
	# Hurt the player once the animation is over
	if hit_player: return
	if $PlayerDetector.overlaps_body(Player.instance) and check_for_player:
		Player.instance.hurt(DamageEvent.new(1))
		hit_player = true
