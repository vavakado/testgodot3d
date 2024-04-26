extends Node3D

@onready var player = $"../CharacterBody3D"
@onready var label = $Label3D

func _process(delta):
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player < 2:
		label.show()
		label.look_at(player.global_position, Vector3.DOWN)
	else:
		label.hide()
	
