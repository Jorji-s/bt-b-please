# Author: asher
extends Node3D
@onready var modulator: Sprite3D = $modulator
@onready var sprite_list = modulator.get_children()
@onready var num_sprites = sprite_list.size()
@onready var display_sprite = sprite_list[0]

func _ready():
	hide_sprites()
	randomize()
	print(str(num_sprites) + " alien designs loaded.")
	randomize_sprite()

# Hides the previous display sprite
# Chooses a random sprite from the sprite_list
# Assigns display sprite to this one and unhides it
func randomize_sprite():
	display_sprite.visible = false
	var selector = randi_range(0,num_sprites - 1)
	display_sprite = sprite_list[selector]
	display_sprite.visible = true

# Utility function to hide all the child sprites of modulator
func hide_sprites():
	for sprite in sprite_list:
		sprite.visible = false
