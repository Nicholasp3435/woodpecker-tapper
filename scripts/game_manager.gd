@tool
extends Node

@onready var pyre: Node2D = %Pyre
@onready var counter_label: Label = $"../CounterLabel"
@onready var playing_label: Label = $"../PlayingLabel"

const WOODPECKER_DATA: String = "res://assets/woodpecker_data.json";

var in_recording_mode: bool = false;

enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;

var woodpecker_data: Dictionary = get_data();


func handle_pattern(data: Dictionary):
	playing_label.text = "Playing a " + data["name"] + "'s drum";
	pyre.time_max = data["data"][-1]["timer"] / 1000;
	for strike in data["data"]:
		var time: float = strike["timer"] / 1000;
		var volume: float = strike["volume"];
		get_tree().create_timer(time).timeout.connect(func(): pyre.handle_strike(volume, false));

func get_data() -> Dictionary:
	var woodpecker_file: String = FileAccess.get_file_as_string(WOODPECKER_DATA);
	
	var json: JSON = JSON.new();
	var error: Error = json.parse(woodpecker_file);
	if error == OK:
		return json.data as Dictionary;
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line());
		return {};
