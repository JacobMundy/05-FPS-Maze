extends KinematicBody

onready var Camera = $Pivot/Camera
onready var cheatLabel = get_node("/root/Game/Cheats/Label")
onready var timeLabel = get_node("/root/Game/Time/Label")

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2

var timer = 0.000000
var playerMoved = false

var velocity = Vector3()

func get_input():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("backward"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	if Input.is_action_pressed("flyUp") and Global.flying == true: #If flying is enabled go up 
		velocity.y = 5
	if Input.is_action_pressed("flyDown") and Global.flying == true: #If flying is enabled go down
		velocity.y = -5
	if Input.is_action_just_pressed("nopclip") and Global.cheats_enabled == true: #if cheats are on enable flying
		if Global.flying == false:
			Global.flying = true
		else:
			Global.flying = false 
	if Input.is_action_just_pressed("attack"):
		var body = $Pivot/RayCast.get_collider()
		if body != null and "Crystal" in body.name:
			Global.scores[str(Global.level)] = "%.4f"%timer
			print(Global.scores)
			body.die()
	if Input.is_action_just_pressed("pauseTimer"):
		if Global.timerPaused == true:
			Global.timerPaused = false
		else:
			Global.timerPaused = true 
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	if Global.flying == false: #As long as the player is not flying enable gravity
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	var desired_velocity = get_input() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	cheatLabel.text = "Flying: " + str(Global.flying) + "\nTimer Paused: " + str(Global.timerPaused)
	if Global.cheats_enabled == true:
		cheatLabel.show()
		var cheatButton = get_node("/root/Game/Menu/Cheats")
		cheatButton.pressed = true 
	if velocity.z >= 0.1 or velocity.y >= 0.1:
		playerMoved = true
	if playerMoved == true and Global.timerPaused == false:
		timer += delta
		timeLabel.text = "Time \n" + str("%.4f"%timer)

func _on_Cheats_pressed():
	if Global.cheats_enabled == true:
		Global.all_cheats_off()
	else:
		cheatLabel.show()
		Global.cheats_enabled = true
