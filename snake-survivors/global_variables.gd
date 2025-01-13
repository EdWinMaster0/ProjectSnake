extends Node

@export var health = 300
@export var max_health = 300
@export var damage = 100
@export var exp = 0
@export var level = 1
@export var exp_cap = 50
@export var defense = 1
@export var hps_regen = 20 #how much health every 60 frames

func _reset() -> void:
	health = 300
	max_health = 300
	damage = 100
	exp = 0
	level = 1
	exp_cap = 50
	defense = 1
	hps_regen = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
