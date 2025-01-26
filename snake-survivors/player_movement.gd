extends CharacterBody2D

@export var speed = 400
@export var num_segments = 2
var delay_frames = (4800 / speed)  # speed 200 => 24, speed 400 => 12 // When to make the segment follow the player/last segment
var segments = []
var position_history = []
var tail_pos: Vector2
var dir_history = []
var tail_dir: Vector2
var segment_scene = preload("res://scenes/Segment.tscn")
var projectile_scene = preload("res://scenes/Projectile.tscn")
var stay_red_counter = -1

var timeout = 2
var can_shoot = true

func _ready():
	timeout = GlobalVariables.p_cooldown
	for i in range(num_segments):
		var s = segment_scene.instantiate()
		segments.append(s)
		s.z_index = num_segments-i
		s.name = str("Segment", i)
		call_deferred("add_sibling", s)
	z_index = num_segments+1
	GlobalVariables.level = num_segments -1
	tail_pos = position
	tail_dir = Vector2(1, 0)

var dir
func get_input():
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	dir = input_direction

func _physics_process(delta):
	if get_parent().is_in_menu == false:
		get_input()
	move_and_slide()
	
	delay_frames = (4800 / speed)/Engine.time_scale
	# Add a segment for every level earned
	while GlobalVariables.level > num_segments-1:
		num_segments += 1
		var s = segment_scene.instantiate()
		segments.append(s)
		s.name = str("Segment", num_segments)
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
		# Shoot from the player
		proj.position = position + dir_history[dir_history.size() - 1] * 30
		can_shoot = false
		timeout = GlobalVariables.p_cooldown
		
	if stay_red_counter == 0:
		modulate = Color(1, 1, 1)
		$"../Tail".modulate = Color(1, 1, 1)
		for i in range(segments.size()):
			segments[i].get_child(0).modulate = Color(1, 1, 1) 
		stay_red_counter -= 1
		get_node("../Tail").modulate = Color(1, 1, 1)
	elif stay_red_counter > 0:
		modulate = Color(3, 0, 0)
		for i in range(segments.size()):
			segments[i].get_child(0).modulate = Color(3, 0, 0) 
		stay_red_counter -= 1
		get_node("../Tail").modulate = Color(3, 0, 0)
	# Save where the player's direction and position history for the segments
	if position_history.is_empty() or position != position_history.back():
		position_history.append(position)
		dir_history.append(dir)
	# Start following the player after delay_frames is 0
	if position_history.size() > delay_frames * (num_segments + 1):
		# 2 to close the gap between the last segment and the tail
		tail_pos = position_history[2]
		# Delete the oldest position in the position history, place the newest in the first index
		position_history.pop_front()
		tail_dir = dir_history[2]
		# Same as position_history
		dir_history.pop_front()
		
	for i in range(num_segments):
		# If each segment has moved already:
		if position_history.size() > (num_segments)*delay_frames:
			# Follow the player and its direction, behind by delay_frames amount of frames
			# Calculated from backwards, move the right segment
			segments[i].position = position_history[(num_segments-i)*delay_frames]
			segments[i].rotation = dir_history[(num_segments-i)*delay_frames].angle()
		# If each segment hasn't moved already:
		elif position_history.size() > (i+1)*delay_frames:
			# Calculate with position_history instead of number of segments
			# This makes the snake start clumped up in one position, and moving makes the segments and tail come out one by one
			segments[i].position = position_history[position_history.size()-(i+1)*delay_frames]
			segments[i].rotation = dir_history[position_history.size()-(i+1)*delay_frames].angle()
		elif get_parent().is_in_menu == false:
			segments[i].position = position
	$"../Tail".position = tail_pos
	$"../Tail".rotation = tail_dir.angle()
		
	if dir.length() > 0:
		rotation = dir.angle()
