extends CanvasLayer

signal restart_pressed

onready var _health = $GUI/HUD/VBoxContainer/HealthContainer/HealthBar
onready var _stamina = $GUI/HUD/VBoxContainer/StaminaContainer/StaminaBar

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/RestartContainer.hide()

func update_health(value):
	_health.set_value(value)
	# TODO: Update the face of Mocho

func update_stamina(value):
	_stamina.set_value(value)

func _process(delta):
	if not $GUI/RestartContainer.is_visible(): return
	if Input.is_action_just_pressed("hit"):
		$GUI/RestartContainer.hide()
		emit_signal("restart_pressed")

func show_restart():
	yield(get_tree().create_timer(2.0), "timeout")
	$GUI/RestartContainer.show()