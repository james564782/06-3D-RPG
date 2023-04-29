extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Label.text = "You died! Your score was " + str(Global.score)



func _on_Play_Again_pressed():
	Global.reset()
	get_tree().change_scene("res://Game.tscn")


func _on_Quit_pressed():
	get_tree().quit()
