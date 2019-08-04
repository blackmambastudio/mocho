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
		[1,1,1,1,1,4,0,0,3,5,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1],
		[1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0]
	]
	beats_lenght = len(status_pattern)

func set_status(status):
	match status:
		STATUS.HIT:
			$AnimationPlayer.play("Spit")
	.set_status(status)

func apply_damage(mocho):
	if self.current_attack == 1:
		var reduced_stamina = -20
		if mocho.current_status == STATUS.BLOCK:
			reduced_stamina = -5
		mocho.add_stamina(reduced_stamina)
	else:
		.apply_damage(mocho)
