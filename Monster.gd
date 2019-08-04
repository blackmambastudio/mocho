extends "res://Fighter.gd"

#AudioManager
var AM

export (float) var reflexes = 0.95

var mocho_status = 0
export (float) var min_time_to_hit = 0.2
onready var original_time_to_hit = time_to_hit

# times to hit
# 0.48 - 0.4 
# 
#
#
var current_attack = 0
# 0 to idle
# 1 to be alert!
# 2 to attack
# 3 to second attack
# 4 decrease time to hit
# 5 restore time to hit
var status_pattern = [
	[2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
]
var mocho_dead = false

var beats_lenght = 0
onready var approaching = 0

func _ready():
	beats_lenght = len(status_pattern)
	AM = get_node("../AudioManager")
	$Sprite.set_scale(Vector2(0, 0))
	self.release()

func set_mocho_status(mocho_status):
	self.mocho_status = mocho_status
	match self.mocho_status:
		STATUS.DEAD:
			mocho_dead = true
			# $AnimationPlayer.play("Victory")

func check_dodge(chance):
	if current_status == STATUS.TO_DODGE and self.mocho_status == STATUS.CANCEL:
		self.set_status(STATUS.DODGE)
		return
	if current_status != STATUS.IDLE: return
	if self.mocho_status != STATUS.TO_HIT: return
	var value = randf()
	print("to dodge ", value)
	if chance > value:
		print("should dodge ")
		self.set_status(STATUS.TO_DODGE)

func solve_next(beat, tick):
	if mocho_dead: return

	var beat_index = beat % beats_lenght

	if approaching >= 0:
		approaching += 1
		match approaching:
			1:
				$Sprite.set_scale(Vector2(0.3, 0.3))
				return
			5:
				$Sprite.set_scale(Vector2(0.7, 0.7))
				return
			9:
				$Sprite.set_scale(Vector2(1.2, 1.2))
				return
			13:
				self.approaching = -1
			_:
				return
	
	# 0 to idle
	# 1 to be alert!
	# 2 to attack
	# 3 to second attack
	# 4 decrease time to hit
	# 5 restore time to hit

	var action = status_pattern[beat_index][tick]
	if action == 0:
		if self.current_status == STATUS.IDLE:
			$Sprite.set_frame(4)
	elif action == 1:
		if self.current_status == STATUS.IDLE:
			$Sprite.set_frame(0)
		self.check_dodge(self.reflexes)
	elif action == 2 || action == 3:
		current_attack = action - 2
		self.hit()
	elif action == 4:
		self.time_to_hit = self.min_time_to_hit
	elif action == 5:
		self.time_to_hit = self.original_time_to_hit

func set_status(status):
	match status:
		STATUS.IDLE, STATUS.STUNNED:
			$Sprite.set_frame(0)
		STATUS.TO_HIT:
			AM.alien_prepare()
			$Sprite.set_frame(1)
		STATUS.HIT:
			AM.alien_attack()
			$Sprite.set_frame(2)
		STATUS.DODGE:
			AM.alien_dodge()
			# trigger the dogging animation
			randomize()
			if randf() < 0.5:
				$AnimationPlayer.play("DodgeLeft", -1, 1.5)
			else:
				$AnimationPlayer.play("DodgeRight", -1, 1.5)
	.set_status(status)

func get_damage(damage):
	if approaching >= 0:
		yield()
		return
	.get_damage(damage)
	
	if self.damaged:
		$Sprite.set_frame(3)
		yield(get_tree().create_timer(0.05), "timeout")
	else:
		yield()

func apply_damage(mocho):
	var applied_damage = mocho.update_applied_damage(damage)
	mocho.get_damage(applied_damage)
	