extends Node


@onready var pyre: Node2D = $"../Pyre"


var in_sample_mode: bool = false;
var in_recording_mode: bool = false;

enum Game_States {TIMER, ENDLESS};
var cur_state: int = Game_States.TIMER;

var strike_count: int = 0;

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
