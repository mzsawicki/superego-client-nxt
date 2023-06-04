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
	var player_state = game_state.get_player_by_code(GameClient.player_code());
	if player_state.awaited_to_answer or player_state.awaited_to_guess:
		self.text = game_state.answer_b;
		self.visible = true;
	else:
		self.visible = false;

func _pressed():
	var game_state = GameState.new();
	game_state.initialize(GameClient.last_state());
	var player_state = game_state.get_player_by_code(GameClient.player_code());
	if player_state.awaited_to_answer:
		GameClient.send_answer_request("B");
	elif player_state.awaited_to_guess:
		var bet_button = get_node(^"/root/Game/Background/ContextMenuPanel/BetButton")
		GameClient.send_guess_request("B", bet_button.bet);
