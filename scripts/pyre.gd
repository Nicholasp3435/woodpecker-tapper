extends Node2D

var mouse_in: bool = false;

@onready var game_manager: Node = %GameManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D;




		

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true;
	animated_sprite.play("hover");
	
func _on_area_2d_mouse_exited() -> void:
	mouse_in = false;
	animated_sprite.play("idle");
