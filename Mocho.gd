extends "res://Fighter.gd"

func set_status(status):
	match self.current_status:
		STATUS.RELEASE, STATUS.STUNNED:
			$Sprite.set_frame(0)
		STATUS.TO_HIT:
			$Sprite.set_frame(3)
		STATUS.HIT:
			$Sprite.set_frame(4)
		STATUS.BLOCK:
			$Sprite.set_frame(1)
		STATUS.TO_BLOCK:
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