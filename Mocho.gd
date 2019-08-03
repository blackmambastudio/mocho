extends "res://Fighter.gd"

func set_status(status):
	.set_status(status)
	match self.current_status:
		STATUS.HIT:
			$Sprite.set_frame(2)
		STATUS.RELEASE:
			$Sprite.set_frame(0)
		STATUS.BLOCK:
			$Sprite.set_frame(1)
		STATUS.STUNNED:
			pass
		STATUS.DODGE:
			pass