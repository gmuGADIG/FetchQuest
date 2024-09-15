extends Node2D

# Speed at which the camera moves through the noise for the shake effect
@export var noise_shake_speed: float = 30.0
# Rate at which the shake strength decays over time
@export var shake_decay_rate: float = 5.0
# Reference to the thrown sword object
@export var thrown_sword: ThrownSword
# Maximum strength of the shake effect
@export var max_shake_strength: float = 60.0

# Reference to the camera that will be shaken
var camera: Camera2D
# Random number generator and noise generator, initialized on ready
@onready var rand: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var noise: FastNoiseLite = FastNoiseLite.new()

# Keeps track of our position within the noise to allow smooth transitions
var noise_i: float = 0.0
# Current shake strength, decaying over time
var shake_strength: float = 0.0

# Called when the node is ready (initialized)
func _ready() -> void:
	camera = get_viewport().get_camera_2d()  # Get the camera from the viewport
	rand.randomize()                         # Randomize the seed for noise generation
	noise.seed = rand.randi()                # Seed the noise generator
	noise.frequency = 2                      # Set the frequency of the noise pattern
	thrown_sword.bounce_sword.connect(apply_noise_shake)  # Connect the bounce signal to shake the camera

# Applies a noise shake effect when the sword bounces
func apply_noise_shake(intensity: float) -> void:
	# Set the shake strength based on the bounce intensity and max shake strength
	shake_strength = intensity * max_shake_strength

# Called every frame to update the shake effect
func _process(delta: float) -> void:
	# Gradually reduce the shake strength over time (decay effect)
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	
	# Adjust the camera's offset based on the noise-generated shake
	if (camera != null):
		camera.offset = get_noise_offset(delta)

# Calculates the noise-based offset for camera shake
func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed  # Increment the noise index to create continuous noise
	
	# Generate two different noise values for the x and y axis for the shake
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,    # Noise for the x-axis offset
		noise.get_noise_2d(100, noise_i) * shake_strength   # Noise for the y-axis offset
	)
