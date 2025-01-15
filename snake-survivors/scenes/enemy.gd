extends CharacterBody2D

@export var base_speed = 100
var speed = 100 
@export var max_health = 100
var health = 100
var player_position
var target_position
var damage = 100
var player
var tail
var prog
var canhit = true
var isin = false
var is_slow = false
var is_boss = false
var has_dot = false
# Get a reference to the player. It's likely different in your project

func _ready() -> void:
	speed = base_speed
	player = get_parent().get_node("Player")
	tail = get_parent().get_node("Tail")
	prog = $TextureProgressBar
	health = max_health
 
func _physics_process(delta):
	
	if is_slow:
		speed = GlobalVariables.slow_factor * base_speed
	else:
		speed = base_speed
	if has_dot:
		health -= 1 * Engine.time_scale * GlobalVariables.poison_potency
	prog.value = (((prog.max_value - prog.min_value) / max_health) * health) + prog.min_value
	
	# Set player_position to the position of the player node
	player_position = player.position
	# Calculate the target position
	target_position = (player_position - position).normalized()
 
	velocity = target_position * speed
	# Check if the enemy is in a 3px range of the player, if not move to the target position
	if position.distance_to(player_position) > 3:
		move_and_slide()
		$Sprite2D.look_at(player_position)
		$Sprite2D.rotation_degrees += 90
	if health <= 0:
		GlobalVariables.exp += int(damage)
		while GlobalVariables.exp >= GlobalVariables.exp_cap:
			GlobalVariables.exp -= GlobalVariables.exp_cap
			GlobalVariables.level += 1
			GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
		queue_free()
		

func _on_timer_timeout() -> void:
	canhit= true
	player.modulate = Color(1, 1, 1)
	tail.modulate = Color(1, 1, 1)
	for i in range(player.segments.size()):
		player.segments[i].get_child(0).modulate = Color(1, 1, 1) 
	if isin == true:
		if canhit:
			$Hurtbox/Timer.start()
			canhit = false
			GlobalVariables.health -= damage/GlobalVariables.defense
			player.modulate = Color(3, 0, 0)
			tail.modulate = Color(3, 0, 0)
			for i in range(player.segments.size()):
				player.segments[i].get_child(0).modulate = Color(3, 0, 0) 

func deal_damage(def:float):
	isin = true
	if canhit:
		$Hurtbox/Timer.start()
		player.stay_red_counter = 60
		canhit = false
		GlobalVariables.health -= int(damage/def)
		player.modulate = Color(3, 0, 0)
		tail.modulate = Color(3, 0, 0)
		for i in range(player.segments.size()):
			player.segments[i].get_child(0).modulate = Color(3, 0, 0) 


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		deal_damage(GlobalVariables.defense)
	elif body.name.contains("Segment"):
		deal_damage(GlobalVariables.defense * GlobalVariables.scale_toughness)
			
func _on_hurtbox_body_exited(body: Node2D) -> void:
	isin = false
