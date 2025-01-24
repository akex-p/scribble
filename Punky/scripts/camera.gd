extends Camera3D

# Ziel, dem die Kamera folgen soll
@export var target: Node3D = null

# Abstand und Winkel der Kamera relativ zum Ziel
@export var distance: float = 5.0
@export var vertical_angle: float = 20.0  # In Grad
@export var horizontal_angle: float = 0.0  # In Grad

# Geschwindigkeit für sanfte Bewegungen
@export var follow_speed: float = 0.1

# Raycast-Limit für Objekte zwischen Kamera und Ziel
@export var raycast_min_distance: float = 1.0  # Minimaler Abstand, wenn etwas blockiert
@export var raycast_max_distance: float = 5.0  # Maximaler Abstand (default distance)

func _process(_delta: float) -> void:
    if target:
        # 1. Zielposition abrufen
        var target_position = target.global_transform.origin

        # 2. Zielposition mit Abstand und Winkel berechnen
        var calculated_position = calculate_position(target_position, distance, vertical_angle, horizontal_angle)

        # 3. Raycast durchführen
        var final_position = perform_raycast(target_position, calculated_position)

        # 4. Kamera sanft zur finalen Position bewegen
        global_transform.origin = lerp(global_transform.origin, final_position, follow_speed)

        # 5. Kamera schaut zum Ziel
        look_at(target_position)

# Berechnet die Position der Kamera basierend auf Abstand und Winkel
func calculate_position(target_position: Vector3, distance: float, vertical_angle: float, horizontal_angle: float) -> Vector3:
    var vertical_radians = vertical_angle * PI / 180.0
    var horizontal_radians = horizontal_angle * PI / 180.0

    # Berechnen der relativen Position
    var offset = Vector3(
        distance * sin(horizontal_radians) * cos(vertical_radians),
        distance * sin(vertical_radians),
        distance * cos(horizontal_radians) * cos(vertical_radians)
    )

    return target_position + offset

# Führt den Raycast von Ziel zur Kamera durch
func perform_raycast(target_position: Vector3, camera_position: Vector3) -> Vector3:
    var space_state = get_world_3d().direct_space_state
    
    # Raycast mit PhysicsRayQueryParameters3D durchführen
    var raycast_params = PhysicsRayQueryParameters3D.new()
    raycast_params.from = target_position
    raycast_params.to = camera_position
    raycast_params.collision_mask = 1 << 3
    raycast_params.exclude = [target]  # Exclude the target node itself, so it doesn't block the raycast
    
    var raycast_result = space_state.intersect_ray(raycast_params)

    if raycast_result.size() > 0:
        # Ein Objekt blockiert die Sichtlinie: Passe Abstand an
        return raycast_result.position + (target_position - raycast_result.position).normalized() * raycast_min_distance
    else:
        # Kein Objekt blockiert: Nutze normale Kamera-Position
        return camera_position
