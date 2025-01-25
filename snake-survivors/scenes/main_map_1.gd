extends Node2D

@export var enemy_spawn_rate = 1.0
@export var max_enemy_count = 10
@export var exp_spawn_rate = 10.0
@export var max_exp_count = 3
@export var is_raining = false
var enemies =[]
var exps =[]
var enemy_scene = preload("res://scenes/Enemy.tscn")
var exp_scene = preload("res://scenes/Exp.tscn")
var proj_script = preload("res://projectile.gd")
var counter = 0
var is_in_menu = false
var boss_alive = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func menu() -> void:
	if is_in_menu == true:
		is_in_menu = false
		Engine.time_scale = 1
		$UI/PauseMenu.hide()
	else:
		is_in_menu = true
		Engine.time_scale = 0
		$UI/PauseMenu.show()

var enemy_num = 0
var e


func spawn(max_hp: float, size: float, dmg: float, spd: float, is_boss: bool, has_shield: bool, ai_num: int) -> void:
	e = enemy_scene.instantiate()
	if is_boss:
		e.max_health *= 20
		e.scale *= 4
		e.damage *= 5
		e.base_speed /= 3
		e.is_boss = true
	else:
		e.ai_num = ai_num
		e.scale *= size
		e.max_health *= max_hp
		e.damage *= dmg
		e.base_speed *= spd
		e.has_shield = has_shield
	e.damage = int(e.damage)
	e.name = str("Enemy", enemy_num)
	enemy_num += 1
	call_deferred("add_child", e)
	# Enemy spawns within 1000 units of the player
	e.position = Vector2(randf_range(-1000 + $Player.position.x, 1000 + $Player.position.y), randf_range(-1000 + $Player.position.x, 1000 + $Player.position.y))
		



func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Menu"):
		menu()
	if is_raining:
		modulate = Color(0.5, 0.5, 2)
	else:
		modulate = Color(1, 1, 1)
	# Every frame theres an enemy_spawn_rate percent chance to spawn an enemy
	if randf_range(0, 100) < enemy_spawn_rate and enemies.size() <= max_enemy_count and is_in_menu == false:
		var e = enemy_scene.instantiate()
		if enemy_num % 20 == 0 and enemy_num != 0 and not boss_alive:
			spawn(1, 1, 1, 1, true, false, 1)
			# 2 bosses can't be alive at once; this will become obsolete when progression is complete
			boss_alive = true
		var rpercent = randf_range(0, 100)
		# 60% chance for the enemy to have the axe ai
		if rpercent > 40:
			spawn(1, 1, 1, 1, false, false, 0)
		# 10% axe II
		elif rpercent > 30:
			spawn(3, 1.5, 2, 1, false, false, 2)
		# 30% archer
		else:
			spawn(0.7, 1, 1, 0.7, false, false, 1)
			
	if randf_range(0, 100) < exp_spawn_rate and exps.size() <= max_exp_count and is_in_menu == false:
		var ex = exp_scene.instantiate()
		exps.append(ex)
		call_deferred("add_child", ex)
		while ex.position == Vector2.ZERO:
			# Spawns within 700 units of the player
			var randpos = Vector2(randf_range(-700 + $Player.position.x, 700 + $Player.position.y), randf_range(-700 + $Player.position.x, 700 + $Player.position.y))
			if 500 < abs($Player.position.x - randpos.x) and 500 < abs($Player.position.y - randpos.y):
				ex.position = randpos
	if GlobalVariables.health <= 0:
		proj_script.puddles = []
		GlobalVariables.death_counter += 1
		get_tree().change_scene_to_file("res://scenes/Death.tscn")
	elif  GlobalVariables.health < GlobalVariables.max_health and is_in_menu == false:
		# This balances the healing, making it heal only every few frames
		if counter >= 60/GlobalVariables.hps_regen:
			GlobalVariables.health += 1
			counter = 0
		else:
			counter +=1
	

func _on_despawn_area_area_exited(area: Area2D) -> void:
	if exps.has(area):
		exps.erase(area)
		area.queue_free()
	# NeverTurnThisAreaOff is neccessary because the hitbox of axe II gets turned off during the charge, despawning the enemy
	# So the code checks if the enemy has any hitboxes, which it always does, so problem is solved
	if enemies.has(area.get_parent()) and area.name == "NeverTurnThisAreaOff":
		if area.get_parent().is_boss == false:
			enemies.erase(area.get_parent())
			area.get_parent().queue_free()
