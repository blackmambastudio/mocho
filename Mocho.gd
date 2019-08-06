extends "res://Fighter.gd"

onready var block_blood = preload("res://BlockBlood.tscn")

var AM
var stamina = 100

var stm_cost_hit = -20
var stm_cost_block = -1
var stm_recover_hit = 25
var stm_recover_base = 1
var stm_recover_parry = 30
var stm_min_to_hit = 10
var stm_limit_bad_blocking = 15
var stm_damage_bad_blocking_factor = 2

onready var original_time_to_hit = time_to_hit

func _ready():
	AM = get_node("../AudioManager")
	self.parried = false

func hit():
	if stamina < stm_min_to_hit: return
	.hit()

func add_stamina(value):
	if self.hp <= 0: return
	
	self.stamina += value
	if self.stamina < stm_min_to_hit:
		$Sprite.self_modulate.a = 0.5
		#$Sprite.set_frame(6)
		$AnimationPlayer.stop()
	else:
		$Sprite.self_modulate.a = 1
		#$Sprite.set_frame(0)
	if self.stamina < 0:
		self.stamina = 0
	if self.stamina > 100:
		self.stamina = 100
	
	$Stamina.text = 'Stamina: '+str(self.stamina)

func recover_stamina():
	var recovered = stm_recover_base
	if current_status == STATUS.BLOCK:
		recovered = recovered * 2
	self.add_stamina(recovered)

func recover_stamina_by_kill():
	self.add_stamina(stm_recover_hit)
	if self.parried:
		self.parried = false
		self.hp += 15
	else:
		self.hp += 2
	if self.hp > 100:
		self.hp = 100

func update_applied_damage(damage):
	if self.stamina < stm_limit_bad_blocking:
		return damage*stm_damage_bad_blocking_factor
	return damage
	
func set_status(status):
	if hp <= 0:
		status = STATUS.DEAD
	match status:
		STATUS.CANCEL:
			self.add_stamina(-stm_cost_hit)
			$CanvasLayer/ColorRect.self_modulate.a = 0
			$Sprite.set_frame(0)
			$AnimationPlayer.play("Idle")
			if self.stamina < stm_min_to_hit:
				$Sprite.set_frame(6)
		STATUS.IDLE:
			$CanvasLayer/ColorRect.self_modulate.a = 0
			if self.stamina >= stm_min_to_hit:
				$Sprite.set_frame(0)
				$AnimationPlayer.play("Idle")
			else:
				$Sprite.set_frame(6)
		STATUS.PARRY:
			self.add_stamina(stm_recover_parry)
			AM.mocho_parry()
			$AnimationPlayer.play("ParryHit", -1, 1.3)
		STATUS.TO_HIT:
			self.add_stamina(stm_cost_hit)
			self.time_to_hit = original_time_to_hit - (100-hp)/1000
			$Sprite.set_frame(3)
		STATUS.HIT:
			$Sprite.set_frame(4)
		STATUS.BLOCK:
			AM.mocho_defend()
			$Sprite.set_frame(2)
		STATUS.TO_BLOCK:
			$AnimationPlayer.stop()
			$Sprite.set_frame(1)
		STATUS.DODGE:
			pass
		STATUS.STUNNED:
			$Sprite.set_frame(5)
			AM.mocho_stunned()
		STATUS.DEAD:
			yield($AnimationPlayer, "animation_finished")
			$AnimationPlayer.play("Death")
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

func restart():
	stamina = 100
	$Sprite.self_modulate.a = 1
	$AnimationPlayer.seek(0.0)
	$AnimationPlayer.stop()
	.restart()