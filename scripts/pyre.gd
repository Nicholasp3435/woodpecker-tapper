extends Node2D

var mouse_in: bool = false;

@onready var game_manager: Node = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var timer: Timer = $Timer

const WOODPECKER_STRIKE: String = "res://assets/strike.mp3";

var woodpecker_strike: AudioStreamMP3 = load_audio();

func load_audio() -> AudioStreamMP3:
	var file: FileAccess = FileAccess.open(WOODPECKER_STRIKE, FileAccess.READ);
	var sound: AudioStreamMP3 = AudioStreamMP3.new();
	sound.data = file.get_buffer(file.get_length());
	return sound;

func handle_strike(volume: float):
	game_manager.strike_count += 1;
	
	if game_manager.in_sample_mode:
		animated_sprite.play("strike");
		timer.start();
	
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new();
	var stream: AudioStream = woodpecker_strike;
	add_child(audio_player);
	audio_player.stream = stream;
	audio_player.volume_linear = volume;
	audio_player.play();
	audio_player.finished.connect(audio_player.queue_free);


func _on_area_2d_mouse_entered() -> void:
	mouse_in = true;
	animated_sprite.play("hover");
	
func _on_area_2d_mouse_exited() -> void:
	mouse_in = false;
	animated_sprite.play("idle");

func _on_timer_timeout() -> void:
	animated_sprite.play("hover");
