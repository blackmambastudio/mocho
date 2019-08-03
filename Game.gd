extends Control

var Fighter = preload("res://Fighter.gd")
var pressed = false
var STATUS = Fighter.STATUS

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
	match status:
		STATUS.HIT:
			$Background.color = Color('669966')
			$Monster.get_damage(10000)
		STATUS.IDLE:
			$Background.color = Color('0a0808')
		STATUS.TO_HIT:
			$Background.color = Color('2a2828')
		STATUS.RELEASE:
			$Background.color = Color('2a2828')
		STATUS.TO_BLOCK:
			$Background.color = Color('2a2828')
		STATUS.BLOCK:
			$Background.color = Color('222249')
	