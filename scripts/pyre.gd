extends Node2D

var mouse_in: bool = false;

@onready var game_manager: Node = %GameManager
@onready var sample_timer: Timer = $SampleTimer
@onready var delay_timer: Timer = $DelayTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;

const WOODPECKER_STRIKE: String = "res://assets/strike.mp3";

var time_elapsed: float = 0.0;
var time_max: float = 1.0;

var strike_count: int = 0;

var woodpecker_strike: AudioStreamMP3 = load_audio();

enum Drumming_States {IDLE, USER, SAMPLE, DELAY};
var cur_state: int = Drumming_States.IDLE;


func _process(delta: float) -> void:
	if cur_state == Drumming_States.IDLE or cur_state == Drumming_States.DELAY:
		return;
	
	game_manager.counter_label.text = ("You've struck " + str(strike_count) +
		" times in " + str(snapped(time_elapsed, 0.01)) + " seconds");
	
	time_elapsed += delta;
	print(time_elapsed)

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


func load_audio() -> AudioStreamMP3:
	var file: FileAccess = FileAccess.open(WOODPECKER_STRIKE, FileAccess.READ);
	var sound: AudioStreamMP3 = AudioStreamMP3.new();
	sound.data = file.get_buffer(file.get_length());
	return sound;
	
func play_strike(volume: float):
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new();
	var stream: AudioStream = woodpecker_strike;
	add_child(audio_player);
	audio_player.stream = stream;
	audio_player.volume_linear = volume;
	audio_player.play();
	audio_player.finished.connect(audio_player.queue_free);

func handle_strike(volume: float, is_user: bool):
	if cur_state == Drumming_States.IDLE:
		if is_user:
			cur_state = Drumming_States.USER;
		else:
			cur_state = Drumming_States.SAMPLE;

		sample_timer.wait_time = time_max;
		strike_count = 0;
		time_elapsed = 0;
		sample_timer.start();
		
	if !is_user:
		animated_sprite.play("strike");
	
	strike_count += 1;
	play_strike(volume)


func _on_area_2d_mouse_entered() -> void:
	mouse_in = true;
	if cur_state != Drumming_States.SAMPLE:
		animated_sprite.play("hover");
	
func _on_area_2d_mouse_exited() -> void:
	mouse_in = false;
	if cur_state != Drumming_States.SAMPLE:
		animated_sprite.play("idle");

func _on_sample_timer_timeout() -> void:
	if cur_state == Drumming_States.SAMPLE:
		animated_sprite.play("hover");
	else:
		var speed: float = strike_count / time_elapsed;
		var result: String;
		if speed > 12:
			result = "That's as fast as a woodpecker!";
		else:
			result = "That's still slower than a woodpecker!";
			
		game_manager.playing_label.text = result;
		
	cur_state = Drumming_States.DELAY
	delay_timer.start();

func _on_delay_timer_timeout() -> void:
	cur_state = Drumming_States.IDLE;
	time_max = 1;
	if mouse_in:
		animated_sprite.play("hover");
	else:
		animated_sprite.play("idle");
