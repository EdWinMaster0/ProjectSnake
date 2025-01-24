extends Control

# naming scheme: skillx_y_z
# z is row the skill is in
# y if a skill creates a new branch, new skill with higher y level is made skill1_1_2; skill1_2_2
# x is a branch within a branch. branch 1: skill1_1_3, branch2: option 1: skill1_2_3 option 2: skill2_2_3
# there is no more space for new branch layer but if there is, add a new value skill2_1_1_3

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	$SkillPoints.text = str("Skill Points: ", GlobalVariables.skill_points)

# MAKE SURE TO RENAME FUNCTION TO on_<skill>_pressed()
# hp+ is first skill and placeholder for new skills

func _on_skill_1_1_1_pressed() -> void:
	if GlobalVariables.skill_points > 0:
		GlobalVariables.skill_points -= 1
		GlobalVariables.skills.append("hp+")
		GlobalVariables.max_health += 200
		$SkillBox/ScrollContainer/VBoxContainer/row2/Skill1_2_2/TextureButton.disabled = false
		$SkillBox/ScrollContainer/VBoxContainer/row2/Skill1_1_2/TextureButton.disabled = false
		$SkillBox/ScrollContainer/VBoxContainer/row1/Skill1_1_1/TextureButton.disabled = true

func _on_skill_1_1_2_pressed() -> void:
	if GlobalVariables.skill_points > 0:
		GlobalVariables.skill_points -= 1
		GlobalVariables.skills.append("hp+")
		GlobalVariables.max_health += 200
		$SkillBox/ScrollContainer/VBoxContainer/row3/Skill1_1_3/TextureButton.disabled = false
		$SkillBox/ScrollContainer/VBoxContainer/row2/Skill1_1_2/TextureButton.disabled = true

func _on_skill_1_2_2_pressed() -> void:
	if GlobalVariables.skill_points > 0:
		GlobalVariables.skill_points -= 1
		GlobalVariables.skills.append("hp+")
		GlobalVariables.max_health += 200
		$SkillBox/ScrollContainer/VBoxContainer/row3/Skill1_2_3/TextureButton.disabled = false
		$SkillBox/ScrollContainer/VBoxContainer/row3/Skill2_2_3/TextureButton.disabled = false
		$SkillBox/ScrollContainer/VBoxContainer/row2/Skill1_2_2/TextureButton.disabled = true
