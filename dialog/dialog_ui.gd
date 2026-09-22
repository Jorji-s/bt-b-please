# Author: asher
# Drives the main functionality for dialog
# Handles dialog UI display and effects
extends Control

@onready var text_display: RichTextLabel = $HBoxContainer/MarginContainer/TextDisplay
@onready var choice_container: VBoxContainer = $HBoxContainer/VBoxContainer
@onready var next_label: Panel = $"HBoxContainer/VBoxContainer/Continue Button"
const CHOICE_LAB = preload("uid://bamc0ahe5yj0x")
@onready var selector: TextureRect = $Selector

# Time it takes for text to fill out in the text box
@export var text_duration := 0.5
# Time it takes for the dialog box to transition on/off screen
@export var anim_duration := 0.1
# Tween for text animation
var text_tween : Tween
# Tween for UI animation
var anim_tween : Tween
var current_choice = 0
var current_max_choices = 1
signal choice_made

func _ready() -> void:
	text_display.visible_ratio = 0.0
	DialogManager.dialog_started.connect(_on_dialog_started)
	DialogManager.dialog_finished.connect(_on_dialog_finished)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("UI_Interact"):
		DialogManager.register_choice(current_choice)
		choice_made.emit()
	if event.is_action_pressed("UI_UP"):
		if current_choice > 0:
			unselect_choice_label(current_choice)
			current_choice -= 1
			select_choice_label(current_choice)
	if event.is_action_pressed("UI_DOWN"):
		if current_choice < current_max_choices - 1:
			unselect_choice_label(current_choice)
			current_choice += 1
			select_choice_label(current_choice)

func select_choice_label(index: int):
	var label = choice_container.get_child(index + 1)
	label.set_selected(true)
	
func unselect_choice_label(index: int):
	var label = choice_container.get_child(index + 1)
	label.set_selected(false)

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
			# first section is the prompt
			# the rest are choices
			var prepared_string = lines[i].trim_prefix("[CHOICE]").strip_edges()
			var tokens = prepared_string.split("|")
			
			# display prompt text
			show_line(tokens[0])
			
			next_label.visible = false
			
			var labels : Array[Panel]
			var num_choices = 0
			# generate buttons
			for j in range(1, tokens.size()):
				var new_label = CHOICE_LAB.instantiate()
				labels.append(new_label)
				choice_container.add_child(new_label)
				new_label.set_text(tokens[j])
				num_choices += 1

			current_max_choices = num_choices
			select_choice_label(0)
			
			await choice_made
			
			for lab in labels:
				lab.queue_free()
			next_label.visible = true
			
			i += 1 + current_choice
			current_choice = 0
			current_max_choices = 1
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
			await choice_made
			
			# if player skipped dialog tween, finish it and wait for button press
			if text_tween.is_running():
				text_tween.kill()
				text_display.visible_ratio = 1.0
				await choice_made
			
			i += 1

	DialogManager.finish_dialog()

# Shows a plain line of dialog in the text_display
func show_line(line : String):
	text_display.visible_ratio = 0.0
	text_display.text = line
	text_tween = create_tween()
	text_tween.tween_property(text_display,"visible_ratio", 1.0, text_duration)
	
# Simple tween animations
func enter_anim():
	anim_tween = create_tween()
	anim_tween.tween_property(self,"position",Vector2(0,0),anim_duration)
	
func exit_anim():
	anim_tween = create_tween()
	anim_tween.tween_property(self,"position",Vector2(0,300),anim_duration)
