extends Button

const GameState = preload("res://GameState.gd");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_connection_game_updated():
	var game_state = GameState.new();
	game_state.initialize(GameClient.last_state());
	var curr_player_state = game_state.get_player_by_code(GameClient.player_code());
	var is_ready = curr_player_state.is_ready;
	if game_state.phase == "RESULT_PHASE" and not is_ready:
		self.visible = true;
	else:
		self.visible = false;


func _on_pressed():
	GameClient.send_mark_ready_request();
