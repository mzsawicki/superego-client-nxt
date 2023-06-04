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
	var points_in_bank = game_state.points_in_bank;
	self.text = "Points in bank: %d" % points_in_bank;
