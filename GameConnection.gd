extends Node

signal game_updated;

func _ready():
	GameClient.state_updated.connect(_on_game_state_updated);
	
func _on_game_state_updated():
	_emit_state();
	
func _emit_state():
	emit_signal("game_updated");
	print("State updated.");
