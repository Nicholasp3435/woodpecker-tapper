extends Node


@onready var pyre: Node2D = $"../Pyre";



var in_sample_mode: bool = false;
var in_recording_mode: bool = false;

enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;

var strike_count: int = 0;

var wooodpecker_data: Dictionary = get_data();


func _input(event: InputEvent) -> void:
	if not in_sample_mode:
		if event.is_action_pressed("strike") and pyre.mouse_in:
			pyre.animated_sprite.play("strike")
			handle_strike();
		elif event.is_action_released("strike"):
			if pyre.mouse_in:
				pyre.animated_sprite.play("hover");
			else:
				pyre.animated_sprite.play("idle");

func handle_strike():
	strike_count += 1;
	print("strike: " + str(strike_count));

func get_data() -> Dictionary:
	var woodpecker_file: String = FileAccess.get_file_as_string("res://assets/woodpecker_data.json");
	
	var json := JSON.new();
	var error := json.parse(woodpecker_file);
	if error == OK:
		return json.data as Dictionary;
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line());
		return {}
