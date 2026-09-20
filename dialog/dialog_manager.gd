# Author: asher
# Autoload script to manage broad dialog functions
extends Node
var is_active = false
signal dialog_started
signal dialog_finished(lines: Array[String])
signal choice_made(index: int)

# Call this to start dialog
func start_dialog(lines: Array[String]) -> void:
	is_active = true
	dialog_started.emit(lines)

# Call this to finish dialog
func finish_dialog() -> void:
	is_active = false
	dialog_finished.emit()

# The dialog UI will send the player's choice here so a signal can be emitted
# This is for game objects to use to trigger functionality
# await this signal after starting dialog to parse each choice the player makes
func register_choice(index: int) -> void:
	choice_made.emit(index)
	print(str(index))
	
