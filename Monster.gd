extends "res://Fighter.gd"

export (float) var reflexes = 0.5

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
	next_check -= dt
	if next_check <= 0:
		if current_status == STATUS.IDLE:
			check_mocho()
		next_check += time_next_check
	# if not doing something:
		# read environment
		# make decision
		# act
	# else... continue
	pass

func check_mocho():
	# depending on the configuration of this bicho...
	# prevent - attack
	match self.mocho_status:
		STATUS.IDLE:
			pass
		STATUS.TO_HIT:
			var chance = randf()
			if chance < self.reflexes:
				self.set_status(STATUS.TO_DODGE)
			else:
				time_next_check += chance*0.1
				print('cant')
	
	pass

func get_damage(damage):
	.get_damage(damage)
	$HP.text = 'HP: ' + str(self.hp)
	