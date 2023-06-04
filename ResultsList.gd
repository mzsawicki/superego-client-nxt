extends ItemList

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
		for player_state in game_state.player_states:
			if player_state.points_change > 0:
				var item_id = self.add_item("%s won %d points." % [player_state.player_name, player_state.points_change])
				self.set_item_selectable(item_id, false);
				self.set_item_tooltip_enabled(item_id, false);
			elif player_state.points_change < 0:
				var points = player_state.points_change * -1;
				var item_id = self.add_item("%s lost %d points" % [player_state.player_name, points]);
				self.set_item_selectable(item_id, false);
				self.set_item_tooltip_enabled(item_id, false);
	else:
		self.visible = false;
