extends Control

var Monster = preload("res://Monster.tscn")

func next_monster():
	return Monster.instance()

