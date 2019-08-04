extends "res://Monster.gd"

# 0 to idle
# 1 to be alert!
# 2 to attack
# 3 to second attack
# 4 decrease time to hit
# 5 restore time to hit
func _ready():
	status_pattern = [
		[1,1,1,1,0,0,0,0,2,4,2,2,2,2,2,2],
		[2,2,2,5,0,0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	]
	beats_lenght = len(status_pattern)

func set_status(status):
	match status:
		STATUS.TO_HIT:
			$Sprite.flip_h = not $Sprite.flip_h
			if $Sprite.flip_h:
				$Sprite.offset.x += 26
			else:
				$Sprite.offset.x -= 26
	.set_status(status)