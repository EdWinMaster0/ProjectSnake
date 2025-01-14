extends CharacterBody2D

@export var speed = 100 
@export var health = 100
var player_position
var target_position
var damage = 100
var player
var tail
var canhit = true
var isin = false
# Get a reference to the player. It's likely different in your project

func _ready() -> void:
	player = get_parent().get_node("Player")
	tail = get_parent().get_node("Tail")
 
func _physics_process(delta):
	
	# Set player_position to the position of the player node
	player_position = player.position
	# Calculate the target position
	target_position = (player_position - position).normalized()
 
	velocity = target_position * speed
	# Check if the enemy is in a 3px range of the player, if not move to the target position
	if position.distance_to(player_position) > 3:
		move_and_slide()
		look_at(player_position)
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
		print(body.name, " entered")
		deal_damage(GlobalVariables.defense)
	elif body.name.contains("Segment"):
		print(body.name, " entered")
		deal_damage(GlobalVariables.defense * GlobalVariables.scale_toughness)
			
func _on_hurtbox_body_exited(body: Node2D) -> void:
	isin = false
