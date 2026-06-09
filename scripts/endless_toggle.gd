extends TextureButton;


@onready var game_manager: Node = %GameManager


func _toggled(toggled_on: bool) -> void:
	if toggled_on:
		game_manager.cur_state = game_manager.Game_States.ENDLESS;
	else:
		game_manager.cur_state = game_manager.Game_States.TIMER;
