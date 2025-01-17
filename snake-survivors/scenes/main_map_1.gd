extends Node2D

@export var enemy_spawn_rate = 0.5
@export var max_enemy_count = 10
@export var exp_spawn_rate = 10.0
@export var max_exp_count = 3
var enemies =[]
var exps =[]
var enemy_scene = preload("res://scenes/Enemy.tscn")
var exp_scene = preload("res://scenes/Exp.tscn")
var proj_script = preload("res://projectile.gd")
var counter = 0
var is_in_menu = false

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



# Called every frame. 'delta' is the elapsed time since the previous frame.
var enemy_num = 0
func _process(delta: float) -> void:
	for i in range(exps.size()-1):
		if !is_instance_valid(exps[i]):
			exps.remove_at(i)
		elif abs($Player.position.x - exps[i].position.x) > 1000 or abs($Player.position.y - exps[i].position.y) > 1000:
			exps[i].queue_free()
			exps.remove_at(i)
	for i in range(enemies.size()-1):
		if !is_instance_valid(enemies[i]):
			enemies.remove_at(i)
		elif abs($Player.position.x - enemies[i].position.x) > 1000 or abs($Player.position.y - enemies[i].position.y) > 1000:
			enemies[i].queue_free()
			enemies.remove_at(i)
	if Input.is_action_just_pressed("Menu"):
		menu()
	if randf_range(0, 100) < enemy_spawn_rate and enemies.size() <= max_enemy_count and is_in_menu == false:
		var e = enemy_scene.instantiate()
		enemies.append(e)
		var r = randf_range(0.5, 2)
		if enemy_num % 20 == 0 and enemy_num != 0:
			e.max_health *= 5
			e.scale *= 5
			e.damage *= 5
			e.speed /= 3
			e.is_boss = true
		else:
			e.max_health *= r
			e.scale *= r
			e.damage *= r 
		if randf_range(0, 100) > 30:
			e.ai_num = 0
		else:
			e.ai_num = 1
		e.damage = int(e.damage)
		e.name = str("Enemy", enemy_num)
		enemy_num += 1
		call_deferred("add_child", e)
		e.position = Vector2(randf_range(-1000 + $Player.position.x, 1000 + $Player.position.y), randf_range(-1000 + $Player.position.x, 1000 + $Player.position.y))
	if randf_range(0, 100) < exp_spawn_rate and exps.size() <= max_exp_count and is_in_menu == false:
		var ex = exp_scene.instantiate()
		exps.append(ex)
		call_deferred("add_child", ex)
		while ex.position == Vector2.ZERO:
			var randpos = Vector2(randf_range(-700 + $Player.position.x, 700 + $Player.position.y), randf_range(-700 + $Player.position.x, 700 + $Player.position.y))
			if 500 < abs($Player.position.x - randpos.x) and 500 < abs($Player.position.y - randpos.y):
				ex.position = randpos
	if GlobalVariables.health <= 0:
		proj_script.puddles = []
		get_tree().change_scene_to_file("res://scenes/Death.tscn")
	elif  GlobalVariables.health < GlobalVariables.max_health and is_in_menu == false:
		if counter >= 60/GlobalVariables.hps_regen:
			GlobalVariables.health += 1
			counter = 0
		else:
			counter +=1
	
	
	
