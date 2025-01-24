extends Node

var current_state: Enums.State = Enums.State.OUT_OF_DIALOG

func enter_dialogue() -> void:
	current_state = Enums.State.IN_DIALOG

	AudioManager.set_menu()
	
func exit_dialogue() -> void:
	Dialogic.end_timeline()
	current_state = Enums.State.OUT_OF_DIALOG

	AudioManager.set_game()

func in_dialogue() -> bool:
	return current_state == Enums.State.IN_DIALOG