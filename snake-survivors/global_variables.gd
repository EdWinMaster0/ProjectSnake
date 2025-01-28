extends Node

@export var max_health = 500
@export var health = max_health
@export var damage = 100
@export var exp = 0
@export var level = 1
@export var exp_cap = 50
@export var defense = 1.0
@export var scale_toughness = 2.0
@export var hps_regen = 5 #how much health every 60 frames
@export var slow_factor = 0.5
@export var poison_potency = 0.5
@export var pierce = 1
@export var max_puddles = 3
@export var p_speed = 700
@export var p_cooldown = 2
@export var linger = 1.0
@export var skill_points = 0
@export var skills = []
var death_counter = 0


func _reset() -> void:
	Engine.time_scale = 1
	max_health = 500
	health = max_health
	damage = 100
	exp = 0
	level = 1
	exp_cap = 50
	defense = 1
	hps_regen = 20
	slow_factor = 0.5
	poison_potency = 0.5
	pierce = 1
	max_puddles = 3
	p_speed = 700
	p_cooldown = 2
	linger = 1.0
	skill_points = 0
	skills = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
