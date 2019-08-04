extends AudioStreamPlayer2D

      
export (float) var Volume = 0

export (float) var Pitch = 0
#BusOutput Defaults to MASTER
export (String) var Bus = "Master"

#Position Sound in space
#export (bool) var PositionSound = false

#export (float, -50, 50, 0.1) var Position = 0

#RandomSelection
export (bool) var RandomVolume

export (float) var minVolume = 0
export (float) var maxVolume = 0


export (bool) var RandomPitch

export (float) var minPitch = 0
export (float) var maxPitch = 0

export (bool) var ShowName = false

var Name


func _ready():
	
	Pitch =  Pitch/24
	minPitch = minPitch/24
	maxPitch = maxPitch/24
	set_volume_db(Volume)
	set_pitch_scale(Pitch+1)
	#Position = range_lerp (Position, -50, 50, 0, 2555)
	#if PositionSound == true:
	#	
	#	position.x = Position
	#	
	#else:
	#	set_attenuation(0)

	
	

func playsound():
	
	if RandomVolume == true:
		randomizeVol(Volume, minVolume, maxVolume)
	if RandomPitch == true:
		randomizePitch(Pitch, minPitch, maxPitch)
	play()
	if ShowName == true:
		print_tree_pretty() 
	

func stopsound():
	stop()


func randomizeVol(Volume, minVolume, maxVolume):
	var ranVol = (rand_range( minVolume, (maxVolume+1)))
	set_volume_db(Volume + ranVol)

func randomizePitch(_Pitch, minPitch, maxPitch):
		var ranPitch = (rand_range( minPitch + 1, (maxPitch+1)))
		if (_Pitch + ranPitch > 0):
			set_pitch_scale(_Pitch + ranPitch)
