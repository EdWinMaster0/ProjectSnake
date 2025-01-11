extends CharacterBody2D

@export var speed = 400
@export var num_segments = 3
@export var delay_frames = 12  # speed 200 => 24, speed 400=> 12
var segments = []
var position_history = []
var dir_history = []
var segment_scene = preload("res://scenes/Segment.tscn")
var s
func _ready():
	for i in range(num_segments):
		s = segment_scene.instantiate()
		segments.append(s)
		call_deferred("add_sibling", s)
	for i in range(segments.size()):
		print("asd:",segments[i], i)

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

	for i in range(num_segments):
		if position_history.size() > (num_segments)*delay_frames:
			segments[i].position = position_history[(num_segments-i)*delay_frames]
			segments[i].rotation = dir_history[(num_segments-i)*delay_frames].angle()
		elif position_history.size() > (i+1)*delay_frames:
			segments[i].position = position_history[(position_history.size()%delay_frames)]
			segments[i].rotation = dir_history[position_history.size()%delay_frames].angle()
			
		
	if dir.length() > 0:  # Ensure there's movement
		rotation = dir.angle()
