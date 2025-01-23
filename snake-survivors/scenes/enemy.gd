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
	# This makes the dot effect stay after leaving the puddle
	if dot_linger > 0:
		dot_linger -= delta
	else:
		has_dot = false
	# Slows the enemy, multiplies the enemy speed by slow_factor
	if is_slow:
		speed = GlobalVariables.slow_factor * base_speed
	else:
		speed = base_speed
	# Makes the dot effect deal damage every frame
	if has_dot:
		health -= 1 * Engine.time_scale * GlobalVariables.poison_potency
	prog.value = (((prog.max_value - prog.min_value) / max_health) * health) + prog.min_value
	# This is for the axe II enemy, which stops, then charges at the player
	if is_enraged:
		speed *= enraged_factor
	
	# Set player_position to the position of the player node
	player_position = player.position
	# Calculate the target position
	target_position = (player_position - position).normalized()
	
	# Calculate velocity
	velocity = target_position * speed
	# Activate the ai of the enemy that was randomly selected in main_map_1.gd
	if is_boss:
		boss_I_ai(delta)
	elif ai_num == 0:
		axe_I_ai()
	elif ai_num == 1:
		archer_I_ai(delta)
	elif ai_num == 2:
		axe_II_ai(delta)
		
	# Show shield animation
	if has_shield:
		$Sprite2D/ShieldSprite.show()
		$Sprite2D/AnimationPlayer.play("shield")
	else:
		$Sprite2D/ShieldSprite.hide()
	
	# Give xp after enemy dies
	if health <= 0:
		# Amount based on enemy damage
		GlobalVariables.exp += int(damage)
		# Keep giving levels and subtracting the xp cap from the current xp until xp is less than the xp cap
		while GlobalVariables.exp >= GlobalVariables.exp_cap:
			GlobalVariables.exp -= GlobalVariables.exp_cap
			GlobalVariables.level += 1
			# Ramping xp cap
			GlobalVariables.exp_cap = pow(GlobalVariables.level, 2) * 50
		# If the boss dies, make the rain go away
		if is_boss:
			get_parent().is_raining = false
		queue_free()
		
		
# Attacking cooldown for the enemies
func _on_timer_timeout() -> void:
	can_hit= true
	# Checks every time the enemy hurtbox enters, if the timer is up
	if isin == true:
		# Deals damage
		deal_damage(GlobalVariables.defense * GlobalVariables.scale_toughness)

func deal_damage(def:float):
	# Enemy stops to damage the player
	can_move = false
	if can_hit:
		$Hurtbox/Timer.start()
		# Make player red for X Ticks
		player.stay_red_counter = 30
		can_hit = false
		GlobalVariables.health -= int(damage/def)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	# Check seperately if enemy is touching the head or segment of the player
	if body.name == "Player":
		# Stop the axe II charge
		is_enraged = false
		if !is_boss and ai_num == 2:
			cooldown = max_cooldown
		deal_damage(GlobalVariables.defense)
	elif body.name.contains("Segment"):
		is_enraged = false
		if !is_boss and ai_num == 2:
			cooldown = max_cooldown
		# This is why it is checked seperately, segments have another defense variable to multiply with
		deal_damage(GlobalVariables.defense * GlobalVariables.scale_toughness)

	
func _on_hurtbox_body_exited(body: Node2D) -> void:
	# Checked in _on_timer_timeout()
	isin = false
	# Enemy can move again
	if body.name == "Player" or body.name.contains("Segment"):
		can_move = true
		
func shoot() -> void:
	var proj = projectile_scene.instantiate()
	# Arrow scales with enemy size
	proj.scale *= scale
	# Shoot from the crossbow
	proj.global_position = get_child(0).get_child(0).global_position
	call_deferred("add_sibling", proj)

func axe_I_ai() -> void:
	$AnimationPlayer.play("axe_idle")
	if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
			
func axe_II_ai(delta: float) -> void:
	# Sets z index to one above the other enemies, so it goes above other enemies when charging
	$Sprite2D.z_index = 2
	$AnimationPlayer.play("axe_II_idle")
	cooldown -= delta
	# If charge is not ready, walk normally
	if cooldown > 0:
		if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
		$CollisionShape2D.disabled = false
	# If charge is ready, stand for 1 second
	elif cooldown > -1:
		$Sprite2D.look_at(player_position)
		$Sprite2D.rotation_degrees += 90
	# If wait is over, charge forward
	elif cooldown > -3:
		# Disabling collisionshape so it goes through enemies, but not the player
		$CollisionShape2D.disabled = true
		is_enraged = true
		if position.distance_to(player_position) > 3 and can_move:
			move_and_slide()
			$Sprite2D.look_at(player_position)
			$Sprite2D.rotation_degrees += 90
	# Reset
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
	# Phase 1
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
	# Phase 2
	else:
		get_parent().is_raining = true
		if subordinates.size() <= max_subordinates and can_spawn:
			has_shield = true
			get_parent().spawn(3, 1.5, 2, 1, false, false, 2)
			subordinates.append(get_parent().e)
			get_parent().e.position = position
			# Spawn subordinates at boss positon, will be changed
		else:
			can_spawn = false
		for s in subordinates:
			if !is_instance_valid(s):
				subordinates.erase(s)
		if subordinates.size() <= 0:
			has_shield = false
			# Hop
			cooldown -= delta
			# Spawn subordinates
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
