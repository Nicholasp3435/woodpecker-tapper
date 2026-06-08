@tool
extends TextureButton

@onready var game_manager: Node = %GameManager;

## Macaulay Library taxon code
@export var taxon_code: String = "":
	set(value):
		taxon_code = value;
		update_self();

var data: Dictionary = {};

func _ready():
	update_self();
	
	data = game_manager.woodpecker_data[taxon_code]
	
	var label: Label = $Label;
	label.text = data.name;

func update_self():
	if taxon_code == "":
		return;
		
	var image_path: String = "res://assets/sprites/woodpeckers/" + taxon_code + ".png";
	texture_normal = load(image_path);


func _on_button_up() -> void:
	game_manager.handle_pattern(data);
