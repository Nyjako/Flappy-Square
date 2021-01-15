# By Kacper "Nyjako" Tucholski 2021

extends Particles2D

func _ready() -> void:
	self.emitting = true

func _process(delta: float) -> void:
	if not self.emitting:
		get_parent().remove_child(self)
