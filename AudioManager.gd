extends Control

func _ready():
	pass # Replace with function body.

func mocho_hurt():
	$Mocho/SFX_Hurt.playsound()

func mocho_block():
	$Mocho/SFX_Block.playsound()

func mocho_stunned():
	$Mocho/SFX_Stunned.playsound()

func alien_prepare():
	$Alien/SFX_Prepare.playsound()
	

func alien_attack():
	$Alien/SFX_Slash.playsound()
	if randf() < 0.3:
		$Alien/SFX_Attk.playsound()
	
	
func alien_dodge():
	$Alien/SFX_Dodge.playsound()
	$Alien/SFX_Move.playsound()