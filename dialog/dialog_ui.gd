# Author: asher
# Drives the main functionality for dialog
# Handles dialog UI display and effects
extends Control

@onready var text_display: RichTextLabel = $PanelContainer/VBoxContainer/TextDisplay
@onready var continue_button: Button = $PanelContainer/VBoxContainer/ContinueButton
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer

const CHOICE_BUTTON = preload("uid://bamc0ahe5yj0x")
# Time it takes for text to fill out in the text box
@export var text_duration := 0.5
# Time it takes for the dialog box to transition on/off screen
@export var anim_duration := 0.1
# Tween for text animation
var text_tween : Tween
# Tween for UI animation
var anim_tween : Tween

signal choice_selected(index : int)

func _ready() -> void:
	text_display.visible_ratio = 0.0
	DialogManager.dialog_started.connect(_on_dialog_started)
	DialogManager.dialog_finished.connect(_on_dialog_finished)
	
	
func _on_dialog_started(lines : Array[String]):
	visible = true
	text_display.text = ""
	enter_anim()
	await anim_tween.finished
	display_lines(lines)

func _on_dialog_finished():
	exit_anim()
	await anim_tween.finished
	visible = false

# Runs through the provided array of lines and displays the dialog
# Handles regular lines and special ones like choices and results
func display_lines(lines: Array[String]):
	var i = 0
	var has_displayed_result = false
	while i < lines.size():
		# Parse line contents
		if lines[i].begins_with("[CHOICE]"):
			var choice = await handle_choice(lines[i])
			DialogManager.register_choice(choice)
			i += 1 + choice
		elif lines[i].begins_with("[RESULT]") and has_displayed_result:
			# Skips other result dialog lines
			i += 1
		else:
			if lines[i].begins_with("[RESULT]"):
				# Only displays the correct result dialog line
				has_displayed_result = true
				var prepared_string = lines[i].trim_prefix("[RESULT]").strip_edges()
				show_line(prepared_string)
			else:
				show_line(lines[i])
			await continue_button.pressed
			
			# if player skipped dialog tween, finish it and wait for button press
			if text_tween.is_running():
				text_tween.kill()
				text_display.visible_ratio = 1.0
				await continue_button.pressed
			
			i += 1

	DialogManager.finish_dialog()

# returns the player's dialog choice after displaying text and buttons
func handle_choice(line : String) -> int:
	# first delimited section is the prompt
	# the rest are choices
	var prepared_string = line.trim_prefix("[CHOICE]").strip_edges()
	var tokens = prepared_string.split("|")
	
	# display prompt text
	show_line(tokens[0])
	
	continue_button.visible = false
	
	var buttons : Array[Button]
	# generate buttons
	for i in range(1, tokens.size()):
		var new_button = CHOICE_BUTTON.instantiate()
		buttons.append(new_button)
		new_button.text = tokens[i]
		v_box_container.add_child(new_button)
		
	var choice = await wait_for_choice(buttons)
	
	# clear buttons and restore to normal layout
	for btn in buttons:
		btn.queue_free()
	continue_button.visible = true
	
	return choice

# Shows a plain line of dialog in the text_display
func show_line(line : String):
	text_display.visible_ratio = 0.0
	text_display.text = line
	text_tween = create_tween()
	text_tween.tween_property(text_display,"visible_ratio", 1.0, text_duration)

# Waits for the player to select a choice from the list
# Returns the index associated with the choice
func wait_for_choice(buttons : Array[Button]) -> int:
	# Connect signals for the buttons
	for i in range(0, buttons.size()):
		if not buttons[i].pressed.is_connected(_on_choice_button_pressed):
			buttons[i].pressed.connect(_on_choice_button_pressed.bind(i))
	
	var choice_index = await choice_selected
	
	# Clear button signal connections
	for btn in buttons:
		if btn.pressed.is_connected(_on_choice_button_pressed):
			btn.pressed.disconnect(_on_choice_button_pressed)
	
	return choice_index

func _on_choice_button_pressed(index : int):
	choice_selected.emit(index)

# Simple tween animations
func enter_anim():
	anim_tween = create_tween()
	anim_tween.tween_property(self,"position",Vector2(0,0),anim_duration)
	
func exit_anim():
	anim_tween = create_tween()
	anim_tween.tween_property(self,"position",Vector2(0,300),anim_duration)

	
