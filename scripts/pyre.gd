extends Node2D;

var mouse_in: bool = false;

@onready var game_manager: Node = %GameManager;
@onready var drum_timer: Timer = $DrumTimer;
@onready var delay_timer: Timer = $DelayTimer;
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;


const WOODPECKER_STRIKE: AudioStreamMP3 = preload("uid://bnjd0f1fhcg6c");
const SPEED_TO_BEAT: int = 12;

var time_elapsed: float = 0.0;
var time_max: float = 1.0;

var strike_count: int = 0;

enum Drumming_States {IDLE, USER, SAMPLE, DELAY};
var cur_state: int = Drumming_States.IDLE;


func _process(delta: float) -> void:
	var result: String = "You've struck " + str(strike_count) + " times";
		
	time_elapsed += delta;
	if time_elapsed > time_max:
		time_elapsed = time_max;
	
	game_manager.counter_label.text = result + " in " + str(snapped(time_elapsed, 0.01)) + " second";
		
	if (snapped(time_elapsed, 0.01) != 1):
		game_manager.counter_label.text += 's';
		

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
	if game_manager.cur_state == game_manager.Game_States.TIMER:
		if cur_state == Drumming_States.IDLE:
			if is_user:
				cur_state = Drumming_States.USER;
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
			time_elapsed = 0;
			drum_timer.start();
			
	if !is_user:
		animated_sprite.play("strike");
			
	strike_count += 1;
	play_strike(volume);
	
func handle_pattern(data: Dictionary):
	game_manager.playing_label.text = "Playing a " + data["name"] + "'s drum";
	time_max = data["data"][-1]["timer"] / 1000;
	
	for strike in data["data"]:
		var time: float = strike["timer"] / 1000;
		var volume: float = strike["volume"];
		get_tree().create_timer(time).timeout.connect(func(): handle_strike(volume, false));


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
	time_max = 1;
	if mouse_in:
		animated_sprite.play("hover");
	else:
		animated_sprite.play("idle");
