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
var can_spawn = true #can spawn subordinates
var can_hit = true
var can_move = true
var isin = false
var is_slow = false
var is_boss = false
var is_enraged = false
var has_shield = false
var has_dot = false
var dot_linger = 1.0
var max_cooldown = 3
var cooldown = 3
var max_cooldown_II = 10
var cooldown_II = 10
var ammo = 5
var enraged_factor = 3
var ai_num = 0 #0 is axe I; 1 is archer I; 2 is axe II
var subordinates = []
var max_subordinates = 3 #+1
var projectile_scene = preload("res://scenes/EnemyProjectile.tscn")
# Get a reference to the player. It's likely different in your project

func _ready() -> void:
	dot_linger = GlobalVariables.linger
	speed = base_speed
	player = get_parent().get_node("Player")
	tail = get_parent().get_node("Tail")
	prog = $TextureProgressBar
	health = max_health
	cooldown = max_cooldown
	
func _physics_process(delta):
	if dot_linger > 0:
		dot_linger -= delta
	else:
		has_dot = false
	if is_slow:
		speed = GlobalVariables.slow_factor * base_speed
	else:
		speed = base_speed
	if has_dot:
		health -= 1 * Engine.time_scale * GlobalVariables.poison_potency
	prog.value = (((prog.max_value - prog.min_value) / max_health) * health) + prog.min_value
	if is_enraged:
		speed *= enraged_factor
	
	# Set player_position to the position of the player node
	player_position = player.position
	# Calculate the target position
	target_position = (player_position - position).normalized()
	
	velocity = target_position * speed
	if is_boss:
		boss_I_ai(delta)
	elif ai_num == 0:
		axe_I_ai()
	elif ai_num == 1:
		archer_I_ai(delta)
	elif ai_num == 2:
		axe_II_ai(delta)
		
	if has_shield:
		$Sprite2D/ShieldSprite.show()
		$Sprite2D/AnimationPlayer.play("shield")
	else:
		$Sprite2D/ShieldSprite.hide()
	
	if health <= 0:
		GlobalVariables.exp += int(damage)
		while GlobalVariables.exp >= GlobalVariables.exp_cap:
			GlobalVariables.exp -= GlobalVariables.exp_cap
			GlobalVariables.level += 1
			if GlobalVariables.level >= 5:
				GlobalVariables.skill_points += 1
			GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
		if is_boss:
			get_parent().is_raining = false
		queue_free()
		
		

func _on_timer_timeout() -> void:
	can_hit= true
	player.modulate = Color(1, 1, 1)
	tail.modulate = Color(1, 1, 1)
	for i in range(player.segments.size()):
		player.segments[i].get_child(0).modulate = Color(1, 1, 1) 
	if isin == true:
		if can_hit:
			$Hurtbox/Timer.start()
			can_hit = false
			GlobalVariables.health -= damage/GlobalVariables.defense
			player.modulate = Color(3, 0, 0)
			tail.modulate = Color(3, 0, 0)
			for i in range(player.segments.size()):
				player.segments[i].get_child(0).modulate = Color(3, 0, 0) 

func deal_damage(def:float):
	isin = true
	can_move = false
	if can_hit:
		$Hurtbox/Timer.start()
		player.stay_red_counter = 60
		can_hit = false
		GlobalVariables.health -= int(damage/def)
		player.modulate = Color(3, 0, 0)
		tail.modulate = Color(3, 0, 0)
		for i in range(player.segments.size()):
			player.segments[i].get_child(0).modulate = Color(3, 0, 0) 


var is_hurtbox_active = true

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_enraged = false
		if !is_boss and ai_num == 2:
			cooldown = max_cooldown
		deal_damage(GlobalVariables.defense)
	elif body.name.contains("Segment"):
		is_enraged = false
		if !is_boss and ai_num == 2:
			cooldown = max_cooldown
		deal_damage(GlobalVariables.defense * GlobalVariables.scale_toughness)

	
func _on_hurtbox_body_exited(body: Node2D) -> void:
	isin = false
	if body.name == "Player" or body.name.contains("Segment"):
		can_move = true
		
func shoot() -> void:
	var proj = projectile_scene.instantiate()
	proj.scale *= scale
	proj.global_position = get_child(0).get_child(0).global_position
	call_deferred("add_sibling", proj)

func axe_I_ai() -> void:
	$AnimationPlayer.play("axe_idle")
	if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
			
func axe_II_ai(delta: float) -> void:
	$Sprite2D.z_index = 2
	$AnimationPlayer.play("axe_II_idle")
	cooldown -= delta
	if cooldown > 0:
		if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
		$CollisionShape2D.disabled = false
	elif cooldown > -1:
		$Sprite2D.look_at(player_position)
		$Sprite2D.rotation_degrees += 90
	elif cooldown > -3:
		$CollisionShape2D.disabled = true
		is_enraged = true
		if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
	else:
		$CollisionShape2D.disabled = false
		is_enraged = false
		cooldown = max_cooldown
	
func archer_I_ai(delta: float) -> void:
	$AnimationPlayer.play("archer_idle")
	if cooldown > 0:
		cooldown -= delta
		if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
	else:
		shoot()
		cooldown = max_cooldown
	
	

func boss_I_ai(delta: float) -> void:
	$Sprite2D/ShieldSprite.scale = Vector2(2, 2)
	$Sprite2D/ShieldSprite.position = Vector2(0, 0)
	z_index = 100
	cooldown -= delta
	if health > max_health/2:
		if cooldown > 0:
			$AnimationPlayer.play("boss_idle")
			$CollisionShape2D.disabled = false
			$Hurtbox/CollisionShape2D.disabled = false
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
		else:
			$AnimationPlayer.play("boss_hop")
			$CollisionShape2D.disabled = true
			$Hurtbox/CollisionShape2D.disabled = true
			$Sprite2D.rotation_degrees -= 90
			velocity = $Sprite2D.transform.x * speed*3
			$Sprite2D.rotation_degrees += 90
			move_and_slide()
	else:
		get_parent().is_raining = true
		if subordinates.size() <= max_subordinates and can_spawn:
			has_shield = true
			get_parent().spawn(3, 1.5, 2, 1, false, false, 2)
			subordinates.append(get_parent().e)
			get_parent().e.position = position
		else:
			can_spawn = false
		for s in subordinates:
			if !is_instance_valid(s):
				subordinates.erase(s)
		if subordinates.size() <= 0:
			has_shield = false
			cooldown -= delta
			cooldown_II -= delta
			if cooldown_II <= 0:
				can_spawn = true
				cooldown_II = max_cooldown_II
			if cooldown > 0:
				$AnimationPlayer.play("boss_idle")
				$CollisionShape2D.disabled = false
				$Hurtbox/CollisionShape2D.disabled = false
				$Sprite2D.look_at(player_position)
				$Sprite2D.rotation_degrees += 90
			else:
				$AnimationPlayer.play("boss_hop")
				$CollisionShape2D.disabled = true
				$Hurtbox/CollisionShape2D.disabled = true
				$Sprite2D.rotation_degrees -= 90
				velocity = $Sprite2D.transform.x * speed*3
				$Sprite2D.rotation_degrees += 90
				move_and_slide()
			


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "boss_hop":
		cooldown = max_cooldown
