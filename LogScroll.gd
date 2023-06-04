extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scroll_vertical = self.get_v_scroll_bar().max_value;


func _on_game_connection_game_updated():
	pass
