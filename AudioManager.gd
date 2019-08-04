extends Control

var MX_LPF
export (float) var cutoff

func _ready():
	MX_LPF = AudioServer.get_bus_effect(2,0)

func reset():
	MX_LPF.set_cutoff(14000)

func mocho_hurt():
	$Mocho/SFX_Hurt.playsound()

func mocho_defend():
	$Mocho/SFX_BlockGrunt.playsound()
	$Mocho/SFX_LowWhoosh.play()

func mocho_block():
	$Mocho/SFX_Block.playsound()

func mocho_stunned():
	$Mocho/SFX_Stunned.playsound()

func mocho_parry():
	$Mocho/SFX_Parry.playsound()

func mocho_die():
	$Mocho/SFX_Death.playsound()
	MX_LPF.set_cutoff(cutoff)
#	tween_out.interpolate_property(MX_LPF, "cutoff", 14000, 2000, 1, 1, Tween.EASE_OUT, 1)
#	tween_out.start()

func alien_prepare(monster_type):
	
	match monster_type:
		"Mostro":
			$Alien/SFX_Prepare.playsound()
		"Milton":
			$Milton/SFX_Prepare.playsound()
		"Marta":
			$Marta/SFX_Prepare.playsound()
	

func alien_attack(monster_type):
	match monster_type:
		"Mostro":
			if randf() < 0.3:
				$Alien/SFX_Attk.playsound()
		"Milton":
			if randf() < 0.3:
				$Milton/SFX_Attk.playsound()
		"Marta":
			if randf() < 0.3:
				$Marta/SFX_Attk.playsound()
	$Alien/SFX_Slash.playsound()
	
func alien_dodge(monster_type):
	
	match monster_type:
		"Mostro":
			if randf() < 0.2:
				$Alien/SFX_Dodge.playsound()
		"Milton":
			if randf() < 0.2:
				$Milton/SFX_Dodge.playsound()
		"Marta":
			if randf() < 0.2:
				$Marta/SFX_Dodge.playsound()
	$Alien/SFX_Move.playsound()

func alien_death(monster_type):
	$Alien/SFX_Death.play()


