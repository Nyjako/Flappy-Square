# By Kacper "Nyjako" Tucholski 2021

extends Node2D

export(Array, int) var y_spawn_limits:   = [224, 1687]
export(int)        var begin_point:      = 1170
export(int)        var max_pipes_in_game = 7
export(int)        var gap_bettwen_pipes = 530
export(int)        var offscreen_gap     = 300

var pipe
var pipes = []
var curresnt_pos_x
var currentToPass


func _ready() -> void:
	curresnt_pos_x = begin_point
	currentToPass = curresnt_pos_x + gap_bettwen_pipes
	pipe = preload("res://src/Game Elements/pipe.tscn")
	for i in range(max_pipes_in_game):
		spawnPipe()

func spawnPipe() -> void:
	curresnt_pos_x += gap_bettwen_pipes
	pipes.append(pipe.instance())
	add_child(pipes[-1])
	pipes[-1].position = Vector2(curresnt_pos_x, randi() % (y_spawn_limits[1]-y_spawn_limits[0]) + y_spawn_limits[0])
	if len(pipes) > max_pipes_in_game:
		pipes.remove(0)

func player_move(posX: int) -> bool:
	if posX + begin_point + gap_bettwen_pipes > curresnt_pos_x:
		spawnPipe()
	if posX > currentToPass:
		currentToPass += gap_bettwen_pipes
		return true
	return false
