extends CheckButton

const GameState = preload("res://GameState.gd");

var bet = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_toggled(button_pressed):
	if button_pressed:
		self.text = "Bet 2 points";
		self.bet = 2;
	else:
		self.text = "Bet 1 point";
		self.bet = 1;


func _on_game_connection_game_updated():
	var game_state = GameState.new();
	game_state.initialize(GameClient.last_state());
	var player_state = game_state.get_player_by_code(GameClient.player_code());
	if player_state.awaited_to_guess:
		self.visible = true;
	else:
		self.visible = false;
