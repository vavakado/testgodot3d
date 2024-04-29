extends CSGBox3D

var activate: bool
var openn: Vector3
var not_finished: bool
var closedd: Vector3

func _ready():
	openn = global_position + Vector3(3,0,0)
	closedd = global_position
	
func _process(delta):
	open()
func open():
	if activate == true:
		self.global_position = lerp(global_position, openn, 0.1)
	if activate == false:
		self.global_position = lerp(global_position, closedd, 0.1)
	
func _on_button_button_is_pressed_signal(bool):
	activate = bool
