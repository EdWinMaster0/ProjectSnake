extends Label

var prog

func _ready() -> void:
	prog = $ProgressBar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(GlobalVariables.health, " / ", GlobalVariables.max_health)
	prog.value = (((prog.max_value - prog.min_value) / GlobalVariables.max_health) * GlobalVariables.health) + prog.min_value
