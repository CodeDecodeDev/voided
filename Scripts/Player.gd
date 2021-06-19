extends RigidBody2D



export var speed = 10
export var air_speed = 7
export var jump = 70

var is_coliding = false

var orbs_collected = 0


func _on_Collision_Detect_body_entered(body):
	if body.is_in_group("orb"):
		orbs_collected += 1
		body.queue_free()
	if body.is_in_group("ding"):
		if body.name == "WinDetect":
			if orbs_collected == 9:
				$AudioStreamPlayer.play()
		else:
			$AudioStreamPlayer.play()
	if body.name == "WinDetect":
		if orbs_collected == 9:
			yield(get_tree().create_timer(1), "timeout")
			get_tree().change_scene("res://Scenes/Win.tscn")
	if body.name == "DeathZone":
		get_tree().reload_current_scene()
	is_coliding = true


func _on_Collision_Detect_body_exited(_body):
	is_coliding = false

#func _ready():
#	$AudioStreamPlayer.playing = true

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	
	if Input.is_action_pressed("ui_left"):
		if is_coliding:
			linear_velocity.x -= speed
		else:
			linear_velocity.x -= air_speed
		if (angular_velocity < 10 and angular_velocity > -10) and not is_coliding:
			angular_velocity += 1

	elif Input.is_action_pressed("ui_right"):
		if is_coliding:
			linear_velocity.x += speed
		else:
			linear_velocity.x += air_speed
		if (angular_velocity < 10 and angular_velocity > -10) and not is_coliding:
			angular_velocity += 1

	if is_coliding:
		if Input.is_action_just_pressed("ui_up"):
			linear_velocity.y -= jump
	
	$Camera/Label.text = str(orbs_collected)

