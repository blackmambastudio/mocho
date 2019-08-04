extends Control

var MX_LPF
export (float) var cutoff

func _ready():
	MX_LPF = AudioServer.get_bus_effect(2,0)
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

func alien_prepare():
	$Alien/SFX_Prepare.playsound()
	

func alien_attack():
	$Alien/SFX_Slash.playsound()
	if randf() < 0.3:
		$Alien/SFX_Attk.playsound()
	
	
func alien_dodge():
	if randf() < 0.2:
		$Alien/SFX_Dodge.playsound()
	$Alien/SFX_Move.playsound()