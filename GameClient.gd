extends Node

const SettingsProvider = preload("res://SettingsProvider.gd");

signal state_updated;

var ACTION_SUBSCRIBE = "SUBSCRIBE";
var ACTION_READ = "READ";
var ACTION_CHANGE_CARD = "CHANGE_CARD";
var ACTION_ANSWER = "ANSWER";
var ACTION_GUESS = "GUESS;"
var ACTION_READY = "READY";
var STATUS_GAME_STATE = "STAT";

var _settings = SettingsProvider.new();
var _socket = WebSocketPeer.new();
var _player_code = null;
var _last_state = null;

func connect_to_game_server(player_code):
	self._player_code = player_code;
	var server_url = self._settings.get_game_server_url();
	print("Connecting to server on url: %s" % server_url);
	var error = self._socket.connect_to_url(server_url);
	if error != OK:
		print("Unable to connect. Error: %d" % error);
	else:
		self._initialize_state();
		
func send_card_change_request():
	var data = {
		"action": self.ACTION_CHANGE_CARD,
		"issuer": self._player_code
	};
	self._send(data);
	
func send_answer_request(answer):
	var data = {
		"action": self.ACTION_ANSWER,
		"params": [answer,],
		"issuer": self._player_code
	};
	self._send(data);
	
func send_guess_request(answer, bet):
	var data = {
		"action": self.ACTION_GUESS,
		"params": [answer, bet],
		"issuer": self._player_code
	};
	self._send(data);
	
func send_mark_ready_request():
	var data = {
		"action": self.ACTION_READY,
		"issuer": self._player_code
	}
	self._send(data);
	
func last_state():
	return self._last_state;
		
func _ready():
	pass

func _initialize_state():
	self._subscribe();
	self._fetch_last_state();

func _subscribe():
	print("Subscribing to game server...")
	var data = {
		"action": self.ACTION_SUBSCRIBE,
		"issuer": self._player_code
	};
	self._send(data);
	
func _fetch_last_state():
	print("Fetching current game state from the game server...")
	var data = {
		"action": self.ACTION_READ,
		"issuer": self._player_code
	}
	self._send(data);
	
func _send(data):
	var json = JSON.stringify(data);
	var encoded = json.to_utf8_buffer();
	var error = self._socket.send(encoded);
	if error != OK:
		push_warning("Error occured during sending data to game server. Error: " % error);
	
func _process(delta):
	self._socket.poll();
	var state = self._socket.get_ready_state();
	if state == WebSocketPeer.STATE_OPEN:
		print("Socket is open, processing packets...")
		self._process_packets();
	elif state == WebSocketPeer.STATE_CLOSING:
		print("Socket is closing...");
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = self._socket.get_close_code();
		var reason = self._socket.get_close_reason();
		print("Socket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		self.set_process(false);

func _process_packets():
	while self._socket.get_available_packet_count():
		self._process_next_packet();
		
func _process_next_packet():
	var packet = self._socket.get_packet();
	var decoded_data = packet.get_string_from_utf8();
	var parsed_data = JSON.parse_string(decoded_data);
	var status = parsed_data["status"];
	if status == self.STATUS_GAME_STATE:
		self._last_state = parsed_data["data"];
		emit_signal("state_updated");
		print("Client state updated")
	else:
		push_warning("Encountered invalid server status: %s" % status)
