extends Node3D

# Geschwindigkeit für sanfte Drehung
@export var rotation_speed: float = 0.1
@export var player: Node3D = null

# Originale Richtung des NPCs (als Vector3)
var original_direction: Vector3

func _ready():
    # Speichere die ursprüngliche Richtung des NPCs
    original_direction = -global_transform.basis.z.normalized()


func _process(_delta: float) -> void:
    var target_direction: Vector3

    if $Interactable.player_in_range:
        # Spieler ist in der Nähe: Berechne Richtung zum Spieler
        target_direction = (player.global_transform.origin - global_transform.origin).normalized()
    else:
        # Spieler ist nicht in der Nähe: Kehre zur Originalrichtung zurück
        target_direction = original_direction

    # Behalte nur die Y-Komponente (ignoriere Höhe)
    target_direction.y = 0
    target_direction = target_direction.normalized()

    # Interpoliere sanft die Rotation
    var current_direction = -global_transform.basis.z.normalized()
    var new_direction = current_direction.lerp(target_direction, rotation_speed)
    new_direction = new_direction.normalized()

    # Aktualisiere die Rotation basierend auf der neuen Richtung
    look_at(global_transform.origin + new_direction, Vector3.UP)
