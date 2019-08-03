extends Control

signal STATUS_UPDATED
var status = 'IDLE'
# IDLE - TO-BLOCK - BLOCK - RELEASE - IDLE - TO-HIT - HIT
#     ttb         tb     tr         ti     tth      th
# IDLE can block or hit (vulnerable)
# TO-BLOCK transition state between IDLE and BLOCK (vulnerable)
# BLOCK unvulnerable to attacks (invulnerable)
# RELEASE transition state between BLOCK or HIT to IDLE (vulnerable)
# TO-HIT transition state between IDLE and HIT (vulnerable)

# time to block should be faster than time to hit

export (float) var time_to_block = 0.200
export (float) var time_release = 0.100
export (float) var time_to_hit = 0.250
export (float) var time_hit = 0.060

export (float) var time_blocking = 0.1

var time_transition = 0
var block_released = false

func hit():
	if status != 'IDLE': return
	time_transition = 0
	set_status('TO_HIT')

func block():
	if status != 'IDLE': return
	time_transition = 0
	set_status('TO_BLOCK')

func _ready():
	pass

func release():
	time_transition = 0
	set_status('RELEASE')

func unblock():
	if status == 'BLOCK':
		release()
	elif status == 'TO_BLOCK':
		block_released = true

func set_status(status):
	self.status = status
	$Label.text = 'Mocho: ' + self.status
	print(self.status)
	emit_signal('STATUS_UPDATED', self.status)

func _process(dt):
	time_transition += dt
	if status == 'TO_HIT':
		if time_transition >= time_to_hit:
			time_transition = 0
			set_status('HIT')
			# do the hit!!!
	elif status == 'HIT':
		if time_transition >= time_hit:
			time_transition = 0
			release()
	elif status == 'RELEASE':
		if time_transition >= time_release:
			time_transition = 0
			set_status('IDLE')
			block_released = false
	elif status == 'IDLE':
		pass
	elif status == 'TO_BLOCK':
		if time_transition >= time_to_block:
			time_transition = 0
			set_status('BLOCK')
			# do the block!!!
	elif status == 'BLOCK':
		print('BLOCKING!!!')
		if block_released and time_transition >= time_blocking:
			release()
	