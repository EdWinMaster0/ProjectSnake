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
func _process(delta: float) -> void:
	if randf_range(0, 100) < enemy_spawn_rate and enemies.size() <= max_enemy_count:
		var e = enemy_scene.instantiate()
		enemies.append(e)
		call_deferred("add_child", e)
		e.position = Vector2(randf_range(-100, 100), randf_range(-100, 100))
	if GlobalVariables.health <= 0:
		get_tree().change_scene_to_file("res://scenes/Death.tscn")
	elif  GlobalVariables.health < GlobalVariables.max_health:
		if counter >= 60/GlobalVariables.hps_regen:
			GlobalVariables.health += 1
			counter = 0
		else:
			counter +=1
	
