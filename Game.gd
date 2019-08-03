extends Control

var pressed = false

func _ready():
	connect("gui_input", self, "on_input")
	$Mocho.connect("STATUS_UPDATED", self, "on_mocho_updated")
	

func on_input(Event):
	if Event is InputEventMouseButton:
		if Event.pressed and !pressed:
			if Event.button_index == 1:
				$Mocho.hit()
			elif Event.button_index == 2:
				$Mocho.block()
			pressed = true
		elif pressed and !Event.pressed:
			pressed = false
			if Event.button_index == 2:
				$Mocho.unblock()
	

func on_mocho_updated(status):
	if status == 'HIT':
		$Background.color = Color('669966')
	elif status == 'IDLE':
		$Background.color = Color('0a0808')
	elif status == 'TO_HIT' or status == 'RELEASE':
		$Background.color = Color('2a2828')
	elif status == 'TO_BLOCK':
		$Background.color = Color('2a2828')
	elif status == 'BLOCK':
		$Background.color = Color('222249')
	