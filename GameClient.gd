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

var _game_server_url = null;
var _settings = SettingsProvider.new();
var _socket = WebSocketPeer.new();
var _player_code = null;
var _last_state = null;
var _initialized = false;
var _connected = false;

func set_game_server_url(url):
	self._game_server_url = url;
	
func connected():
	return self._connected;

func connect_to_game_server(player_code):
	self._player_code = player_code;
	print("Connecting to server on url: %s" % self._game_server_url);
	
	var error = self._socket.connect_to_url(self._game_server_url);
	if error != OK:
		print("Unable to connect. Error: %d" % error);
	else:
		self._connected = true;
		set_process(true)
		
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
	set_process(false)

func _initialize_state():
	self._subscribe();
	self._fetch_last_state();
	self._initialized = true;

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
	var msg = json.to_utf8_buffer()
	self._socket.put_packet(msg)
	
func _process(delta):
	self._socket.poll();
	var state = self._socket.get_ready_state();
	if state == WebSocketPeer.STATE_OPEN:
		if self._last_state == null and not self._initialized:
			self._initialize_state();
		else:
			self._process_packets();

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
		print(self._last_state)
	else:
		push_warning("Encountered invalid server status: %s" % status)
