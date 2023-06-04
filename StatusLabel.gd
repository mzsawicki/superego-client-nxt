extends Label

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
	if game_state.phase == "ANSWER_PHASE":
		var answering_player = game_state.get_answering_player();
		self.text = "Waiting for %s to answer..." % answering_player.player_name;
	elif game_state.phase == "GUESS_PHASE":
		self.text = "Waiting for players to guess...";
	elif game_state.phase == "RESULT_PHASE":
		self.text = "Check this round's results!";
	elif game_state.phase == "GAME_OVER_PHASE":
		self.text = "Game over!";
