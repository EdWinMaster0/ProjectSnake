extends Node2D

@export var enemy_spawn_rate = 1.0
@export var max_enemy_count = 10
@export var exp_spawn_rate = 10.0
@export var max_exp_count = 3
var enemies =[]
var exps =[]
var enemy_scene = preload("res://scenes/Enemy.tscn")
var exp_scene = preload("res://scenes/Exp.tscn")
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var enemy_num = 0
func _process(delta: float) -> void:
	if randf_range(0, 100) < enemy_spawn_rate and enemies.size() <= max_enemy_count:
		var e = enemy_scene.instantiate()
		enemies.append(e)
		var r = randf_range(0.5, 2)
		if enemy_num % 20 == 0 and enemy_num != 0:
			e.health *= 5
			e.scale *= 5
			e.damage *= 5
			e.speed /= 3
		else:
			e.health *= r
			e.scale *= r
			e.damage *= r
		e.damage = int(e.damage)
		e.name = str("Enemy", enemy_num)
		enemy_num += 1
		call_deferred("add_child", e)
		e.position = Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
	if randf_range(0, 100) < exp_spawn_rate and exps.size() <= max_exp_count:
		var x = exp_scene.instantiate()
		exps.append(x)
		call_deferred("add_child", x)
		x.position = Vector2(randf_range(-500, 500), randf_range(-500, 500))
	if GlobalVariables.health <= 0:
		get_tree().change_scene_to_file("res://scenes/Death.tscn")
	elif  GlobalVariables.health < GlobalVariables.max_health:
		if counter >= 60/GlobalVariables.hps_regen:
			GlobalVariables.health += 1
			counter = 0
		else:
			counter +=1
	for i in range(exps.size()-1):
		if !is_instance_valid(exps[i]):
			exps.remove_at(i)
	for i in range(enemies.size()-1):
		if !is_instance_valid(enemies[i]):
			enemies.remove_at(i)
	
