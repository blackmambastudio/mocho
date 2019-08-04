extends CanvasLayer

onready var _health = $GUI/HUD/VBoxContainer/HealthContainer/HealthBar
onready var _stamina = $GUI/HUD/VBoxContainer/StaminaContainer/StaminaBar

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health(100)

func update_health(value):
	_health.set_value(value)
	# TODO: Update the face of Mocho

func update_stamina(value):
	_stamina.set_value(value)