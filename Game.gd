extends Control

var Fighter = preload("res://Fighter.gd")
onready var alien_death = preload("res://AlienExplosion.tscn")
var pressed = false
var STATUS = Fighter.STATUS

var current_monster
var kills = 0
var music_playing

func _ready():
	randomize()
#	connect("gui_input", self, "on_input")
	$AudioManager/MX_InGame.play()
	$AudioManager/MX_InGame.volume_db = -80
	
	$Mocho.connect("STATUS_UPDATED", self, "on_mocho_updated")
	$Metronome.connect('SIXTEENTH', self, 'on_metronome_note')
	$Metronome.connect('SYNC', self, 'on_metronome_sync_start')
	$UI.connect("restart_pressed", self, "restart_game")
	$UI.connect("start_pressed", self, "start_juego")
	
	$UI.show_start()

func start_juego():
	$UI.update_health(100)
	$Mocho.add_stamina(100)
	$UI.update_stamina(100)
	$UI.update_kills(0)
	self.new_monster()
	yield(get_tree().create_timer(2), 'timeout')
	$Metronome.start()

func on_metronome_sync_start(time):
	if not music_playing:
		$AudioManager/MX_InGame.seek(time)
		music_playing = true
	$AudioManager/MX_InGame.volume_db = -8

func new_monster():
	current_monster = $Dungeon.next_monster()
	add_child(current_monster)
	move_child(current_monster, 6)
	current_monster.connect("STATUS_UPDATED", self, "on_monster_updated")

func kill_monster():
	if !current_monster: return
	yield(current_monster.get_damage(100000), "completed")
	$Mocho.recover_stamina_by_kill()
	$UI.update_health($Mocho.hp)
#	current_monster.get_damage(100000)
	if current_monster.hp < 0:
		var Death = alien_death.instance()
		add_child(Death)
		Death.set_emitting(true)
		current_monster.disconnect("STATUS_UPDATED", self, "on_monster_updated")
		current_monster.queue_free()
		current_monster = null
		
		kills += 1
		$Kills.text = "Kills: " + str(kills)
		
		# Update the GUI
		$UI.update_kills(kills)

# Comenté esto porque ahora el Input Map del proyecto registra la K y el clic
# izquierdo como "hit"; y la D y el clic derecho como "block" ------------------
#func on_input(Event):
#	if Event is InputEventMouseButton:
#		if Event.pressed and !pressed:
#			if Event.button_index == 1:
#				$Mocho.hit()
#			elif Event.button_index == 2:
#				$Mocho.block()
#			pressed = true
#		elif pressed and !Event.pressed:
#			pressed = false
#			if Event.button_index == 2:
#				$Mocho.unblock()
# ------------------------------------------------------------------------------

func on_mocho_updated(status):
	match status:
		STATUS.HIT:
			$AudioManager/Mocho/SFX_Whoosh.play()
			$AudioManager/Mocho/SFX_Attk.playsound()
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
			$AudioManager.mocho_die()
			$Metronome.playing = false
			$UI.show_restart()
	
	if current_monster:
		current_monster.set_mocho_status(status)

func on_monster_updated(status):
	if status == STATUS.HIT:
		#var damage = current_monster.damage
		#damage = $Mocho.update_applied_damage(damage)
		#$Mocho.get_damage(damage)
		current_monster.apply_damage($Mocho)
		# Update the GUI
		$UI.update_health($Mocho.hp)

func on_metronome_note(beat, tick):
	if current_monster:
		current_monster.solve_next(beat, tick)
	elif tick == 0:
		self.new_monster()
	
	if tick % 4 == 0:
		$Tempo.text = str(beat) + ': '+str(tick/4 + 1) + '/4'
	if tick == 0:
		$Mocho.recover_stamina()
		$UI.update_stamina($Mocho.stamina)

func restart_game():
	# Delete the current monster
	if current_monster:
		current_monster.queue_free()
	$Mocho.restart()
	$AudioManager.reset()
	start_juego()