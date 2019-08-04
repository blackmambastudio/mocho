extends Control

var Monster = preload("res://Monster.tscn")
var Marta = preload("res://MonsterMarta.tscn")
var Milton = preload("res://MonsterMilton.tscn")

func next_monster():
	randomize()
	if randf() < 0.5:
		return Monster.instance()
	if randf() < 0.8:
		return Milton.instance()
	else:
		return Marta.instance()

