extends Node2D


func play_hit(strength = 0):
	if strength >= 0:
		strength = 0
	$Hit.volume_db = strength - 6
	$Hit.play()

func play_sticked():
	$Sticked.play()
