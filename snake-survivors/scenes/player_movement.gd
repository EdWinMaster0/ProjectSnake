extends CharacterBody2D

@export var speed = 200
@export var num_segments = 3
@export var delay_frames = 25  # How many frames ago to store the position
@export var index = 1
var mouse_position = null
var segments = []
var position_history = []
var dir_history = []
var segment_node: CharacterBody2D

var head_collision_shape: CollisionShape2D
var segment_collision_shapes: Array = []

func _ready():
	segment_node = get_node("../Segment")

# Called when the node enters the scene tree for the first time
	# Assuming the trail sprite is a child of the player node
var dir
func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	dir = input_direction

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	if position_history.size() <= delay_frames:
		pass

	# Check if player position changed and store the new position
	if position != position_history.back():  # Only update if position has changed
		position_history.append(position)
		dir_history.append(dir)

	# Keep only the last `delay_frames` positions in history
	if position_history.size() > delay_frames * (num_segments + 1):
		position_history.pop_front()
		dir_history.pop_front()

	if position_history.size() > (num_segments)*delay_frames:
		segment_node.position = position_history[(num_segments)*delay_frames]
		segment_node.rotation = dir_history[(num_segments)*delay_frames].angle()
		
	if dir.length() > 0:  # Ensure there's movement
		rotation = dir.angle()
