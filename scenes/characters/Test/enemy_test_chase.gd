class_name EnemyTestChase
extends NonPlayableCharacter

@onready var chase_area: Area2D = $ChaseArea
@onready var hit_shape_cast: ShapeCast2D = $HitShapeCast

var player: Node2D = null
var is_player_detected: bool = false

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
	chase_area.body_entered.connect(_on_chase_area_body_entered)
	chase_area.body_exited.connect(_on_chase_area_body_exited)

func _physics_process(delta: float) -> void:
	if hit_shape_cast.is_colliding():
		var node = hit_shape_cast.get_collider(0)
		node.state_machine.transition_to("Search")

func _on_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_detected = true
		player = body
		state_machine.transition_to("Chase")

func _on_chase_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_player_detected = false
		player = null
		state_machine.transition_to("Search")
		
func get_player_position() -> Vector2:
	return player.global_position if player else Vector2.ZERO
