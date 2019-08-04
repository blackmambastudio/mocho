extends "res://Audio/zScripts/SoundObject.gd"

var index_sound = -1
var select_sound
var canplay

func _ready():
	for sounds in get_children():
		sounds.set_bus(Bus)
#func _process(delta):
#	if Input.is_action_pressed("ui_right"):
#		if canplay == true:
#			playsound()
#			canplay = false
#	if Input.is_action_just_released("ui_right"):
#		canplay = true
#	
	pass

func playsound():
	
	randomize()
	index_sound = randi()%get_child_count()
	select_sound = get_child(index_sound)
	var avVolume = select_sound.Volume + Volume
	var avPitch = select_sound.Pitch + Pitch 
	
	if RandomVolume == true:
		select_sound.randomizeVol(avVolume, minVolume, maxVolume)
	else:
		select_sound.set_volume_db(avVolume)
	
	
	if RandomPitch == true:
		select_sound.randomizePitch(avPitch, minPitch, maxPitch)
	#	select_sound.set_pitch_scale((Pitch) + ranPitch)
	else:
		select_sound.set_pitch_scale(avPitch+1)
	select_sound.playsound()
