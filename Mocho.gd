extends "res://Fighter.gd"

func set_status(status):
	match status:
		STATUS.RELEASE, STATUS.STUNNED:
			$Sprite.set_frame(0)
			$AnimationPlayer.play("Idle")
		STATUS.TO_HIT:
			$Sprite.set_frame(3)
		STATUS.HIT:
			$Sprite.set_frame(4)
		STATUS.BLOCK:
			$Sprite.set_frame(1)
		STATUS.TO_BLOCK:
			$AnimationPlayer.stop()
			$Sprite.set_frame(2)
		STATUS.DODGE:
			pass
	.set_status(status)

func get_damage(damage):
	.get_damage(damage)
	if self.damaged:
		if not self.current_status == STATUS.BLOCK:
			$AnimationPlayer.play("GetHit", -1, 2.0)
		else:
			$AnimationPlayer.play("BlockHit", -1, 1.3)

func _process(delta):
	if Input.is_action_just_pressed("hit"):
		self.hit()
	elif Input.is_action_just_pressed("block"):
		self.block()
	elif Input.is_action_just_released("block"):
		self.unblock()
