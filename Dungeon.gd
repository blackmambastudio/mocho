extends Control

var Monster = preload("res://Monster.tscn")
var Marta = preload("res://MonsterMarta.tscn")
var Milton = preload("res://MonsterMilton.tscn")

func next_monster():
	randomize()
	var value = randf()
	if value < 0.5:
		return Monster.instance()
	if value < 0.75:
		return Milton.instance()
	else:
		return Marta.instance()

