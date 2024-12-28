extends Node2D

#The node where the dummies are stored
@export var dummy_container: Node2D

#The amount of time before damage is omitted from the DPS calculation
@export var damage_expiration_time : float = 5.0
static var damage : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dummy_container == null:
		printerr("DummyGroup: Needs a Node2D container for the dummies")
	
	var dummies : Array = dummy_container.get_children() 
	
	if dummies.is_empty():
		printerr("Error: DummyGroup should have at least 1 dummy as a child")
	
	for dummy : Dummy in dummies:
		dummy.dummy_hit.connect(dummy_hit)
	pass # Replace with function body.
	
	

func dummy_hit(damage_event : DamageEvent) -> void:
	damage += damage_event.damage
	print(damage)
	update_dps()
	await get_tree().create_timer(damage_expiration_time).timeout
	damage -= damage_event.damage
	update_dps()
	pass

func update_dps() -> void:
	$DPSCounter.text = str(float(damage)/damage_expiration_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_damage_expiration_timeout() -> void:
	pass # Replace with function body.
