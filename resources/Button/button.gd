extends Node3D

enum TYPE {TOGGLE, PUSH, PUSHTOTOGGLE}

@export var type: TYPE

@onready var E = $E
@onready var animator = $AnimationPlayer
var in_area = false
var button_is_pressed: bool

signal button_is_pressed_signal(bool)
signal player_in_zone(bool)

func _process(delta):
	if type == TYPE.PUSH:
		if Input.is_action_just_pressed("E") and in_area == true:
			button_is_pressed = true
			animator.play("Press")
			button_is_pressed_signal.emit(true)
		if Input.is_action_just_released("E") and in_area == true or (in_area == false and button_is_pressed == true):
			button_is_pressed = false
			animator.play_backwards("Press")
			button_is_pressed_signal.emit(false)
	if type == TYPE.PUSHTOTOGGLE:
		if Input.is_action_just_pressed("E") and in_area == true and button_is_pressed == false:
			button_is_pressed = true
			animator.play("Press")
			if animator.is_playing():
				animator.play_backwards("Press")
			button_is_pressed_signal.emit(true)
		elif Input.is_action_just_pressed("E") and in_area == true and button_is_pressed == true:
			button_is_pressed = false
			animator.play_backwards("Press")
			button_is_pressed_signal.emit(false)
	if type == TYPE.TOGGLE:
		if Input.is_action_just_pressed("E") and in_area == true and button_is_pressed == false:
			button_is_pressed = true
			animator.play("Press")
			button_is_pressed_signal.emit(true)
		elif Input.is_action_just_pressed("E") and in_area == true and button_is_pressed == true:
			button_is_pressed = false
			button_is_pressed_signal.emit(false)
			animator.play_backwards("Press")
func _on_area_3d_body_entered(body):
	player_in_zone.emit(true)
	in_area = true
	E.player = body
	E.look_at_player = true
	E.show()

func _on_area_3d_body_exited(body):
	player_in_zone.emit(false)
	in_area = false
	E.look_at_player = false
	E.hide()
	if type == TYPE.PUSH:
		if animator.is_playing():
			animator.play_backwards("Press")
