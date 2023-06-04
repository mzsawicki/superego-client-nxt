extends Node

const PlayerState = preload("res://PlayerState.gd");

var time;
var phase;
var player_states;
var points_in_bank;
var round_number;
var question;
var answer_a;
var answer_b;
var answer_c;
var card_changed;

func initialize(dict):
	self.time = dict["time"];
	self.phase = dict["phase"];
	self.points_in_bank = dict["points_in_bank"];
	self.round_number = dict["round_number"];
	self.question = dict["current_card"]["question"];
	self.answer_a = dict["current_card"]["answer_A"];
	self.answer_b = dict["current_card"]["answer_B"];
	self.answer_c = dict["current_card"]["answer_C"];
	self.card_changed = dict["card_changed"];
	
	self.player_states = [];
	for player_dict in dict["player_states"]:
		var player_state = PlayerState.new();
		player_state.initialize(player_dict);
		self.player_states.append(player_state);
		
func get_player_by_code(player_code):
	for player_state in self.player_states:
		if player_state.guid == player_code:
			return player_state;
			
func get_answering_player():
	for player_state in self.player_states:
		if player_state.awaited_to_answer:
			return player_state;
		
