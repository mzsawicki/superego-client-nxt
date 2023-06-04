extends Control

const SettingsProvider = preload("res://SettingsProvider.gd");

var _settings = SettingsProvider.new();
var _url_base = null;
var _game_status_url = null;
var _players_url = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	self._url_base = self._settings.get_web_server_url();
	self._game_status_url = _url_base + "/game";
	self._players_url = _url_base + "/people?name=";
	set_process(false);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameClient.connected():
		get_tree().change_scene_to_file("res://Game.tscn");
	elif GameClient.connection_failed():
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.text = "Connection to the game server failed"
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.visible = true;
		set_process(false);


func _on_join_game_button_pressed():
	var name = $Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/LineEdit.text;
	if name.is_empty():
		return;
	var headers = ["Content-Type: application/json"];
	$GameAvailableRequest.request(self._game_status_url, headers, HTTPClient.METHOD_GET);


func _on_game_available_request_request_completed(result, response_code, headers, body):
	if response_code == 404:
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.text = "There's no game ongoing currently."
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.visible = true;
	elif response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8());
		var gameserver_url = json["address"];
		GameClient.set_game_server_url(gameserver_url);
		var name = $Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/LineEdit.text;
		var url = self._players_url + name;
		var request_headers = ["Content-Type: application/json"];
		$PlayerCodeRequest.request(url, request_headers, HTTPClient.METHOD_GET);
	else:
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.text = "Couldn't reach the game server."
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.visible = true;


func _on_player_code_request_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8());
		var player_code = json["guid"];
		GameClient.connect_to_game_server(player_code);
		set_process(true);
	elif response_code == 404:
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.text = "Player name not found on the game server."
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.visible = true;
	else:
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.text = "Couldn't reach the game server."
		$Background/ReferenceRect/CenterSection/MainMenuCenterPanel/VBoxContainer/ErrorLabel.visible = true;
	
