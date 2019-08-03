extends "res://Fighter.gd"

export (float) var reflexes = 0.8

# to dodge...
# dodge
var mocho_status = 0
#var next_check = 0
var time_next_check = 0.05

# 0 to idle
# 2 to be alert!
# 1 to attack
var status_pattern = [
	[2,2,2,2,2,2,2,0,2,2,2,2,2,2,2,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[2,2,2,2,0,0,0,0,2,2,2,2,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]
onready var beats_lenght = len(status_pattern)

func _ready():
	self.release()

func set_mocho_status(mocho_status):
	self.mocho_status = mocho_status


func check_dodge(chance):
	if current_status != STATUS.IDLE: return
	if self.mocho_status != STATUS.TO_HIT: return
	var value = randf()
	if chance > value:
		self.set_status(STATUS.TO_DODGE)

func solve_next(beat, tick):
	var beat_index = beat%beats_lenght
	var action = status_pattern[beat_index][tick]
	if action == 1:
		self.hit()
	elif action == 2:
		self.check_dodge(self.reflexes)
	elif action == 0:
		pass
