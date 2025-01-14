extends Node

@export var max_health = 500
@export var health = max_health
@export var damage = 100
@export var exp = 0
@export var level = 1
@export var exp_cap = 50
@export var defense = 1.0
@export var scale_toughness = 2.0
@export var hps_regen = 20 #how much health every 60 frames

func _reset() -> void:
	max_health = 500
	health = max_health
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
