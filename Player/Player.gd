extends KinematicBody

onready var Camera = get_node("/root/Game/Player/Pivot/Camera")

var velocity = Vector3()
var gravity = -9.8
var speed = 0.5
var max_speed = 10
var speed_dampen = 0.9 #between 0 and 1, closer to 0 makes it dampen faster

var mouse_sensitivity = 0.002

var target = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta):
	velocity.y += gravity * _delta
	var falling = velocity.y
	velocity.y = 0
	
	var desired_velocity = get_input() * speed
	if desired_velocity.length():
		velocity += desired_velocity
	else:
		velocity *= speed_dampen
	var current_speed = velocity.length()
	if Input.is_action_pressed("sprint"):
		velocity = velocity.normalized() * clamp(current_speed, 0, max_speed * 1.5)
	else:
		velocity = velocity.normalized() * clamp(current_speed, 0, max_speed)
	velocity.y = falling
	if not $AnimationPlayer.is_playing():
		$AnimationTree.active = true
		$AnimationTree.set("parameters/Idle_Run/blend_amount", current_speed / max_speed)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	if Input.is_action_just_pressed("shoot"):
		$AnimationTree.active = false
		$AnimationPlayer.play("Shoot")
		if target != null and target.is_in_group("target"):
			target.damage(1)
	
	if global_transform.origin.y < -15 or Global.timer < 0:
		get_tree().change_scene("res://UI/Game_Over.tscn")
	if get_node("/root/Game/Target_Container").get_child_count() == 0 and get_node("/root/Game/Drone_Container").get_child_count() == 0:
		get_tree().change_scene("res://UI/Win_Screen.tscn")
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(event.relative.y * mouse_sensitivity)
		$Pivot.rotation_degrees.x = clamp($Pivot.rotation_degrees.x, -30, 15)

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir -= Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir -= Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

func damage(var _dmg):
	get_node("/root/Game/UI").add_damage(0.5)
	Global.update_score(-5)
