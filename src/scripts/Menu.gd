# By Kacper "Nyjako" Tucholski 2021

extends Node

export var desiredPos = 340

var particlesB
var soundsB
var settings: = []

var credits
var creditsVisible: = false

func _ready() -> void:
	get_node("./MenuGUI/Score").text = "Highscore: " + load_score()
	settings = load_settings()
	particlesB = get_node("./Menu/Particles")
	soundsB = get_node("./Menu/Sounds")
	particlesB.pressed = settings[0]
	soundsB.pressed = settings[1]
	credits = get_node("./Credits/PopupDialog")


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not creditsVisible:
			if not(compare(event.position, Vector2.ZERO, Vector2(313, 216))) and not(compare(event.position, Vector2(707, 0), Vector2(1080, 120))):
				if event.pressed:
					get_tree().change_scene("res://src/Scenes/Game.tscn")
					get_parent().remove_child(self)
		elif event.pressed and not(compare(event.position, Vector2(116,20), Vector2(982, 433))):
			creditsVisible = false
			credits.hide()


func compare(pos: Vector2, i: Vector2, j: Vector2) -> bool:
	if pos.x > i.x and pos.x < j.x:
		if pos.y > i.y and pos.y < j.y:
			return true
	return false


func load_score() -> String:
	var save_game = File.new()
	if save_game.file_exists("user://score.save"):
		save_game.open("user://score.save", File.READ)
		var con = save_game.get_as_text()
		save_game.close()
		return con
	return '0'


func load_settings():
	var s = File.new()
	if s.file_exists("user://settings.cfg"):
		s.open("user://settings.cfg", File.READ)
		var con = s.get_as_text()
		s.close()
		var sett = []
		for i in range(2):
			if con[i] == '0':
				sett.append(false)
			else:
				sett.append(true)
		return sett
	return [true,true]


func save_settings():
	var data = ""
	for i in range(2):
		if settings[i]:
			data += '1'
		elif not settings[i]:
			data += '0'
	var s = File.new()
	s.open("user://settings.cfg", File.WRITE)
	s.store_line(data)
	s.close()


func _on_Particles_toggled(button_pressed: bool) -> void:
	if button_pressed != settings[0]:
		settings[0] = button_pressed
		save_settings()


func _on_Sounds_toggled(button_pressed: bool) -> void:
	if button_pressed != settings[-1]:
		settings[-1] = button_pressed
		save_settings()


func _on_Licence_button_down() -> void:
	OS.shell_open("https://godotengine.org/license")


func _on_CreditsButton_released() -> void:
	credits.popup()
	creditsVisible = true
