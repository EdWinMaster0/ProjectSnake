extends Area2D

# Initial speed of the projectile
var speed = 700
# Deceleration rate
var deceleration = 600
# Velocity vector for the projectile
var velocity = Vector2()

# Puddle scene to be loaded (ensure you've preloaded the scene)
var puddle_scene = preload("res://scenes/Puddle.tscn")

# Array to keep track of puddles
static var puddles = []

func _ready() -> void:
	# Point the projectile towards the mouse
	look_at(get_global_mouse_position())
	
	# Initialize velocity to move in the direction the projectile is facing
	velocity = transform.x * speed

func _physics_process(delta):
	# Apply deceleration: reduce the velocity towards zero
	if velocity.length() > 0:  # only decelerate if there's movement
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	# Update position based on the velocity
	position += velocity * delta

	# Optionally, destroy the projectile when it's almost stopped
	if velocity.length() < 1:
		create_puddle()
		queue_free()

func create_puddle() -> void:
	# Create the puddle node
	var puddle = puddle_scene.instantiate()
	get_parent().add_child(puddle)  # Add the puddle to the same parent as the projectile
	puddle.position = position  # Set the puddle at the current position of the projectile

	# Add the new puddle to the list
	puddles.append(puddle)
	
	# If there are more than 3 puddles, remove the oldest one
	if puddles.size() > 3:
		var oldest_puddle = puddles.pop_front()  # Remove the first puddle from the list
		if oldest_puddle:  # Ensure it's valid before freeing
			oldest_puddle.queue_free()
