extends CharacterBody3D

var MAX_SPEED = 7.0
var ACC = 10
var SENS = 0.001

@onready var head = $cam_head
@onready var camera = $cam_head/Camera3D
@onready var righthand = $Hand
@onready var raycast = $cam_head/Camera3D/RayCast3D
@onready var hand_animator = $Hand/hand/AnimationPlayer
var player_in_target_zone: bool
var rotate_target: Object

func _ready():
	pass

func _physics_process(delta):
	if InputEventScreenTouch:
		Input.MOUSE_MODE_CAPTURED
	if Input.is_action_pressed("sprint"):
		MAX_SPEED = 13.0
		ACC = 10
	else:
		MAX_SPEED = 7.0
		ACC = 10
	var dir = Vector3(Input.get_action_strength("D") - Input.get_action_strength("A"), 0, Input.get_action_strength("S") - Input.get_action_strength("W"))
	dir = dir.rotated(Vector3.UP, transform.basis.get_euler().y)
	
	velocity = velocity.lerp(dir * MAX_SPEED, ACC * delta)
	move_and_slide()

	hand_rotating()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("LMB"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$".".rotate_y(-event.relative.x * SENS)
		camera.rotate_x(-event.relative.y * SENS)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func hand_rotating():
	if raycast.is_colliding():
		rotate_target = raycast.get_collider().get_parent()
	print("-----------------------------------")
	print("RightHand Rotate: ", righthand.rotation_degrees)
	print("RightHand Pos   : ", righthand.global_position)
	print("Player pos      : ", self.global_position)
	if player_in_target_zone == true or raycast.is_colliding():
		righthand.look_at(rotate_target.global_position + Vector3(0,0.7,0), Vector3.UP, true)
		righthand.rotate_y(deg_to_rad(-90))
	if player_in_target_zone == false or !raycast.is_colliding():
		righthand.rotation_degrees.x = 0
		righthand.rotation_degrees.y = 90
		righthand.rotation_degrees.z = 0

func _on_button_player_in_zone(bool):
	player_in_target_zone = bool
	if !hand_animator.is_playing():
		if bool == true:
			hand_animator.play("ButtonPress")
