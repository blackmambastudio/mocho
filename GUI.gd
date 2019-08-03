extends CanvasLayer

onready var _health = $GUI/HUD/VBoxContainer/HealthContainer/HealthBar

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health(100)

func update_health(value):
	_health.set_value(value)
	# TODO: Update the face of Mocho
