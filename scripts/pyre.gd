extends Node2D

var mouse_in: bool = false;
var strike_count: int = 0;

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;

func handle_strike():
	strike_count += 1;
	print("strike: " + str(strike_count));

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("strike") and mouse_in:
		animated_sprite.play("strike")
		handle_strike();
	elif event.is_action_released("strike"):
		if mouse_in:
			animated_sprite.play("hover");
		else:
			animated_sprite.play("idle");
		

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true;
	animated_sprite.play("hover");
	
func _on_area_2d_mouse_exited() -> void:
	mouse_in = false;
	animated_sprite.play("idle");
