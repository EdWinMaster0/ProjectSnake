extends NinePatchRect

var map
var sCol1
var sCol2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = get_parent().get_parent().get_parent()
	sCol1 = get_node("Stats/Statbox/col1")
	sCol2 = get_node("Stats/Statbox/col2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		$Main.show()
		$Stats.hide()
		$Skills.hide()
	# The stats that show in the "Stats" menu
	sCol1.get_node("level").text = str("level: ", GlobalVariables.level)
	sCol1.get_node("exp").text = str("exp: ", GlobalVariables.level)
	sCol1.get_node("expUntilNext").text = str("exp until next: ", GlobalVariables.exp_cap - GlobalVariables.exp)
	sCol1.get_node("hp").text = str("hp: ", GlobalVariables.health, " / ", GlobalVariables.max_health)
	sCol1.get_node("defense").text = str("defense: ", GlobalVariables.defense)
	sCol1.get_node("damage").text = str("damage: ", GlobalVariables.damage)
	sCol2.get_node("slow").text = str("slowing: ", GlobalVariables.slow_factor*100, "%")
	sCol2.get_node("poison").text = str("poison: ", GlobalVariables.poison_potency)
	sCol2.get_node("pierce").text = str("pierce: ", GlobalVariables.pierce)
	sCol2.get_node("scaleToughness").text = str("scale toughness: ", GlobalVariables.scale_toughness)
	sCol2.get_node("regen").text = str("regen rate: ", GlobalVariables.hps_regen)
	sCol2.get_node("puddleCount").text = str("puddles count: ", GlobalVariables.max_puddles)
	sCol2.get_node("projectileSpeed").text = str("bullet speed: ", GlobalVariables.p_speed)

func _on_resume_pressed() -> void:
	map.menu()

func _on_skills_pressed() -> void:
	$Main.hide()
	$Skills.show()

func _on_stats_pressed() -> void:
	$Main.hide()
	$Stats.show()

func _on_back_pressed() -> void:
	$Skills.hide()
	$Stats.hide()
	$Main.show()
