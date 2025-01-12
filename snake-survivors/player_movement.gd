extends CharacterBody2D

@export var speed = 400
@export var num_segments = 3
@export var delay_frames = 12  # speed 200 => 24, speed 400=> 12
var segments = []
var position_history = []
var tail_pos: Vector2
var dir_history = []
var tail_dir: Vector2
var segment_scene = preload("res://scenes/Segment.tscn")
var projectile_scene = preload("res://scenes/Projectile.tscn")

var timeout = 1
var can_shoot = true

func _ready():
	for i in range(num_segments):
		var s = segment_scene.instantiate()
		segments.append(s)
		s.z_index = num_segments-i
		call_deferred("add_sibling", s)
	z_index = num_segments+1
	GlobalVariables.level = num_segments -2
	tail_pos = position
	tail_dir = Vector2(1, 0)

var dir
func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	dir = input_direction

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	while GlobalVariables.level > num_segments-2:
		num_segments += 1
		var s = segment_scene.instantiate()
		segments.append(s)
		call_deferred("add_sibling", s)
		for i in range(segments.size()):
			segments[i].z_index +=1
		z_index += 1

	
	# Venom shot cooldown
	timeout -= delta
	if timeout <=0:
		can_shoot = true
		
	if Input.is_action_just_pressed("Action") && can_shoot == true:
		var proj = projectile_scene.instantiate()
		call_deferred("add_sibling", proj)
		proj.position = position + dir_history[dir_history.size() - 1] * 30
		can_shoot = false
		timeout = 1
		
		
	
	if position_history.is_empty() or position != position_history.back():
		position_history.append(position)
		dir_history.append(dir)

	if position_history.size() > delay_frames * (num_segments + 1):
		tail_pos = position_history[2]
		position_history.pop_front()
		tail_dir = dir_history[2]
		dir_history.pop_front()
		
	for i in range(num_segments):
		if position_history.size() > (num_segments)*delay_frames:
			segments[i].position = position_history[(num_segments-i)*delay_frames]
			segments[i].rotation = dir_history[(num_segments-i)*delay_frames].angle()
		elif position_history.size() > (i+1)*delay_frames:
			segments[i].position = position_history[position_history.size()-(i+1)*delay_frames]
			segments[i].rotation = dir_history[position_history.size()-(i+1)*delay_frames].angle()
		else:
			segments[i].position = position
	$"../Tail".position = tail_pos
	$"../Tail".rotation = tail_dir.angle()
		
	if dir.length() > 0:
		rotation = dir.angle()
