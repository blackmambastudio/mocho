extends CanvasLayer

signal restart_pressed
signal start_pressed

onready var _health = $GUI/HUD/VBoxContainer/HealthContainer/HealthBar
onready var _stamina = $GUI/HUD/VBoxContainer/StaminaContainer/StaminaBar

var in_start = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/RestartContainer.hide()

func update_health(value):
	_health.set_value(value)
	# TODO: Update the face of Mocho

func update_stamina(value):
	_stamina.set_value(value)

func _process(delta):
	if not $GUI/RestartContainer.is_visible() and not in_start: return
	if Input.is_action_just_pressed("hit"):
		if $GUI/RestartContainer.is_visible():
			$GUI/RestartContainer.hide()
			emit_signal("restart_pressed")
		else:
			in_start = false
			$GUI/AnimationPlayer.play("ShowStart", -1, -2.0, true)
			yield($GUI/AnimationPlayer, "animation_finished")
			emit_signal("start_pressed")

func show_restart():
	yield(get_tree().create_timer(2.0), "timeout")
	$GUI/RestartContainer.show()

func update_kills(new_value):
	$GUI/HUD/Kills.text = str(new_value)

func show_start():
	$GUI/AnimationPlayer.play("ShowStart")
	yield($GUI/AnimationPlayer, "animation_finished")
	in_start = true