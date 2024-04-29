extends Label3D

var look_at_player: bool
var player: Object

func _process(delta):
	if look_at_player:
		self.look_at(player.global_position + Vector3(0,1,0), Vector3.DOWN)
