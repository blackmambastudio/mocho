extends "res://Monster.gd"

# 0 to idle
# 1 to be alert!
# 2 to attack
# 3 to second attack
# 4 decrease time to hit
# 5 restore time to hit
func _ready():
	status_pattern = [
		[2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	]
	beats_lenght = len(status_pattern)

func set_status(status):
	match status:
		STATUS.HIT:
			$AnimationPlayer.play("Spit")
	.set_status(status)