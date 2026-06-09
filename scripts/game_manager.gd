@tool
extends Node;

@onready var pyre: Node2D = %Pyre;
@onready var counter_label: Label = $"../CounterLabel";
@onready var playing_label: Label = $"../PlayingLabel";

@onready var endless_toggle: TextureButton = $"../EndlessToggle"
@onready var recording_toggle: TextureButton = $"../RecordingToggle"
@onready var replay_button: TextureButton = $"../ReplayButton"

const WOODPECKER_DATA: Dictionary = preload("res://assets/woodpecker_data.json").data;


enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;


func _on_endless_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		cur_state = Game_States.ENDLESS;
		recording_toggle.visible = true;
		replay_button.visible = true;
	else:
		cur_state = Game_States.TIMER;
		recording_toggle.visible = false;
		replay_button.visible = false;

func _on_recording_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pyre.in_recording_mode = true;
		replay_button.visible = false;
		endless_toggle.visible = false;
		pyre.time_elapsed = 0;
		pyre.recorded_drum_data = {
			"name": "recording",
			"source": "",
			"source-time": 0,
			"image-source": "",
			"data": []
		}
	else:
		pyre.in_recording_mode = false;
		replay_button.visible = true;
		endless_toggle.visible = true;

func _on_replay_button_button_up() -> void:
	if pyre.cur_state != pyre.Drumming_States.IDLE:
		return;
	pyre.handle_pattern(pyre.recorded_drum_data);
