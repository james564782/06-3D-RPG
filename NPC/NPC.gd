extends KinematicBody

onready var Dialogue = get_node("/root/Game/UI/Dialogue")

var dialogue = [
	"Welcome to the game! (Press E to continue)",
	"Your life depends on your speed and accuracy.",
	"Shoot the five targets and defeat the drone before you run out of time!",
	"The challenge starts as soon as you press E."
]

func _ready():
	$AnimationPlayer.play("Idle")
	Dialogue.connect("finished_dialogue", self, "finished")

func _on_Area_body_entered(body):
	if body.name == "Player":
		Dialogue.start_dialogue(dialogue)


func _on_Area_body_exited(body):
	if body.name == "Player":
		Dialogue.hide_dialogue()

func finished():
	get_node("/root/Game/Target_Container").show()
	Global.timer = 120
	Global.update_time()
	get_node("/root/Game/UI/Timer").start()
