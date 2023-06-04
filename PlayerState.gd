extends Node

var guid;
var player_name;
var points;
var points_change;
var awaited_to_answer;
var awaited_to_guess;
var is_ready;

func initialize(dict):
	self.guid = dict["guid"];
	self.player_name = dict["name"];
	self.points = dict["points"];
	self.points_change = dict["points_change"];
	self.awaited_to_answer = dict["awaited_to_answer"];
	self.awaited_to_guess = dict["awaited_to_guess"];
	self.is_ready = dict["ready"];
