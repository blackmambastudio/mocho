extends Control

var Monster = preload("res://Monster.tscn")
var Monster2 = preload("res://MonsterMarta.tscn")

func next_monster():
	randomize()
	if randf() < 0.5:
		return Monster.instance()
	else:
		return Monster2.instance()

