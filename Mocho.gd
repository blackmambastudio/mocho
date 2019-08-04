extends "res://Fighter.gd"

onready var block_blood = preload("res://BlockBlood.tscn")

var AM
var stamina = 100

func _ready():
	AM = get_node("../AudioManager")

func hit():
	if stamina < 10: return
	.hit()

func add_stamina(value):
	if self.hp <= 0: return
	self.stamina += value
	if self.stamina < 0:
		self.stamina = 0
	if self.stamina > 100:
		self.stamina = 100
	
	$Stamina.text = 'Stamina: '+str(self.stamina)
	
func set_status(status):
	match status:
		STATUS.CANCEL:
			self.add_stamina(10)
			$ColorRect.self_modulate.a = 0
			$Sprite.set_frame(0)
			$AnimationPlayer.play("Idle")
		STATUS.IDLE:
			$ColorRect.self_modulate.a = 0
			$Sprite.set_frame(0)
			$AnimationPlayer.play("Idle")
		STATUS.PARRY:
			self.add_stamina(50)
			$AnimationPlayer.play("ParryHit", -1, 1.3)
		STATUS.TO_HIT:
			self.add_stamina(-10)
			$Sprite.set_frame(3)
		STATUS.HIT:
			$Sprite.set_frame(4)
		STATUS.BLOCK:
			$Sprite.set_frame(2)
			print(self.time_blocking)
		STATUS.TO_BLOCK:
			$AnimationPlayer.stop()
			$Sprite.set_frame(1)
		STATUS.DODGE:
			pass
		STATUS.STUNNED:
			$Sprite.set_frame(5)
			AM.mocho_stunned()
	.set_status(status)

func get_damage(damage):
	.get_damage(damage)
	if self.damaged:
		if not self.current_status == STATUS.BLOCK:
			AM.mocho_hurt()
			$AnimationPlayer.play("GetHit", -1, 2.0)
		else:
			AM.mocho_block()
			var Blood = block_blood.instance()
			add_child(Blood)
			Blood.set_emitting(true)
			$AnimationPlayer.play("BlockHit", -1, 1.3)
			self.add_stamina(-5)

#warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("hit"):
		self.hit()
	elif Input.is_action_just_pressed("block"):
		self.block()
	elif Input.is_action_just_released("block"):
		self.unblock()
