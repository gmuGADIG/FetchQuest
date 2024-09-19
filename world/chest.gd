extends Sprite2D

# Properties to fine-tune the chest
var opened := false
@export var closed_texture : CompressedTexture2D
@export var opened_texture : CompressedTexture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Opens the chest
func open_chest() -> void:
	# If the chest was already opened, then forgettaboutit
	if (opened):
		return
