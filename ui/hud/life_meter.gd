extends Control

@onready var stamina_nine_patch: NinePatchRect = %Stamina
@onready var stamina_container_nine_patch: NinePatchRect = %StaminaContainer

@onready var heart_background_spawn: Node2D = %HeartBackgroundSpawn
@onready var hearts: Control = %Hearts
@onready var heart_backgrounds: Control = %HeartBackgrounds
@onready var heart_container_nine_patch: NinePatchRect = %HeartContainer
@onready var bone_texture := preload("res://ui/hud/Health-Stamina-Item-Points Bar/Bone.png")
@onready var half_bone_texture := preload("res://ui/hud/Health-Stamina-Item-Points Bar/half_bone.png")

@onready var bomb_counter: Label = %BombCounter
@onready var sword: TextureRect = %Sword

const PX_PER_STAMINA: float = (272 - 35) / 3.
const MAX_STAMINA_START: float = 314

const PX_PER_HP: float = 83.
const MAX_HP_START: float = 444.

func _ready() -> void:
	PlayerInventory.max_stamina_updated.connect(_on_max_stamina_updated)
	PlayerInventory.max_health_updated.connect(_on_max_health_updated)
	PlayerInventory.bombs_updated.connect(_on_bombs_updated)
	Player.instance.stamina_changed.connect(_on_player_stamina_changed)
	Player.instance.health_changed.connect(_on_player_health_changed)

	Player.instance.sword_thrown.connect(sword.hide)
	Player.instance.sword_caught.connect(sword.show)

	_on_max_stamina_updated.call_deferred()
	_on_max_health_updated.call_deferred()
	_on_bombs_updated.call_deferred()

func _on_bombs_updated() -> void:
	bomb_counter.text = str(PlayerInventory.bombs)

var last_max_health_x := 0
func _on_max_health_updated() -> void:
	# WARN: this does not support max health going down or being below 6
	var x := ceili(PlayerInventory.max_health / 2.) - 3 - last_max_health_x

	# spawn shit
	for i in x:
		# spawn health background
		var offset := PX_PER_HP * (last_max_health_x + i + 1)
		# print("[life_meter] offset = ", offset)
		var t := TextureRect.new()
		t.texture = preload("res://ui/hud/Health-Stamina-Item-Points Bar/Health Bar Background Extender Thing.png")
		t.position = heart_background_spawn.position + offset * Vector2.RIGHT
		heart_backgrounds.add_child(t)

		# spawn bone
		var heart: TextureRect = hearts.get_child(-1).duplicate()
		heart.position.x += PX_PER_HP
		hearts.add_child(heart)

	# push container
	heart_container_nine_patch.size.x += x * PX_PER_HP

	last_max_health_x = x
	_on_player_health_changed()

func _on_player_health_changed() -> void:
	var health := Player.instance.health

	for heart: TextureRect in hearts.get_children():
		# print("[life_meter] health = ", health)
		heart.visible = health > 0

		if health == 1:
			heart.texture = half_bone_texture
		else:
			heart.texture = bone_texture

		health -= 2

func _on_max_stamina_updated() -> void:
	# HUD is made under the assumption max_stamina is 3
	var x := PlayerInventory.max_stamina - 3
	stamina_container_nine_patch.size.x = MAX_STAMINA_START + (x * PX_PER_STAMINA)

func _on_player_stamina_changed() -> void:
	stamina_nine_patch.size.x = 35 + (PX_PER_STAMINA * Player.instance.stamina)
