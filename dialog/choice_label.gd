extends Panel
@onready var label: Label = $Label
@onready var selector: TextureRect = $Selector

func set_text(text : String):
	label.text = text

func set_selected(is_selected: bool):
	selector.visible = is_selected
