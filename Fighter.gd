extends Control

signal STATUS_UPDATED
enum STATUS { IDLE, TO_BLOCK, BLOCK, RELEASE, TO_HIT, HIT, DEAD, STUNNED, TO_DODGE, DODGE, PARRY, CANCEL }
var current_status = STATUS.IDLE
# IDLE - TO-BLOCK - BLOCK - RELEASE - IDLE - TO-HIT - HIT
#     ttb         tb     tr         ti     tth      th
# IDLE can block or hit (vulnerable)
# TO-BLOCK transition state between IDLE and BLOCK (vulnerable)
# BLOCK unvulnerable to attacks (invulnerable)
# RELEASE transition state between BLOCK or HIT to IDLE (vulnerable)
# TO-HIT transition state between IDLE and HIT (vulnerable)

# time to block should be faster than time to hit

export (String) var id = 'fighter'

export (float) var time_to_block = 0.200
export (float) var time_release = 0.100
export (float) var time_to_hit = 0.250
export (float) var time_hit = 0.060
export (float) var time_stunned = 0.200
export (float) var time_dodge = 0.100

export (float) var time_cancel = 0.1

export (float) var time_blocking = 0.1
export (float) var hp = 100
export (int) var damage = 5

var time_transition = 0
var block_released = false
var damaged = false
var parried = false

func hit():
	if self.current_status != STATUS.IDLE: return
	self.time_transition = 0
	self.set_status(STATUS.TO_HIT)

func block():
	if self.current_status == STATUS.TO_HIT:
		print('cancel')
		self.time_transition = 0
		self.set_status(STATUS.CANCEL)
		return
	if self.current_status != STATUS.IDLE: return
	self.time_transition = 0
	self.set_status(STATUS.TO_BLOCK)

func _ready():
	$HP.text = 'HP: ' + str(self.hp)

func release():
	self.time_transition = 0
	self.set_status(STATUS.RELEASE)

func unblock():
	if self.current_status == STATUS.BLOCK:
		self.release()
	elif self.current_status == STATUS.TO_BLOCK:
		self.block_released = true

func set_status(status):
	self.current_status = status
	$Label.text = self.id + ': ' + STATUS.keys()[self.current_status]
	emit_signal('STATUS_UPDATED', self.current_status)

func _process(dt):
	self.time_transition += dt
	match self.current_status:
		STATUS.TO_HIT, STATUS.PARRY:
			if self.time_transition >= self.time_to_hit:
				self.time_transition = 0
				self.set_status(STATUS.HIT)
				# do the hit!!!
		
		STATUS.HIT:
			if self.time_transition >= self.time_hit:
				self.release()
		STATUS.RELEASE:
			if self.time_transition >= self.time_release:
				self.time_transition = 0
				self.set_status(STATUS.IDLE)
				self.block_released = false
		STATUS.IDLE:
			pass
		STATUS.TO_BLOCK:
			if self.time_transition >= self.time_to_block:
				self.time_transition = 0
				self.set_status(STATUS.BLOCK)
				# do the block!!!
		STATUS.BLOCK:
			if self.block_released and self.time_transition >= self.time_blocking:
				self.release()
		STATUS.STUNNED:
			if self.time_transition >= self.time_stunned:
				self.time_transition = 0
				self.set_status(STATUS.IDLE)
		STATUS.CANCEL:
			if self.time_transition >= self.time_cancel:
				self.time_transition = 0
				self.set_status(STATUS.IDLE)
		STATUS.DODGE:
			if self.time_transition >= self.time_dodge:
				self.release()

func get_damage(damage):
	damaged = false
	parried = false
	if self.current_status == STATUS.BLOCK:
		damage = damage*0.1
		if self.block_released:
			parried = true
			print('parry!!!!!')
			self.time_transition -= 0.2
			self.set_status(STATUS.PARRY)
			return
		
	if self.current_status == STATUS.TO_DODGE:
		self.time_transition = 0
		set_status(STATUS.DODGE)
		return

	self.hp -= damage
	damaged = true
	$HP.text = 'HP: ' + str(self.hp)
	if self.hp <= 0:
		print('dead!!!')
		set_status(STATUS.DEAD)
	elif self.current_status != STATUS.BLOCK:
		self.time_transition = 0
		set_status(STATUS.STUNNED)
		
func restart():
	self.hp = 100
	self.damaged = false
	self.block_released = false
	$HP.text = 'HP: ' + str(self.hp)
	set_status(STATUS.IDLE)
