extends "res://Fighter.gd"

export (float) var reflexes = 0.5
export (float) var aggresive = 0.3

# to dodge...
# dodge
var mocho_status = 0
var next_check = 0
var time_next_check = 0.05

func _ready():
	self.release()

func set_mocho_status(mocho_status):
	self.mocho_status = mocho_status

func _process(dt):
	if current_status == STATUS.IDLE:
		next_check -= dt
		if next_check <= 0:
			check_mocho()
			next_check += time_next_check
	# if not doing something:
		# read environment
		# make decision
		# act
	# else... continue


func check_mocho():
	# depending on the configuration of this bicho...
	# prevent - attack
	var chance = randf()
	match self.mocho_status:
		STATUS.TO_HIT:
			if chance < self.reflexes:
				self.set_status(STATUS.TO_DODGE)
			else:
				time_next_check += chance*0.1
				print('cant')
		_:
			if chance < self.reflexes:
				self.hit()
				time_next_check += 1
	
	pass
