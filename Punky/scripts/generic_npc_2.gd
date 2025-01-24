extends CharacterBody3D

# Zustände definieren
enum State {
    IDLE,
    RANDOM,
    FOLLOW
}

@export var move_speed: float = 3.0
@export var follow_target: NodePath  # Referenz auf das Ziel, das im FOLLOW-Modus verfolgt wird
@export var random_timer: Timer

var current_state: State = State.RANDOM


func _physics_process(delta):
    match current_state:
        State.IDLE:
            velocity = Vector3.ZERO
        State.RANDOM:
            _move_random(delta)
        State.FOLLOW:
            _follow_target(delta)
    
    move_and_slide()

# Zustand ändern
func set_state(state: State):
    if current_state == state:
        return
    current_state = state
    if state == State.RANDOM:
        random_timer.start()
    elif state == State.IDLE:
        velocity = Vector3.ZERO

# IDLE: Nichts machen
# RANDOM: Zufällige Bewegung im Bereich
func _move_random(_delta):
    if !random_timer.is_stopped():
        return  # Warten bis der Timer abläuft
    if $RandomArea:
        var nav_mesh = $RandomArea.navigation_mesh
        var random_position = _get_random_point_in_navigation(nav_mesh)
        velocity = (random_position - global_transform.origin).normalized() * move_speed

func _get_random_point_in_navigation(nav_mesh: NavigationMesh):
    var vertices = nav_mesh.get_vertices()  # Holt alle Eckpunkte des Navigationsbereichs
    if vertices.size() == 0:
        return global_transform.origin  # Rückfallebene, falls keine Punkte gefunden werden
    var random_index = randi() % vertices.size()
    return nav_mesh.get_vertex_position(random_index)

# FOLLOW: Ziel verfolgen
func _follow_target(_delta):
    if follow_target:
        var target = get_node(follow_target) as Node3D
        if target:
            var direction = (target.global_transform.origin - global_transform.origin).normalized()
            velocity = direction * move_speed
			

func _on_random_timer_timeout() -> void:
    random_timer.start()