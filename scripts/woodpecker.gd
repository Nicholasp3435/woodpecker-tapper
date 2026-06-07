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

func update_self():
	if taxon_code == "":
		return;
		
	if game_manager == null:
		return
		
	data = game_manager.woodpecker_data[taxon_code];

	var image_path: String = "res://assets/sprites/woodpeckers/" + taxon_code + ".png";
	texture_normal = load(image_path);
	
	var label: Label = $Label;
	label.text = data.name;


func _on_button_up() -> void:
	pass # Replace with function body.
