extends CPUParticles2D

# Exported variables for external tuning in the editor
@export var thrown_sword: ThrownSword   # Reference to the thrown sword object
@export var max_velocity: float         # Maximum velocity for the particle burst

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Connect the sword's bounce signal to trigger the spark function
	thrown_sword.bounce_sword.connect(spark)

# Function to create a burst of particles (sparks) when the sword bounces
func spark(intensity: float) -> void:
	# Set the particles to emit a burst
	emitting = true
	
	# Configure the burst properties
	lifetime = 0.1  # The duration of the particle emission
	one_shot = true  # Ensure the particles emit only once per bounce
	
	# Set particle velocity based on the intensity of the bounce
	initial_velocity_max = max_velocity * intensity
	initial_velocity_min = initial_velocity_max * 0.75  # Slight variation in velocity
	
	# Restart the particle system to trigger the burst
	restart()
