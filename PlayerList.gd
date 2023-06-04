extends ItemList

const GameState = preload("res://GameState.gd");


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_connection_game_updated():
	self.clear();
	var game_state = GameState.new();
	game_state.initialize(GameClient.last_state());
	var player_states = game_state.player_states;
	for player_state in player_states:
		var player_name = player_state.player_name
		var player_points = player_state.points;
		
		var player_activity = "Idle";
		if player_state.awaited_to_answer:
			player_activity = "Answering";
		elif player_state.awaited_to_guess:
			player_activity = "Guessing";
		elif player_state.is_ready:
			player_activity = "Ready";
		
		var player_text = "%s (%d) | %s" % [player_name, player_points, player_activity];
		var item_id = self.add_item(player_text);
		if player_state.guid == GameClient.player_code():
			self.select(item_id);
		else:
			self.set_item_selectable(item_id, false);
		self.set_item_tooltip_enabled(item_id, false);
		
