extends Node

signal SIXTEENTH
signal SYNC

#export(int) var time_signature_top = 4
export(int) var time_signature_botton = 4
export(float) var  bpm = 136

#var beat_count
var beat_interval
var current_beat
#var current_measure

var sixteenth_time
var current_time = 0
var current_tick = 0

var playing = false

func _ready():
	beat_interval = 60 / bpm * 4 / float(time_signature_botton)
	sixteenth_time = beat_interval/16
	print (current_time, " time to sixteenth: ", sixteenth_time)
	


func _process(delta):
	if !playing: return
	if playing and current_time == 0 and current_tick == 0:
		emit_signal('SYNC', delta)
	current_time += delta
	var next_beat = int((current_time+delta/2)/sixteenth_time)
	current_tick += next_beat
	if current_tick >= 16:
		current_tick -= 16
		current_beat += 1

	if next_beat >= 1:
		current_time = current_time - (next_beat * sixteenth_time)
		#print('the sixteenth, remain ', current_time)
		emit_signal('SIXTEENTH', current_beat, current_tick)
	
	
func start():
	playing = true
	current_beat = 0
	current_time = 0
	current_tick = 0