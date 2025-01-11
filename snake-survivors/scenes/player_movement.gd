extends CharacterBody2D

@export var speed = 400
@export var num_segments = 10
@export var delay_frames = 12  # speed 200 => 24, speed 400=> 12
var segments = []
var position_history = []
var dir_history = []
var segment_scene = preload("res://scenes/Segment.tscn")
func _ready():
	for i in range(num_segments):
		var s = segment_scene.instantiate()
		segments.append(s)
		s.z_index = num_segments-i
		call_deferred("add_sibling", s)
	z_index = num_segments+1

var dir
func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	dir = input_direction

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	if position != position_history.back():
		position_history.append(position)
		dir_history.append(dir)

	if position_history.size() > delay_frames * (num_segments + 1):
		position_history.pop_front()
		dir_history.pop_front()

	for i in range(num_segments):
		if position_history.size() > (num_segments)*delay_frames:
			segments[i].position = position_history[(num_segments-i)*delay_frames]
			segments[i].rotation = dir_history[(num_segments-i)*delay_frames].angle()
		elif position_history.size() > (i+1)*delay_frames:
			segments[i].position = position_history[position_history.size()-(i+1)*delay_frames]
			segments[i].rotation = dir_history[position_history.size()-(i+1)*delay_frames].angle()
			
		
	if dir.length() > 0:
		rotation = dir.angle()
