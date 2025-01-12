extends Area2D

@export var can_move = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_move:
		get_parent().velocity = Vector2.ZERO
		get_parent().move_and_slide()
	
func _on_area_entered(area: Area2D) -> void:
	can_move = false
	print("entered")
	
func _on_area_exited(area: Area2D) -> void:
	can_move = true
	print("exted")
