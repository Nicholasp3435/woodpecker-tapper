extends Node2D;

var mouse_in: bool = false;

@onready var game_manager: Node = %GameManager;
@onready var drum_timer: Timer = $DrumTimer;
@onready var delay_timer: Timer = $DelayTimer;
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;


const WOODPECKER_STRIKE: AudioStreamMP3 = preload("uid://bnjd0f1fhcg6c");
const SPEED_TO_BEAT: int = 12;

var recorded_drum_data: Array = [];
var time_elapsed: float = 0.0;
var time_max: float = 1.0;

var strike_count: int = 0;

enum Drumming_States {IDLE, USER, SAMPLE, DELAY};
var cur_state: int = Drumming_States.IDLE;

var in_recording_mode: bool = false;

var has_started: bool = false;

func _process(delta: float) -> void:
	if !has_started:
		return;
	
	var result: String = "You've struck %d time" % [strike_count];
	var result_timed: String = " in %.3f second";
	if strike_count != 1:
		result += 's';
	
	time_elapsed += delta; # this is fine for ~115 days of constant running
	
	if game_manager.cur_state == game_manager.Game_States.TIMER:
		var displayed_time: float;
		if time_elapsed <= time_max:
			displayed_time = time_elapsed;
		else:
			displayed_time = time_max;
			
		if displayed_time != 1:
			result_timed += 's';
		
		game_manager.counter_label.text = result + result_timed % [displayed_time];

	else:
		game_manager.counter_label.text = result;

func _input(event: InputEvent) -> void:		
	if cur_state == Drumming_States.IDLE or cur_state == Drumming_States.USER:
		if event.is_action_pressed("strike") and mouse_in:
			animated_sprite.play("strike");
			handle_strike(1.0, true);
		elif event.is_action_released("strike"):
			if mouse_in:
				animated_sprite.play("hover");
			else:
				animated_sprite.play("idle");


func play_strike(volume: float):
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new();
	add_child(audio_player);
	audio_player.stream = WOODPECKER_STRIKE;
	audio_player.volume_linear = volume;
	audio_player.play();
	audio_player.finished.connect(audio_player.queue_free);

func handle_strike(volume: float, is_user: bool):
	if !has_started:
		has_started = true;
		
	if in_recording_mode:
		recorded_drum_data.append({"c": volume, "t": time_elapsed * 1000});
		
	if game_manager.cur_state == game_manager.Game_States.TIMER:
		if cur_state == Drumming_States.IDLE:
			if is_user:
				cur_state = Drumming_States.USER;
				time_max = 1;
			else:
				cur_state = Drumming_States.SAMPLE;

			drum_timer.wait_time = time_max;

			strike_count = 0;
			time_elapsed = 0;
			drum_timer.start();
	else:
		if !is_user and cur_state == Drumming_States.IDLE:
			cur_state = Drumming_States.SAMPLE;
			drum_timer.wait_time = time_max;
			drum_timer.start();
			
	if !is_user:
		animated_sprite.play("strike");
			
	strike_count += 1;
	play_strike(volume);
	
func handle_pattern(woodpecker_data: Dictionary, drum_data: Array):
	if drum_data.is_empty():
		game_manager.playing_label.text = "This woodpecker doesn't drum!"
		return;
	
	game_manager.playing_label.text = "Playing a %s's drum" % [woodpecker_data["name"]];
	time_max = drum_data[-1]["t"] / 1000;
	var time_min: float = drum_data[0]["t"] / 1000;
	
	for strike in drum_data:
		var time: float = strike["t"] / 1000;
		var volume: float = strike["v"];
		get_tree().create_timer(time - time_min).timeout.connect(func(): handle_strike(volume, false));


func _on_area_2d_mouse_entered() -> void:
	mouse_in = true;
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND);
	if cur_state != Drumming_States.SAMPLE:
		animated_sprite.play("hover");
	
func _on_area_2d_mouse_exited() -> void:
	mouse_in = false;
	Input.set_default_cursor_shape(Input.CURSOR_ARROW);
	if cur_state != Drumming_States.SAMPLE:
		animated_sprite.play("idle");

func _on_drum_timer_timeout() -> void:
	if cur_state == Drumming_States.SAMPLE:
		animated_sprite.play("hover");
	else:
		var speed: float = strike_count / time_elapsed;
		var result: String;
		if speed > SPEED_TO_BEAT:
			result = "That's as fast as a woodpecker!";
		else:
			result = "That's still slower than a woodpecker!";
			
		game_manager.playing_label.text = result;
		
	cur_state = Drumming_States.DELAY;
	delay_timer.start();

func _on_delay_timer_timeout() -> void:
	cur_state = Drumming_States.IDLE;
	if mouse_in:
		animated_sprite.play("hover");
	else:
		animated_sprite.play("idle");
