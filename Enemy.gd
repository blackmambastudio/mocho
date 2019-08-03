extends Control

var z_index = 3
var status = ''

func _ready():
	pass

func advance():
	z_index -= 1
	if z_index == 0:
		status = 'idle'

func play_turn():
	if status == 'move':
		advance()
	elif status == 'idle':
		pass

func on_hit():
	pass

