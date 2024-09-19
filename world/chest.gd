extends Sprite2D

# Properties to fine-tune the chest
var opened := false
var player_instance : Player
var collider : Area2D

@export var closed_texture : CompressedTexture2D
@export var opened_texture : CompressedTexture2D

# Assign one item for it to drop always,
# or assign multiple for a random chance drop, if needed.
@export var loot_table : Array[PackedScene]
@export var min_distance := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_instance = get_tree().get_nodes_in_group("Player")[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("interact") and
	position.distance_to(player_instance.position) < min_distance):
		open_chest()

# Opens the chest.
func open_chest() -> void:
	
	# If the chest was already opened, then forgettaboutit
	if (opened):
		print("Already opened!")
		return
	
	# Otherwise, let's game.
	opened = true
	print("Opening chest: ", self)
	texture = opened_texture
	
	var item : PackedScene = loot_table.pick_random()
	var spawned := item.instantiate()
	add_sibling(spawned)
	spawned.position = position
	
