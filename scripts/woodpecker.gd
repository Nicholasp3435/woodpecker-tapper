extends TextureButton


@export var taxon_code: String;

@onready var label: Label = $Label

func _ready() -> void:	
	var image_path: String = "res://assets/sprites/woodpeckers/" + taxon_code + ".png";
	texture_normal = load(image_path);
	
	label.text = taxon_code

func _on_button_up() -> void:
	print(taxon_code);
