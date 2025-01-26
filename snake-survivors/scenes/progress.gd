extends NinePatchRect

var exp_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exp_label = get_parent().get_parent().get_node("Exp")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 70 is max width, 6 is height
	size = Vector2((70*(GlobalVariables.exp/GlobalVariables.exp_cap)), 6)
	exp_label.text = str(GlobalVariables.exp, " / ", GlobalVariables.exp_cap)
	exp_label.get_child(0).text = str(GlobalVariables.level)
	
