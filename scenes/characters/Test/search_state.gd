extends NodeState

@export var character: EnemyTestChase
@export var search_state_time_interval: float = 1.5

@onready var search_state_timer: Timer = Timer.new()

var search_state_timeout: bool = false

func _ready() -> void:
	search_state_timer.wait_time = search_state_time_interval
	search_state_timer.timeout.connect(on_search_state_timeout)
	add_child(search_state_timer)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if character.is_player_detected:
		transition.emit("Chase")


func _on_next_transitions() -> void:
	if search_state_timeout:
		transition.emit("Walk")


func _on_enter() -> void:
	animated_sprite_2d.play("idle")
	
	search_state_timeout = false
	search_state_timer.start()


func _on_exit() -> void:
	animated_sprite_2d.stop()
	search_state_timer.stop()

func on_search_state_timeout() -> void:
	search_state_timeout = true
