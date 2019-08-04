extends Control

var Fighter = preload("res://Fighter.gd")
onready var alien_death = preload("res://AlienExplosion.tscn")
var pressed = false
var STATUS = Fighter.STATUS

var current_monster
var kills = 0

func _ready():
	randomize()
	connect("gui_input", self, "on_input")
	$AudioManager/MX_InGame.play()
	$AudioManager/MX_InGame.volume_db = -80
	
	$Mocho.connect("STATUS_UPDATED", self, "on_mocho_updated")
	self.new_monster()
	$Metronome.connect('SIXTEENTH', self, 'on_metronome_note')
	$Metronome.connect('SYNC', self, 'on_metronome_sync_start')
	
	yield(get_tree().create_timer(2), 'timeout')
	
	$Metronome.start()

func on_metronome_sync_start(time):
	$AudioManager/MX_InGame.seek(time)
	$AudioManager/MX_InGame.volume_db = 0

func new_monster():
	current_monster = $Dungeon.next_monster()
	add_child(current_monster)
	current_monster.connect("STATUS_UPDATED", self, "on_monster_updated")

func kill_monster():
	if !current_monster: return
	yield(current_monster.get_damage(100000), "completed")
#	current_monster.get_damage(100000)
	if current_monster.hp < 0:
		var Death = alien_death.instance()
		add_child(Death)
		Death.set_emitting(true)
		
		$AudioManager/Alien/SFX_Death.play()
		current_monster.disconnect("STATUS_UPDATED", self, "on_monster_updated")
		current_monster.queue_free()
		current_monster = null
		
		kills += 1
		$Kills.text = "Kills: " + str(kills)
		
		yield(get_tree().create_timer(2), 'timeout')
		
		self.new_monster()

func on_input(Event):
	if Event is InputEventMouseButton:
		if Event.pressed and !pressed:
			if Event.button_index == 1:
				$Mocho.hit()
			elif Event.button_index == 2:
				$Mocho.block()
			pressed = true
		elif pressed and !Event.pressed:
			pressed = false
			if Event.button_index == 2:
				$Mocho.unblock()
	

func on_mocho_updated(status):
	match status:
		STATUS.HIT:
			$AudioManager/Mocho/SFX_Whoosh.play()
			pass
			self.kill_monster()
		STATUS.IDLE:
			pass
		STATUS.TO_HIT:
			pass
		STATUS.RELEASE:
			pass
		STATUS.TO_BLOCK:
			pass
		STATUS.BLOCK:
			pass
		STATUS.DEAD:
			$Background/AnimationPlayer.play("Fall")
	
	if current_monster:
		current_monster.set_mocho_status(status)

func on_monster_updated(status):
	if status == STATUS.HIT:
		$Mocho.get_damage(current_monster.damage)
		# Update the GUI
		$UI.update_health($Mocho.hp)

func on_metronome_note(beat, tick):
	if current_monster:
		current_monster.solve_next(beat, tick)
	
	if tick % 4 == 0:
		$Tempo.text = str(beat) + ': '+str(tick/4 + 1) + '/4'
	
	