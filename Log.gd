extends RichTextLabel

const GameState = preload("res://GameState.gd");

var _previous_state;
var _current_state;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_connection_game_updated():
	self._previous_state = self._current_state;
	var game_state = GameState.new();
	game_state.initialize(GameClient.last_state());
	self._current_state = game_state;
	
	if game_state.phase == "ANSWER_PHASE":
		var answering_player = game_state.get_answering_player();
		if self._previous_state == null or self._previous_state.phase == "RESULT_PHASE":
			self.append_text("%s is now answering." % answering_player.player_name);
			self.newline();
		if self._current_state.card_changed:
			self.append_text("%s changed their card." % answering_player.player_name);
			self.newline();
	elif game_state.phase == "GUESS_PHASE":
		if self._previous_state:
			if self._previous_state.phase == "ANSWER_PHASE":
				var answering_player = self._previous_state.get_answering_player();
				self.append_text("%s answered the question. Other players are guessing now." % answering_player.player_name);
				self.newline();
			else:
				for player_state in game_state.player_states:
					var old_player_state = self._previous_state.get_player_by_code(player_state.guid);
					if player_state.awaited_to_guess != old_player_state.awaited_to_guess:
						self.append_text("%s made their guess." % player_state.player_name);
						self.newline();
						break;
		else:
			self.append_text("Players are guessing now.");
			self.newline();
	elif game_state.phase == "RESULT_PHASE":
		for player_state in game_state.player_states:
			var points_change = player_state.points_change;
			if points_change > 0:
				self.append_text("%s guessed correctly and received %d point/s!" % [player_state.player_name, player_state.points_change]);
				self.newline();
	elif game_state.phase == "GAME_OVER_PHASE":
		self.append_text("Game over!");
		self.newline();
