@tool
extends TextureButton

## Macaulay Library taxon code
@export var taxon_code: String = "":
	set(value):
		taxon_code = value;
		update_self();

func _ready():
	update_self();

func update_self():
	if taxon_code == "":
		return;

	var image_path: String = "res://assets/sprites/woodpeckers/" + taxon_code + ".png";
	texture_normal = load(image_path);
	
	var label: Label = $Label;
	label.text = taxon_code;
