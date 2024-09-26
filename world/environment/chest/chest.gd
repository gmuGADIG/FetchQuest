extends Area2D

var opened := false
var player: Player

# Assign one item for it to drop always,
# or assign multiple for a random chance drop, if needed.
@export var loot_table : Array[PackedScene]

@onready var closed_sprite: Sprite2D = %ClosedSprite
@onready var open_sprite: Sprite2D = %OpenSprite

func _ready() -> void:
	player = Player.instance
	assert(player != null, "Player does not exist in the scene!")

func _process(_delta: float) -> void:
	# NOTE: might be better to handle input in the player instead?
	if Input.is_action_just_pressed("interact") and player in get_overlapping_bodies():
		open_chest()

## Opens the chest.
func open_chest() -> void:
	# If the chest was already opened, then forgettaboutit
	if opened:
		print("Already opened!")
		return
	
	# Otherwise, let's game.
	opened = true
	print("Opening chest: ", get_path())
	closed_sprite.visible = false
	open_sprite.visible = true
	
	# Picks a random item from the list and spawns it at the chest.
	var item : PackedScene = loot_table.pick_random()
	var spawned := item.instantiate()
	spawned.position = position
	add_sibling(spawned)
	