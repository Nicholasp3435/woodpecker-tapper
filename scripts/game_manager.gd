extends Node


@onready var pyre: Node2D = $"../Pyre";

const WOODPECKER_DATA: String = "res://assets/woodpecker_data.json";
const WOODPECKER_STRIKE: String = "res://assets/strike.mp3";

var in_sample_mode: bool = false;
var in_recording_mode: bool = false;

enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;

var strike_count: int = 0;

var woodpecker_data: Dictionary = get_data();
var woodpecker_strike: AudioStreamMP3 = load_audio();

func _input(event: InputEvent) -> void:
	if not in_sample_mode:
		if event.is_action_pressed("strike") and pyre.mouse_in:
			pyre.animated_sprite.play("strike");
			handle_strike(1.0);
		elif event.is_action_released("strike"):
			if pyre.mouse_in:
				pyre.animated_sprite.play("hover");
			else:
				pyre.animated_sprite.play("idle");

func handle_strike(volume: float):
	strike_count += 1;
	
	pyre.animated_sprite.play("strike");
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new();
	add_child(audio_player);
	var stream: AudioStream = woodpecker_strike;
	audio_player.stream = stream;
	audio_player.volume_linear = volume;
	audio_player.play();
	audio_player.finished.connect(audio_player.queue_free);
	
func load_audio() -> AudioStreamMP3:
	var file: FileAccess = FileAccess.open(WOODPECKER_STRIKE, FileAccess.READ);
	var sound: AudioStreamMP3 = AudioStreamMP3.new();
	sound.data = file.get_buffer(file.get_length());
	return sound;
	
func handle_pattern(data: Dictionary):
	for strike in data.data:
		var time: float = strike.timer / 1000;
		var volume: float = strike.volume;
		get_tree().create_timer(time).timeout.connect(func(): handle_strike(volume));

func get_data() -> Dictionary:
	var woodpecker_file: String = FileAccess.get_file_as_string(WOODPECKER_DATA);
	
	var json := JSON.new();
	var error := json.parse(woodpecker_file);
	if error == OK:
		return json.data as Dictionary;
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line());
		return {}
