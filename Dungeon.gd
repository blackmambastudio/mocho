extends Control

var Monster = preload("res://Monster.tscn")
var Marta = preload("res://MonsterMarta.tscn")
var Milton = preload("res://MonsterMilton.tscn")

var spawned_monsters = 0
var speed_factor = 1
var damage_factor = 1

func reset_stats():
	spawned_monsters = 0
	speed_factor = 1
	damage_factor = 1

func next_monster():
	randomize()
	var value = randf()
	var monster
	if value < 0.5:
		monster = Monster.instance()
	elif value < 0.75:
		monster = Milton.instance()
	else:
		monster = Marta.instance()

	speed_factor -= 0.0001*spawned_monsters
	damage_factor += 0.001*spawned_monsters
	monster.set_difficult(speed_factor, damage_factor)
	spawned_monsters += 1
	
	return monster
	

