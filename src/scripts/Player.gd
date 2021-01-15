# By Kacper "Nyjako" Tucholski 2021

extends KinematicBody2D

export var gravity:         = 60
export var movement_x:      = 100
export var jump_strength:   = 1000
export var score_multipler: = 1
export var playerXPos:      = 200

var alive:    = true
var inGame:   = false
var movement: = Vector2.ZERO
var motion:   = Vector2.ZERO
var score:    = 0

var pipes
var cam
var scoreNode
var guiNode
var jumpSound
var pipeSound
var particles
var particle
var hitSound
var blood
var use_particles
var use_sounds

var highScore = 0

func _on_Begin_timeout() -> void:
	inGame = true


func _ready() -> void:
	movement = Vector2(movement_x, gravity)
	pipes = get_node("/root/Game/Pipes")
	cam = get_node("/root/Game/cam")
	scoreNode = get_node("/root/Game/cam/GUI/score")
	guiNode = get_node("/root/Game/cam/MenuGUI")
	jumpSound = get_node("/root/Game/Sounds/JumpSound")
	pipeSound = get_node("/root/Game/Sounds/PipeSound")
	hitSound = get_node("/root/Game/Sounds/HitSound")
	particles = get_node("./Particles")
	blood = get_node("./Particles/blood")
	particle = preload("res://src/Game Elements/ParticleSystem.tscn")
	scoreNode.visible = true
	load_game()
	var settings = []
	settings = load_settings()
	use_particles = settings[0]
	use_sounds = settings[1]


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed == true:
			if inGame and alive:
				if use_sounds:
					jumpSound.play()
				if use_particles:
					particles.add_child(particle.instance())
				if motion.y > 0:
					motion = Vector2(movement.x, -jump_strength)
				else:
					motion += Vector2(0, -jump_strength)
			elif not alive:
				get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	if inGame and alive:
		motion = Vector2(movement.x, motion.y + movement.y)
		if self.move_and_collide(motion * delta) != null:
			if use_particles:
				blood.emitting = true
			if use_sounds:
				hitSound.play()
			alive = false
			motion = Vector2.ZERO
			if score > highScore:
				highScore = score
				save_game()
			guiNode.visible = true
			guiNode.get_node("./Score").text = "Highscore: " + str(highScore)
		if pipes.player_move(self.position.x):
			score += score_multipler
			scoreNode.text = "Score: " + str(score)
			if use_sounds:
				pipeSound.play()
		cam.position.x = self.position.x + playerXPos
	elif not alive:
		motion += Vector2(0, gravity)
		self.move_and_slide(motion)


func save_game() -> void:
	var save_game = File.new()
	save_game.open("user://score.save", File.WRITE)
	save_game.store_line(str(score))
	save_game.close()


func load_game() -> void:
	var save_game = File.new()
	if save_game.file_exists("user://score.save"):
		save_game.open("user://score.save", File.READ)
		var con = save_game.get_as_text()
		highScore = int(con)
		save_game.close()


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
