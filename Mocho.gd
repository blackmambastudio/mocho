extends "res://Fighter.gd"

onready var block_blood = preload("res://BlockBlood.tscn")

var AM
var stamina = 100

var stm_cost_hit = -10
var stm_cost_block = -8
var stm_recover_hit = 12
var stm_recover_base = 1
var stm_recover_parry = 40
var stm_min_to_hit = 10
var stm_limit_bad_blocking = 15
var stm_damage_bad_blocking_factor = 2

func _ready():
	AM = get_node("../AudioManager")

func hit():
	if stamina < stm_min_to_hit: return
	.hit()

func add_stamina(value):
	if self.hp <= 0: return
	self.stamina += value
	if self.stamina < 0:
		self.stamina = 0
	if self.stamina > 100:
		self.stamina = 100
	
	$Stamina.text = 'Stamina: '+str(self.stamina)

func recover_stamina():
	self.add_stamina(stm_recover_base)

func recover_stamina_by_kill():
	self.add_stamina(stm_recover_hit)

func update_applied_damage(damage):
	if self.stamina < stm_limit_bad_blocking:
		return damage*stm_damage_bad_blocking_factor
	return damage
	
func set_status(status):
	match status:
		STATUS.CANCEL:
			self.add_stamina(-stm_cost_hit)
			$ColorRect.self_modulate.a = 0
			$Sprite.set_frame(0)
			$AnimationPlayer.play("Idle")
		STATUS.IDLE:
			$ColorRect.self_modulate.a = 0
			$Sprite.set_frame(0)
			$AnimationPlayer.play("Idle")
		STATUS.PARRY:
			self.add_stamina(stm_recover_parry)
			$AnimationPlayer.play("ParryHit", -1, 1.3)
		STATUS.TO_HIT:
			self.add_stamina(stm_cost_hit)
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
			self.add_stamina(stm_cost_block)

#warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("hit"):
		self.hit()
	elif Input.is_action_just_pressed("block"):
		self.block()
	elif Input.is_action_just_released("block"):
		self.unblock()
