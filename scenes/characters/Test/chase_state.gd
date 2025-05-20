extends NodeState

@export var character: EnemyTestChase
@export var navigation_agent_2d: NavigationAgent2D
@export var chase_speed: float = 50.0
@export var update_interval: float = 0.2

var update_timer: float = 0.0

func _ready() -> void:
	pass
	

func _on_physics_process(_delta : float) -> void:
	
	update_timer -= _delta
	if update_timer <= 0:
		update_target()
		update_timer = update_interval
	
	var next_position = navigation_agent_2d.get_next_path_position()
	var direction = character.global_position.direction_to(next_position)
	character.velocity = direction * chase_speed
	character.move_and_slide()


func update_target():
	navigation_agent_2d.target_position = character.get_player_position()

func _on_enter():
	character.velocity = Vector2.ZERO
	navigation_agent_2d.velocity = Vector2.ZERO
	
	animated_sprite_2d.play("walk")
	navigation_agent_2d.target_desired_distance = 10.0
	update_target()

func _on_exit():
	character.velocity = Vector2.ZERO
	navigation_agent_2d.velocity = Vector2.ZERO
