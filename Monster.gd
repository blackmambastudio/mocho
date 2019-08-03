extends "res://Fighter.gd"

export (float) var reflexes = 0.5

# to dodge...
# dodge

func _ready():
	self.release()

func _process(dt):
	if current_status == STATUS.IDLE:
		check_mocho()
	# if not doing something:
		# read environment
		# make decision
		# act
	# else... continue
	pass

func check_mocho():
	# depending on the configuration of this bicho...
	# prevent - attack
	
	pass