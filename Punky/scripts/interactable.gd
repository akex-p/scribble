extends Area3D

@export var timeline: String = ""
@export var interactable: bool = false
@export var reactive: bool = false

var player_in_range: bool = false

signal playerEntered
signal playerLeft

func interact() -> void:
    if !(interactable and reactive):
        return
    
    if player_in_range:
        StateManager.enter_dialogue()
        Dialogic.start(timeline)

func _on_body_entered(_body:Node3D) -> void:
    if !reactive:
        return

    player_in_range = true
    playerEntered.emit()
    print("Entered!")

func _on_body_exited(_body:Node3D) -> void:
    if !reactive:
        return
    
    if StateManager.in_dialogue():
        StateManager.exit_dialogue()

    player_in_range = false
    playerLeft.emit()
    print("Left!")
