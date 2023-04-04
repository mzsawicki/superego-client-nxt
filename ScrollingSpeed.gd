extends Node

@export var scroll_speed: float = 0.4
func _ready():
	self.material.set_shader_param("scroll_speed", scroll_speed)


func _process(delta):
	pass
