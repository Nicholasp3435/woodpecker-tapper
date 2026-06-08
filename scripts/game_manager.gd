@tool
extends Node

@onready var pyre: Node2D = $"../Pyre";

const WOODPECKER_DATA: String = "res://assets/woodpecker_data.json";

var in_sample_mode: bool = false;
var in_recording_mode: bool = false;

enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;

var strike_count: int = 0;

var woodpecker_data: Dictionary = get_data();

func _input(event: InputEvent) -> void:
	if not in_sample_mode:
		if event.is_action_pressed("strike") and pyre.mouse_in:
			pyre.animated_sprite.play("strike");
			pyre.handle_strike(1.0);
		elif event.is_action_released("strike"):
			if pyre.mouse_in:
				pyre.animated_sprite.play("hover");
			else:
				pyre.animated_sprite.play("idle");
	

func handle_pattern(data: Dictionary):
	print("Playing a ", data["name"], "'s drum")
	for strike in data.data:
		var time: float = strike["timer"] / 1000;
		var volume: float = strike["volume"];
		get_tree().create_timer(time).timeout.connect(func(): pyre.handle_strike(volume));

func get_data() -> Dictionary:
	var woodpecker_file: String = FileAccess.get_file_as_string(WOODPECKER_DATA);
	
	var json: JSON = JSON.new();
	var error: Error = json.parse(woodpecker_file);
	if error == OK:
		return json.data as Dictionary;
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line());
		return {}

func _on_timer_timeout() -> void:
	in_sample_mode = false;
	if pyre.mouse_in:
		pyre.animated_sprite.play("hover");
	else:
		pyre.animated_sprite.play("idle");
